---
title: 粉丝地图的可视化
date: '2013-06-02T20:12:35+00:00'
author: 朱雪宁
categories:
  - 统计图形
  - 软件应用
tags:
  - animation
  - ggmap
  - Himsic
  - 可视化
  - 地图
  - 微博
  - 社交
  - 粉丝
slug: weibo-fans-map-visualization
forum_id: 418941
---

Rweibo问世以来，我就对它的可视化感到兴趣盎然。通过它我们可以得到微博关注者的各项信息，其中比较有意思的一项是地点(location)，这也就意味着，通过关注者的location（省市），可以找到他们的地理分布信息，同时，又可以得到他们的粉丝数目信息（可以判断是否是“微博名人”）。所以，既然万事俱备，为什么不用它做个“粉丝地图”来展示个人的粉丝信息呢？通过如下四步，我便基本得到了我想要的效果。

1. 收集关注者的信息，整理地点信息；
1. 获取并整理经纬度信息；
1. 结合Himsic与ggmap包绘制图形；
1. 结合animation包绘制动态图形。

<!--more-->

# 1. 收集关注者的信息，整理location信息

首先，收集关注者的信息，并进行整理，我的做法是去除在“海外”，或者所在地为“其他”的人群（如果市的信息为“其他”而省份不为“其他”，令它与省份相同）。整理工作的代码如下：

```r
roauth < - createOAuth(app_name = "pudding", access_name = "rweibo")
my_fri <- friendships.friends(roauth, uid = 2530951134, count = 200, cursor = 0)
save(my_fri, file = "my_fri.rda")
fri = my_fri[[1]]
info1=lapply(fri,function(x) c(x$name,x$location,x$followers_count))
info=do.call(rbind,info1)
loc=strsplit(info[,2]," ")
a=do.call(rbind,loc)
a[,1][a[,1]=="台湾"]="台"
a[,2][a[,2]=="台湾"]="台"
a[,2][a[,2]=="其他"]=a[,1][a[,2]=="其他"]
 
myfri=data.frame(name=info[,1],province=a[,1],city=a[,2],loc=apply(a,1,paste,collapse=" ")
 ,follower=as.numeric(info[,3]))
myfri=myfri[which(myfri$province!="其他"&myfri$province!="海外"),]
```

# 2. 获取并整理经纬度信息

不过，有了地理位置的名称是不够的，我们必须知道他们的经纬度信息，这一部分信息可以通过网页抓取而得：

```r
library(XML)
# get data from web
webpage < - "http://blog.csdn.net/svrsimon/article/details/8255051"
tables <- readHTMLTable(webpage, stringsAsFactors = FALSE)
raw <- tables[[1]]
zh_posi <- raw[-1, ]
colnames(zh_posi) = c("province", "city", "county", "lon", "lat")
save(zh_posi, file = "zh_posi.rda")
zh_posi$loc = apply(zh_posi[, 1:3], 1, paste, collapse = " ")
zh_posi[, 4:5] = apply(zh_posi[, 4:5], 2, as.numeric)

get.loc <- function(loc) {
    pro = grepl(loc[1], zh_posi$loc)
    cit = grepl(loc[2], zh_posi$loc)
    match = which(pro & cit)
    show(match)
    return(c(mean(zh_posi$lon[match]), mean(zh_posi$lat[match])))
}

b = apply(myfri[, 2:3], 1, get.loc)
myfri$lon = b[1, ]
myfri$lat = b[2, ]
```

鉴于关注人数在某些地区过于集中，此处只取在这些地区的均值表示：

```r
library(sqldf)
myfri2 = sqldf("select province,city, avg(lon) as m_lon,avg(lat) as m_lat, avg(follower) as m_fol from myfri group by province,city")
Encoding(myfri2$province) = "UTF-8"
Encoding(myfri2$city) = "UTF-8"
```    

# 3. 结合Himsic与ggmap包绘制图形

作图，这里作图我借鉴了这位的[作品](http://quantifyingmemory.blogspot.com/2013/04/mapping-gdelt-data-in-r-and-some.html)（需科学上网），做了一点小修改。感觉很漂亮，可惜我做出来没这么好效果。重点在于对边的画法，方法是根据地图的中心点决定线的弯曲程度和方向，这里用到Hmisc包的bezier函数，相当于过任意三个点画平滑曲线。

 ```r
library(ggmap)
library(Hmisc)
edgeMaker 
 ```

与ggmap组合，效果图就是下面这张彩图啦。各个彩带起点的位置正是我目前的方位（广东 广州），终点就是我关注的各位的方位啦，用彩带可以表示出我们的关注关系。至于点的大小和线的粗细表示什么呢，它们的size被我设置成与被关注者的粉丝数目成正比（也就是可以表示传说中的微博名人）。几个大的微博名人聚集地多位于中国东部沿海的大城市中，而我的好友们大多数也位于东部由山东到广东的范围内。

```r
china=get_map(location = c(lon = mean(myfri2$m_lon), lat = mean(myfri2$m_lat)), zoom=5,maptype= "roadmap")
p1=ggmap(china,extent='device',darken=0.2)
drawit<-function(i){
 p=p1+geom_path(data=allEdges[1:i,], aes(x = x, y = y,group = Group, # Edges with gradient
 size=log(weight+1),color=Sequence),alpha=0.6,show_guide=F)+ # and taper
 scale_colour_gradient(low = "red3", high = "white", guide = "none")
 if (i>=100)
 {
 p=p+geom_point(data=myfri2[1:floor(i/100),],aes(x=m_lon,y=m_lat,size=log(m_fol+1)*1.3),alpha=0.5,show_guide=F,colour = "black") +
 geom_point(data=myfri2[1:floor(i/100),],aes(x=m_lon,y=m_lat,size=(log(m_fol+1))),alpha=0.6,show_guide=F,colour="red3")
 }
 return(p)
}
print(drawit(3800))
``` 

![](http://farm9.staticflickr.com/8395/8708205712_fc5f4d397d.jpg)

# 4. 结合animation包绘制动态图形

用彩带表示还有一个有意思的地方就是可以用动画的形式呈现出我关注的顺序！用animation包做成gif形式就可以做到：

```r
library(animation)
saveMovie({
    ani.options(interval = 0.1, convert = shQuote("C:/Program Files/ImageMagick-6.8.5-Q16/convert.exe"))
    for (i in seq(50, 3000, 50)) print(drawit(i))
})
```    

![](https://cloud.githubusercontent.com/assets/26109492/24919709/293f3b10-1f17-11e7-911b-0c94122425a8.gif)
  
可以看到我对微博名人的关注和对同学（粉丝较少的小点）的关注在时间上是有聚集效应的。为啥呢，这要感谢sina微博的推荐机制，它会把与你当前关注的同一“类别”的人群在你点击“关注”之后同时推送给你，于是你对这一类人的关注几乎就变成不分先后啦。

注：本文来自COS论坛的PuddingNnn，原帖[请见此处](https://cos.name/cn/topic/110269)。

作者：朱雪宁，中山大学数学与应用数学专业（2009级）；个人主页：Pudding (<http://www.puddingnnn.com/>)
