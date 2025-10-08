package k8s.privileged

test_privileged_container_is_denied {
  input := {
    "kind": "Pod",
    "spec": { "containers": [ {"name": "c1", "securityContext": {"privileged": true}} ] }
  }
  deny[_]
}

test_non_privileged_is_allowed {
  input := {
    "kind": "Pod",
    "spec": { "containers": [ {"name": "c1", "securityContext": {"privileged": false}} ] }
  }
  not deny[_]
}
