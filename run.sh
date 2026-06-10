#!/bin/bash

config_file="my-ec2-landscape.json"

cd deploy || exit
terraform init -reconfigure

case $1 in
"destroy")
	terraform destroy -var "config_file=$config_file" -auto-approve
	exit $?
	;;
"plan")
	terraform plan -var "config_file=$config_file" -out="plan.out"
	exit $?
	;;
"apply")
	terraform plan -var "config_file=$config_file" -out="plan.out"
	terraform apply -auto-approve plan.out
	exit $?
	;;
"fmt")
	terraform fmt
	;;
"show")
	terraform show -json plan.out | tf-summarize -tree
	;;
"state")
	terraform state list
	;;
"validate")
	terraform validate
	;;
"")
	terraform plan -var "config_file=$config_file" -out="plan.out"
	exit $?
	;;
*)
	echo -n "Passed argument must be fmt, show, state, plan, apply, validate or destroy"
	exit 1
	;;
esac
