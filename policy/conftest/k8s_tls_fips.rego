package k8s.tlsfips

# Require TLS >= 1.2 via common ingress controllers (nginx example)
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

# Optional: enforce FIPS ciphers list if provided
deny[msg] {
  input.kind == "Ingress"
  c := input.metadata.annotations["nginx.ingress.kubernetes.io/ssl-ciphers"]
  c != ""
  not re_match("(^|.*:)TLS_AES_256_GCM_SHA384(:|$)", c)
  msg = "Ingress TLS ciphers must include FIPS-approved suites"
}
