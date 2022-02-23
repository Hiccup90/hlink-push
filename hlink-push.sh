#!/bin/bash
config='/mnt/disk1/shell/hlink.config.mjs'  #hlink配置文件路径
node='/mnt/disk1/appdata/node/bin/'         #node环境路径
cachebackup='/mnt/disk1/shell/'             #缓存备份路径
log='/mnt/disk1/shell/'                     #日志文件路径
push='/mnt/disk1/shell/'                    #push.sh脚本路径
##########################
# 4. 推送配置
# --企业微信通知配置
export CORPID="企业ID"
export CORP_SECRET="密匙"
export AGENTID="应用ID"
export TOUSER="@all或者账号"
export MEDIA_ID="图片ID"
export LOG_DIR='$log/log.txt'    #不用改


cd $node
./hlink restore $cachebackup/.hlink                                                    #还原缓存备份文件-如果重启不丢失缓存，请注释
./hlink -c $config /mnt/disk2/Downloads/Temp /mnt/disk2/hlink2 > $log/log.txt          #自行修改硬链接路径
bash $push/push.sh
./hlink -c $config /mnt/disk3/Media/TV /mnt/disk3/hlink3/tv > $log/log.txt             #自行修改硬链接路径
bash $push/push.sh
./hlink -c $config /mnt/disk3/Media/Movie /mnt/disk3/hlink3/movie > $log/log.txt       #自行修改硬链接路径
bash $push/push.sh
./hlink -c $config /mnt/disk3/Media/Hiccup/1 /mnt/disk3/hlink3/1 > $log/log.txt    #自行修改硬链接路径
bash $push/push.sh
./hlink -c $config /mnt/disk3/Media/Hiccup/2 /mnt/disk3/hlink3/2 > $log/log.txt    #自行修改硬链接路径
bash $push/push.sh
./hlink backup $cachebackup                                                            #备份缓存文件-如果重启不丢失缓存，请注释
