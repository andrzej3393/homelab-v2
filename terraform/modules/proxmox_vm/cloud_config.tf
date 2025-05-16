resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
  count = var.use_user_data_file ? 1 : 0

  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.node_name

  source_raw {
    data = templatefile("${path.module}/user-data-cloud-config.yaml.tftpl", {
      vm_name = var.vm_name,
      users   = var.users,
    })
    file_name = "${var.vm_name}-user-data-cloud-config.yaml"
  }
}
