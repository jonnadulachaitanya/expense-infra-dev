#!/bin/bash
dnf install ansible -y
cd /tmp
git clone https://github.com/jonnadulachaitanya/expense-ansible.git
cd expense-ansible
ansible-playbook -i inventory.ini 1-mysql.yaml
ansible-playbook -i inventory.ini backend.yaml
ansible-playbook -i inventory.ini frontend.yaml


#To connect MYSQL db from ansible or any other server:
# mysql -h 10.0.21.119 -u root -pExpenseApp@1
# show databases;
# use transaction;
# select * from transactions;