package agents.actions

default allow = false

danger_verbs := {
  "delete","drop","truncate","transfer","wire","terminate",
  "revoke","rotate","shutdown","scale_down","change_dns",
  "open_ingress","disable_mfa","purge","make_public","approve_payment"
}

# Block danger verbs unless there is explicit human approval.
deny[msg] {
  v := lower(input.tool.action.verb)
  danger_verbs[v]
  not input.tool.approval.human_approved
  msg := sprintf("Danger verb '%s' requires human approval", [v])
}

# Require natural-language justification for any tool call.
deny[msg] {
  not input.tool.justification
  msg := "Tool call missing natural-language justification"
}

# Minimal hygiene: block tool calls when injection risk is high.
deny[msg] {
  input.model.injection_risk == "high"
  not input.tool.approval.human_approved
  msg := "High injection risk without human approval"
}

allow { not deny[_] }
