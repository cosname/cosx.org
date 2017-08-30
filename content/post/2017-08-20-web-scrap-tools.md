---
title: 忍法:数据通灵术
author: 杜亚磊
date: '2017-08-20'
slug: web-scrap-tools
categories:
  - 软件应用
tags:
  - 爬虫
  - python
  - R语言
---

俗话说"巧妇难为无米之炊"。如果你是一个数据忍者，却因为没有数据而烦恼，这卷"数据通灵术"或许是你需要的。首先你要看透术名那华丽的外衣，它的真面目是：爬虫技巧。

此卷通灵术包含了爬虫的基础入门术，动态加载破解术，登陆破解术，以及额外赠送的手机APP爬取篇。

# 爬虫简介

简单来说，爬虫就是从网上自动下载网页，经过解析处理得到你想到要的数据，存贮下来。
这里的步骤和关键词有三个: **下载**, **解析**, **存贮**。本文只介绍下载和解析的术式，存贮暂不考虑。


## 入门篇

"知己知彼，百战百胜"。这是为新手入门准备的网页简介。一个网页的源代码其实就是纯文本，包含了HTML,CSS和JavaScript。

- HTML: 标记语言，只有语法，没有变量和逻辑，不能称之为**编程**语言。

- CSS: 控制元素的展现形式

- JavaScript: 操作HTML中元素的增删改

