#!/bin/bash

source ./common.sh

check_root

echo "Please enter DB Password:"
#read -s mysql_root_password
read mysql_root_password

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling of default nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling of nodejs:20 version"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"

#useradd expense

id expense &>>$LOGFILE # it will not create user if not existed, do it manually
if [ $? -ne 0 ]
then 
   useradd expense &>>$LOGFILE
   VALIDATE $? "Creating expense user"
else
   echo -e "Expense user already created..$Y Skipping $N"
fi

mkdir -p /app &>>$LOGFILE
VALIDATE $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading backend code"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "Extracked backend code"

npm install &>>$LOGFILE
VALIDATE $? "Installing nodejs dependencies"

cp /home/ec2-user/3.5.expense-shellscript-source/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "Copied backend service"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Daemon Reload"

systemctl start backend  &>>$LOGFILE
VALIDATE $? "starting backend"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "Enabling backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing Mysql Client"

#mysql -h mysql.lithesh.shop -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE

mysql -h mysql.lithesh.shop -uroot -p${mysql_root_password} -e 'use transactions;' &>>$LOGFILE
if [ $? -ne 0 ] 
then
  mysql -h mysql.lithesh.shop -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
  VALIDATE $? "mysql schema loading..."
else
  echo -e "Schema already loaded... $Y SKIPPING $N" 
fi

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting backend Server"

systemctl status backend &>>$LOGFILE
VALIDATE $? "backend Server status"