echo "date of storing files: ${DATE}"
echo -e "\e[31m >>>> install repo files \e[0m"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log}
exit_status
echo -e "\e[31m >>>> install enable redis \e[0m"
dnf module enable redis:remi-6.2 -y &>>${log}
exit_status
echo -e "\e[31m >>>> install install redis \e[0m"
dnf install redis -y &>>${log}
exit_status
# Update listen address from 127.0.0.1 to 0.0.0.0
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf & /etc/redis/redis.conf
restart_service
exit_status