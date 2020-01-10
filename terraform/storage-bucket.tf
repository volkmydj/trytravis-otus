terraform {
  #Terraform version
  required_version = "~> 0.12.0"
}

provider "google" {
  version = "~> 2.5.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "storage-bucket-stage" {
  source   = "SweetOps/storage-bucket/google"
  version  = "0.3.0"
  name     = "storage-bucket-otus-stage"
  location = "europe-west1"
}

module "storage-bucket-prod" {
  source   = "SweetOps/storage-bucket/google"
  version  = "0.3.0"
  name     = "storage-bucket-otus-prod"
  location = "europe-west1"
}



output storage-bucket_url-stage {
  value = "${module.storage-bucket-stage.url}"
}

output storage-bucket_url-prod {
  value = "${module.storage-bucket-prod.url}"
}
