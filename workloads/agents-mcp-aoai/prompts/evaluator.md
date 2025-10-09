# Evaluator — Validate PlanReview JSON

Given a candidate PlanReview JSON, validate **structure** against the schema and assess **reasonableness**:
- Deltas must be non-negative integers.
- If `status` is RED, ensure `rationale` cites concrete risk factors.
- If `uncertainty` is true, ensure the summary explicitly says what is unknown.
- Controls should be from NIST families (AC, IA, CM, AU, SC, SI, SA, CA).

Output JSON:
{
  "valid": true|false,
  "errors": ["..."],
  "score": 0-100,
  "improvements": ["..."]
}
