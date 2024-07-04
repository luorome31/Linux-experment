#!/bin/bash

# 更新系统包
sudo apt-get update -y

# 安装Git
sudo apt-get install -y git
git --version || { echo "Git 安装失败"; exit 1; }

# 安装Java
sudo apt-get install -y openjdk-11-jdk
java -version || { echo "Java 安装失败"; exit 1; }

# 安装Node.js和NPM
sudo apt-get install -y nodejs npm
node -v || { echo "Node.js 安装失败"; exit 1; }
npm -v || { echo "NPM 安装失败"; exit 1; }

# 安装Maven
sudo apt-get install -y maven
mvn -v || { echo "Maven 安装失败"; exit 1; }

# 安装Tomcat
TOMCAT_VERSION=9.0.56
wget https://downloads.apache.org/tomcat/tomcat-9/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz
tar -xzf apache-tomcat-$TOMCAT_VERSION.tar.gz
sudo mv apache-tomcat-$TOMCAT_VERSION /opt/tomcat
sudo ln -s /opt/tomcat/apache-tomcat-$TOMCAT_VERSION /opt/tomcat/latest
sudo /opt/tomcat/latest/bin/startup.sh
curl -s --head http://localhost:8080 | head -n 1 | grep "200 OK" || { echo "Tomcat 安装失败"; exit 1; }

# 安装Nginx
sudo apt-get install -y nginx
nginx -v || { echo "Nginx 安装失败"; exit 1; }
sudo systemctl start nginx
sudo systemctl enable nginx

# 安装MySQL
sudo apt-get install -y mysql-server
# 配置MySQL
sudo mysql -e "CREATE DATABASE mydb;"
sudo mysql -e "CREATE USER 'luorome'@'localhost' IDENTIFIED BY '123456';"
sudo mysql -e "GRANT ALL PRIVILEGES ON mydb.* TO 'luorome'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"
sudo systemctl start mysql
sudo systemctl enable mysql

sudo mysql -e "SHOW DATABASES;" || { echo "MySQL 安装失败"; exit 1; }

# 安装Redis
sudo apt-get install -y redis-server
redis-server -v || { echo "Redis 安装失败"; exit 1; }
sudo systemctl start redis-server
sudo systemctl enable redis-server

echo "所有软件安装和配置完成。"

# 检查安装情况并输出结果
echo "检查软件安装情况："
for software in "git" "java" "node" "npm" "mvn" "nginx" "mysql" "redis-server"; do
  command -v $software &> /dev/null && echo "$software 已安装" || echo "$software 安装失败"
done

# 检查Tomcat服务状态
curl -s --head http://localhost:8080 | head -n 1 | grep "200 OK" && echo "Tomcat 已安装并运行" || echo "Tomcat 安装或运行失败"
