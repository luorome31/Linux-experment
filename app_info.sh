#!/bin/bash

echo "这是一个应用信息脚本"

nginx_server='http://127.0.0.1'
mysql_server='127.0.0.1'

Nginx_info(){
    status_code=$(curl -I -m 10 -o /dev/null -s -w %{http_code} $nginx_server)
    if [ $status_code -eq 000 -o $status_code -ge 500 ];then
        echo -e "Nginx服务出错"
        echo -e "响应码: $status_code"
    else
        echo -e "Nginx服务正常"
        curl -s http://127.0.0.1/ > /tmp/nginx_status
        cat /tmp/nginx_status
        rm -f /tmp/nginx_status
    fi
}

MySQL_info(){
    nc -z -w 10 $mysql_server 3306 &> /dev/null
    if [ $? -eq 0 ];then
        echo -e "连接MySQL $mysql_server 3306端口正常"
        mysql_uptimes=$(mysql -uroot -p123456 -h127.0.0.1 -e "show status" 2>/dev/null | grep Uptime|head -1 | awk '{print $2}')
        echo -e "MySQL已运行: $mysql_uptimes 秒"
    else
        echo -e "MySQL服务出错"
    fi
}

Nginx_info
MySQL_info