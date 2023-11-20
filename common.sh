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
            all_components
            npm install
         schema_setup
        restart_service

}
all_components () {
        echo "date of storing files: ${DATE}"
        cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
        exit_status
        echo -e "\e[32m >>>> user add application user  >>>>>\e[0m"
        id roboshop
        if [ $? -ne 0 ]; then
        useradd roboshop &>>${log}
        fi
         echo -e "\e[36m>>>>>>>>>>>>  Cleanup Existing Application Content  <<<<<<<<<<<<\e[0m"
          rm -rf /app
        mkdir /app &>>${log}
        exit_status
        echo -e "\e[32m >>>> download the content   >>>>>\e[0m"
        curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
        cd /app
        unzip /tmp/${component}.zip
        cd /app
}
schema_setup () {
  if [ "${schema_type}" == "mongodb" ]; then
      echo -e "\e[31m >>>> install mongodb <<<< \e[0m"
    dnf install mongodb-org-shell -y &>>${log}
    exit_status
    echo -e "\e[36m>>>>>>>>>>>>  Load Schema   <<<<<<<<<<<<\e[0m"
    mongo --host mongodb.sivadevops22.online </app/schema/catalogue.js &>>${log}
    exit_status
  fi
  if [ "${schema_type}" == "mysql" ]; then
      echo -e "\e[31m >>>> install mysql client <<<< \e[0m"
    dnf install mysql -y &>>${log}
    exit_status
     echo -e "\e[31m >>>> install load schema <<<< \e[0m"
    mysql -h mysql.sivadevops22.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>${log}
    exit_status
  fi
}

 shipping_part () {
  echo -e "\e[31m >>>> install maven package <<<< \e[0m"
  dnf install maven -y &>>${log}
  exit_status
  cd /app
  echo -e "\e[31m >>>> install clean package <<<< \e[0m"
  mvn clean package  &>>${log}
  exit_status
  mv target/${component}-1.0.jar ${component}.jar
  all_components
  schema_setup
  restart_service
 }
 dispatch_part () {
   echo -e "\e[31m >>>> golang installation <<<< \e[0m"
   dnf install golang -y  &>>${log}
   exit_status
   all_components
    echo -e "\e[31m >>>> download dependencies <<<< \e[0m"
   cd /app  &>>${log}
   go mod init dispatch  &>>${log}
   go get  &>>${log}
      exit_status
      echo -e "\e[31m >>>> building the software <<<< \e[0m"
     go build  &>>${log}
    exit_status
   restart_service
 }
restart_service () {
   echo -e "\e[32m >>>> start ${component} servive >>>>>\e[0m"
   systemctl daemon-reload &>>${log}
   systemctl enable ${component} &>>${log}
   systemctl restart ${component} &>>${log}
    exit_status
}

