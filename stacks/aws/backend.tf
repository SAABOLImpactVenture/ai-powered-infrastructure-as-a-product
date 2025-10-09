terraform {
  backend "s3" {
    bucket         = "tfstate-<env>"
    key            = "global/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfstate-<env>-locks"
    encrypt        = true
  }
}
