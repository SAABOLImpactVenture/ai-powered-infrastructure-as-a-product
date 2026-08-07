package tf.backend

deny[msg] {
  not contains_backend(input.plan)
  msg = "Remote backend missing in governed module"
}

contains_backend(plan) {
  contains(plan, "backend \"azurerm\"")
}

contains_backend(plan) {
  contains(plan, "backend \"s3\"")
}

contains_backend(plan) {
  contains(plan, "backend \"gcs\"")
}
