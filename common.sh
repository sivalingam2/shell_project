log=/tmp/logs.file
DATE=$(date +%F)
exit_status () {
 if [ $? -eq 0 ]; then
   echo -e  "\e[32m success \e[0m"
else
  echo -e "\e[31m failure \e[0m"
fi
}
catalogue_part () {
  echo "date of storing files: ${DATE}"
  echo -e "\e[32m >>>> copy the catalogue service >>>>>\e[0m"
  cp catalogue.service /etc/systemd/system/catalogue.service &>>${log}
  exit_status
  echo -e "\e[32m >>>> copy mongo repo files >>>>>\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
   exit_status
  echo -e "\e[32m >>>> disable nodejs  >>>>>\e[0m"
  dnf module disable nodejs -y &>>${log}
  exit_status
   echo -e "\e[32m >>>> enable nodejs  >>>>>\e[0m"
  dnf module enable nodejs:18 -y &>>${log}
  exit_status
  echo -e "\e[32m >>>> install  nodejs  >>>>>\e[0m"
  dnf install nodejs -y &>>${log}
   exit_status
  echo -e "\e[32m >>>> user add roboshop  >>>>>\e[0m"
  useradd roboshop &>>${log}
  mkdir /app &>>${log}
  exit_status
  echo -e "\e[32m >>>> download the content   >>>>>\e[0m"
  curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
  cd /app
  unzip /tmp/catalogue.zip
  exit_status
  cd /app
  npm install
    echo -e "\e[32m >>>> install mongodb >>>>>\e[0m"
  dnf install mongodb-org-shell -y &>>${log}
  exit_status
  echo -e "\e[32m >>>>  load schema >>>>>\e[0m"
  mongo --host mongodb.sivadevops22.online </app/schema/catalogue.js
  exit_status
  restart_service
}

restart_service () {
   echo -e "\e[32m >>>> start the servive >>>>>\e[0m"
   systemctl daemon-reload &>>${log}
   systemctl enable nginx &>>${log}
   systemctl restart nginx &>>${log}
}

