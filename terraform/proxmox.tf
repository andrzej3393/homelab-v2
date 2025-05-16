locals {
  proxmox_usb_mappings = flatten([
    for node in local.proxmox_nodes : [
      for name, id in node.usb_mappings : {
        node = node.name
        name = name
        id   = id
      }
    ]
  ])
  proxmox_pci_mappings = flatten([
    for node in local.proxmox_nodes : [
      for name, details in node.pci_mapping : {
        node         = node.name
        name         = name
        id           = details.id
        iommu_group  = details.iommu_group
        subsystem_id = details.subsystem_id
        path         = details.path
      }
    ]
  ])
}

resource "proxmox_virtual_environment_cluster_options" "homelab" {
  language = "en"
  keyboard = "pl"
}

resource "proxmox_virtual_environment_hardware_mapping_usb" "this" {
  for_each = { for mapping in local.proxmox_usb_mappings : "${mapping.node}-${mapping.name}" => mapping }
  name     = each.value.name
  comment  = "Managed with Terraform"
  map = [
    {
      id   = each.value.id
      node = each.value.node
    }
  ]
}

resource "proxmox_virtual_environment_hardware_mapping_pci" "this" {
  for_each = { for mapping in local.proxmox_pci_mappings : "${mapping.node}-${mapping.name}" => mapping }
  name     = each.value.name
  comment  = "Managed with Terraform"
  map = [
    {
      id           = each.value.id
      node         = each.value.node
      iommu_group  = each.value.iommu_group
      subsystem_id = each.value.subsystem_id
      path         = each.value.path
    }
  ]
}

resource "proxmox_virtual_environment_download_file" "debian_12_cloud_image" {
  for_each = { for node in local.proxmox_nodes : node.name => node }

  content_type = "iso"
  datastore_id = "local"
  node_name    = each.key

  url       = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
  file_name = "debian-12.img"
}

resource "proxmox_virtual_environment_download_file" "ubuntu-24-04-cloud-image" {
  for_each = { for node in local.proxmox_nodes : node.name => node }

  content_type = "iso"
  datastore_id = "local"
  node_name    = each.key

  url       = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  file_name = "ubuntu-24-04.img"
}

module "proxmox_prometheus_user" {
  source = "./modules/proxmox_user"

  username = "prometheus"
  realm    = "pve"
  acl = {
    path    = "/"
    role_id = "PVEAuditor"
  }
}

module "proxmox_homepage_user" {
  source = "./modules/proxmox_user"

  username     = "homepage"
  realm        = "pve"
  create_token = true
  acl = {
    path    = "/"
    role_id = "PVEAuditor"
  }
}
