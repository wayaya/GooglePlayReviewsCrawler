import json
import urllib.request
import urllib.parse
from HandleJs import Py4Js


def open_url(url):
    headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:23.0) Gecko/20100101 Firefox/23.0'}
    req = urllib.request.Request(url=url, headers=headers)
    response = urllib.request.urlopen(req)
    data = response.read().decode('utf-8')
    return data


def buildUrl(content, tk, tl):
    baseUrl = 'http://translate.google.cn/translate_a/single'
    baseUrl += '?client=t&'
    baseUrl += 'sl=auto&'
    baseUrl += 'tl=' + str(tl) + '&'
    baseUrl += 'hl=zh-CN&'
    baseUrl += 'dt=at&'
    baseUrl += 'dt=bd&'
    baseUrl += 'dt=ex&'
    baseUrl += 'dt=ld&'
    baseUrl += 'dt=md&'
    baseUrl += 'dt=qca&'
    baseUrl += 'dt=rw&'
    baseUrl += 'dt=rm&'
    baseUrl += 'dt=ss&'
    baseUrl += 'dt=t&'
    baseUrl += 'ie=UTF-8&'
    baseUrl += 'oe=UTF-8&'
    baseUrl += 'clearbtn=1&'
    baseUrl += 'otf=1&'
    baseUrl += 'pc=1&'
    baseUrl += 'srcrom=0&'
    baseUrl += 'ssel=0&'
    baseUrl += 'tsel=0&'
    baseUrl += 'kc=2&'
    baseUrl += 'tk=' + str(tk) + '&'
    baseUrl += 'q=' + content
    return baseUrl


# 翻译接口
def translate(data, js, tl):
    tk = js.getTk(data)  # 获取token
    # content是要翻译的内容
    content = urllib.parse.quote(data)
    url = buildUrl(content, tk, tl)  # 构造请求参数
    result = open_url(url)
    res_json = json.loads(result)

    trans_text = res_json[0][0][0]
    # 去除读取文字中前后的换行符和逗号及单引号或双引号
    original = data.strip("\n").strip(",").strip("'").strip('"')
    trans = trans_text.strip(",").strip("'").strip('"')
    return trans


def main():
    js = Py4Js()
    tl = "en"  # tl是要翻译的目标语种，值参照ISO 639-1标准，如果翻译成中文"zh/zh-CN简体中文"
    # 读取需要翻译的文件
    # with open('chinese.zh.js', encoding="utf-8") as file_obj:
    #     for line in file_obj:
    #         data = line.strip('\n')
    #         result = translate(data, js, tl)  # 执行翻译
    #         print(result)
    result = translate("A very good app. Easy to use, reliable and hasn't given any problems.", js, "zh")  # 执行翻译
    print(result)


if __name__ == "__main__":
    main()
