terraform {
  backend "gcs" {
    bucket = "tfstate-<project>"
    prefix = "state"
  }
}
