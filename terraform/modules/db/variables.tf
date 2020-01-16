variable public_key_path {
  description = "Path to the public key used for ssh access"
}


variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable private_key {
  description = "Path to the private key used for ssh access"
  default     = "~/.ssh/appuser"
}

variable provision_enabled {
  default = "false"
}
