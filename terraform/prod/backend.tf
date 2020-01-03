terraform {
  required_version = "0.12.8"
  backend "gcs" {
    bucket = "storage-bucket-volkmydj2"
    prefix = "terraform/state"
  }
}
