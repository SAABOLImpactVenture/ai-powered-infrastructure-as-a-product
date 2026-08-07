package iac.cost

deny[msg] {
  not module_has_budget
  msg = "Cost budget module missing (azure/aws/gcp/oci). Add one under observability/cost/*."
}

module_has_budget {
  p := input.path
  re_match("observability/cost/(azure|aws|gcp|oci)/budget", p)
}
