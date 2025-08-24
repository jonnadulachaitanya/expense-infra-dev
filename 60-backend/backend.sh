#!/bin/bash

component=$1
environment=$2

echo "component: $component, environment: $environment"
ansible-pull -vvv -i localhost, -U https://github.com/jonnadulachaitanya/expense-ansible-roles-tf.git -e component=$component -e environment=$environment main.yaml

