package k8s.tls

deny[msg] {
  input.kind == "Ingress"
  not input.metadata.annotations["nginx.ingress.kubernetes.io/ssl-protocols"]
  msg = "Ingress missing nginx ssl-protocols annotation"
}
deny[msg] {
  input.kind == "Ingress"
  protocols := input.metadata.annotations["nginx.ingress.kubernetes.io/ssl-protocols"]
  not contains(protocols, "TLSv1.2")
  msg = "Ingress must allow TLSv1.2 or higher"
}
