terraform {
  backend "gcs" {
    bucket  = "terraform.artello.network"
    prefix  = "upmaru/cineplex/state"
  }

  provider "lxd" {
    generate_client_certificates = true
    accept_remote_certificate    = true
  }
}

variable "version" {
  type = "string"
}


variable "nodes" {
  type = "map"

  default = {
    "production" = 2
    "staging" = 1
  }
}


resource "lxd_container" "cineplex_server" {
  count    = "1"
  name     = "cineplex-server-1"
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

resource "null_resource" "cineplex_server_updater" {
  count = "1"

  triggers {
    version = "${var.version}"
  }

  provisioner "remote-exec" {
    inline     = [
      "gcsfuse -o ro --implicit-dirs packages.apk.build /mnt/packages",
      "rm -f /var/lib/studio/.self",
      "echo ${lxd_container.cineplex_server.*.ip_address[count.index]} > /var/lib/studio/.self",
      "apk update && apk add --upgrade cineplex@upmaru",
      "fusermount -u /mnt/packages"
    ]
    
    connection {
      host = "${lxd_container.cineplex_server.*.ip_address[count.index]}"
      private_key = "${file("/home/builder/.ssh/id_rsa")}"
    }
  }
}
