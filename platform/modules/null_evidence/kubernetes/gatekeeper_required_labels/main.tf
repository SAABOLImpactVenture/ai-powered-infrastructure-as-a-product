terraform {
  required_version = ">= 1.4.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32"
    }
  }
}

provider "kubernetes" {}

# ConstraintTemplate
resource "kubernetes_manifest" "template" {
  manifest = {
    "apiVersion" = "templates.gatekeeper.sh/v1beta1"
    "kind" = "ConstraintTemplate"
    "metadata" = { "name" = "k8srequiredlabels" }
    "spec" = {
      "crd" = {
        "spec" = {
          "names" = { "kind" = "K8sRequiredLabels" }
          "validation" = {
            "openAPIV3Schema" = {
              "properties" = {
                "labels" = { "type" = "array", "items" = { "type" = "string" } }
              }
            }
          }
        }
      }
      "targets" = [{
        "target" = "admission.k8s.gatekeeper.sh"
        "rego" = <<-EOT
          package k8srequiredlabels
          violation[{"msg": msg}] {
            provided := {label | input.review.object.metadata.labels[label]}
            required := {label | label := input.parameters.labels[_]}
            missing := required - provided
            count(missing) > 0
            msg := sprintf("Missing required labels: %v", [missing])
          }
        EOT
      }]
    }
  }
}

# Constraint
resource "kubernetes_manifest" "constraint" {
  manifest = {
    "apiVersion" = "constraints.gatekeeper.sh/v1beta1"
    "kind" = "K8sRequiredLabels"
    "metadata" = { "name" = "require-owner-label" }
    "spec" = {
      "match" = {
        "kinds" = [ { "apiGroups" = [""], "kinds" = ["Pod"] } ]
      }
      "parameters" = { "labels" = var.required_labels }
    }
  }
  depends_on = [kubernetes_manifest.template]
}
