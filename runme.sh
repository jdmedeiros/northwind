#!/usr/bin/env bash
terraform plan
terraform apply --auto-approve
terraform destroy -target aws_instance.mysqlcli --auto-approve
terraform destroy -target aws_security_group.mysqlcli --auto-approve