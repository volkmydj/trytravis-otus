terraform {
  backend "gcs" {
    bucket = "storage-bucket-otus-prod"
    prefix = "terraform/state"
  }
}
