package agents.scopes

# Deny wildcard or admin-like scopes.
deny[msg] {
  s := input.tool.requested_scopes[_]
  re_match("(?i)^(\*|admin|owner|full_access|all|god|superuser)$", s)
  msg := sprintf("Denied wildcard/admin scope: %v", [s])
}

# Require at least one explicit scope.
deny[msg] {
  count(input.tool.requested_scopes) == 0
  msg := "No explicit scopes requested"
}

# JIT elevation must include an approver, ticket id and non-expired time window.
deny[msg] {
  input.request.elevation_requested == true
  not input.request.ticket.id
  msg := "JIT elevation missing ticket id"
}

deny[msg] {
  input.request.elevation_requested == true
  not input.request.ticket.approver
  msg := "JIT elevation missing approver"
}

deny[msg] {
  input.request.elevation_requested == true
  time.now_ns() > time.parse_rfc3339_ns(input.request.ticket.expires_at)
  msg := "JIT elevation ticket expired"
}

# Final decision: allowed when no denies and requester identity is present.
allow {
  not deny[_]
  input.user.id
}
