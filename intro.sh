#!/bin/bash

width=80

clear
figlet -c -w "$width" -f standard 'From Zero'
figlet -c -w "$width" -f mini 'to'
figlet -c -w "$width" -f slant 'Hello Terraform'

echo
echo
sleep 5

echo 'Hit enter to kick off terraform -apply'

while [ true ]; do
  read -t 3 -n 1
  if [ $? = 0 ]; then
    break
  fi
done

cd terraform

time terraform init
time terraform apply -auto-approve
