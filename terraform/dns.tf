locals {
  dns_records = [
    {
      name    = "printer"
      content = "10.93.10.11"
    },
    {
      name    = "bmc"
      content = "10.93.20.4"
    },
    {
      name    = "switch"
      content = "10.93.20.2"
    },
    {
      name    = "ap"
      content = "10.93.20.3"
    },
  ]
}

data "cloudflare_zone" "homelab" {
  filter = {
    name = local.cloudflare_zone_name
  }
}

resource "cloudflare_dns_record" "this" {
  for_each = { for record in local.dns_records : record.name => record }

  zone_id  = data.cloudflare_zone.homelab.zone_id
  name     = each.value.name
  content  = each.value.content
  ttl      = try(each.value.ttl, 120)
  type     = try(each.value.type, "A")
  priority = try(each.value.priority, 10)
  comment  = "Managed with Terraform."
}
