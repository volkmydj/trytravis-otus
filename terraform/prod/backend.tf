terraform {
  #required_version = "0.12.19"
  backend "gcs" {
    bucket = "storage-bucket-otus-prod"
    prefix = "terraform/state"
  }
}
