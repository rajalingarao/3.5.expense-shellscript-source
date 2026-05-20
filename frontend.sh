#!/bin/bash

source ./common.sh

check_root

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Installing nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabling  Nginx Server"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Starting Nginx Server"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "Removing existing Content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading frontend code"

cd /usr/share/nginx/html &>>$LOGFILE
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Extracked frontend code"

#cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
cp /root/3.5.expense-shellscript-source/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "Copied expense conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restarting nginx"

systemctl status nginx &>>$LOGFILE
VALIDATE $? "nginx status"