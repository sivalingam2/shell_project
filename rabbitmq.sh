source common.sh
rabbitmq_password= $1
read -s rabbitmq_password
if [ -z "${rabbitmq_password}" ]; then
  echo "input rabbitmq password misssing"
  exit1
fi
echo -e "\e[32m >>>> install rabbitmq repositories <<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>${log}
exit_status
echo -e "\e[32m >>>> install rabbitmq repositories <<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${log}
exit_status
echo -e "\e[32m >>>> install rabbitmq servre <<<<\e[0m"
dnf install rabbitmq-server -y &>>${log}
exit_status
echo -e "\e[32m >>>> enable rabbitmq servre <<<<\e[0m"
systemctl enable rabbitmq-server  &>>${log}
exit_status
echo -e "\e[32m >>>> start rabbitmq servre <<<<\e[0m"
systemctl start rabbitmq-server &>>${log}
exit_status
echo -e "\e[32m >>>> user add  <<<<\e[0m"
rabbitmqctl add_user roboshop ${rabbitmq_password} &>>${log}
exit_status
echo -e "\e[32m >>>> give the permissions  <<<<\e[0m"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"&>>${log}
exit_status
