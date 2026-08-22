# Data classification

**Requirement ID:** `BFR-DAT-001`

> **Status:** Proposed Bootstrap and Foundation Readiness requirement. It does not authorize processing of customer, taxpayer, CUI, regulated, or other nonpublic data in current synthetic IaaP paths.

## Requirement

The customer must classify every input, output, log, prompt, model response, configuration export, evidence artifact, backup, and product workload, then bind allowed storage, access, location, transmission, retention, redaction, model processing, and disposition to that classification.

## Why this requirement exists

Architecture documents and cloud metadata can be sensitive even without workload payloads. Composite AI and evidence workflows may create derived data with equal or greater sensitivity. Without classification, controls are chosen by assumption and data can cross an unauthorized boundary.

## Applicability

Classification is mandatory at intake. Simulation defaults to synthetic/sanitized data. Discovery requires approved metadata fields and redaction. Live sandbox, pilot, and production consideration require exact workload/evidence classifications and authorized processing boundaries.

## Customer decisions

The customer must decide:

- authoritative classification scheme, labels, owners, and handling rules;
- classification of repositories, diagrams, policies, metadata, logs, evidence, prompts, responses, and derived summaries;
- approved environments, regions, stores, identities, networks, exports, backups, and retention by class;
- prohibited content and minimization/redaction/tokenization requirements;
- model/provider eligibility, training/retention terms, egress, and human-review constraints by class;
- data residency, legal hold, records, privacy, sharing, and disposal obligations;
- reclassification and spill-response procedures; and
- how uncertainty is handled when classification cannot be established.

## Minimum acceptable state by stage

| Stage | Minimum acceptable state |
|---|---|
| Assessment | Every source has an owner/classification or is excluded; prohibited data is documented. |
| Simulation | Synthetic fixtures only unless sanitized data has explicit approval and verified redaction. |
| Read-only discovery | Collected metadata schema, redaction, destination, retention, and AI eligibility are approved. |
| Live sandbox | Product/evidence classifications match target controls, identity, network, encryption, logging, backup, and model policy. |
| Pilot | Real workload/consumer data is bounded, consented, monitored, retained, exported, and disposed under approved rules. |
| Production consideration | Enterprise data, privacy, records, residency, and authorization owners formally accept the full lifecycle. |

## Composite AI assistance

Composite AI may suggest candidate classifications, detect possible sensitive markers after local controls, explain handling differences, and draft data-flow questions.

It must not make the authoritative classification, receive prohibited data, downgrade derived output, assume provider processing consent, retain raw inputs outside policy, or declare redaction complete without deterministic evidence.

## Deterministic validation target

A future validator should require classification and owner on every input/output class, compare it with environment/region/store/access/retention/model rules, scan for prohibited markers, and verify redaction and disposition. Unknown classification, mismatched target, external-model use without approval, or raw sensitive data in evidence should fail closed. This is a proposed target.

## Human approval

Data owners classify and approve use. Privacy, records, legal, security, and authorization roles approve applicable handling. AI governance approves model processing. Technical teams may recommend but cannot downgrade classification.

## Required evidence

- classification scheme and handling matrix;
- data/source inventory with owners and labels;
- data-flow and processing-boundary diagram;
- environment, region, access, encryption, retention, backup, and export mappings;
- model/provider processing decision and terms evidence;
- redaction/minimization and negative-fixture tests;
- spill/incident response exercise; and
- retention, reclassification, and disposal records.

## `FoundationReadinessDecision` behavior

- `CONTINUE`: all data and derived evidence are classified, minimized, handled, and processed within approved boundaries.
- `CONTINUE_WITH_CONDITIONS`: synthetic or lower-class sanitized work may proceed while higher-class sources and external models remain excluded.
- `STOP`: classification/owner is unknown, target controls do not match, prohibited data is present, consent/terms are absent, or disposition cannot be proven.

## Forge handoff

Forge receives only an allowed classification value supported by the selected, versioned product contract plus policy references. It does not accept arbitrary new classifications through documentation, downgrade data, or send intent/evidence to a model without a separate approved adapter boundary.

## Exceptions and prohibited shortcuts

Exceptions require data owner, exact fields/flows, purpose, controls, processors, duration, and disposal. Never label real data synthetic, use “internal” as a catch-all, paste customer data into prompts, retain raw discovery exports unnecessarily, infer consent from access, or let AI decide declassification.

## Related requirements

- [`BFR-AIG-001` AI governance](ai-governance.md)
- [`BFR-KMS-001` Encryption and key management](encryption-and-key-management.md)
- [`BFR-ING-001` Ingress and egress](ingress-and-egress.md)
- [`BFR-EVD-001` Evidence and traceability](evidence-and-traceability.md)
