# Ensure TF state is never local
guard-backend:
	@grep -R 'backend\s*"' -n $$PATH || (echo 'Backend not configured in $${PATH}'; exit 1)

# Usage: make tf-plan PATH=platform/aws/networking
tf-plan: guard-backend
	cd $(PATH) && terraform init -input=false && terraform plan -out=tfplan.bin -lock=false -input=false

tf-apply:
	cd $(PATH) && terraform apply -lock-timeout=10m -input=false tfplan.bin
