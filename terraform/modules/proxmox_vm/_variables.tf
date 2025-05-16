variable "vm_name" {
  description = "Name of the VM"
  type        = string
}

variable "node_name" {
  description = "Name of the Proxmox node"
  type        = string
}

variable "vm_id" {
  description = "ID of the VM"
  type        = number
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
}

variable "ram_mb" {
  description = "Amount of RAM in MB"
  type        = number
}

variable "disk" {
  description = "Disk configuration"
  type = object({
    size          = number
    storage       = string
    image_file_id = string
  })
}

variable "pci" {
  type = list(object({
    mapping_name = string
    pcie         = bool
    rombar       = bool
  }))
  default = []
}

variable "usb" {
  type = list(object({
    mapping_name = string
    usb3         = bool
  }))
  default = []
}

variable "network" {
  type = object({
    host  = number
    vlans = list(number)
  })
}

variable "users" {
  type = list(object({
    username       = string
    shell          = optional(string, "/bin/bash")
    public_ssh_key = optional(string, "")
    sudo           = optional(string, "none")
  }))
  default = []

  validation {
    condition     = alltrue([for user in var.users : contains(["none", "all", "all_nopasswd"], user.sudo)])
    error_message = "sudo must be one of: none, all, all_nopasswd"
  }
}

variable "start_on_boot" {
  description = "Start the VM on boot"
  type        = bool
  default     = true
}

variable "prod" {
  description = "Production VM"
  type        = bool
  default     = false
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID"
  type        = string
  default     = null
}

variable "use_user_data_file" {
  description = "Use user data file"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags for the VM"
  type        = list(string)
  default     = []
}
