
# Kubernetes Gatekeeper Policy Pack

Includes ConstraintTemplates and Constraints for:
- Required labels: `app`, `owner`, `env`
- Deny privileged containers
- Disallow `:latest` image tags
- Enforce `runAsNonRoot=true`

Apply order:
1. Apply templates in `templates/`
2. Apply constraints in `constraints/`
