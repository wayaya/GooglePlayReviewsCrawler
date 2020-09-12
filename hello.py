#!/usr/bin/env python
# -*- coding:utf-8 -*- 
"""
一个python文件
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

# 定义一个Handler打印DEBUG及以上级别的日志到sys.stderr
# 设置日志打印格式
# 将定义好的console日志handler添加到root logger
console = logging.StreamHandler()
console.setLevel(logging.DEBUG)
# formatter = logging.Formatter("[%(asctime)s] %(name)s:%(levelname)s: %(message)s")
# console.setFormatter(formatter)

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

    pass


# 主函数入口
if __name__ == '__main__':
    fire.Fire()
