#!/bin/bash

set +x

# Create the only server
source ./create-server.sh

wait_for_ssh "${PUBLIC_DNS}"
execute_ssh "${PUBLIC_DNS}" "sudo yum install -y mysql-server"
execute_ssh "${PUBLIC_DNS}" "sudo /etc/init.d/mysqld start"
execute_ssh "${PUBLIC_DNS}" "sudo /usr/libexec/mysql55/mysqladmin -u root password 'hagenberg'"
execute_ssh "${PUBLIC_DNS}" "echo \"create database app_lottery;\" | mysql -u root -phagenberg"
execute_ssh "${PUBLIC_DNS}" "echo \"grant all on app_lottery.* to 'app_lottery'@'localhost' identified by 'app_lottery';\" | mysql -u root -phagenberg"
scp_file ../lottery/target/lottery-0.0.1-SNAPSHOT.jar "${PUBLIC_DNS}" /home/ec2-user/
execute_ssh "${PUBLIC_DNS}" "java -jar /home/ec2-user/lottery-0.0.1-SNAPSHOT.jar > /home/ec2-user/spring.log &"

echo "Your service is now running at: http://${PUBLIC_DNS}:5000/"