---
title: "发邮件这事你可以认真一点优雅一点"
author: 楚新元
date: "2020-06-17"
categories:
  - R语言
tags:
  - blastula
  - 发邮件
slug: send-email-serious-elegant
meta_extra: "审稿：李家郡；编辑：雷博文"
forum_id: 
---

之前在我的博客里介绍了一个利用R发邮件的方法^[<https://cxy.rbind.io/post/mailr/>]，这次我要推荐一个发邮件的包:`blastula`，首先，这个包不依赖Java，带来的好处是省去了在你电脑上安装Java这一步，以及避免了后续Java版本更新可能会带来的兼容性问题；其次，推荐这个包最主要的原因是：这个包可以很容易的在邮件正文部分嵌入R Markdown渲染的内容，方便成果分享。关于这个包更多的细节，请查看这个包在GitHub上的源码^[<https://github.com/rich-iannone/blastula>]，在此就不再赘述了，这里仅从用户层面分享一个笔者应用该包发邮件的例子，代码如下:

## 创建许可证

生成许可证的代码只需运行一次即可，许可证文件（访问SMTP服务器的唯一凭证）会自动存储在你的电脑里。生成许可证代码如下：

```r
# 加载相关R包
library(keyring)
library(blastula)

# 创建许可证
create_smtp_creds_key(
  id = "outlook", # 帮助文档是以Gmail为例的，这里以Outlook为例。
  user = "xxxxxxxx@outlook.com",  # 这里填入你的邮件地址
  provider = "outlook"
)
```

运行以上代码后，会弹出一个对话框要求你输入邮箱登陆密码，输入后提交即可。这里需要说明的是，创建许可证的另一种方式是使用`create_smtp_creds_file()`函数，具体请运行`?blastula::create_smtp_creds_file`查看该包帮助文档。

需要说明的是，这个包不光支持Gmail和Outlook，事实上该包对国内用户常用的QQ邮箱、163邮箱和新浪邮箱等也是支持的。各类邮箱POP3和SMTP服务器地址和端口可以参考这篇博客：各类邮箱POP3和SMTP服务器地址和端口^[<https://blog.csdn.net/o_o814222198/article/details/100110288>]。

## 定义邮件各要素

以下代码请保存在一个.R格式的文件中，如:head.R，定义好邮件各要素后，运行head.R即可发送邮件。注：笔者建议所有涉及文件保存在一个Poject下面，方便管理。

```r
# 填写收件人姓名
receiver = "张三"  # 后面sendmail.R中笔者会处理收件人和邮箱地址的关系

# 填写邮件主题
subject = "这是一封测试邮件"

# 填写附件及路径信息
attachment = "path/to/附件"  # 附件必须包含后缀，如果没有附件，引号内留空即可。

# 填写邮件正文所对应的.Rmd文件信息
body = "path/to/body.Rmd" # 这个Rmd文件渲染后就是邮件的正文

# 上面四个变量为利用sendmail.R发邮件时需要自定义的变量
source("sendmail.R")
```

## 定义邮件正文

邮件正文是通过上面提到的body.Rmd文件渲染得到，以下是一个body.Rmd文件的例子。

````
---
title: "来自楚新元的问候"
output: blastula::blastula_email
--- 

亲爱的朋友：

&emsp;&emsp;您好！近期您可能对**风速和气温之间的关系**比较关注，这里我做了一张图，供参考。顺祝心情愉快，一切顺利！

```{r fig.cap='风速和气温线性拟合图',fig.align='center',warning=FALSE,message=FALSE, echo=FALSE}
library(ggplot2)
library(RColorBrewer)
myColors = c(brewer.pal(5, "Dark2"), "black")
ggplot(airquality, aes(Wind, Temp, col = factor(Month))) +
  geom_point() +
  geom_smooth(method = lm, se = FALSE, aes(group = 1, col = "All")) +
  geom_smooth(method = lm, se = FALSE) +
  scale_color_manual("Month", values = myColors)
```

参考来源：慕课网。更多信息请参[这里](https://www.imooc.com/video/11582)    

----

楚新元     
新疆财经大学&emsp;&emsp;博士研究生     
地址: 新疆乌鲁木齐市北京中路449号     
邮编：830012     
个人主页: <http://cxy.rbind.io>     
E-mail: chuxinyuan@outlook.com     

````

以上body.Rmd文件渲染后的效果如下：

![body.Rmd文件渲染效果图](https://user-images.githubusercontent.com/26518047/84739677-b3be9b80-af71-11ea-8888-c61479644d18.jpg)

需要指出的是body.Rmd文件的output参数可以不是`blastula::blastula_email`，如：设置为`rmarkdown::html_document`也是可以的，body.Rmd文件内容请读者自行定制即可。

## 定义sendmail.R文件

以上部分都是发邮件的准备工作，sendmail.R文件才是发邮件的最关键部分，由于这部分一旦定义好以后基本不需要每次调整，所以笔者把它放在最后说明。

笔者把联系人放在contact.xlsx文件中，contact.xlsx文件里有两个字段：name和address，如果上文提到的收件人“张三”不在contact.xlsx文件中，则需要先把“张三”及邮件地址维护进contact.xlsx文件里。

```r
# 定义用户（发件人邮箱）
from = "xxxxxxxx@outlook.com"  # 发件人邮箱一般固定，所以放在这里而没有放在head.R文件中。

# 处理收件人和收件人邮箱地址关系
contact = readxl::read_xlsx("path/to/contact.xlsx")  # 读取联系人姓名和邮箱地址
to = contact$address[contact$name == receiver][1]  # 根据姓名自动匹配邮件地址

# 渲染邮件内容并添加附件，考虑到邮件可能有附件也可能没有附件，所以需要做个条件判断
library(blastula)
if (attachment == "") {
  render_email(body) -> email
  } else {
  render_email(body) %>% 
    add_attachment(file = attachment) -> email
    }

# 发送邮件
smtp_send(
  from = from,
  to = to,
  subject = enc2utf8(subject),  # 这里利用enc2utf8()处理中文主题乱码问题
  email = email,
  credentials = creds_key(id = "outlook") 
)
```

一切准备就绪，你只需要运行head.R文件即可发邮件。

Windows下定时发邮件可以参考我之前的博文[利用R语言定时自动发邮件](https://cxy.rbind.io/post/mailr/)。如果不想让自己的电脑当主机整天开着就是为了定时发个邮件，那么你需要掌握**travis**相关内容。

最后，需要说明的是：这篇文章主要参考了RStudio Blog上发表的一篇关于blatula包的博文。
具体请看这里：<https://blog.rstudio.com/2019/12/05/emails-from-r-blastula-0-3/>。
