package agents.egress

default allow = false

# Organization-level allowlist. Extend via policy distribution.
allowed_hosts := {
  "api.github.com",
  "status.github.com",
  "api.atlassian.com",
  "jira.example.gov",
  "confluence.example.gov",
  "packages.example.s3.us-gov-west-1.amazonaws.com"
}

# Only allow if FQDN is explicitly in allowlist.
allow {
  h := lower(input.request.host)
  allowed_hosts[h]
}
