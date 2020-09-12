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


# BI库初始化
if false;then
    log "BI数据库初始化..."
    mysql -N -h '172.17.42.71' -P '3306' -u 'wayaya' -p'wayaya' < init.sql
fi

# 业务库
if true;then
    log "业务表..."
    mysql -N -h '172.17.42.71' -P '3306' -u 'wayaya' -p'wayaya' < biz.sql
fi

# 按天同步数据
if false;then
    log "按天同步 同步数据 table: data.stat_appstore_payinfo ..."
    mysql -N -h 'rr-2ze7ehb2kwjee561l.mysql.rds.aliyuncs.com' -P '3306' -u 'ant' -p'Ant4mysql!@#' \
        -e "select * from data.stat_appstore_payinfo WHERE date_format(create_time,'%Y-%m-%d')= date_sub(current_date, INTERVAL 1 day);"  > stat_appstore_payinfo_day.txt
    log "按天同步 load数据到BI库 table: wayaya.stat_appstore_payinfo_day ..."
    cp stat_appstore_payinfo_day.txt /tmp/
    mysql -N -h '172.17.42.71' -P '3306' -u 'wayaya' -p'wayaya' \
        -e "load data infile '/tmp/stat_appstore_payinfo_day.txt' ignore into table wayaya.stat_appstore_payinfo fields terminated by '\t' (id,create_time,update_time,datadate,pkg,downloads,weekly_subscribers,weekly_pay_amounts,weekly_pay_amounts_success,weekly_refund_amounts,weekly_customer_pay_money,weekly_developer_income_money,monthly_subscribers,monthly_pay_amounts,monthly_pay_amounts_success,monthly_refund_amounts,monthly_customer_pay_money,monthly_developer_income_money,quarterly_subscribers,quarterly_pay_amounts,quarterly_pay_amounts_success,quarterly_refund_amounts,quarterly_customer_pay_money,quarterly_developer_income_money,yearly_subscribers,yearly_pay_amounts,yearly_pay_amounts_success,yearly_refund_amounts,yearly_customer_pay_money,yearly_developer_income_money,lifetime_subscribers,lifetime_pay_amounts,lifetime_pay_amounts_success,lifetime_refund_amounts,lifetime_customer_pay_money,lifetime_developer_income_money,weeklyRefundMoney,weeklyRefundIncomeMoney,monthlyRefundMoney,monthlyRefundIncomeMoney,quarterlyRefundMoney,quarterlyRefundIncomeMoney,yearlyRefundMoney,yearlyRefundIncomeMoney,lifetimeRefundMoney,lifetimeRefundIncomeMoney);"
    rm -rf /tmp/stat_appstore_payinfo_day.txt
fi

