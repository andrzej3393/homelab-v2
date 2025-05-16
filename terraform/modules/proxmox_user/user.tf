resource "random_password" "this" {
  length  = 20
  special = false
}

resource "proxmox_virtual_environment_user" "this" {
  user_id  = "${var.username}@${var.realm}"
  password = random_password.this.result
  comment  = "Managed with Terraform."

  acl {
    path      = var.acl.path
    role_id   = var.acl.role_id
    propagate = var.acl.propagate
  }
}

resource "proxmox_virtual_environment_user_token" "this" {
  count = var.create_token ? 1 : 0

  user_id    = proxmox_virtual_environment_user.this.user_id
  token_name = var.username
  comment    = "Managed with Terraform."
}

data "onepassword_vault" "homelab" {
  name = "Homelab"
}

resource "onepassword_item" "this" {
  vault      = data.onepassword_vault.homelab.uuid
  title      = "Proxmox ${var.username}"
  category   = "login"
  note_value = "Managed with Terraform."
  password   = random_password.this.result
  username   = var.username

  section {
    label = "proxmox"

    field {
      label = "realm"
      value = var.realm
    }

    dynamic "field" {
      for_each = var.create_token ? [1] : []
      content {
        label = "token"
        value = split("=", proxmox_virtual_environment_user_token.this[0].value)[1]
        type  = "CONCEALED"
      }
    }

    dynamic "field" {
      for_each = var.create_token ? [1] : []
      content {
        label = "token_id"
        value = proxmox_virtual_environment_user_token.this[0].id
      }
    }
  }
}
