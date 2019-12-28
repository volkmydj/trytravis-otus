variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable public_key_path {

  description = "Path to the public key used for ssh access"
}

variable disk_image {
  description = "Disk Image"
}

variable private_key {
  description = "Path to the private key used for ssh access"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable users {
  default = ["appuser", "appuser1", "appuser2", "appuser3"]
}