# 同步订单记录
if false;then
    log "导入数据至mysql..."
    cp parsed.com.app.fastcleaner /tmp/
    mysql -N -h '172.17.42.71' -P '3306' -u 'wayaya' -p'wayaya' -e "load data infile '/tmp/parsed.com.app.fastcleaner' ignore into table wayaya.ios_order_details_v3 fields terminated by '\t' (db_transaction_id,original_order_id,order_id, product_id, quantity, is_trial_period, purchase_date_ms, purchase_date_ms_bj, cancellation_date_ms, cancellation_date_ms_bj, expires_date_ms, original_purchase_date_ms, original_purchase_date_ms_bj, expiration_intent, is_in_billing_retry_period, auto_renew_status);"
    rm -rf /tmp/parsed.com.app.fastcleaner

    cp parsed.com.app.IPClear.www /tmp/
    mysql -N -h '172.17.42.71' -P '3306' -u 'wayaya' -p'wayaya' -e "load data infile '/tmp/parsed.com.app.IPClear.www' ignore into table wayaya.ios_order_details_v3 fields terminated by '\t' (db_transaction_id,original_order_id,order_id, product_id, quantity, is_trial_period, purchase_date_ms, purchase_date_ms_bj, cancellation_date_ms, cancellation_date_ms_bj, expires_date_ms, original_purchase_date_ms, original_purchase_date_ms_bj, expiration_intent, is_in_billing_retry_period, auto_renew_status);"
    rm -rf /tmp/parsed.com.app.IPClear.www

    cp parsed.com.app.quickcleaner /tmp/
    mysql -N -h '172.17.42.71' -P '3306' -u 'wayaya' -p'wayaya' -e "load data infile '/tmp/parsed.com.app.quickcleaner' ignore into table wayaya.ios_order_details_v3 fields terminated by '\t' (db_transaction_id,original_order_id,order_id, product_id, quantity, is_trial_period, purchase_date_ms, purchase_date_ms_bj, cancellation_date_ms, cancellation_date_ms_bj, expires_date_ms, original_purchase_date_ms, original_purchase_date_ms_bj, expiration_intent, is_in_billing_retry_period, auto_renew_status);"
    rm -rf /tmp/parsed.com.app.quickcleaner

    cp parsed.www.app.superCleanMaster /tmp/
    mysql -N -h '172.17.42.71' -P '3306' -u 'wayaya' -p'wayaya' -e "load data infile '/tmp/parsed.www.app.superCleanMaster' ignore into table wayaya.ios_order_details_v3 fields terminated by '\t' (db_transaction_id,original_order_id,order_id, product_id, quantity, is_trial_period, purchase_date_ms, purchase_date_ms_bj, cancellation_date_ms, cancellation_date_ms_bj, expires_date_ms, original_purchase_date_ms, original_purchase_date_ms_bj, expiration_intent, is_in_billing_retry_period, auto_renew_status);"
    rm -rf /tmp/parsed.www.app.superCleanMaster
fi

if false;then
    log "历史数据 同步数据 table: ant_earn."
fi

