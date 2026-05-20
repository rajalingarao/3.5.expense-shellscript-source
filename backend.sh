#!/bin/bash

source ./common.sh

check_root

echo "Please enter DB Password:"
#read -s mysql_root_password
read mysql_root_password

dnf module disable nodejs -y &>>$LOGFILE

dnf module enable nodejs:20 -y &>>$LOGFILE

dnf install nodejs -y &>>$LOGFILE
useradd expense

id expense &>>$LOGFILE # it will not create user if not existed, do it manually
if [ $? -ne 0 ]
then 
   useradd expense &>>$LOGFILE
else
   echo -e "Expense user already created..$Y Skipping $N"
fi

mkdir -p /app &>>$LOGFILE

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE

npm install &>>$LOGFILE

cp /root/3.5.expense-shellscript-source/backend.service /etc/systemd/system/backend.service &>>$LOGFILE

systemctl daemon-reload &>>$LOGFILE

systemctl start backend  &>>$LOGFILE

systemctl enable backend &>>$LOGFILE

dnf install mysql -y &>>$LOGFILE

mysql -h db.lithesh.shop -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE

systemctl restart backend &>>$LOGFILE

systemctl status backend &>>$LOGFILE