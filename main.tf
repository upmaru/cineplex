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

module "cineplex_server" {
  source = "./infrastructure/server"
  version = "${var.version}"
}
