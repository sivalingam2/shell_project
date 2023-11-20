mysql_password=$1
read -s mysql_password
if [ -z "${mysql_password}" ]; then
  echo "input password missing"
  exit1
fi
echo -e "\e[31m >>>> copy repo files <<<<\e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo
exit_status
echo -e "\e[31m >>>> disable my sql <<<<\e[0m"
dnf module disable mysql -y &>>${log}
exit_status
echo -e "\e[31m >>>> install mysql <<<<\e[0m"
dnf install mysql-community-server -y &>>${log}
exit_status
echo -e "\e[31m >>>> enable mysql <<<<\e[0m"
systemctl enable mysqld &>>${log}
exit_status
echo -e "\e[31m >>>> start mysql <<<<\e[0m"
systemctl start mysqld &>>${log}
exit_status
echo -e "\e[31m >>>> set root password <<<<\e[0m"
mysql_secure_installation --set-root-pass ${mysql_password} &>>${log}
exit_status
