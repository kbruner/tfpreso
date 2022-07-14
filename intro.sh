#!/bin/bash

width=80

clear
figlet -c -w "$width" -f standard 'From Zero'
echo
echo
echo
figlet -c -w "$width" -f mini 'to'
echo
echo
echo
figlet -c -w "$width" -f slant 'Hello Terraform'

echo
echo
echo
echo

cd terraform

echo 'Hit enter to run terraform init'

while [ true ]; do
  read -t 3 -n 1
  if [ $? = 0 ]; then
    break
  fi
done

clear

figlet -f standard "terraform init"

echo
echo
echo

echo '$ terraform init'
time terraform init

echo
echo
echo
echo 'Hit enter to kick off terraform apply'

while [ true ]; do
  read -t 3 -n 1
  if [ $? = 0 ]; then
    break
  fi
done

clear

figlet -f standard "terraform apply"

echo
echo
echo
echo '$ terraform apply -auto-approve'
time terraform apply -auto-approve
echo
echo
echo
