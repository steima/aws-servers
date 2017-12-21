#!/bin/bash

set +x

# database server
source ./create-server.sh
wait_for_ssh "${PUBLIC_DNS}"
execute_ssh "${PUBLIC_DNS}" "sudo yum install -y mysql-server"
execute_ssh "${PUBLIC_DNS}" "sudo /etc/init.d/mysqld start"
execute_ssh "${PUBLIC_DNS}" "sudo /usr/libexec/mysql55/mysqladmin -u root password 'hagenberg'"
execute_ssh "${PUBLIC_DNS}" "echo \"create database app_lottery;\" | mysql -u root -phagenberg"
execute_ssh "${PUBLIC_DNS}" "echo \"grant all on app_lottery.* to 'app_lottery'@'%' identified by 'app_lottery';\" | mysql -u root -phagenberg"

DATABASE_PRIVATE_DNS="${PRIVATE_DNS}"

# web server
source ./create-server.sh
wait_for_ssh "${PUBLIC_DNS}"
scp_file ../lottery/target/lottery-0.0.1-SNAPSHOT.jar "${PUBLIC_DNS}" /home/ec2-user/
execute_ssh "${PUBLIC_DNS}" "java -Dspring.datasource.url=jdbc:mysql://${DATABASE_PRIVATE_DNS}:3306/app_lottery?autoReconnect=true -jar /home/ec2-user/lottery-0.0.1-SNAPSHOT.jar > /home/ec2-user/spring.log &"

echo "Your service is now running at: http://${PUBLIC_DNS}:5000/"