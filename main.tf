terraform {
  backend "s3" {
    bucket = "terraform.upmaru.cloud"
    key    = "encoders/terraform"
    region = "eu-central-1"
  }

  provider "lxd" {}
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
      "apk update",
      "apk add compressor@upmaru"
    ]
    
    connection {
      private_key = "${file("/home/builder/.ssh/id_rsa")}"
    }
  }
}

resource "null_resource" "updater" {
  count = "${terraform.workspace == "production" ? 3 : 1}"

  triggers {
    version = "${var.version}"
  }

  provisioner "remote-exec" {
    inline     = [
      "apk update",
      "apk add --upgrade compressor@upmaru"
    ]
    
    connection {
      host = "${lxd_container.encoders.*.ip_address[count.index]}"
      private_key = "${file("/home/builder/.ssh/id_rsa")}"
    }
  }
}