# 历史数据同步
if false;then
    log "历史数据 同步数据 table: data.stat_appstore_payinfo ..."
    mysql -N -h 'rr-2ze7ehb2kwjee561l.mysql.rds.aliyuncs.com' -P '3306' -u 'ant' -p'Ant4mysql!@#' \
        -e "select * from data.stat_appstore_payinfo"  > stat_appstore_payinfo.txt
    log "历史数据 load数据到BI库 table: wayaya.stat_appstore_payinfo ..."
    cp stat_appstore_payinfo.txt /tmp/
    mysql -N -h '172.17.42.71' -P '3306' -u 'wayaya' -p'wayaya' \
        -e "load data infile '/tmp/stat_appstore_payinfo.txt' ignore into table wayaya.stat_appstore_payinfo fields terminated by '\t' (id,create_time,update_time,datadate,pkg,downloads,weekly_subscribers,weekly_pay_amounts,weekly_pay_amounts_success,weekly_refund_amounts,weekly_customer_pay_money,weekly_developer_income_money,monthly_subscribers,monthly_pay_amounts,monthly_pay_amounts_success,monthly_refund_amounts,monthly_customer_pay_money,monthly_developer_income_money,quarterly_subscribers,quarterly_pay_amounts,quarterly_pay_amounts_success,quarterly_refund_amounts,quarterly_customer_pay_money,quarterly_developer_income_money,yearly_subscribers,yearly_pay_amounts,yearly_pay_amounts_success,yearly_refund_amounts,yearly_customer_pay_money,yearly_developer_income_money,lifetime_subscribers,lifetime_pay_amounts,lifetime_pay_amounts_success,lifetime_refund_amounts,lifetime_customer_pay_money,lifetime_developer_income_money,weeklyRefundMoney,weeklyRefundIncomeMoney,monthlyRefundMoney,monthlyRefundIncomeMoney,quarterlyRefundMoney,quarterlyRefundIncomeMoney,yearlyRefundMoney,yearlyRefundIncomeMoney,lifetimeRefundMoney,lifetimeRefundIncomeMoney);"
    rm -rf /tmp/stat_appstore_payinfo.txt

    log "历史数据 同步数据 table:ant_earn.ad_putin_data ..."
    mysql -N -h 'rr-2ze7ehb2kwjee561l.mysql.rds.aliyuncs.com' -P '3306' -u 'ant' -p'Ant4mysql!@#' \
        -e "SELECT * FROM ant_earn.ad_putin_data;"  > ad_putin_data.txt
    cp ad_putin_data.txt /tmp/
    log "历史数据 load数据到BI库 table: wayaya.ad_putin_data ..."
    mysql -N -h '172.17.42.71' -P '3306' -u 'wayaya' -p'wayaya' \
        -e "load data infile '/tmp/ad_putin_data.txt' ignore into table wayaya.ad_putin_data fields terminated by '\t' (id,account_id,type,display_name,advertiser_id,plan_id,plan_name,pkg,source,vn,cost,active,show_pv,click,datadate,updated_at);"
    rm -rf /tmp/ad_putin_data.txt

    log "历史数据 同步数据 table: ant_earn.apps ..."
    mysql -N -h 'rr-2ze7ehb2kwjee561l.mysql.rds.aliyuncs.com' -P '3306' -u 'ant' -p'Ant4mysql!@#' \
        -e "SELECT * FROM ant_earn.apps;"  > apps.txt
    log "处理空的json字段..."
    cat apps.txt | sed 's/NULL$/{}/g' | awk -F '\t' 'BEGIN{OFS="\t"}{if($11=="NULL") $11="{}"}1' > apps_d.txt
    log "历史数据 load数据到BI库 table: wayaya.apps ..."
    cp apps_d.txt /tmp/
    mysql -N -h '172.17.42.71' -P '3306' -u 'wayaya' -p'wayaya' \
        -e "load data infile '/tmp/apps_d.txt' ignore into table wayaya.apps fields terminated by '\t' (id,appName,pkg,app_type,license,platform,description,status,created_at,updated_at,app_cfg,owner,currency_cfg);"
    rm -rf /tmp/apps_d.txt
fi

