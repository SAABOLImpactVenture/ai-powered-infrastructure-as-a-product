terraform {
  backend "gcs" {}
  required_providers { google = { source="hashicorp/google", version=">= 5.40" } }
}
provider "google" {}
