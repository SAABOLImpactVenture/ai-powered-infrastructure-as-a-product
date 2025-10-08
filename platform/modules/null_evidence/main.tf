terraform { required_version = ">= 1.4.0" }
resource "null_resource" "evidence" {
  triggers = { ts = timestamp(), detail = var.detail }
  provisioner "local-exec" {
    command = <<EOT
      python ../../scripts/emitters/infra-evidence/emit_evidence_to_log_analytics.py         --kind "module.null_evidence" --status "success" --detail "${var.detail}"
    EOT
    interpreter = ["bash","-c"]
  }
}
