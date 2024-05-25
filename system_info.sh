#!/bin/bash

# 获取系统类型及版本、当前用户、当前时间
os_type=$(uname -s)
os_release=$(uname -r)
os_user=$(whoami)
current_time=$(date)

# 获取任务数量
task_count=$(ps aux | wc -l)

# 获取负载均衡情况
load_average=$(uptime | awk '{print $8 $9 $10}')

# 打印系统信息
echo -e "系统类型: $os_type $os_release"
echo -e "当前用户: $os_user"
echo -e "当前时间: $current_time"
echo -e "任务数量: $task_count"
echo -e "负载均衡情况: $load_average"

# 获取系统内存使用情况
system_memory_usage=$(awk '/MemTotal/{total=$2}/MemFree/{free=$2}/^Cached/{cache=$2}END{print (total-free)/1024}' /proc/meminfo)
echo -e "系统内存使用情况: $system_memory_usage"
# 获取应用内存使用情况
app_memory_usage=$(awk '/MemTotal/{total=$2}/MemFree/{free=$2}/^Cached/{cache=$2}/Buffers/{buffers=$2}END{print (total-free-cache-buffers)/1024}' /proc/meminfo)
echo -e "应用内存使用情况: $app_memory_usage"
# 获取磁盘使用情况
disk_usage=$(df -hP|grep -vE 'Filesystem|tmpfs'|awk '{print $1 " " $5}')
echo -e "磁盘使用情况: "$disk_usage


# IP地址、Mac地址、DNS、网络是否可用
internal_ip=$(hostname -I)
external_ip=$(curl -s http://ipecho.net/plain)
dns=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
network_status=$(ping -c 1 www.baidu.com &> /dev/null && echo "网络可用" || echo "网络不可用")

echo -e "内网IP: $internal_ip"
echo -e "外网IP: $external_ip"
echo -e "DNS: $dns"
echo -e "网络状态: $network_status"


# 登入用户
who>who.txt
echo -e "登入用户: "&& cat who.txt
rm -f who.txt
