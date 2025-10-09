
# AWS OIDC (GitHub Actions)

- Create an IAM role with trust policy for `token.actions.githubusercontent.com`.
- Use `aws-actions/configure-aws-credentials@v4` and `role-to-assume`.

Terraform example is included in `platform/aws/identity` (apply it once, then reuse).
