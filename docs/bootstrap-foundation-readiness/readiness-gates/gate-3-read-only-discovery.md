# Gate 3 — read-only discovery

**Requirement ID:** `BFR-GATE-003`

> **Status:** Architecture target. The credential-free POCs use supplied fixtures and sanitized status; they do not authenticate to or inspect a customer cloud. Current Guard V1 does not require customer-cloud credentials, and this gate does not change that boundary.

## Gate objective

Verify selected current-state assumptions against a live cloud environment through a narrowly scoped, short-lived, revocable, auditable read-only adapter.

## Entry criteria

- Gate 2 evidence is complete for the discovery adapter's contract.
- [Read-only discovery prerequisites](../prerequisites/discovery-prerequisites.md) are satisfied.
- Exact organizations, accounts, subscriptions, projects, folders, regions, services, and environments are named.
- The effective permissions exclude mutation, secret values, and workload data-plane access.
- Discovery and provisioning identities are separate.
- Collection, redaction, Composite AI use, retention, and deletion are approved.

## Permitted activity

- inventory approved metadata and configuration fields;
- compare observed state with customer-supplied evidence;
- verify dependencies, ownership tags, enabled services, and selected policy state;
- produce sanitized observations with source time and scope; and
- revoke access after the authorized window or collection completes.

## Prohibited activity

- cloud mutation of any kind;
- secret, key, token, payload, object-content, or database-record reads;
- organization-wide wildcard access without an explicit documented need;
- reusing a provisioning principal;
- giving Composite AI raw credentials or direct uncontrolled API access; and
- treating discovered configuration as authorization or compliance proof by itself.

## Required exit evidence

- approved target and API action scope;
- identity issuer, subject, audience, session, and expiration;
- effective-permission or policy-simulation result;
- complete audit-log capture test;
- versioned collection and redaction schema;
- sanitized discovery artifact with timestamp and integrity digest;
- differences between asserted and observed state;
- revocation result; and
- reviewer disposition for every material difference.

## Exit decision

- `CONTINUE`: current state is sufficiently verified to evaluate a bounded live sandbox.
- `CONTINUE_WITH_CONDITIONS`: assessment may use customer-supplied exports or a narrower discovery scope; provisioning stays disabled.
- `STOP`: permissions are broader than approved, sensitive data is exposed, collection is unaudited, or target identity is ambiguous.

## POC traceability boundary

The Composite AI POC accepts only structured intent and sanitized product status. Its no-network, no-credential design is useful authority evidence, but it is not a discovery adapter. All live-cloud discovery controls on this page are new.

## Related requirements

- [Gate 4 — live sandbox](gate-4-live-sandbox.md)
- [Provider-neutral contract](../providers/provider-neutral-contract.md)
- [Evidence requirements](../evidence/evidence-requirements.md)
- [Exceptions and expiration](../decisions/exceptions-and-expiration.md)
