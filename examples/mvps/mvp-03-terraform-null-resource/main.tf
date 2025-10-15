terraform { required_version = ">= 1.4.0" }
module "evidence" {
  source = "../../../platform/modules/null_evidence"
  detail = "mvp-03 execution"
}
