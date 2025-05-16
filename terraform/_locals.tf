locals {
  vlans = {
    clients  = 10
    mgmt     = 20
    services = 30
    guest    = 40
    iot      = 50
    not      = 60
    nfs      = 82
  }

  vm_user_ansible = {
    username       = "ansible"
    shell          = "/bin/bash"
    public_ssh_key = data.local_file.ssh_public_key.content
    sudo           = "all_nopasswd"
  }
  vm_user_andrzej3393 = {
    username       = "andrzej3393"
    shell          = "/bin/bash"
    public_ssh_key = data.local_file.ssh_public_key.content
    sudo           = "all_nopasswd"
  }

  proxmox_nodes = [
    {
      name = "proxmox"
      usb_mappings = {
        "bdrom"      = "152e:2571"
        "skyconnect" = "10c4:ea60"
        "bluetooth"  = "33fa:0001"
        "rtl-sdr"    = "0bda:2838"
      }
      pci_mapping = {
        "gpu" = {
          path         = "0000:18:00"
          iommu_group  = 3
          subsystem_id = "1028:c723"
          id           = "10de:1e84"
        }
      }
    }
  ]
}

data "local_file" "ssh_public_key" {
  filename = "/home/andrzej3393/.ssh/id_rsa.pub"
}
