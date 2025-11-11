The chart overlay expects a Kubernetes Secret named `backstage-mtls` in the `backstage` namespace containing:
- `client.crt` — PEM-encoded client certificate for mTLS to Postgres (if required)
- `client.key` — PEM-encoded private key (0600 permissions recommended)
- `ca.crt` — PEM-encoded CA bundle used to verify servers and proxy interception certificates

Create it like so:

kubectl -n backstage create secret generic backstage-mtls   --from-file=client.crt=./client.crt   --from-file=client.key=./client.key   --from-file=ca.crt=./ca.crt
