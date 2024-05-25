#!/bin/bash
echo "这是一个日志信息脚本"
logfile_path="/var/log/nginx/access.log"

# 定义一个函数用于统计各个区间的状态码的个数以及状态码总数
Get_http_status()
{
        # 通过正则表达式获取一系列包含状态码的信息，使用awk分割出一个个的状态码,统计区间里的状态码个数，保存到变量i，j，k，m，n中，最后形成数组http_status_codes
        http_status_codes=(`cat ${logfile_path} | grep -ioE "HTTP\/1\.[1|0]\"[[:blank:]][0-9]{3}" | awk '{
                if($2>=100&&$2<200)
                        {i++}
                if($2>=200&&$2<300)
                        {j++}
                if($2>=300&&$2<400)
                        {k++}
                if($2>=400&&$2<500)
                        {m++}
                if($2>=500)
                        {n++}
                }END{print i?i:0,j?j:0,k?k:0,m?m:0,n?n:0,i+j+k+m+n}' `)

        # 输出上述统计结果
        echo -e "The counter http status[100+]: "${http_status_codes[0]}
        echo -e "The counter http status[200+]: "${http_status_codes[1]}
        echo -e "The counter http status[300+]: "${http_status_codes[2]}
        echo -e "The counter http status[400+]: "${http_status_codes[3]}
        echo -e "The counter http status[500+]: "${http_status_codes[4]}
        echo -e "The counter http status[ALL]: "${http_status_codes[5]}
}
# 定义一个函数
Get_http_codes()
{
        # 通过正则表达式和awk命令统计404和500的数量并计算所有状态码的总数
        http_codes=(`cat ${logfile_path} | grep -ioE "HTTP\/1\.[1|0]\"[[:blank:]][0-9]{3}" | awk -v total=0 '{
                if($2!="")
                        { code[$2]++; total++ }
                else
                        { exit }
                }END{print code[404]?code[404]:0,code[500]?code[500]:0,total}' `)

        # 输出上述统计结果
        echo -e "The Counter of 404: " ${http_codes[0]}
        echo -e "The Counter of 500: " ${http_codes[1]}
}
# 调用上述写好的两个函数
Get_http_status
Get_http_codes
