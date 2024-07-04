#!/bin/bash

# 克隆项目代码
git clone https://github.com/luorome31/PetStoreBackEnd.git /var/www/backend
git clone https://github.com/luorome31/pet_store_vue.git /var/www/frontend

# 运行数据库脚本
sudo mysql -u luorome -p123456 petstore < /var/www/backend/db/init.sql

# 构建后端项目
# 还需要修改后端项目pom.xml中的打包方式为war；同时添加辅助类，并将原启动类的类加载器作为参数传入
cd /var/www/backend
mvn clean package

# 构建前端项目
cd /var/www/frontend
npm install
npm run build

# 部署后端到Tomcat
sudo cp /var/www/backend/target/backend.war /var/lib/tomcat10/webapps/

# 部署前端到Nginx
sudo rm -rf /var/www/html/*
sudo cp -r /var/www/frontend/dist/* /var/www/html/

# 配置Nginx反向代理
sudo tee /etc/nginx/sites-available/default <<EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm;

    server_name _;

    location / {
        try_files \$uri \$uri/ /index.html;
    }

    location /api/ {
        proxy_pass http://8.130.14.2:8080/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# 重启Nginx和Tomcat服务
sudo systemctl restart nginx
sudo systemctl restart tomcat10

# 配置日志文件目录
sudo mkdir -p /var/log/petstore
sudo chown -R $USER:$USER /var/log/petstore

# 配置计划任务进行日志备份和分析
(crontab -l ; echo "0 2 * * * tar -czf /var/log/myproject/backup_\$(date +\%Y\%m\%d).tar.gz /var/log/nginx/*.log /var/log/tomcat9/*.log") | crontab -
(crontab -l ; echo "0 3 * * * /usr/bin/python3 /path/to/your/log_analysis_script.py /var/log/myproject/") | crontab -

echo "Deployment completed successfully!"