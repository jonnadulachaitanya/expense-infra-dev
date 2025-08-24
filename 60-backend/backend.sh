#!/bin/bash

component=$1
environment=$2

echo "component: $component, environment: $2"
ansible-pull -i localhost, -u https://github.com/jonnadulachaitanya/expense-ansible-roles-tf main.yaml -e component=$component -e environment=$environment

