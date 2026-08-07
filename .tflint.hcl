config {
  call_module_type = "local"
  force            = false
}

# The credential-free baseline owns Terraform-language quality only. Provider-
# specific correctness is validated through `terraform validate`, Checkov, and
# provider/live-cloud evidence gates. Cloud rulesets may be added later only
# when their source and version are explicitly pinned.
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}