# 报表输出
if false;then
    log "导出数据 按地域输出 订阅 购买 退订..."
    sql=$(cat <<EOF
        -- 按地域分 订阅 购买 退订
        SELECT a.datadate,
               a.pkg,
               a.city,
               a.subscribe,
               b.buy,
               c.refund
        FROM (
            -- 订阅
            SELECT original_purchase_date_ms_bj      AS datadate,
                b.pkg                             AS pkg,
                d.city                            AS city,
                count(DISTINCT original_order_id) AS subscribe
            FROM wayaya.ios_order_details_v3 a
                  JOIN wayaya.pkg2sku b ON a.product_id = b.sku
                  LEFT JOIN wayaya.ios_order2user c on a.original_order_id = c.ios_transaction_id
                  LEFT JOIN wayaya.user_ip_info d on convert(c.uid, signed ) = d.uid
            WHERE cancellation_date_ms = 0
            AND is_trial_period = 'true'
            GROUP BY original_purchase_date_ms_bj, b.pkg, d.city
            ORDER BY b.pkg, original_purchase_date_ms_bj
        ) a
        LEFT JOIN (
              -- 购买统计
            SELECT original_purchase_date_ms_bj      AS datadate,
                   b.pkg,
                   d.city                            AS city,
                   count(DISTINCT original_order_id) AS buy
            FROM wayaya.ios_order_details_v3 a
                     JOIN wayaya.pkg2sku b ON a.product_id = b.sku
                  LEFT JOIN wayaya.ios_order2user c on a.original_order_id = c.ios_transaction_id
                  LEFT JOIN wayaya.user_ip_info d on convert(c.uid, signed ) = d.uid
            WHERE is_trial_period = 'false'
            GROUP BY pkg, original_purchase_date_ms_bj, d.city
            ORDER BY pkg, original_purchase_date_ms_bj
        ) b ON a.datadate = b.datadate AND a.pkg = b.pkg AND a.city=b.city
        LEFT JOIN (
            -- 退单统计
            SELECT original_purchase_date_ms_bj      AS datadate
                 , b.pkg                             AS pkg
                 , d.city                            AS city
                 , count(DISTINCT original_order_id) AS refund
            FROM wayaya.ios_order_details_v3 a
                     JOIN wayaya.pkg2sku b ON a.product_id = b.sku
                  LEFT JOIN wayaya.ios_order2user c on a.original_order_id = c.ios_transaction_id
                  LEFT JOIN wayaya.user_ip_info d on convert(c.uid, signed ) = d.uid
            WHERE cancellation_date_ms_bj <> 0
            GROUP BY original_purchase_date_ms_bj, b.pkg, d.city
            ORDER BY b.pkg, original_purchase_date_ms_bj
        ) c ON a.datadate = c.datadate AND a.pkg = c.pkg AND a.city=c.city;
EOF
)
    mysql -N -h '172.17.42.71' -P '3306' -u 'wayaya' -p'wayaya' -e "${sql}" > all_day_city.txt
    sed -i '1i 订阅日期\t购买\t退订' all_day_city.txt

    log "导出数据 订阅报表 Quick Cleaner ..."
    pkg='com.app.quickcleaner'
    log "输出 Quick Cleaner, ${pkg} roi ..."
    sed "s/{pkg}/${pkg}/" ios_report_sql.sql | mysql -h 'rr-2ze7ehb2kwjee561l.mysql.rds.aliyuncs.com' -P '3306' -u 'ant' -p'Ant4mysql!@#' > "data/3/${date_str}_${pkg}_roi.csv"

    log "导出数据 订阅报表 Super Cleaner ..."
    pkg='www.app.superCleanMaster'
    log "输出 Super Cleaner, ${pkg} roi ..."
    sed "s/{pkg}/${pkg}/" ios_report_sql.sql | mysql -h 'rr-2ze7ehb2kwjee561l.mysql.rds.aliyuncs.com' -P '3306' -u 'ant' -p'Ant4mysql!@#' > "data/3/${date_str}_${pkg}_roi.csv"

    log "导出数据 订阅报表 Genius Cleaner ..."
    pkg='com.app.IPClear.www'
    log "输出 Genius Cleaner, ${pkg} roi ..."
    sed "s/{pkg}/${pkg}/" ios_report_sql.sql | mysql -h 'rr-2ze7ehb2kwjee561l.mysql.rds.aliyuncs.com' -P '3306' -u 'ant' -p'Ant4mysql!@#' > "data/3/${date_str}_${pkg}_roi.csv"

    log "导出数据 订阅报表 Fast Cleaner ..."
    pkg='com.app.fastcleaner'
    log "输出 Fast Cleaner, ${pkg} roi ..."
    sed "s/{pkg}/${pkg}/" ios_report_sql.sql | mysql -h 'rr-2ze7ehb2kwjee561l.mysql.rds.aliyuncs.com' -P '3306' -u 'ant' -p'Ant4mysql!@#' > "data/3/${date_str}_${pkg}_roi.csv"
fi

