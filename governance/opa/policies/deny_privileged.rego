package k8s.privileged

deny[msg] {
  input.kind == "Pod"
  some i
  c := input.spec.containers[i]
  c.securityContext.privileged == true
  msg := "Privileged containers are not allowed"
}
