ENV ?= dev
TF_BACKEND_CONFIG ?= backend.${ENV}.tfvars

.PHONY: init plan apply
init:
	terraform init -input=false -backend-config=$(TF_BACKEND_CONFIG)

plan: init
	terraform plan -input=false -out=tfplan.bin

apply:
	terraform apply -input=false -lock-timeout=10m tfplan.bin
