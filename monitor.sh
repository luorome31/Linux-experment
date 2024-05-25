#!/bin/bash
# 设置正常屏幕输出
reset_terminal=$(tput sgr0)
# 声明一个数组
declare -A script_array
# 声明并初始化循环控制变量i
i=1
# 声明并初始化提示信息变量tips
tips=""

# 循环遍历当前目录下其他文件
for script_file in `ls -I "monitor.sh" ./`
do
        # 用紫色加粗字体输出前一段，输出可供选择的脚本名称及其代号
        echo -e '\e[1;35m' "The Script:" ${i} '=>' ${reset_terminal} ${script_file}
        # 将脚本名字存入数组
        script_array[$i]=${script_file}
        # 更新变量值
        tips="${tips} | ${i}"
        # 迭代变量+1进行迭代
        i=$((i+1))
done

# 开启另一个循环
while true
do
        # 提示输入一个选择
        read -p "Please input a number [${tips}] (0:exit): " choice
        # 判断输入的是否为数字
        if [[ ! ${choice} =~ ^[0-9]+ ]]; then
                # 非数字，输出错误信息
                echo "The input choice is not a Number!!!"
        else
                # 如果输入0
                if [ ${choice} -eq 0 ]; then
                        # 输出Bye Bye
                        echo "Bye Bye"
                        # 退出执行脚本
                        exit 0
                # 如果输入的数字不在1-3内
                elif [ ${choice} -lt 1 ] || [ ${choice} -gt 3 ]; then
                        # 提示输入1-3的数字
                        echo "Please input a number between 1 and 3!!!"
                else
                        # 如果输入的数字在1-3内，执行数字代表的脚本
                        /bin/bash ./${script_array[$choice]}
                fi
        fi
done
