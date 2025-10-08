package k8srequiredlabels

default allow = false

# Required labels decision: returns a set of missing labels for convenience.
missing_required[lab] {
  required := {l | l := input.parameters.labels[_]}
  not input.review.object.metadata.labels[lab]
  lab := required[_]
}

deny[msg] {
  count(missing_required) > 0
  msg := sprintf("Missing required labels: %v", [missing_required])
}
