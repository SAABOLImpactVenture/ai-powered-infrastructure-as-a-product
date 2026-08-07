package k8s.bestpractices

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not container.livenessProbe
  msg = "Missing livenessProbe"
}

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not container.readinessProbe
  msg = "Missing readinessProbe"
}

deny[msg] {
  input.kind == "Deployment"
  image := input.spec.template.spec.containers[_].image
  endswith(image, ":latest")
  msg = "Image tag 'latest' is not allowed"
}

deny[msg] {
  input.kind == "Deployment"
  container := input.spec.template.spec.containers[_]
  not container.resources.requests
  msg = "Missing resource requests"
}

deny[msg] {
  input.kind == "Deployment"
  not input.spec.template.spec.securityContext.runAsNonRoot
  msg = "Container must runAsNonRoot"
}
