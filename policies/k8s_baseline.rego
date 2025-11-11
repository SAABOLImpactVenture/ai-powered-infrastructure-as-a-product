package kubernetes.baseline

default deny = []

deny[msg] {
  input.kind == "Pod" or input.kind == "Deployment" or input.kind == "StatefulSet" or input.kind == "DaemonSet"
  container := input.spec.containers[_]
  not container.securityContext.runAsNonRoot
  msg := sprintf("%s/%s: containers must runAsNonRoot", [input.kind, input.metadata.name])
}

deny[msg] {
  input.kind == "Pod" or input.kind == "Deployment" or input.kind == "StatefulSet" or input.kind == "DaemonSet"
  container := input.spec.containers[_]
  not container.securityContext.capabilities.drop
  msg := sprintf("%s/%s: containers must drop Linux capabilities (NET_RAW at minimum)", [input.kind, input.metadata.name])
}

deny[msg] {
  input.spec.hostNetwork == true
  msg := sprintf("%s/%s: hostNetwork is not allowed", [input.kind, input.metadata.name])
}

deny[msg] {
  input.spec.hostPID == true
  msg := sprintf("%s/%s: hostPID is not allowed", [input.kind, input.metadata.name])
}

deny[msg] {
  input.spec.hostIPC == true
  msg := sprintf("%s/%s: hostIPC is not allowed", [input.kind, input.metadata.name])
}

deny[msg] {
  container := input.spec.containers[_]
  not container.resources.limits
  msg := sprintf("%s/%s: containers must define resource limits", [input.kind, input.metadata.name])
}

deny[msg] {
  container := input.spec.containers[_]
  endswith(container.image, ":latest") or not contains(container.image, ":")
  msg := sprintf("%s/%s: containers must pin image tags (no latest)", [input.kind, input.metadata.name])
}
