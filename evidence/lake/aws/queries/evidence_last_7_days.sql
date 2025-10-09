-- Query evidence JSON columns
SELECT kind, status, ts
FROM evidence_json
WHERE ts >= date_add('day', -7, current_timestamp);
