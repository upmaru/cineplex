resource "lxd_container" "cineplex_server" {
  count    = "1"
  name     = "cineplex-server-${terraform.workspace}-1"
  image    = "app-${terraform.workspace}"
  profiles = ["cineplex-server-${terraform.workspace}"]

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

variable "version" {
  type = "string"
}

resource "null_resource" "cineplex_server_updater" {
  count = "1"

  triggers {
    version = "${var.version}"
  }

  provisioner "remote-exec" {
    inline     = [
      "gcsfuse -o ro --implicit-dirs packages.apk.build /mnt/packages",
      "rm -f /var/lib/cineplex/.self",
      "echo ${lxd_container.cineplex_server.*.ip_address[count.index]} > /var/lib/cineplex/.self",
      "apk update && apk add --upgrade cineplex@upmaru",
      "fusermount -u /mnt/packages"
    ]
    
    connection {
      host = "${lxd_container.cineplex_server.*.ip_address[count.index]}"
      private_key = "${file("/home/builder/.ssh/id_rsa")}"
    }
  }
}