#!/usr/bin/env python
# -*- coding:utf-8 -*-

import time

from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
import json
import fire

# 浏览器驱动位置
drivers = []
# driver = webdriver.Chrome()
chrome_opt = webdriver.ChromeOptions()
chrome_opt.add_argument('--headless')
chrome_opt.add_argument('--disable-gpu')
chrome_opt.add_argument('--no-sandbox')
driver = webdriver.Chrome(chrome_options=chrome_opt, executable_path='/usr/chrome/chromedriver')

app_ip = ['bazinga.historyclean']

show_more_class_tag = "CwaK9"  # 显示更多
all_reviews_tag = "UD7Dzf"  # 评论
full_reviews_tag = "zc7KVe"
users_tag = "xKpxId"  # 用户
users_name_tag = "X43Kjb"
dates_tag = "p2TkOb"
stars_tag = "pf5lIe"
solid_star_tag = "vQhuPe"
scroll_to_bottom = "window.scrollTo(0, document.body.scrollHeight);"

click_show_more = "var a = document.getElementsByClassName(\"" + show_more_class_tag + "\"); a[0].click();"
full_reviews_len = '0'


# 搜索显示更多
def search_show_more():
    count = 0
    while len(driver.find_elements_by_class_name(show_more_class_tag)) == 0 and count < 10:
        driver.execute_script(scroll_to_bottom)
        time.sleep(3)
        count += 1
    return len(driver.find_elements_by_class_name(show_more_class_tag))


# 评论过滤
def is_crash_exist(review):
    crash_words = ["crash"]  # , "freeze"]
    for word in crash_words:
        if word in review.lower():
            return True
    return False


def main():
    print("main...")
    app_num = 0
    while app_num < len(app_ip):
        # hl用于定于国家
        url = "https://play.google.com/store/apps/details?id=" + app_ip[app_num] + "&showAllReviews=true&hl=cn"
        print(url)
        page_num = 0
        driver.get(url)
        show_more_exist = 1

        # show all reviews
        # 翻页请求评论
        while show_more_exist:
            show_more_exist = search_show_more()
            if show_more_exist:
                print("app name %s page %d:" % (app_ip[app_num], page_num))
                page_num += 1
                driver.execute_script(click_show_more)
            if page_num >= 2:
                break

        """ 点击更多按钮
        # click all full review buttons
        full_reviews_len = len(driver.find_elements_by_class_name(full_reviews_tag))
        if (full_reviews_len > 0):
            for i in range(0, full_reviews_len):
                click_full_reviews = "var a = document.getElementsByClassName(\"" + full_reviews_tag + "\"); a[" + str(
                    i) + "].click();"
                driver.execute_script(click_full_reviews)
        # """

        print("start to match result")
        count = 0
        reviews = driver.find_elements_by_class_name(all_reviews_tag)
        users = driver.find_elements_by_class_name(users_tag)
        dates = []  # 日期
        user_name = []  # 用户名称
        # stars = driver.find_elements_by_class_name(stars_tag)  # 星等
        for user in users:
            dates.append(user.find_elements_by_class_name(dates_tag)[0].text)  # 日期
            user_name.append(user.find_elements_by_class_name(users_name_tag)[0].text)  # 用户名称
            # stars.append(user.find_elements_by_class_name(star_tag)[0])
        pass

        final_json = []  # 结果列表
        print("start to build json for " + app_ip[app_num])
        for review, date, name in zip(reviews, dates, user_name):
            count += 1
            ls = [name, review.text, date]
            ls = [i.replace('\t', ' ') for i in ls]  # 删除特殊符号
            result = {"User": name, "Content": review.text, "Numbers": str(count), "Date": date}
            print('\t'.join(ls))
            final_json.append(result)
        pass
        if len(final_json) > 0:
            output = json.dumps(final_json)
            fp = open("json_file/" + app_ip[app_num] + ".json", "w")
            fp.write(output)
            fp.close()

        app_num += 1
        pass

    driver.quit()  # 退出
    pass


if __name__ == "__main__":
    fire.Fire()
