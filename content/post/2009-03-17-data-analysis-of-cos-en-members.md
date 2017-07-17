---
title: COS竞赛：英文站点会员类型的识别
date: '2009-03-17T00:15:17+00:00'
author: 谢益辉
categories:
  - 数据挖掘与机器学习
tags:
  - 判别分析
  - 数据分析
  - 数据挖掘
  - 稀有事件
  - 竞赛
  - 统计之都
  - 英文网站
  - 非平衡数据
slug: data-analysis-of-cos-en-members
forum_id: 418778
---

大家好，为了促进大家对统计之都的了解，并锻炼各位会员的统计应用能力，即日起我们推出“COS竞赛”系列活动。第一期活动的主要任务是分析统计之都英文网站（<https://cos.name/en/>）的会员数据，从中找出识别正规会员和机器人（垃圾、广告、自动注册）会员的规律。
<!--more-->

# 数据背景

原始数据来自phpBB论坛的phpbb\_users数据库，其中包含用户id、用户名、是否激活、Email、发帖数等字段，其中我们要研究的因变量是“是否激活”（user\_active），它取值0和1，分别代表该用户是否被管理员激活，1表示是正规会员，0表示该会员是机器人或不知如何激活的人类。

我们对原始数据首先做了隐私处理，删掉了一些敏感字段，如用户名等，然后对Email和MSN帐号做了如下处理：

```r
x = read.csv("cos_en_users.csv", stringsAsFactors = FALSE,
    encoding = "UTF-8")
x$user_email_nchar = nchar(x$user_email)
x$user_email = sub("^.*@", "", x$user_email)
x$user_msnm_nchar = nchar(x$user_msnm, allowNA = TRUE)
x$user_msnm = sub("^.*@", "", x$user_msnm)
write.csv(x, "cos_en_spam.csv", row.names = FALSE)
```

即：去掉了帐号中@字符前面的字符串，只剩下域名字符串，然后在原数据中添加了两个变量*\_nchar表示Email和MSN帐号的字符数。

# 数据下载

整理之后的数据下载：[统计之都英文网站会员数据](https://uploads.cosx.org/2009/03/cos_en_spamcsv.gz)；

所有变量名的解释参见：[phpbb_users的数据表结构说明](http://www.phpbbdoctor.com/doc_columns.php?id=24 "http://www.phpbbdoctor.com/doc_columns.php?id=24")；注意其中所有时间数据都是Unix时间戳格式，起点为1970-01-01 00:00:00，可以用R函数`as.POSIXlt(, origin = "1970-01-01 00:00:00")`转化为日期。

# 分析目的

找出有效的规则区分会员类型：是否正规会员。本数据是一个高度不平衡的数据，取值为1的会员非常少：

```r
> table(x$user_active)
    0     1
25911    92
```

这给判别分析带来了不小的难度，如：即使将所有正规会员判别为机器人，正确率也在99.6462%，因此仅仅看模型的正确率可能不是合适的评判标准。我们最终考察的指标包括：预测正确率、模型简洁性、程序效率、分析结果新颖性。

# 注意事项

使用数据时请注意数据有效性，可以从原始信息中生成新的变量用来做预测：

1. user\_session\_page：该变量的取值意义不太确定，建议不使用；
1. user\_lastvisit：变量取值不稳定，建议不使用，user\_session_time可能更适合于作为用户最后的访问时间；
1. 由于非激活用户不能发帖，因此他们的user_posts必然都是0；而我们的分析目标是在用户注册之后马上就能从注册信息获知是否机器人注册，所以建议建模时不要使用这个变量；
1. user_style取值只能为1，是个常数，因此不必使用该变量；
1. 建议着重分析用户注册信息中的签名档、邮箱、网站链接，可以从这些文本数据生成新的变量，如邮箱域名是否以”.ru”（俄罗斯）结尾，签名档是否含有“free”等具有垃圾特征的词汇，等等；

# 参加方式

本次竞赛以邮箱投稿的方式接收作品，请将您的作品发送至contact [at] cos.name（[at]替换为@），作品应满足以下要求：

1. 注明使用软件工具的详细信息（版本、操作系统等）；
1. 评委可在其它地方相同条件下重复您的完整分析过程，包括：数据转换、建模、预测、图表的输出；为了保证预测结果的可重复性，请适当增大预测中估计正确率的交叉验证次数（或其它验证方法的次数）；
1. 写明最终的分析结论；
1. 文档格式不限，但有如下优先考虑顺序：Sweave > LaTeX/LyX > MS Word。

# 竞赛奖项

本次竞赛拟设立5名奖励名额，获得奖励为：（1）统计之都主站作者资格；（2）COS论坛中“COS项目”版块阅读权限；（3）其它“副产品”（如众多fans、广告效应带来的个人收入等）。

# 重要日期

本次竞赛自2009年3月17日开始，初步计划进行1个月，即4月17日截止，有意参加者可以先发邮件告知，时间可适当延长。

# 分析示例

此处举一例说明分析的目标：例如我们想研究会员类型与邮箱后缀的关系，那么可以将后缀用正则表达式提取出来，然后做列联表看它们有何联系：

```r
> table(x$user_active, sub("^.*\.", "", x$user_email))

     asia    at    au    az   biz    br    bs    by    ca    cc
  0     5     1    13     3    96     2     9    11    17    12
  1     0     0     0     0     0     0     0     0     0     0

       ch    cn   com   COM   con    cz    de    dk   edu    ee
  0     2   891 14539     1     1    20   122     8     6    75
  1     0     7    75     0     0     1     1     0     1     0

    email    es    eu    fm    fr   gov    gr    hk     i    il
  0     0     8     7    71    19     1     2     0     2     1
  1     1     0     0     0     0     0     1     1     0     0

       in  info    it    jp    kz    lt    lv    md  name   net
  0   234  1244    17     2     1     2    75     2    29  3838
  1     0     0     0     0     0     0     0     0     0     0

       nu    nz   org    pl   plo    pv    ro    ru   rui    se
  0     1     2  1440   505     1     1     3  1667     1     1
  1     0     1     0     0     0     0     0     0     0     0

       sn    su    th    tj    tu    tv    ua    uk    us    ws
  0     1    30     0     1     1    69   271   194   139   194
  1     0     0     1     0     0     0     0     1     0     0
```

从中我们发现以ru为邮箱后缀的会员都是垃圾会员，因此不妨将它作为一个新变量：

```r
email_ru = spam = logical(nrow(x))
email_ru[grep("^.*\.ru$", x$user_email)] = TRUE
spam = x$user_active == 0
par(mar = c(3, 3, 3, 1))
plot(t(table(spam, email_ru)), cex.axis = 0.8, shade = TRUE,
     main = "Spam members and Russian email address")
```

[![COS英文网站会员类别与俄罗斯后缀邮箱的马赛克图](https://uploads.cosx.org/2009/03/cos_en_spam_mosaicplot.png "COS英文网站会员类别与俄罗斯后缀邮箱的马赛克图")](/2009/03/data-analysis-of-cos-en-members/)
<p style="text-align: center;">COS英文网站会员类别与俄罗斯后缀邮箱的马赛克图</p>

以上马赛克图进一步说明了俄罗斯邮箱与会员类型的关系。
