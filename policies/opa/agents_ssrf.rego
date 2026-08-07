package agents.ssrf

# Block cloud-instance metadata endpoints and local loopback targets when a
# tool attempts to compose an HTTP URL from model-controlled input.
deny[msg] {
  url := lower(input.tool.action.url)
  contains(url, "169.254.169.254")
  msg := "Link-local cloud metadata endpoint is not an allowed tool target"
}

deny[msg] {
  url := lower(input.tool.action.url)
  contains(url, "metadata.google.internal")
  msg := "Cloud metadata hostname is not an allowed tool target"
}

deny[msg] {
  url := lower(input.tool.action.url)
  contains(url, "127.0.0.1")
  msg := "Loopback address is not an allowed tool target"
}

deny[msg] {
  url := lower(input.tool.action.url)
  contains(url, "localhost")
  msg := "Localhost is not an allowed tool target"
}

deny[msg] {
  url := lower(input.tool.action.url)
  contains(url, "[::1]")
  msg := "IPv6 loopback is not an allowed tool target"
}
