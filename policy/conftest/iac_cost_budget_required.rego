package iac.cost

deny[msg] {
  not inputHasBudget
  msg = "No budget module detected; add cost/*/budget in platform stack"
}

inputHasBudget {
  some i
  contains(input, "cost/aws/budget") or contains(input, "cost/azure/budget") or contains(input, "cost/gcp/budget") or contains(input, "cost/oci/budget")
}
