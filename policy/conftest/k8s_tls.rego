package k8s.tls

# Ingress must enforce TLS >= 1.2 (annotation-based for common ingress controllers)
deny[msg] {
  input.kind == "Ingress"
  not input.metadata.annotations["nginx.ingress.kubernetes.io/ssl-protocols"]
  msg = "Ingress is missing TLS protocol pin (nginx: ssl-protocols)"
}

deny[msg] {
  input.kind == "Ingress"
  protocols := input.metadata.annotations["nginx.ingress.kubernetes.io/ssl-protocols"]
  not contains(protocols, "TLSv1.2")
  msg = "Ingress must allow TLSv1.2+"
}
