terraform {
  backend "gcs" {
    bucket = "storage-bucket-otus-stage"
    prefix = "terraform/state"
  }
}
