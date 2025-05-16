resource "cloudflare_dns_record" "mgmt" {
  count = (contains(var.network.vlans, 20) && var.cloudflare_zone_id != null) ? 1 : 0

  zone_id = var.cloudflare_zone_id
  name    = "mgmt.${var.vm_name}"
  content = "10.93.20.${var.network.host}"
  ttl     = 120
  type    = "A"
  comment = "Managed with Terraform."
}