一般来说，数据是在HTML元素中(否则你看不见它)。详细的HTML介绍可以参考W3School的
[HTML 教程](http://www.w3school.com.cn/html/index.asp)。

### 下载术

在R或Python中的下载网页是很简单的。以下的两行代码，使用R的`readLines`函数读取了豆瓣电影 Top 250 的网页源码：

```{r eval=FALSE}
html_lines = readLines('https://movie.douban.com/top250')
doc = paste0(html_lines, collapse = '')
```

其他的R包也有类似的函数，如`RCurl::getURL`和`httr:GET`。Python中的标配是`requests`模块。读文档，不细讲。

### 解析术

下载后的纯文本是类似下边的HTML标签，然而你需要的只是电影名称。

```html
<a href="https://movie.douban.com/subject/1292052/" class="">
  <span class="title">肖申克的救赎</span>
  <span class="title">&nbsp;/&nbsp;The Shawshank Redemption</span>
  <span class="other">&nbsp;/&nbsp;月黑高飞(港)  /  刺激1995(台)</span>
</a>
```

解析术就是将所需数据抽取出来的技巧。接下来介绍三种方法: 正则表达式，Xpath 和 CSS选择器。这些技巧都是通用的，基本不需要考虑编程语言的选择，都会支持的。

#### 正则表达式

正则表达式是通过描述文本规则来达到抽取目的。承接上文的豆瓣电影，使用正则来抽取电影名字:

```r
# 匹配包含class="title"字符的行 无关正则
title_lines = grep('class="title"', html_lines, value=T)
# 用正则抽取>字符和<字符中间的字符
titles = gsub('.*>(.*?)<.*', '\\1', title_lines, perl=T)
```

如果想看看第二行的效果，可以试试下边的代码：
```r
gsub('.*>(.*?)<.*', '\\1', 
     '<span class="title">肖生克的救赎</span>', perl=T)
```

其中`.*>(.*?)<.*`是一个正则表达式，其匹配规则如下图所示。
![regularexp](https://user-images.githubusercontent.com/3295865/29708182-63ae3bb2-89ba-11e7-828c-9b8090e9205f.png)

<!-- 正则可视化: https://jex.im/regulex/#!embed=false&flags=&re=%5E(a%7Cb)*%3F%24 -->

这个例子包含了正则中的通配符，贪婪匹配和懒惰匹配，以及分组的概念。看你骨骼惊奇，送你这本[正则表达式30分钟入门教程](http://deerchao.net/tutorials/regex/regex.htm)秘籍。学成归来之后，再来读读[R语言中的正则表达式](https://github.com/yihui/r-ninja/blob/master/04-character.Rmd#正则表达式)吧。


#### XPath

XPath是XML路径语言，适用于HTML和XML这两种标记语言。了解HTML的树状结构之后，便自可得其精髓。

下边的代码试用`xml2::read_html`函数解析下载的网页源代码，接下来使用XPath语言寻找所有包含 `class="title"` 属性的span标签。

```{r eval=FALSE}
library(xml2)
dom = read_html(doc)
title_nodes = xml_find_all(dom, './/span[@class="title"]')
xml_text(title_nodes)
```

```
 [1] "肖申克的救赎"
 [2] "The Shawshank Redemption"
 [3] "这个杀手不太冷"
 [4] "Léon"
 [5] "霸王别姬"
 [6] "阿甘正传"
 ......
```

深入学习XPath可参考[HTML DOM 教程](http://www.w3school.com.cn/htmldom/)和[XPath 教程](http://www.w3school.com.cn/xpath/index.asp)。

#### CSS选择器

CSS选择器是通过标签的CSS属性达到筛选的目的。类似与XPath，它同样需要先将纯文本解析成DOM文档，再进行选择操作。

这里借用`rvest`包来实现，筛选出`class="title"`的标签并拿到标签内的文本。

```{r eval=FALSE}
library(rvest)
read_html(doc) %>% 
  html_nodes('.title') %>% # class="title"的标签
  html_text()
```

读读[CSS 元素选择器](http://www.w3school.com.cn/css/css_selector_type.asp)教程，可以学到更多用法。


三种技巧相比之下，XPath的CSS选择器明显简单易用，但它们只适用于HTML和XML文档。正则表达式虽然规则复杂，但及其强大。利剑在手，任君选择。

## 工具破解篇

此篇介绍一些工具和技巧，破解以下常见的问题:

- 动态加载数据

- 数据分散在多个网页，难遍历

- 登录验证

### 破解动态加载数据

当你下载网页得到正常的结果(status code等于200)，却看不到想要的数据时，那么它通常都不在原始的HTML网页中，是通过二次请求得到。

判断数据是否包含在HTML网页中的方法很简单：在Chrome浏览器下打开网页后，结印 `Ctrl + Alt + U` 查看网页源代码，搜索是否有你想到的数据。

如果没有，结印`Ctrl + Alt + J`，调出Chrome的开发者模式，并切换到`Network`选项卡。接下来再次访问网页，就可以看到网页加载的过程。其中包含了HTML文件，js文件和cc文件，以及可能的图片和音视频文件等。接下来就是一个个查看这些请求的Response，寻找数据是从哪个请求中返回的。

比如这篇[COS访谈第31期: Charles Stein](https://cosx.org/2017/07/interview-charles-stein/)博文的评论，是通过iframe加载得到的:

![此处应有Chrome开发者模式的图](https://user-images.githubusercontent.com/3295865/29703375-e08ce786-89a7-11e7-9770-2e1a93dfd004.png)

因此直接访问[https://d.cosx.org/embed/419227-cos-31-charles-stein](https://d.cosx.org/embed/419227-cos-31-charles-stein)就可以拿到该博客的评论了。


如果你想亲自练练手，这个[莆田医院分布图](https://wandergis.com/hospital-viz/index.htm)展示了莆田医院在中国各省市的分布，其中医院的列表是通过Ajax加载得到的。试试看能否找到那个链接？

<!-- 答案在这里: https://wandergis.com/hospital-viz/hospital.geojson -->

### 遍历

通常来说，需要爬取的信息都分散在不同的页面，可以通过列表页的链接到达。比如新闻和简历的抓取。

然而有时候并没有一个明显的列表页面，只能通过点击得到动态的列表。这种情况下，列表的数据一般也是通过Ajax加载得到的。比如这个[东风标志的经销商页面](http://dealer.peugeot.com.cn/)，目标是搜集所有经销商的地址，经纬度和电话等信息。而每个经销商的信息都散落在各自的详情页，比如[这个页面](http://dealer.peugeot.com.cn/dealer/XTCLQCXSFWYXGS/)。有兴趣的读者可以自行钻研，再查看接下来的答案。

使用Chrome的开发者模式探索网站后，可以找出以下的步骤和接口：

1. 访问[首页](http://www.peugeot.com.cn/)，抓取省市和响应的数字编码，比如北京市对应3361，河北省对应3363。

2. 根据省的数字编码，获取市区的数据编码。比如河北省各市的数字编码：http://dealer.peugeot.com.cn/ajax.php?pid=3363&action=city 。查看源码可以看到石家庄市的数字编码是3394。

3. 根据市区的数字编码，抓该市的经销商列表。比如石家庄市的两家经销商：http://dealer.peugeot.com.cn/ajax.php?cid=3394&action=dealer。从中可以拿到两个对应的字符编码，河北盛威汽车贸易有限公司的编码是 HBSWQCMYYXGS。

4. 由经销商的编码，进入到该经销商的详情页: http://dealer.peugeot.com.cn/dealer/HBSWQCMYYXGS 。接下来就使用解析术抽取响应的地址和电话等信息即可。提示，地图中的经纬度数据，可以搜索在源码中搜索 BMap.Point 看到。

最后，将4步串接起来，前三步可以拿到所有经销商列表和相应的编码，最后遍历所有的详情页抓取详细信息即可。


### 破解登陆

模拟登陆是一个极有对抗性的话题，简单的网站或许就是一个POST请求。而复杂的网站如新浪微博，登陆过程可能经过层层加密，多个请求前后依赖，少一步都不可。幸而网站一般都是通过Cookie来验证登陆状态，所以在模拟请求的过程中带上相应的Cookie，便可骗过对方。

这里介绍一套工具: Chrome + [CurlWget](https://chrome.google.com/webstore/detail/curlwget/jmocjfidanebdlinpbcdkcmgdifblncg) + [uncurl](https://github.com/spulec/uncurl)/ [curl2r](https://github.com/badbye/curl2r)。

#### CurlWget
Chrome不必多言，CurlWget是一个将浏览器请求转换为curl或者wget命令的工具(curl和wget是两个终端下常用的浏览器)。通过它你可以拨开浏览器的外衣，看到一个网络请求的真面目:访问的url地址，携带的Cookie和Header的配置。

具体操作是，在Network选项卡里选中某个请求，右键，单击`Copy`->`Copy as cURL`。如图，单击后，该请求的curl命令便存贮在粘贴板里了。

![此处应有图](https://user-images.githubusercontent.com/3295865/29703633-e207c9fe-89a8-11e7-90ce-781cc5e0a028.png)

接下来在命令行中，直接粘贴命令并运行即可(据说看到数据在滚动时很有黑客的感觉，但我们是忍者，怎么能因为这个就沾沾自喜？)。

#### uncurl & curl2r

[uncurl](https://github.com/spulec/uncurl)和[curl2r](https://github.com/badbye/curl2r)分别是将刚刚的curl命令转化为Python命令和R命令的工具。因为在抓取后我们通常需要做进一步的解析，这时候使用Python或R会方便做进一步的处理。

其用法很简单，在浏览器中点击"Copy as cURLs"之后，在终端运行下面的命令即可。

```bash
$ uncurl "拷贝进来curl的命令"
requests.get("http://weibo.com/u/xxxxxxxxx/home?topnav=1&wvr=5",
    headers={
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
        "Accept-Encoding": "gzip, deflate, sdch",
        "Accept-Language": "zh-CN,zh;q=0.8,en;q=0.6,de;q=0.4",
        "Cache-Control": "no-cache",
        "Connection": "keep-alive",
        "DNT": "1",
        "Pragma": "no-cache",
        "Upgrade-Insecure-Requests": "1",
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36"
    },
   cookies={
        "xxxxxx": "xxxxx",  # 我是不会暴露自己的cookie的...
        "_s_tentry": "login.sina.com.cn",
        "wvr": "6"
    },
)

$ curl2r 拷贝进来curl的命令  # 此处不要用双引号括住!
library(httr)
GET("https://www.baidu.com/",
    add_headers(c(Pragma = "no-cache",
        DNT = "1", `Accept-Encoding` = "gzip, deflate, sdch, br",
        `Accept-Language` = "zh-CN,zh;q=0.8,en;q=0.6,de;q=0.4",
        `Upgrade-Insecure-Requests` = "1",
        `User-Agent` = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36",
        Accept = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
        `Cache-Control` = "no-cache",
        Connection = "keep-alive")),
    set_cookies(XXX)) # 我是不会暴露自己的cookie的...
```

此术虽然方便，但需牢记，不可泄漏你的Cookie信息。

## 手机APP篇

对于手机APP而言，比较难查看流量请求。虽然也有对应的软件，但据我所知好用的都是收费的。而且难以通用在安卓和IOS两大平台。这里介绍另一个工具: [Charles](https://www.charlesproxy.com/)。通过它，可以在PC端开启一个代理，然后把手机设备设置通过代理上网，所有HTTP(S)流量都会在该软件中一览无余。

Charles是一款免费，且在Windows，Mac OS和Linux上通用的跨平台软件。不论任何手机型号都可以连接Charles代理，可以说是很完美的解决方案的。

安装并开启Charles后，可以在`Help` -> `Local IP Address`里查看本级IP地址。接下来用手机接入同一个WIFI，填入Charles的IP地址和8888端口，配置HTTP代理。

![proxy](https://user-images.githubusercontent.com/3295865/29710289-3d3f8096-89c2-11e7-88cb-3457b198515e.png)

配置成功后，手机访问的HTTP(S)流量便会在Charles中展示出来。



如需查看HTTPS的流量，需要[安装SSL证书](http://www.charlesproxy.com/getssl/)，并在`Proxy` -> `SSL Proxying Settings...`中设置添加信任的网站列表。



如果想练练手的话，可以试试查看国际版微博。虽然它是HTTPS，但其数据获取方式及其简单，只是纯粹的一个GET请求，没有User Agent校验和Cookie校验等。

<!-- 一个国际版微博的例子(access_token和source已打码)：
https://api.weibo.com/2/short_url/info.json?url_short=http://t.cn/RCfjzFp&url_short=http://t.cn/RCwWit9&url_short=http://t.cn/RCfIpLB&url_short=http://m.weibo.cn/client/version&url_short=http://t.cn/RCGrqQd&url_short=http://t.cn/RCf5KPO&url_short=http://t.cn/RC2cwtB&url_short=http://t.cn/RCcu0Vz&access_token=xxxx&source=xxxx -->

最后，此术只能查看HTTP(S)的流量。不要试图用它偷窥微信和支付宝等涉及支付的机密APP。


## 结语

掌握以上术式后，你的数据召唤术已达到中忍级别。且容在下多嘴一句，**不要短时间内高频率的爬**。如果给网站服务器造成压力，你离被封杀也就不远了。友好的爬虫是KPI提升的重要组成部分，你好我好，大家好。
