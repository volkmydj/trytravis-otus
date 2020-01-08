terraform {
  required_version = "0.12.8"
  #project          = "${var.project}"
  backend "gcs" {
    bucket = "storage-bucket-otus-prod"
    prefix = "terraform/state"
  }
}
# data "terraform_remote_state" "foo" {
#   backend = "gcs"
#   config = {
#     bucket = "/storage-bucket-otus-prod"
#     prefix = "prod"
#   }
# }
