package k8s.bestpractices

deny[msg] {
  input.kind == "Deployment"
  not input.spec.template.spec.containers[_].livenessProbe
  msg = "Missing livenessProbe"
}

deny[msg] {
  input.kind == "Deployment"
  not input.spec.template.spec.containers[_].readinessProbe
  msg = "Missing readinessProbe"
}

deny[msg] {
  input.kind == "Deployment"
  input.spec.template.spec.containers[_].image == /:latest$/
  msg = "Image tag 'latest' is not allowed"
}

deny[msg] {
  input.kind == "Deployment"
  not input.spec.template.spec.containers[_].resources.requests
  msg = "Missing resource requests"
}

deny[msg] {
  input.kind == "Deployment"
  not input.spec.template.spec.securityContext.runAsNonRoot
  msg = "Container must runAsNonRoot"
}
