provider "google" {
  version = "~> 2.5"
  project = "${var.project}"
  region  = "${var.region}"
}

# module "storage-bucket-stage" {
#   source   = "git::https://github.com/SweetOps/terraform-google-storage-bucket.git?ref=master"
#   name     = "storage-bucket-stage"
#   stage    = "stage"
#   location = "europe-west1"
# }
#
# module "storage-bucket-prod" {
#   source   = "git::https://github.com/SweetOps/terraform-google-storage-bucket.git?ref=master"
#   name     = "storage-bucket-prod"
#   stage    = "production"
#   location = "europe-west1"
# }
#
# output storage-stage-bucket_url {
#   value = "${module.storage-bucket-stage.url}"
# }
#
# output storage-prod-bucket_url {
#   value = "${module.storage-bucket-prod.url}"
# }

module "storage-bucket" {
  source  = "SweetOps/storage-bucket/google"
  version = "0.1.1"
  name    = ["storage-bucket-otus-stage", "storage-bucket-otus-prod"]
}

output storage-bucket_url {
  value = "${module.storage-bucket.url}"
}
