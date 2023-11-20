source common.sh
echo -e "\e[32m >>>> install nginx >>>> \e[0m"
dnf install nginx -y &>>${log}
exit_status
echo -e "\e[32m >>>> copy files >>>>>\e[0m"
 cp frontend.confi /etc/nginx/default.d/roboshop.conf &>>${log}
 exit_status

echo -e "\e[32m >>>> remove old content >>>>>\e[0m"
rm -rf /usr/share/nginx/html/* &>>${log}
exit_status
echo -e "\e[32m >>>> download content >>>>>\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
exit_status
echo -e "\e[32m >>>> change the directory and unzip the content >>>>>\e[0m"
cd /usr/share/nginx/html &>>${log}
unzip /tmp/frontend.zip &>>${log}
exit_status
restart_service
