# Enterprise Interoperability

The modern accelerator is intentionally not a universal replacement for every enterprise platform.

## Principle

> **Integrate where an enterprise capability is authoritative; do not inherit it as a dependency unless the product requires it.**

## Terraform / OpenTofu / TFE

An enterprise may retain Terraform or TFE for brownfield state, migrations, unsupported resources, or accredited workflows. Those systems should remain external to the maintained accelerator unless a future ADR establishes a new product requirement.

The consumer product contract should not expose workspaces, state, module topology, or plan/apply details.

## Backstage or another portal

A portal can present product documentation, ownership, request experiences, and links. It is an experience layer, not the product contract or control plane.

## Azure Arc

Arc can remain useful for hybrid inventory, governance, or Kubernetes management in an Azure-centered enterprise. It is not required to unify the product architecture.

## Ticketing, CMDB, and service management

GitHub governs product source and change. Tickets, CMDB, incident systems, and records platforms may remain authoritative for their existing responsibilities. Link rather than duplicate when duplication creates ownership disputes.

## Existing account/project factories

If an enterprise already has an authoritative vending system, a foundation product can integrate with or depend on it. Crossplane should not silently create a second authority for the same resource.

## Rule

One external resource has one authoritative owner and reconciler.
