terraform {
  #Terraform version
  required_version = "0.12.8"
}

provider "google" {
  version = "~> 2.15.0"
  project = var.project
  region  = var.region
}

module "db" {
  source          = "../modules/db"
  public_key_path = "${var.public_key_path}"
  zone            = "${var.zone}"
  db_disk_image   = "${var.db_disk_image}"
}

module "app" {
  app_name          = "${var.app_name}"
  source            = "../modules/app"
  public_key_path   = "${var.public_key_path}"
  zone              = "${var.zone}"
  app_disk_image    = "${var.app_disk_image}"
  db_reddit_ip      = "${module.db.internal_ip}"
  provision_enabled = false
}


module "vpc" {
  source        = "../modules/vpc"
  zone          = "${var.zone}"
  source_ranges = "${var.my_ip}"
}
