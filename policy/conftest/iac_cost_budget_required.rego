package iac.cost

deny[msg] {
  not input_has_budget
  msg = "No budget module detected; add cost/*/budget in platform stack"
}

input_has_budget {
  p := input.path
  contains(p, "cost/aws/budget")
}

input_has_budget {
  p := input.path
  contains(p, "cost/azure/budget")
}

input_has_budget {
  p := input.path
  contains(p, "cost/gcp/budget")
}

input_has_budget {
  p := input.path
  contains(p, "cost/oci/budget")
}
