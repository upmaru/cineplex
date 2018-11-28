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

variable "worker_count" {
  type = "map"

  default = {
    "production" = 2
    "staging" = 1
  }
}

module "cineplex_server" {
  source = "./infrastructure/node"
  app_version = "${var.app_version}"
  role = "server"
  cores = "1"
  count = 1
}

module "cineplex_worker" {
  source = "./infrastructure/node"
  app_version = "${var.app_version}"
  role = "worker"
  cores = "2"
  count = "${var.worker_count[terraform.workspace]}"
}