# debug
if false;then
    log "苹果财务细节输入..."
    pkg="com.app.IPClear.www"  # 包名
    sql=$(cat <<EOF
        SELECT datadate                      AS '账单日期',
               pkg                           AS '包名',
               downloads                     AS '下载量',
               weekly_subscribers            AS '周会员订阅量',
               weekly_pay_amounts            AS '周会员付费量',
               weekly_pay_amounts_success    AS '周会员付费成功量',
               weekly_refund_amounts         AS '周会员退单量',
               weekly_developer_income_money AS '周会员开发者收入',
               weeklyRefundIncomeMoney       AS '周会员开发者退单金额',
               yearly_subscribers            AS '年会员订阅量',
               yearly_pay_amounts            AS '年会员支付量',
               yearly_pay_amounts_success    AS '年会员成功支付量',
               yearly_refund_amounts         AS '退单量',
               yearly_developer_income_money AS '年会员开发者收入',
               yearlyRefundIncomeMoney       AS '年会员开发者退款金额'
        FROM wayaya.stat_appstore_payinfo
        WHERE pkg = "${pkg}"
        ORDER BY datadate;
EOF
)
    mysql -h '172.17.42.71' -P '3306' -u 'wayaya' -p'wayaya' -e "${sql}" > "${pkg}_appstore".txt
fi

if false;then
    log "获取订单数据..."
    pkg='www.app.superCleanMaster'  # 包名
fi

if false;then

    log "获取苹果校验数据..."
    sql=$(cat <<EOF
    select datadate, transaction_id, receipt_data
    from ant_earn.location_pay_verify_receipt
    where datadate >= '2020-08-20' and datadate <= '2020-09-02'
        and pkg = "${pkg}"
EOF
)
    mysql -N -h 'rr-2ze7ehb2kwjee561l.mysql.rds.aliyuncs.com' -P '3306' -u 'ant' -p'Ant4mysql!@#' -e "${sql}" > www.app.superCleanMaster.raw

    log "拉取苹果接口数据..."
    python check_www.app.superCleanMaster.py main 1

    log "合并结果文件..."
    cat results.superClean_a.txt.* > results.superClean.txt

fi

if false;then
    log "解析订单数据..."
    cat results.superClean.txt | python check_order_final.py main > superClean.parsed.txt
fi

if false;then
    log "输出 用户id与渠道..."
    sql=$(cat <<EOF
    select distinct datadate, ios_transaction_id, uid, source
     from ant_earn.pay_record
     where datadate between '2020-08-20' and '2020-09-02'
        and ios_transaction_id is not null
        and pkg="${pkg}"
EOF
)
    mysql -N -h 'rr-2ze7ehb2kwjee561l.mysql.rds.aliyuncs.com' -P '3306' -u 'ant' -p'Ant4mysql!@#' -e "${sql}" > order2uid.txt
fi

if false;then
    log "数据打标签"
    cat order2uid.txt | awk '{print $2" A "$3" "$4" "$1}' > x.txt
    cat superClean.parsed.txt | awk '{print $1" B "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9}' >> x.txt
    cat x.txt | sort > y.txt
    log "输出最终结果"
    cat y.txt | python app.py main > a.txt
fi

if false;then
    # origin_id user_date uid source sku status init_buy_tms init_buy_pst action_tms action_pst
    log "创建数据库表..."
    sql=$(cat <<EOF
    -- 创建数据库表
    CREATE TABLE IF NOT EXISTS data.ios_order_status
    (
        origin_id    varchar(255) DEFAULT NULL,
        user_date    date         DEFAULT NULL,
        uid          int(11)      DEFAULT NULL,
        source       varchar(255) DEFAULT NULL,
        sku          varchar(255) DEFAULT NULL,
        status       varchar(255) DEFAULT NULL,
        init_buy_tms varchar(255) DEFAULT NULL,
        init_buy_pst varchar(255) DEFAULT NULL,
        action_tms   varchar(255) DEFAULT NULL,
        action_pst   varchar(255) DEFAULT NULL,
        id           int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
        PRIMARY KEY (id),
        KEY idx_origin_uid_source_date (origin_id, user_date, uid, source) USING BTREE
    )
EOF
)
    mysql -N -h 'rr-2ze7ehb2kwjee561l.mysql.rds.aliyuncs.com' -P '3306' -u 'ant' -p'Ant4mysql!@#' -e "${sql}"
fi

if false;then
    log "插入数据库..."
    cat a.txt | python app.py put2mysql
fi

