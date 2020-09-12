#!/usr/bin/env python
# -*- coding:utf-8 -*- 
"""
 抓取GooglePlay评论数据
"""
import os
import logging
import logging.handlers
import traceback
import unittest
import sys

import fire

# reload(sys)
# sys.setdefaultencoding('utf-8')

__author__ = 'dongsibei'


# root log配置
logging.basicConfig(
    level=logging.DEBUG,
    format=(
        "[%(asctime)s] %(name)s:%(levelname)s "  # 时间与日志级别
        "pid:%(process)d thread:%(threadName)s "  # 线程id与名称
        "%(pathname)s line:%(lineno)d %(funcName)s:"  # 行数与路径
        "%(message)s"  # 显示消息
    ),
    # filename=os.path.join(os.getcwd(), 'root.log') # 日志文件路径
)

logger = logging.getLogger(__name__)  # 默认日志


def main():
    logger.info('I am main')
    logger.debug('this is main.')
    try:
        main()
        xx
    except Exception as e:
        logger.exception('Exception Logged')
        pass
    logger.info('the main end.')
    pass


# 主函数入口
if __name__ == '__main__':
    fire.Fire()
