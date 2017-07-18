---
title: COS数据分析沙龙第十一期（北京）
date: '2013-07-02T14:29:22+00:00'
author: 邓一硕
categories:
  - 新闻通知
  - 统计之都
  - 职业事业
tags:
  - COS沙龙
slug: beijing-cos-salon-june-2013
forum_id: 418944
---

# ![配图](http://blog.fens.me/wp-content/uploads/2013/06/photo-cos1-small.jpg)

2013年6月23日，十一期COS数据分析沙龙（北京站）在明主1016如期举行。本期沙龙主题是“RHadoop助R突破大数据难关”；沙龙嘉宾张丹先生围绕沙龙主题分享了有关在ubuntu系统下配置`RHadoop`的相关知识以及基于`RHadoop`完成数据分析工作的相关案例。

张丹先生，系资深程序开发员，R语言爱好者；前天际网职员，混迹互联网和软件行业多年；曾参与开发多种不同类型的系统及应用，熟悉R/JAVA/PHP/Javacript等语言。对系统架构、编程算法、数据分析等诸多领域有自身见解，并推出了两款互联网小应用：[晒粉丝](http://www.fens.me)和[每日天气](http://apps.weibo.com/chinaweatherapp)。

沙龙开始嘉宾先对`RHadoop`项目的基本情况作了简要介绍：`RHadoop`是由 RevolutionAnalytics 发起的基于R语言的开源数据分析项目。目前，`RHadoop`系列包包含`rmr`、`rhdfs`和`rhbase`三个R包，其分别与 Hadoop 系统架构中的 MapReduce、HDFS 和 HBase 相应。由于它们并未发布到CRAN上，因此，需要到github上的`RHadoop\`主页来寻找，具体地址在[这里](https://github.com/RevolutionAnalytics/RHadoop/wiki)。
  



  
接下来，介绍了安装`RHadoop`需要的系统环境以及在Ubuntu系统下安装R软件的命令。由于`RHadoop`包在使用过程中要调用多个其它支撑包，因此，在安装之前，需要安装好`rJava`，`reshape2`，`Rcpp`，`iterators`，`itertools`，`digest`，`RJSONIO`，`functional`等8个支撑包。完成上述步骤之后，即可安装`rhdfs`和`rmr2`包了。

`RHadoop`的命令与原生Hadoop命令相仿，只是为了调用方便做了一些封装。以`rhdfs`包为例。查看`hdfs`文件目录的Hadoop原生语句是：

```bash
hadoop fs -ls /user
```

其对应的`RHadoop`的命令语句是：

```r
hdfs.ls("/user/")
```

查看`hadoop`数据文件的`hadoop`语句是：

```bash
hadoop fs -cat /user/hdfs/o_same_school/part-m-00000
```

其对应的`RHadoop`的命令是：

```r
hdfs.cat("/user/hdfs/o_same_school/part-m-00000")
```

课件`RHadoop`的命令更符合R用户的习惯。

`rmr2`包是帮助R实现Map-Reduce算法的包，基于它我们可以做很多提高效率的事情。一个简单的例子是：

```r
small.ints = 1:100000
sapply(small.ints, function(x) x^2)
```

基于`rmr2`的命令是：

```r
small.ints= to.dfs(1:100000)
mapreduce(input = small.ints, map = function(k, v) cbind(v, v^2))
from.dfs("/tmp/RtmpWnzxl4/file5deb791fcbd5")
```

由于MapReduce只能访问HDFS文件系统，因而，使用MapReduce功能之前需要借助`to.dfs()`函数将数据存储到HDFS文件系统里。调用MapReduce的运算结果时需要借助`from.dfs()`函数从HDFS文件系统中将其取出。

下面可以借助`rmr2`包对某个`*.txt`文件中出现的英文单词进行计数，相应的代码为：

```r
input <- '/user/hdfs/o_same_school/part-m-00000'
wordcount = function(input, output = NULL, pattern = " "){
  wc.map = function(., lines) {
    keyval(unlist( strsplit( x = lines, split = pattern)), 1)
  }
  wc.reduce = function(word, counts ) {
    keyval(word, sum(counts))
  }
  mapreduce(input = input , output = output, input.format = "text",
    map = wc.map, reduce = wc.reduce, combine = T)
}
wordcount(input)
```

`RHadoop`系列包的最后一个包是`RHbase`，它相当于是一个管理数据库的包。其包含的函数如下：

  * hb.compact.table
  * hb.describe.table
  * hb.insert
  * hb.regions.table
  * hb.defaults
  * hb.get
  * hb.insert.data.frame
  * hb.scan
  * hb.delete
  * hb.delete
  * hb.get.data.frame
  * hb.list.tables
  * hb.scan.ex
  * hb.delete.table
  * hb.init
  * hb.new.table
  * hb.set.table.mode

沙龙最后，嘉宾分享了基于原生`R`代码和`RHadoop` 实现推荐系统中经常用到的`协同过滤算法`的内容。`协同过滤算法`的原生思想比较简单，包含以下三个步骤：

  * 建立物品的同现矩阵
  * 建立用户对物品的评分矩阵
  * 矩阵计算推荐结果

# RHbase

对应的原生`R`代码和`RHadoop`代码分别是：

## 加载plyr包

```r
library(plyr)
```

## 读取数据集

```r
train <- read.csv(file = "small.csv", header = FALSE)
names(train) <- c("user", "item", "pref")
```

## 计算用户列表

```r
usersUnique <- function(){
   users <- unique(train$user) 
   users[order(users)] 
}
```

## 计算商品列表方法

```r
itemsUnique <- function(){ 
   items <- unique(train$item) 
   items[order(items)] 
}
```

## 用户列表

```r
users <- usersUnique()
users
```

## 商品列表

```r
items <- itemsUnique()
items
```

## 建立商品列表索引

```r
index <- function(x) which(items %in% x)
data <- ddply(train, .(user, item, pref), summarize, idx = index(item))
```

## 同现矩阵

```r
cooccurrence <- function(data){
   n <- length(items)
   co <- matrix(rep(0, n * n),nrow = n)
   for(u in users){
     idx <- index(data$item[which(data$user == u)])
     m <- merge(idx,idx)
       for(i in 1:nrow(m)){
          co[m$x[i], m$y[i]] = co[m$x[i], m$y[i]] + 1
       }
   }
   return(co)
}
```

## 推荐算法

```r
recommend <- function(udata = udata, co = coMatrix, num = 0){
   n <- length(items) # all of pref
   pref <- rep(0,n)
   pref[udata$idx] <- udata$pref
   ## 用户评分矩阵
   userx <- matrix(pref, nrow = n)
   ## 同现矩阵 * 评分矩阵
   r <- co %*% userx
   ## 推荐结果排序
   r[udata$idx] <- 0
   idx <- order(r, decreasing = TRUE)
   topn <- data.frame(user = rep(udata$user[1], length(idx)),
                       item = items[idx], val = r[idx])
   ## 推荐结果取前num个
   if(num > 0) topn <- head(topn, num) 
   ## 返回结果
   return(topn)
}
```

来自百度（销售管理中心）、新浪、IBM、亚马逊、京东、豆瓣、小米、去哪儿、中科软、泽佳、华丽志、宽连十方；ICON、新华网、
  
银华基金、诺亚舟财务咨询有限公司、富国基金、安永；中国铁道科学研究院、中科院地理所、密苏里大学哥伦比亚、中国人民大学、
  
中国中医科学院、苏州大学、北京邮电大学等企业和高校的人员报名参与了此次活动，席间与嘉宾积极互动，围绕主题展开了深入精彩的讨论。

### 幻灯片下载

[COS数据沙龙第9期幻灯片](http://doc.fens.me/rhadoop-cos.pdf)

**现场图片**

![rhadoop-cos4](http://blog.fens.me/wp-content/uploads/2013/06/rhadoop-cos4.jpg)

**沙龙视频：**

**预告片**
  


**自我介绍**
  


**第一部分 – RHadoop的安装与使用介绍**
  


**第二部分 – R实现MapReduce协同过滤算法**
  


**第三部分 – 操作演示**
  


**第四部分 – 自由讨论**
  


更多沙龙信息请查看 <https://cos.name/salon>
