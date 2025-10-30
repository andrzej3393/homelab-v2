terraform {
  required_version = "~> 1"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0"
    }
    onepassword = {
      source  = "1Password/onepassword"
      version = ">= 2"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3"
    }
  }
}
