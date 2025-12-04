terraform {
  required_version = "~> 1"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 5"
    }
  }
}
