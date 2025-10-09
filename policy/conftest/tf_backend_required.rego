package tf.backend

deny[msg] {
  not inputContainsBackend
  msg = "Terraform module is missing a remote backend stanza (azurerm/s3/gcs)."
}

inputContainsBackend {
  re_match("backend\s+"(azurerm|s3|gcs)"", input)
}
