# Login into mysql server using putty.
```
git clone https://github.com/rajalingarao/3.5.expense-shellscript-source.git
```
```
cd 3.5.expense-shellscript-source
```
```
sh mysql.sh
```

# Login into backend server
ssh ec2-user@backend.lithesh.shop
```
git clone https://github.com/rajalingarao/3.5.expense-shellscript-source.git
```
```
cd 3.5.expense-shellscript-source
```
```
sh backend.sh
```

# Login into frontend server
ssh ec2-user@frontend.lithesh.shop
```
git clone https://github.com/rajalingarao/3.5.expense-shellscript-source.git
```
```
cd 3.5.expense-shellscript-source
```
```
sh frontend.sh
```
# Trouble shoot the mysql server:
```
mysql -h mysql.lithesh.shop -u root -pExpenseApp@1
```
