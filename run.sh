#!/usr/bin/env bash

#set -e
#set -x

. /etc/profile
#. ~/.bashrc

function log(){
    echo $(date +'%Y-%m-%d %H:%M:%S') msg: $1
}


basedir=$(cd `dirname $0`;pwd) # 获取当前路径
cd ${basedir} # 切换路径

# source common.sh # 导入本地脚本库

date_str=$(date '+%Y%m%d%H%M%S')
today=$(date +'%Y-%m-%d') # 今天的日期
yestoday=$(date +'%Y-%m-%d' -d '-1day') # 昨天的日期
fromday=$(date +'%Y-%m-%d' -d '-1day') # 起始日期


log "${today} start..."

log "抓取GooglePlay评论"
python GooglePlayReviewCrawler.py main > review.txt
sed -i '1i 用户名称\t评论\t中文\t日期' review_ca.txt

log "end"