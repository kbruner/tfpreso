#!/bin/bash

clear
figlet -c 'From Zero to Hello World'
figlet -c -f smslant 'with'
figlet -c -f big 'Terraform'

read -t 3 -n 1

echo 'About to kick off terraform -apply'

read -t 3 -n 1

cd terraform

terraform init

read -t 3 -n 1

terraform apply -auto-approve
