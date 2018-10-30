terraform {
  backend "gcs" {
    bucket  = "terraform.artello.network"
    prefix  = "upmaru/compressor/state"
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


resource "lxd_container" "encoder" {
  count    = "${var.nodes[terraform.workspace]}"
  name     = "compressor-${terraform.workspace}-${count.index + 1}"
  image    = "app-${terraform.workspace}"
  profiles = ["compressor-${terraform.workspace}"]

  limits {
    cpu    = "${terraform.workspace == "production" ? 2 : 1}"
    memory = "1GB"
  }

  provisioner "remote-exec" {
    inline = [
      "gcsfuse -o ro --implicit-dirs packages.apk.build /mnt/packages",
      "apk update && apk add compressor@upmaru",
      "fusermount -u /mnt/packages"
    ]
    
    connection {
      private_key = "${file("/home/builder/.ssh/id_rsa")}"
    }
  }
}

resource "null_resource" "updater" {
  count = "${var.nodes[terraform.workspace]}"

  triggers {
    version = "${var.version}"
  }

  provisioner "remote-exec" {
    inline     = [
      "gcsfuse -o ro --implicit-dirs packages.apk.build /mnt/packages",
      "apk update && apk add --upgrade compressor@upmaru",
      "fusermount -u /mnt/packages"
    ]
    
    connection {
      host = "${lxd_container.encoder.*.ip_address[count.index]}"
      private_key = "${file("/home/builder/.ssh/id_rsa")}"
    }
  }
}
