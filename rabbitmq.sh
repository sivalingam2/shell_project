echo -e "\e[31m >>>> install rabbitmq repositories <<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log}
exit_status
echo -e "\e[31m >>>> install rabbitmq repositories <<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log}
exit_status
echo -e "\e[31m >>>> install rabbitmq servre <<<<\e[0m"
dnf install rabbitmq-server -y &>>${log}
exit_status
echo -e "\e[31m >>>> enable rabbitmq servre <<<<\e[0m"
systemctl enable rabbitmq-server  &>>${log}
exit_status
echo -e "\e[31m >>>> start rabbitmq servre <<<<\e[0m"
systemctl start rabbitmq-server &>>${log}
exit_status
echo -e "\e[31m >>>> user add  <<<<\e[0m"
rabbitmqctl add_user roboshop roboshop123 &>>${log}
exit_status
echo -e "\e[31m >>>> give the permissions  <<<<\e[0m"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"&>>${log}
exit_status
