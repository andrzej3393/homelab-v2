resource "b2_bucket" "state" {
  bucket_name = "andrzej3393-homelab-tfstate"
  bucket_type = "allPrivate"
  bucket_info = { "managed_by" = "Terraform" }

  default_server_side_encryption {
    algorithm = "AES256"
    mode      = "SSE-B2"
  }
}

resource "b2_bucket" "restic" {
  bucket_name = "andrzej3393-homelab-restic"
  bucket_type = "allPrivate"
  bucket_info = { "managed_by" = "Terraform" }

  default_server_side_encryption {
    algorithm = "AES256"
    mode      = "SSE-B2"
  }
}
