terraform {
  required_version = "~> 1"

  required_providers {
    onepassword = {
      source  = "1Password/onepassword"
      version = "~> 2"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    b2 = {
      source  = "backblaze/b2"
      version = "~> 0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2"
    }
  }

  backend "s3" {
    bucket   = "andrzej3393-homelab-tfstate"
    key      = "terraform.tfstate"
    endpoint = "https://s3.us-west-004.backblazeb2.com"
    region   = "us-west-004"

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}

# 1Password

provider "onepassword" {
  account = "https://my.1password.eu"
}

# Cloudflare

data "onepassword_item" "cloudflare" {
  vault = "Homelab"
  title = "Cloudflare"
}

locals {
  cloudflare_zone_name = [for field in data.onepassword_item.cloudflare.section[0].field : field.value if field.label == "zone"][0]
  cloudflare_token     = [for field in data.onepassword_item.cloudflare.section[0].field : field.value if field.label == "token"][0]
}

provider "cloudflare" {
  api_token = local.cloudflare_token
}

# Backblaze B2

data "onepassword_item" "b2" {
  vault = "Homelab"
  title = "Backblaze B2 terraform"
}

locals {
  b2_key_id          = [for field in data.onepassword_item.b2.section[0].field : field.value if field.label == "key_id"][0]
  b2_application_key = [for field in data.onepassword_item.b2.section[0].field : field.value if field.label == "application_key"][0]
}

provider "b2" {
  application_key    = local.b2_application_key
  application_key_id = local.b2_key_id
}

# Proxmox

data "onepassword_item" "proxmox" {
  vault = "Homelab"
  title = "Proxmox"
}

provider "proxmox" {
  endpoint = "https://proxmox.${local.cloudflare_zone_name}:8006/"
  username = "${data.onepassword_item.proxmox.username}@pam"
  password = data.onepassword_item.proxmox.password
  insecure = false
  ssh {
    agent = true
  }
}
