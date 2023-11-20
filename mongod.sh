source common.sh
echo "\e[32m >>>> install mongodb \e[0m"
dnf install mongodb-org -y &>>${log}
exit_status
echo "\e[32m >>>> copy repo files \e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
echo "\e[32m >>>> updating listen address \e[0m"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log}
exit_status
restart_service
exit_status