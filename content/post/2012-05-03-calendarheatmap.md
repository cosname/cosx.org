---
title: 日历中的夏天
date: '2012-05-03T22:37:45+00:00'
author: 肖凯
categories:
  - 统计图形
  - 统计软件
  - 软件应用
tags:
  - ggplot2
  - RCurl
  - R语言
  - 数据可视化
  - 数据源
  - 日历热图
slug: calendarheatmap
forum_id: 418870
---

![看着有节，摸着无节，打一生活用品](https://uploads.cosx.org/2012/05/summer.jpg)

不知不觉，夏日已慢慢临近。姑娘们飞扬的裙角，小贩叫卖的西瓜，蚊蝇嗡嗡的声音，以及翻过的一页日历，都提醒着你夏天快来了。夏季有着不同的定义：根据中国人的日历，我们所俗称的夏季从立夏开始，到立秋结束；但在气候学上，夏季是指连续五天平均温度超过22摄氏度即算作夏季的开始，若连续五天平均温度低于22度则算作入秋；而天文学上的夏季一般是指六、七、八这三个月。

那么哪一种夏季的定义更合适一些呢？还是用数据可视化来说话吧。这项任务基本上有两个步骤：一是获取某城市的2011年日平均温度数据，二是根据数据绘制**日历热图（Calendar-Heatmap）**。<!--more-->

本文所采用的数据源是[Wunderground](http://www.wunderground.com/weather/api/d/documentation.html)提供的API。该API所提供的数据极为丰富，除了历史温度数据之外，还有湿度、风向等大量信息可供利用，所以它也被[数据源手册](http://xccds1977.blogspot.com/2012/04/30.html)所推荐。为了使用这个API我们先申请一个免费帐户，然后利用R语言中的RJSONIO包来提取每天的平均温度。使用这个API要注意的是，其免费帐户限制了每分钟10次调用，超出会中断连接。不知道别人怎么弄的，本人的笨办法是在程序中增加了暂停。这样获得了365个日平均温度。

日历热图是一种有趣的工具，它可以在日历表中显示时间序列数据的变化。在2009年的[The Data Expo](http://blog.revolutionanalytics.com/2009/09/analysis-of-airline-performance.html)中，获奖团队就是利用SAS来生成日历热图。多才多艺的R语言当然也可以做到。在《R Graphs Cookbook》这本书中就提到了绘制日历热图的方法，第一种方法是Paul Bleicher所写的一个[函数](http://blog.revolution-computing.com/downloads/calendarHeat.R)，它是基于grid,lattice,chron这三个扩展包来编写的。第二种方法是使用openair扩展包中的calendarPlot函数。生成的图形就象下面这个样子。
  
![](https://uploads.cosx.org/2012/05/calendarheadmap1.jpeg) 看起来不错，但是我们还没完。我们希望挑选出平均温度在22度以上的日子，突出显示出来。所以我们采用第三种方法，用ggplot2包来绘制日历热图，图形显示如下（参考了MarginTale的[这篇文章](http://margintale.blogspot.com/2012/04/ggplot2-time-series-heatmaps.html)）。
  
![](https://uploads.cosx.org/2012/05/calendarheadmap2.jpeg)上图数日子是竖着来数的，横轴表示每月的第几周，纵轴表示星期几。灰色部分表示当天平均温度在22度以下，有色彩的区块表示在22度以上。颜色越偏黄则表示温度越高。在2011年，立夏的时间是5月6日，立秋是8月8日，但可以观察到立秋之后仍有很多日子的平均温度在22度以上。这就是我们所俗称的“秋老虎”。如果按照气候学的定义，四月末就有五天以上连续的高温天气，照这样看夏天应该在四月末就开始了，一直延续到十月初结束。而天文学上的夏季则是六、七、八三个月，看到这三个月基本上全是22度以上，而且高温天气集中在七八两个月，这也正是学校放暑假的时间段。这样看来，似乎天文学的夏季定义是比较符合我们人体的感觉的。其它的要么偏短，要么偏长。

写到这里，想起了梁静茹的一首歌：

宁静的夏天
  
天空中繁星点点
  
心里头有些思念
  
思念着你的脸
  
我可以假装看不见
  
也可以偷偷的想念
  
直到让我摸到你那温暖的脸

（最后要说的是，本人并非气象专家，本文也没有考虑到湿度对体感温度的影响，或是其它因素。主要还是向各位介绍R语言中日历热图的绘制以及数据的获取。）
  
代码如下：


```r
# 加载所需扩展包
library(RCurl)
library(RJSONIO)
require(quantmod)
library(ggplot2)

# 提取武汉市2011年一年的历史数据
date<- seq.Date(from=as.Date('2011-01-01'),
  to=as.Date('2011-12-31'), by='1 day')
date.range<- as.character(format(date,"%Y%m%d"))
n <- length(date.range)
temp <- humi <- rep(0,n)
for (i in 1:n) {
  # 你要用自己申请的API key来代替程序中的yourkey
  url <- 'http://api.wunderground.com/api/yourkey/'
  finalurl <- paste(url,'history_',date.range[i],
    '/q/wuhan.json',sep='')
  web <- getURL(finalurl)
  raw <-fromJSON(web)
  temp[i] <- raw$history$dailysummary[[1]]$meantempm
  humi[i] <- raw$history$dailysummary[[1]]$humidity
  # 在循环内增加一个7秒的暂停，避免连接断开。
  Sys.sleep(7)
}
# 将获得的数据整合为数据框，并将温度和湿度转为数值格式
dataset <- data.frame(temp,humi,date,stringsAsFactors=F)
dataset$temp <- as.numeric(dataset$temp)
dataset$humi <- as.numeric(dataset$humi)

# 用openair包绘制日历热图
install.packages('openair')
library(openair)
calendarPlot(dataset,pollutant='temp',year=2011)

# 用ggplot2包绘制日历热图
# 复制一个新的数据框
dat <- dataset
# 先取得月份，再转为因子格式
dat$month<-as.numeric(as.POSIXlt(dat$date)$mon+1)
dat$monthf<-factor(dat$month,levels=as.character(1:12),
  labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul",
  "Aug","Sep","Oct","Nov","Dec"),ordered=TRUE)
# 得到每周的星期，也转为因子格式
dat$weekday = as.POSIXlt(dat$date)$wday
dat$weekdayf<-factor(dat$weekday,levels=rev(0:6),
  labels=rev(c("Sun","Mon","Tue","Wed","Thu","Fri","Sat")),ordered=TRUE)
# 先得到全年的周序号，然后得到每个月的周序号
dat$week <- as.numeric(format(dat$date,"%W"))
dat<-ddply(dat,.(monthf),transform,monthweek=1+week-min(week))
# 绘图
P <- ggplot(dat, aes(monthweek, weekdayf, fill = temp)) +
  geom_tile(colour='white') +
  facet_wrap(~monthf ,nrow=3) +
  scale_fill_gradient(space="Lab",limits=c(22, max(dat$value)),
    low="red", high="yellow") +
  opts(title = "武汉市2011年气温日历热图") +
  xlab("Week of Month") + ylab("")
P
```
