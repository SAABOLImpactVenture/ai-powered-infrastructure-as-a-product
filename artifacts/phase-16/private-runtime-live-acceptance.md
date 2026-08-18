# IaaP Guard private-runtime live acceptance

This temporary, unmerged acceptance marker triggers the installed IaaP Guard GitHub App after the protected private-core deployment.

Expected result:

- the webhook is accepted with the existing GitHub App identity and secret;
- the installation token is exchanged successfully;
- `IaaP Guard / Architecture` is published for this immutable revision;
- the non-Guard-material change preserves architecture and Evidence Continuity semantics;
- this pull request remains unmerged and is closed after evidence is retained.
