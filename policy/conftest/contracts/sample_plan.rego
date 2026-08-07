package main

import rego.v1

deny contains msg if {
  some resource in input.resource_changes
  resource.name == "bad"
  msg := "Sample plan contains a deliberately noncompliant resource fixture"
}

deny contains msg if {
  some resource in input.resource_changes
  resource.name == "badbucket"
  msg := "Sample plan contains a deliberately noncompliant bucket fixture"
}
