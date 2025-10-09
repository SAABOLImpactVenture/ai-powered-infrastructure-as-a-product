package docker.security

deny[msg] {
  input.Cmd[_] == "USER root"
  msg = "Container runs as root"
}

deny[msg] {
  some i
  startswith(input.RepoTags[i], "latest")
  msg = "Image is tagged 'latest'"
}
