provider "google" {
  version = "2.5.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "storage-bucket" {
  source  = "SweetOps/storage-bucket/google"
  version = "0.1.1"
  name    = ["storage-bucket-volkmydj", "storage-bucket-volkmydj2"]
}

output storage-bucket_url {
  value = "${module.storage-bucket.url}"
}
