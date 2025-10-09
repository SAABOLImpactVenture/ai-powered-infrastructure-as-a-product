# Module: kubernetes/gatekeeper_required_labels

Installs a Gatekeeper ConstraintTemplate and Constraint that require labels on pods.

## Requirements
- A Kubernetes cluster with Gatekeeper installed
- Kubernetes provider credentials configured

## Example
```hcl
terraform {
  required_providers {
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.32" }
  }
}
provider "kubernetes" {}

module "gk_labels" {
  source = "../../platform/modules/kubernetes/gatekeeper_required_labels"
  required_labels = ["owner","cost-center"]
}
```
