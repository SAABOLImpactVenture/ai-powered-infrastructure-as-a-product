# Backstage Guardrails

- Software Templates must invoke the policy service before provisioning.
- Store `decisionId` and evidence URL (OSCAL results blob) on the catalog entity.
- The Policy Status Card should call `/api/policy/aggregate` and display pass/fail + link to evidence.
