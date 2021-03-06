from bs4 import BeautifulSoup
from urllib.request import urlopen
from urllib.error import HTTPError
import pandas as pd
import numpy as np
import re
import socket, time

url = 'https://bj.lianjia.com/chengjiao'


def getbsobj(url):
    try:
        html = urlopen(url, timeout=3)
    except (HTTPError, socket.timeout):
        return None
    return BeautifulSoup(html, 'html.parser')


def getLinksList(url, n):
    '''
    :param url: 链接
    :param n: 第n页
    :return: 链接列表
    '''
    ls = []
    bsobj = getbsobj(url + '/pg%d' % n)
    if not bsobj:
        print('该页打不开')
        return None
    while True:
        aTagList = bsobj.find('ul', {'class': 'listContent'}).findAll('a', {'class': 'img'})
        if len(aTagList) > 0:
            print('打开成功')
            break
        else:
            print('进入休眠')
            time.sleep(60)
            bsobj = getbsobj(url + '/pg%d' % n)
    for aTag in aTagList:
        if 'href' in aTag.attrs:
            ls.append(aTag['href'])
    return ls


def getInfo(ls):
    '''
    :param ls:链接列表
    :return: 数组
    '''
    infoArray = []
    i = 1
    for lk in ls:
        print('正在获取第%d条信息' % i)
        bsobj = getbsobj(lk)
        if not bsobj: continue
        tags = bsobj.find('div', {'class': 'introContent'}).findAll('li')
        info = list()
        info.append(bsobj.head.title.get_text().split()[0])
        for tag in tags:
            info.append(tag.get_text().strip()[4:])
        ul = bsobj.find('ul', {'class': 'record_list'})
        info.append(ul.li.span.get_text().strip())
        text = ul.li.p.get_text().strip()
        a = re.search(r'\d+元/平', text)
        if a == None:
            info.append('无')
        else:
            info.append(a.group()[:-3])
        b = re.search(r'\d+-\d+-\d+', text)
        if b == None:
            info.append(text)
        else:
            info.append(b.group())
        infoArray.append(info)
        i += 1
    print('-' * 20)
    arr = np.array(infoArray)
    return arr


def checkid(ls, id):
    '''
    :param ls: 链接列表
    :param id: 成交id
    :return: bool
    '''
    links = []
    tag = False
    for lk in ls:
        if lk[-17:-5] != str(id):
            links.append(lk)
        else:
            break
    if len(links) != len(ls):
        tag = True
    ls = links
    return tag, ls


def getIndex(url):
    cols = ['小区名字']
    ls = getLinksList(url, 1)
    bs = getbsobj(ls[0])
    tags = bs.find('div', {'class': 'introContent'}).findAll('li')
    for tag in tags:
        cols.append(tag.span.get_text().strip())
    cols += ['成交额（万元）', '单价（元/平）', '日期']
    new_id = ls[0][-17:-5]
    return cols, new_id


def download(url, start, end):
    i = start
    fn = open('id.txt', 'r')
    id = fn.readline()
    fn.close()
    cols, new_id = getIndex(url)
    df = pd.DataFrame()

    try:
        while True:
            print('正在获取第%d页链接' % i)
            ls = getLinksList(url, i)
            if not ls:
                print(ls)
                print(1)
                break
            # print(ls)
            tag, ls = checkid(ls, id)
            # print(ls)
            arr = getInfo(ls)
            df_new = pd.DataFrame(arr, columns=cols)
            df = df.append(df_new, ignore_index=True)

            if tag:
                print(2)
                break
            i += 1
            if i > end:
                print(3)
                break
    except Exception as e:
        print(e)
    else:
        df_old = pd.read_excel('链家成交数据.xlsx')
        df_old = df.append(df_old, ignore_index=True)
        df_old.to_excel('链家成交数据.xlsx')
        fn = open('id.txt', 'w')
        fn.write(new_id)
        fn.close()
        print('程序执行完毕！')


if __name__ == '__main__':
    download(url, 1, 2)
