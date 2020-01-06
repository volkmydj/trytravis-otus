variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable role_entity {
  description = "List of role/entity pairs in the form ROLE:entity."
  type        = "list"
  default     = ["aaaaa"]
}
