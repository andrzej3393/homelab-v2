locals {
  environment = var.prod ? "prod" : "experimental"

  tags = [
    local.environment,
  ]
}

resource "proxmox_virtual_environment_vm" "this" {
  name      = var.vm_name
  vm_id     = var.vm_id
  node_name = var.node_name

  description     = "Managed with Terraform & Ansible."
  tags            = concat(local.tags, var.tags)
  keyboard_layout = "pl"
  on_boot         = var.start_on_boot
  protection      = var.prod

  agent {
    enabled = true
  }

  bios    = "ovmf"
  machine = "q35"

  cpu {
    cores = var.cpu_cores
    type  = "host"
  }

  memory {
    dedicated = var.ram_mb
    floating  = 0
  }

  initialization {
    datastore_id      = var.disk.storage
    user_data_file_id = var.use_user_data_file ? proxmox_virtual_environment_file.user_data_cloud_config[0].id : null

    dynamic "ip_config" {
      for_each = var.network.vlans
      content {
        ipv4 {
          address = "10.93.${ip_config.value}.${var.network.host}/24"
          gateway = "10.93.${ip_config.value}.1"
        }
      }
    }
  }

  dynamic "network_device" {
    for_each = var.network.vlans
    content {
      vlan_id = network_device.value
    }
  }

  dynamic "hostpci" {
    for_each = var.pci
    content {
      device  = "hostpci${hostpci.key}"
      mapping = hostpci.value.mapping_name
      pcie    = hostpci.value.pcie
      rombar  = hostpci.value.rombar
    }
  }

  dynamic "usb" {
    for_each = var.usb
    content {
      mapping = usb.value.mapping_name
      usb3    = usb.value.usb3
    }
  }

  disk {
    size         = var.disk.size
    datastore_id = var.disk.storage
    file_id      = var.disk.image_file_id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    file_format  = "raw"
  }

  efi_disk {
    datastore_id = var.disk.storage
    file_format  = "raw"
    type         = "4m"
  }

  operating_system {
    type = "l26"
  }

  vga {
    type = "std"
  }

  serial_device {}

  lifecycle {
    ignore_changes = [
      disk[0].file_id,
    ]
  }
}
