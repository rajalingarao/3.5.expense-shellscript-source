#!/bin/bash

source ./common.sh

check_root

echo "Please enter DB password:"
#read -s mysql_root_password
read mysql_root_password

dnf install mysql-server -y &>>$LOGFILE
systemctl enable mysqld &>>$LOGFILE
systemctl start mysqld &>>$LOGFILE

mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
#Below code will be useful for idempotent nature
# #mysql -h mysql.lithesh.shop -u root -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE

# Try connecting locally first
# mysql -u root --password="${mysql_root_password}" -e 'show databases;' &>>$LOGFILE
# if [ $? -ne 0 ]
# then
#     mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
# else
#     echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
# fi

systemctl status mysqld &>>$LOGFILE


# need to setup password first for MySQL:
# mysql -h mysql.lithesh.shop -u root -pExpenseApp@1