if false;then
    log "修复ip对应城市为空的数据..."
    mysql -N -h 'rr-2ze7ehb2kwjee561l.mysql.rds.aliyuncs.com' -P '3306' -u 'ant' -p'Ant4mysql!@#' -e "select uid,ip from data.user_ip_info where city ='';" > city_null.txt
fi

if false;then
    log "使用360api请求ip与城市的转换"
    #curl -s 'https://open.onebox.so.com/dataApi?type=ip&src=onebox&tpl=0&num=1&query=ip&ip=223.104.47.59&url=ip' | jq
    #cat city_null.txt | tail -n +60 | python app.py getIpcity >> b.txt
    cat city_null.txt | python app.py getIpcity
fi

if false;then
log "分析报表..."
    sql=$(cat <<EOF
    -- 报表统计
    select
       date_format(from_unixtime(a.init_buy_tms/1000),'%Y-%m-%d') as '订阅日期',
        b.province as '省份',
        b.city as '城市',
        a.source as '渠道',
        a.sku as '商品',
        a.status as '状态',
        count(*) as v
    from data.ios_order_status a
    LEFT JOIN data.user_ip_info b on a.uid=b.uid
    GROUP BY date_format(from_unixtime(a.init_buy_tms/1000),'%Y-%m-%d'),
             b.city, a.source, a.sku, a.status
    ORDER BY v DESC
EOF
)
    mysql -h 'rr-2ze7ehb2kwjee561l.mysql.rds.aliyuncs.com' -P '3306' -u 'ant' -p'Ant4mysql!@#' -e "${sql}" > report.txt
fi

if false;then
    log "核对购买订单数..."
    sql=$(cat <<EOF
    select
       date_format(from_unixtime(a.action_tms/1000),'%Y-%m-%d') as '动作日期',
        b.province as '省份',
        b.city as '城市',
        a.source as '渠道',
        a.sku as '商品',
        a.status as '状态',
        count(*) as v
    from data.ios_order_status a
    LEFT JOIN data.user_ip_info b on a.uid=b.uid
    GROUP BY date_format(from_unixtime(a.action_tms/1000),'%Y-%m-%d'),
             b.city, a.source, a.sku, a.status
    ORDER BY v DESC
EOF
)
    mysql -h 'rr-2ze7ehb2kwjee561l.mysql.rds.aliyuncs.com' -P '3306' -u 'ant' -p'Ant4mysql!@#' -e "${sql}" > report_buy.txt
fi

if false;then
    log "输出购买行为..."
    python check_order_final2.py main | grep '购买' | sort > wbs.txt
    cat wbs.txt | python  check_order_final2.py transaction_uniq > wbx.txt
    log "时间戳转日期,用于核对购买数量..."
    cat wbx.txt | cut -d ' ' -f8 | grep -P '\d{10}' -o | awk '{print strftime("%Y-%m-%d",$1)}' | sort | uniq -c | tr  -s ' ' | awk -F ' ' '{print $2" "$1}'> wbxc.txt
fi

if false;then
    log "数据打标记,处理购买数据..."
    cat order2uid.txt | awk '{print $2" A "$3" "$4" "$1}' > wa.txt
    cat superClean.parsed.txt | awk '{print $1" B "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9}' >> wa.txt
    cat wbx.txt |  awk '{print $2" C "$1" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "$10 }' >> wa.txt
    cat wa.txt | sort > was.txt
    cat was.txt | python app.py parseBuy | grep '购买' > wx.txt
fi

if false;then
    log "购买数据插入数据库..."
    cat wx.txt | python app.py put2mysql
    log "end"
fi


if false;then
    log "下载用户ip数据..."
    mysql -N -h 'rr-2ze7ehb2kwjee561l.mysql.rds.aliyuncs.com' -P '3306' -u 'ant' -p'Ant4mysql!@#' -e "select * from data.user_ip_info;" > user_ip_info.txt
