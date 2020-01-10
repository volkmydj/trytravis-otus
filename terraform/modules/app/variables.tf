variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable app_name {
  default = "reddit-app"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable private_key {
  description = "Path to the private key used for ssh access"
  default     = "~/.ssh/appuser"
}

variable "db_reddit_ip" {
  description = "Reddit IP DB"
}

variable provision_enabled {
  default = "false"
}
