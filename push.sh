#!/bin/sh
f_path="$(grep -e "源地址" "${LOG_DIR}")"
t_path="$(grep -e "目标地址" "${LOG_DIR}")"
t_file="$(grep -e "共计 " "${LOG_DIR}")"
l_file="$(grep -e "已存在" "${LOG_DIR}")"
t_time="$(grep -e "共计耗时" "${LOG_DIR}")"
push_f_path="$(echo ${f_path} | cut -d ' ' -f 3)"
push_t_path="$(echo ${t_path} | cut -d ' ' -f 3)"
push_t_file="$(echo ${t_file} | cut -d ' ' -f 3)"
push_t_time="$(echo ${t_time} | cut -d ' ' -f 3)"
push_l_file="$(echo ${l_file} | cut -d ' ' -f 3)"
PUSH_DIGEST="源  地  址\t：${push_f_path}\n目标地址\t："${push_t_path}"\n共计文件\t： "${push_t_file}个"\n存在硬链\t： "${push_l_file}"个\n共计耗时\t： "${push_t_time}"秒"
PUSH_CONTENT="$(echo "$PUSH_DIGEST" | sed 's/\\n/\<br\/\>/g')"

#source user.conf
# get key
RET=$(curl -s https://qyapi.weixin.qq.com/cgi-bin/gettoken?"corpid="${CORPID}"&corpsecret="${CORP_SECRET}"")
KEY=$(echo ${RET} | jq -r .access_token)

if [[ ${MEDIA_ID} == "" ]]; then
    cat>./tmp<<EOF
{
    "touser" : "${TOUSER}",
    "msgtype" : "text",
    "agentid" : "${AGENTID}",
    "text" :
    {
        "content" : "${PUSH_CONTENT}"
    }
}
EOF
	else
		cat>./tmp<<EOF
{
   "touser" : "${TOUSER}",
   "msgtype" : "mpnews",
   "agentid" : "${AGENTID}",
   "mpnews" : {
       "articles":[
           {
               "title": "Hlink统计通知", 
               "thumb_media_id": "${MEDIA_ID}",
               "author": "Hlink通知",
               "content_source_url": "URL",
               "content": "${PUSH_CONTENT}",
               "digest": "${PUSH_DIGEST}"
            }
       ]
   },
   "safe":0,
   "enable_id_trans": 0,
   "enable_duplicate_check": 0,
   "duplicate_check_interval": 1800
}
EOF
fi

curl -d @tmp -XPOST https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token="${KEY}"
echo ""
rm tmp
