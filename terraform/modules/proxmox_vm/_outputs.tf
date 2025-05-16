output "ip_addresses" {
  value = { for vlan in var.network.vlans : "vlan_${vlan}" => "10.93.${vlan}.${var.network.host}" }
}
