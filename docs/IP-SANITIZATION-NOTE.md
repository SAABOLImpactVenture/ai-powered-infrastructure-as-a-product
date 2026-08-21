# Public IP Sanitization Note

The current public branch intentionally keeps historical capability evidence while reducing unnecessary disclosure of private product implementation, deployment identifiers, commercial hypotheses, and operational internals.

Historical commits remain available in Git history for provenance. Their continued historical availability does not make those implementation details part of the current supported public product surface.

Current public evidence should focus on:

- the capability demonstrated;
- the trust and authority boundary;
- the bounded acceptance result;
- whether teardown or cleanup was verified when relevant; and
- any limitation necessary to interpret the result accurately.

Current public evidence should avoid private repository revisions, internal entitlement mechanics, pricing hypotheses, physical cloud resource names, IAM-role details, workflow/job identifiers, secret-reference topology, and other operational implementation detail when those facts are not necessary to substantiate the public claim.
