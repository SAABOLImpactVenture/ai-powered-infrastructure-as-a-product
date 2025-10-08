package k8srequiredlabels

test_missing_labels_denied {
  input := {
    "parameters": {"labels": ["owner", "cost-center"]},
    "review": {"object": {"metadata": {"labels": {"owner": "team-a"}}}}
  }
  count(missing_required) == 1
  deny[_]
}

test_all_labels_allowed {
  input := {
    "parameters": {"labels": ["owner", "cost-center"]},
    "review": {"object": {"metadata": {"labels": {"owner": "team-a", "cost-center": "it"}}}}
  }
  count(missing_required) == 0
  not deny[_]
}
