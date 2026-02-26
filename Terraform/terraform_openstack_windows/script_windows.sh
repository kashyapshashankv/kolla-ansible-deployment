#!/bin/bash
terraform init

terraform plan -var-file="secrets.tfvars" -var-file="windows.tfvars"

terraform apply -var-file="secrets.tfvars" -var-file="windows.tfvars" --auto-approve


rm -rf terraform.tfstate*
rm -rf .terraform*