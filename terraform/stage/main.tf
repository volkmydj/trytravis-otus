# terraform {
#   #Terraform version
#   required_version = "0.12.19"
# }

provider "google" {
  version = "~> 2.15.0"
  project = var.project
  region  = var.region
}

provider "null" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}

module "db" {
  source            = "../modules/db"
  public_key_path   = "${var.public_key_path}"
  zone              = "${var.zone}"
  db_disk_image     = "reddit-db-base-ansible"
  provision_enabled = false
}

module "app" {
  source            = "../modules/app"
  public_key_path   = "${var.public_key_path}"
  zone              = "${var.zone}"
  app_disk_image    = "reddit-app-base-ansible"
  db_reddit_ip      = "${module.db.internal_ip}"
  provision_enabled = false
}


module "vpc" {
  source        = "../modules/vpc"
  zone          = "${var.zone}"
  source_ranges = ["0.0.0.0/0"]
}

resource "template_file" "dynamic_inventory" {
  template = file("dynamic_inventory.json")
  vars = {
    app_ext_ip = "${module.app.app_external_ip}"
    db_ext_ip  = "${module.db.db_external_ip}"
  }
}
