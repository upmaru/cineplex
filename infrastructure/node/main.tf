
variable "app_version" {
  type = "string"
}

variable "count" {
  type = "string"
}

variable "role" {
  type = "string"
}


variable "cores" {
  type = "string"
}

resource "lxd_container" "cineplex_node" {
  count    = "${var.count}"
  name     = "cineplex-${var.role}-${terraform.workspace}-${count.index + 1}"
  image    = "app-${terraform.workspace}"
  profiles = ["${var.profiles}"]

  limits {
    cpu    = "${var.cores}"
    memory = "1GB"
  }

  config {
    user.CINEPLEX_ROLE = "${var.role}"
  }

  provisioner "remote-exec" {
    inline = [
      "gcsfuse -o ro --implicit-dirs packages.apk.build /mnt/packages",
      "apk update && apk add cineplex@upmaru",
      "fusermount -u /mnt/packages"
    ]
    
    connection {
      private_key = "${file("/home/builder/.ssh/id_rsa")}"
    }
  }
}

resource "null_resource" "cineplex_node_updater" {
  count     = "${var.count}"

  triggers {
    version = "${var.app_version}"
  }

  provisioner "remote-exec" {
    inline     = [
      "gcsfuse -o ro --implicit-dirs packages.apk.build /mnt/packages",
      "rm -f /var/lib/cineplex/.self",
      "echo ${lxd_container.cineplex_node.*.ip_address[count.index]} > /var/lib/cineplex/.self",
      "apk update && apk add --upgrade cineplex@upmaru",
      "fusermount -u /mnt/packages"
    ]
    
    connection {
      host = "${lxd_container.cineplex_node.*.ip_address[count.index]}"
      private_key = "${file("/home/builder/.ssh/id_rsa")}"
    }
  }
}
