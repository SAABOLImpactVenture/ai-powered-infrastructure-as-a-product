package tf.backend

deny[msg] {
  not contains_backend(input.plan)
  msg = "Remote backend missing in governed module"
}

contains_backend(plan) {
  re_match("backend\s+\"(azurerm|s3|gcs)\"", plan)
}
