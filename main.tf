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

variable "app_version" {
  type = "string"
}

module "cineplex_server" {
  source = "./infrastructure/server"
  app_version = "${var.app_version}"
}
