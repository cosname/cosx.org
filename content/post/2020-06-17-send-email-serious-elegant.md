---
title: "发邮件这事你可以认真一点优雅一点"
author: 楚新元
date: "2020-06-17"
categories:
  - R语言
tags:
  - blastula
  - 邮件
slug: send-email-serious-elegant
meta_extra: "编辑：雷博文"
forum_id: 
---

之前在我得博客里介绍了一个利用R发邮件的方法[具体请戳：[https://cxy.rbind.io/post/mailr/](https://cxy.rbind.io/post/mailr/)]，这次我要推荐的一个发邮件的包是`blastula`，首先这个包不依赖java，最主要的是这个包可以很容易的在邮件正文部分嵌入R Markdown渲染的内容。这里就不多废话了，直接给出代码如下:

## 生成证书（只需运行一次即可）

```r
# 这里是生成证书的代码
library(keyring)
library(blastula)
create_smtp_creds_key(
  id = "outlook",       # 帮助文档是以gmail为例的。
  user = "xxxxxxxx@outlook.com",  # 这里填入你的邮件地址
  provider = "outlook"
)
```

## 定义邮件各要素（运行以下代码发邮件）

```r
#################################################################

# 填写收件人、主题,定义附件和正文内容
receiver = "张三"  # 后面我会处理收件人和邮箱地址的关系
subject = "这是一封测试邮件"
attachment = "path/to/附件"  # 如果没有附件，引号内留空即可。
body = "body.Rmd" # 这个Rmd文件渲染后就是邮件的正文

#################################################################

# 上面定义的要素我会传入sendmail.R文件中
source("sendmail.R")

#################################################################
```

## 定义邮件正文（Rmd文件）

````
---
title: "来自楚新元的问候"
output: blastula::blastula_email
--- 

亲爱的朋友：

&emsp;&emsp;您好！近期您可能对**风速和气温之间的关系**比较关注，这里我做了一张图，供参考。顺祝心情愉快，一切顺利！

```{r warning=FALSE, message=FALSE, echo=FALSE}
library(ggplot2)
library(RColorBrewer)
myColors = c(brewer.pal(5, "Dark2"), "black")
ggplot(airquality, aes(Wind, Temp, col = factor(Month))) +
  geom_point() +
  geom_smooth(method = lm, se = FALSE, aes(group = 1, col = "All")) +
  geom_smooth(method = lm, se = FALSE) +
  scale_color_manual("Month", values = myColors)
```

参考来源：慕课网。更多信息请参[这里](https://www.imooc.com/video/11581)    

----

楚新元     
新疆财经大学&emsp;&emsp;博士研究生     
地址: 新疆乌鲁木齐市北京中路449号     
邮编：830012     
个人主页: http://cxy.rbind.io     
E-mail: chuxinyuan@outlook.com     

````

正文效果如下：

```
<iframe seamless src="https://rbind.gitee.io/html/mailbody.html" height = "900" width  = "750" frameborder="no"></iframe>
```

## 定义sendmail.R文件（这个文件不用管它）

```r
#################################################################

# 处理收件人问题（我把联系人放在contact.xlsx文件中）
library(openxlsx)
contact = read.xlsx("path/to/contact.xlsx")  
to = contact$address[contact$name == receiver][1]

# 注意：我的contact.xlsx文件里有两个字段，name和address

#################################################################

# 渲染邮件内容并添加附件
library(blastula)
if (attachment == "") {
  render_email(body) -> email
  } else {
  render_email(body) %>% 
    add_attachment(file = attachment) -> email
    }

#################################################################

# 定义用户（发件人）
from = "xxxxxxxx@outlook.com"

# 发送邮件
smtp_send(
  from = from,
  to = to,
  subject = enc2utf8(subject),
  email = email,
  credentials = creds_key(id = "outlook")
)

#################################################################
```

定时发邮件可以参考我之前的博文[利用R语言定时自动发邮件](https://cxy.rbind.io/post/mailr/)。如果不想让自己的电脑当主机整天开着就是为了定时发个邮件，那么你需要掌握**travis**相关内容。

最后，需要说明的是这篇文章主要是参考了`blatula`包在rstudio上发表的一篇博文。具体请看这里：[https://blog.rstudio.com/2019/12/05/emails-from-r-blastula-0-3/](https://blog.rstudio.com/2019/12/05/emails-from-r-blastula-0-3/)。
