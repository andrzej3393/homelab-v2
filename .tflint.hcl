plugin "terraform" {
  enabled = true
  preset = "recommended"
}

rule "terraform_required_version" {
  enabled = true
}
