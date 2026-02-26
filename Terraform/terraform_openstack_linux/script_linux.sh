#!/bin/bash
terraform init

terraform plan -var-file="secrets.tfvars" -var-file="linux.tfvars"

terraform apply -var-file="secrets.tfvars" -var-file="linux.tfvars" --auto-approve

rm -rf terraform.tfstate*
rm -rf .terraform*
