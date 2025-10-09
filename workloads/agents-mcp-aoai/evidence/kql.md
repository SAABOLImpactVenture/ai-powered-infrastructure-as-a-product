
-- Evidence summary by kind and status
Evidence_CL
| summarize count() by kind_s, status_s
