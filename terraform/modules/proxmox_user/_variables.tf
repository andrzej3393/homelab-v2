variable "username" {
  description = "Username of the user"
  type        = string
}

variable "realm" {
  description = "Realm of the user"
  type        = string

  validation {
    condition     = contains(["pve", "pam"], var.realm)
    error_message = "Realm must be either 'pve' or 'pam'."
  }
}

variable "acl" {
  description = "Access control list"
  type = object({
    path      = string
    role_id   = string
    propagate = optional(bool, true)
  })
}

variable "create_token" {
  description = "Create a token for the user"
  type        = bool
  default     = false
}
