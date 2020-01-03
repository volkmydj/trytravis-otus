terraform {
  required_version = "0.12.8"
  backend "gcs" {
    bucket = "storage-bucket-volkmydj"
    prefix = "terraform/state"
  }
}

# provider "google" {
#   version = "2.15.0"
#   project = var.project
#   region  = var.region
# }
