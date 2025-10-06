terraform {
  required_version = ">= 1.4.0"
}

resource "null_resource" "mock_change" {
  triggers = {
    timestamp = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      python ../../scripts/emitters/infra-evidence/emit_evidence_to_log_analytics.py         --kind "validate" --status "success" --detail "null_resource applied"
    EOT
    interpreter = ["bash", "-c"]
  }
}
