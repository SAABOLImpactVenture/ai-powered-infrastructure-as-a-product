# ADR: CloudEvents v1.0 for Evidence Envelopes
**Date:** 2025-01-02  
**Status:** Accepted

## Context
Events and evidence need a portable envelope.

## Decision
Use **CloudEvents v1.0** fields (`id`, `type`, `source`, `time`, `dataschema`) for any cross-system evidence messages.

## Consequences
- Easier broker routing
- Clear IDs and times for replay and audits