fi

if false; then
    cp user_ip_info.txt /tmp/
    sql=$(cat <<EOF
    load data infile '/tmp/user_ip_info.txt'
    into table user_ip_info
    fields terminated by '\t'
    lines terminated by '\n'
    -- ignore 1 lines
    -- (id,name);
EOF
)
    mysql -N -h '172.17.42.71' -P '3306' -u 'wayaya' -p'wayaya' -e ${sql}
    rm -rf /tmp/user_ip_info.txt
fi


if false;then
    log "nday退单数据..."
    sql=$(cat <<EOF
    -- nday退单统计 至pkg维度
    SELECT original_purchase_date_ms_bj      AS datadate
         , b.pkg                             AS pkg
         ,datediff(cancellation_date_ms_bj,original_purchase_date_ms_bj) as nday
         , count(DISTINCT original_order_id) AS refund
    FROM wayaya.ios_order_details_v3 a JOIN wayaya.pkg2sku b ON a.product_id = b.sku
          LEFT JOIN wayaya.ios_order2user c on a.original_order_id = c.ios_transaction_id
          LEFT JOIN wayaya.user_ip_info d on convert(c.uid, signed ) = d.uid
    WHERE cancellation_date_ms_bj <> 0
    GROUP BY original_purchase_date_ms_bj, b.pkg,datediff(cancellation_date_ms_bj,original_purchase_date_ms_bj)
    ORDER BY b.pkg, original_purchase_date_ms_bj;
EOF
)
    mysql -N -h '172.17.42.71' -P '3306' -u 'wayaya' -p'wayaya' -e ${sql} > nday_refund.txt
fi

if false;then
    log "nday退单数据sku..."
    sql=$(cat <<EOF
    -- nday退单统计 至pkg维度
   SELECT original_purchase_date_ms_bj      AS datadate
         , b.pkg                             AS pkg
         ,product_id as sku
         ,datediff(cancellation_date_ms_bj,original_purchase_date_ms_bj) as nday
         , count(DISTINCT original_order_id) AS refund
    FROM wayaya.ios_order_details_v3 a JOIN wayaya.pkg2sku b ON a.product_id = b.sku
          LEFT JOIN wayaya.ios_order2user c on a.original_order_id = c.ios_transaction_id
          LEFT JOIN wayaya.user_ip_info d on convert(c.uid, signed ) = d.uid
    WHERE cancellation_date_ms_bj <> 0
    GROUP BY original_purchase_date_ms_bj, b.pkg,b.sku,datediff(cancellation_date_ms_bj,original_purchase_date_ms_bj)
    ORDER BY b.pkg,b.sku, original_purchase_date_ms_bj;
EOF
)
    mysql -N -h '172.17.42.71' -P '3306' -u 'wayaya' -p'wayaya' -e ${sql} > nday_refund_sku.txt
fi

if false;then
    log "订阅数据..."
    sql=$(cat <<EOF
    -- 订阅
    SELECT original_purchase_date_ms_bj      AS datadate,
           b.pkg                             AS pkg,
           -- d.city                            AS city,
           count(DISTINCT original_order_id) AS subscribe
    FROM wayaya.ios_order_details_v3 a
             JOIN wayaya.pkg2sku b ON a.product_id = b.sku
             LEFT JOIN wayaya.ios_order2user c ON a.original_order_id = c.ios_transaction_id
             LEFT JOIN wayaya.user_ip_info d ON convert(c.uid, SIGNED) = d.uid
    WHERE cancellation_date_ms = 0
      AND is_trial_period = 'true'
    GROUP BY original_purchase_date_ms_bj, b.pkg
           -- ,d.city
    ORDER BY b.pkg,original_purchase_date_ms_bj
EOF
)
    mysql -N -h '172.17.42.71' -P '3306' -u 'wayaya' -p'wayaya' -e ${sql} > subscribe.txt
fi




log "end..."