#!/bin/bash

source ./common.sh

check_root

echo "Please enter DB password:"
#read -s mysql_root_password
read mysql_root_password

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing of MySQL Server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling of MySQL Server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting the MySQL server"

# mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE

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

mysql -h mysql.lithesh.shop -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ] 
then
   mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
   VALIDATE $? "MySQL Root password setup done"
else
   echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi

systemctl status mysqld &>>$LOGFILE
VALIDATE $? "mysql installation status"

# need to setup password first for MySQL:
# mysql -h mysql.lithesh.shop -u root -pExpenseApp@1