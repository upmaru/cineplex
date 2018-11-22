
variable "app_version" {
  type = "string"
}

variable "role" {
  type = "string"
}

resource "lxd_container" "cineplex_node" {
  count    = "1"
  name     = "cineplex-${var.role}-${terraform.workspace}-1"
  image    = "app-${terraform.workspace}"
  profiles = ["cineplex-${var.role}-${terraform.workspace}"]

  limits {
    cpu    = "1"
    memory = "1GB"
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
  count = "1"

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