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
---

# ![配图](http://blog.fens.me/wp-content/uploads/2013/06/photo-cos1-small.jpg)

2013年6月23日，十一期COS数据分析沙龙（北京站）在明主1016如期举行。本期沙龙主题是“RHadoop助R突破大数据难关”；沙龙嘉宾张丹先生围绕沙龙主题分享了有关在`ubuntu`系统下配置`RHadoop`的相关知识以及基于`RHadoop`完成数据分析工作的相关案例。

张丹先生，系资深程序开发员，R语言爱好者；前天际网职员，混迹互联网和软件行业多年；曾参与开发多种不同类型的系统及应用，熟悉R/JAVA/PHP/Javacript等语言。对系统架构、编程算法、数据分析等诸多领域有自身见解，并推出了两款互联网小应用：[晒粉丝](http://www.fens.me)和[每日天气](http://apps.weibo.com/chinaweatherapp)。

沙龙开始嘉宾先对`RHadoop`项目的基本情况作了简要介绍：RHadoop`是由`RevolutionAnalytics`发起的基于`R`语言的开源数据分析项目。目前，`RHadoop`系列包包含`rmr`、`rhdfs`和`rhbase`三个`R`包，其分别与`Hadoop`系统架构中的`MapReduce`、`HDFS`和`HBase`相应。由于它们并未发布到`CRAN`上，因此，需要到`github`上的`RHadoop\`主页来寻找，具体地址在[这里](https://github.com/RevolutionAnalytics/RHadoop/wiki)。
  
<!--more-->


  
接下来，介绍了安装`RHadoop`需要的系统环境以及在Ubuntu系统下安装R软件的命令。由于`RHadoop`包在使用过程中要调用多个其它支撑包，因此，在安装之前，需要安装好`rJava`，`reshape2`，`Rcpp`，`iterators`，`itertools`，`digest`，`RJSONIO`，`functional`等8个支撑包。完成上述步骤之后，即可安装`rhdfs`和`rmr2`包了。

`RHadoop`的命令与原生`Hadoop`命令相仿，只是为了调用方便做了一些封装。以`rhdfs`包为例。查看`hdfs`文件目录的`Hadoop`原生语句是：

<pre>hadoopfs-ls/user</pre>

其对应的`RHadoop`的命令语句是：

<pre>hdfs.ls(”/user/“)</pre>

查看`hadoop`数据文件的`hadoop`语句是：

<pre>hadoopfs-cat /user/hdfs/o_same_school/part-m-00000</pre>

其对应的`RHadoop`的命令是：

<pre>hdfs.cat(”/user/hdfs/o_same_school/part-m-00000″)</pre>

课件`RHadoop`的命令更符合`R`用户的习惯。

`rmr2`包是帮助`R`实现`Map-Reduce`算法的包，基于它我们可以做很多提高效率的事情。一个简单的例子是：

<pre>small.ints= 1:100000
sapply(small.ints, function(x) x^2)</pre>

基于`rmr2`的命令是：

<pre>small.ints= to.dfs(1:100000)
mapreduce(input = small.ints, map = function(k, v) cbind(v, v^2))
from.dfs("/tmp/RtmpWnzxl4/file5deb791fcbd5")</pre>

由于`MapReduce`只能访问`HDFS`文件系统，因而，使用`MapReduce`功能之前需要借助`to.dfs()`函数将数据存储到`HDFS`文件系统里。调用`MapReduce`的运算结果时需要借助`from.dfs()`函数从`HDFS`文件系统中将其取出。

下面可以借助`rmr2`包对某个`*.txt`文件中出现的英文单词进行计数，相应的代码为：

<pre>input&lt;-'/user/hdfs/o_same_school/part-m-00000'
wordcount= function(input, output = NULL, pattern = " "){
wc.map = function(., lines) {
keyval(unlist( strsplit( x = lines,split= pattern)),1)
}
wc.reduce=function(word, counts ) {
keyval(word, sum(counts))
}
mapreduce(input = input ,output = output, input.format= "text",
map = wc.map, reduce = wc.reduce,combine= T)
}
wordcount(input)</pre>

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

对应的原生`R`代码和`RHadoop`代码分别是：

# 加载plyr包

<pre>library(plyr)</pre>

# 读取数据集

<pre>train&lt;-read.csv(file="small.csv",header=FALSE)
names(train)&lt;-c("user","item","pref")</pre>

# 计算用户列表

<pre>usersUnique&lt;-function(){
   users&lt;-unique(train$user) 
   users[order(users)] 
}</pre>

# 计算商品列表方法

<pre>itemsUnique&lt;-function(){ 
   items&lt;-unique(train$item) 
   items[order(items)] 
}</pre>

# 用户列表

<pre>users&lt;-usersUnique()
users</pre>

# 商品列表

<pre>items&lt;-itemsUnique()
items</pre>

# 建立商品列表索引

<pre>index&lt;-function(x) which(items %in% x)
data&lt;-ddply(train,.(user,item,pref),summarize,idx=index(item))</pre>

# 同现矩阵

<pre>cooccurrence&lt;-function(data){
   n&lt;-length(items)
   co&lt;-matrix(rep(0,n*n),nrow=n)
   for(u in users){
     idx&lt;-index(data$item[which(data$user==u)])
     m&lt;-merge(idx,idx)
       for(iin 1:nrow(m)){
          co[m$x[i],m$y[i]]=co[m$x[i],m$y[i]]+1
       }
   }
   return(co)
}</pre>

# 推荐算法

<pre>recommend&lt;-function(udata=udata,co=coMatrix,num=0){
   n&lt;-length(items) # all of pref
   pref&lt;-rep(0,n)
   pref[udata$idx]&lt;-udata$pref
   ## 用户评分矩阵
   userx&lt;-matrix(pref,nrow=n)
   ## 同现矩阵 * 评分矩阵
   r&lt;-co %*% userx
   ## 推荐结果排序
   r[udata$idx]&lt;-0
   idx&lt;-order(r,decreasing=TRUE)
   topn&lt;-data.frame(user=rep(udata$user[1],length(idx)),
                       item=items[idx], val=r[idx])
   ## 推荐结果取前num个
   if(num&gt;0) topn&lt;-head(topn,num) 
   ## 返回结果
   return(topn)
}</pre>

来自百度（销售管理中心）、新浪、IBM、亚马逊、京东、豆瓣、小米、去哪儿、中科软、泽佳、华丽志、宽连十方；ICON、新华网、
  
银华基金、诺亚舟财务咨询有限公司、富国基金、安永；中国铁道科学研究院、中科院地理所、密苏里大学哥伦比亚、中国人民大学、
  
中国中医科学院、苏州大学、北京邮电大学等企业和高校的人员报名参与了此次活动，席间与嘉宾积极互动，围绕主题展开了深入精彩的讨论。

### 幻灯片下载

[COS数据沙龙第9期幻灯片](http://doc.fens.me/rhadoop-cos.pdf)

**现场图片**

[<img class="alignnone size-full wp-image-787" alt="rhadoop-cos4" src="http://blog.fens.me/wp-content/uploads/2013/06/rhadoop-cos4.jpg" width="649" height="900" />](http://blog.fens.me/wp-content/uploads/2013/06/rhadoop-cos4.jpg)

**沙龙视频：**

**预告片**
  


**自我介绍**
  


**第一部分 – RHadoop的安装与使用介绍**
  


**第二部分 – R实现MapReduce协同过滤算法**
  


**第三部分 – 操作演示**
  


**第四部分 – 自由讨论**
  


更多沙龙信息请查看 <http://cos.name/salon>
