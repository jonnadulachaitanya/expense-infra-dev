#!/bin/bash

component=$1
environment=$2

dnf install ansible -y
echo "component: $component", and environment: $environment

ansble-pull -i localhost, -u https://github.com/jonnadulachaitanya/expense-ansible-roles-tf.git main.yaml -e component=$component -e environment=$environment
