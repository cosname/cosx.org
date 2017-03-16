---
title: 粉丝地图的可视化
date: '2013-06-02T20:12:35+00:00'
author: COS编辑部
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
---

Rweibo问世以来，我就对它的可视化感到兴趣盎然。通过它我们可以得到微博关注者的各项信息，其中比较有意思的一项是地点(location)，这也就意味着，通过关注者的location（省市），可以找到他们的地理分布信息，同时，又可以得到他们的粉丝数目信息（可以判断是否是“微博名人”）。所以，既然万事俱备，为什么不用它做个“粉丝地图”来展示个人的粉丝信息呢？通过如下五步，我便基本得到了我想要的效果。

  1. 收集关注者的信息，整理地点信息；
  2. 获取并整理经纬度信息；
  3. 结合Himsic与ggmap包绘制图形；
  4. 结合animation包绘制动态图形。

## 1. 收集关注者的信息，整理location信息

首先，收集关注者的信息，并进行整理，我的做法是去除在“海外”，或者所在地为“其他”的人群（如果市的信息为“其他”而省份不为“其他”，令它与省份相同）。整理工作的代码如下：

<pre><code class="hljs nginx">&lt;span class="hljs-attribute">roauth&lt;/span> &lt; - createOAuth(app_name = &lt;span class="hljs-string">"pudding"&lt;/span>, access_name = &lt;span class="hljs-string">"rweibo"&lt;/span>)
my_fri &lt;- friendships.friends(roauth, uid = &lt;span class="hljs-number">2530951134&lt;/span>, count = &lt;span class="hljs-number">200&lt;/span>, cursor = &lt;span class="hljs-number">0&lt;/span>)
save(my_fri, file = &lt;span class="hljs-string">"my_fri.rda"&lt;/span>)
fri = my_fri[[&lt;span class="hljs-number">1&lt;/span>]]
&lt;span class="hljs-literal">info&lt;/span>1=lapply(fri,function(x) c(x&lt;span class="hljs-variable">$name&lt;/span>,x&lt;span class="hljs-variable">$location&lt;/span>,x&lt;span class="hljs-variable">$followers_count&lt;/span>))
&lt;span class="hljs-literal">info&lt;/span>=do.call(rbind,&lt;span class="hljs-literal">info&lt;/span>1)
loc=strsplit(&lt;span class="hljs-literal">info&lt;/span>[,&lt;span class="hljs-number">2&lt;/span>],&lt;span class="hljs-string">" "&lt;/span>)
a=do.call(rbind,loc)
a[,&lt;span class="hljs-number">1&lt;/span>][a[,&lt;span class="hljs-number">1&lt;/span>]==&lt;span class="hljs-string">"台湾"&lt;/span>]=&lt;span class="hljs-string">"台"&lt;/span>
a[,&lt;span class="hljs-number">2&lt;/span>][a[,&lt;span class="hljs-number">2&lt;/span>]==&lt;span class="hljs-string">"台湾"&lt;/span>]=&lt;span class="hljs-string">"台"&lt;/span>
a[,&lt;span class="hljs-number">2&lt;/span>][a[,&lt;span class="hljs-number">2&lt;/span>]==&lt;span class="hljs-string">"其他"&lt;/span>]=a[,&lt;span class="hljs-number">1&lt;/span>][a[,&lt;span class="hljs-number">2&lt;/span>]==&lt;span class="hljs-string">"其他"&lt;/span>]
 
myfri=data.frame(name=&lt;span class="hljs-literal">info&lt;/span>[,&lt;span class="hljs-number">1&lt;/span>],province=a[,&lt;span class="hljs-number">1&lt;/span>],city=a[,&lt;span class="hljs-number">2&lt;/span>],loc=apply(a,&lt;span class="hljs-number">1&lt;/span>,paste,collapse=&lt;span class="hljs-string">" "&lt;/span>)
 ,follower=as.numeric(&lt;span class="hljs-literal">info&lt;/span>[,&lt;span class="hljs-number">3&lt;/span>]))
myfri=myfri[which(myfri&lt;span class="hljs-variable">$province&lt;/span>!=&lt;span class="hljs-string">"其他"&lt;/span>&myfri&lt;span class="hljs-variable">$province&lt;/span>!=&lt;span class="hljs-string">"海外"&lt;/span>),]</code></pre>

## 2. 获取并整理经纬度信息

不过，有了地理位置的名称是不够的，我们必须知道他们的经纬度信息，这一部分信息可以通过网页抓取而得：

<pre><code class="hljs php">library(XML)
&lt;span class="hljs-comment"># get data from web&lt;/span>
webpage &lt; - &lt;span class="hljs-string">"http://blog.csdn.net/svrsimon/article/details/8255051"&lt;/span>
tables &lt;- readHTMLTable(webpage, stringsAsFactors = &lt;span class="hljs-keyword">FALSE&lt;/span>)
raw &lt;- tables[[&lt;span class="hljs-number">1&lt;/span>]]
zh_posi &lt;- raw[&lt;span class="hljs-number">-1&lt;/span>, ]
colnames(zh_posi) = c(&lt;span class="hljs-string">"province"&lt;/span>, &lt;span class="hljs-string">"city"&lt;/span>, &lt;span class="hljs-string">"county"&lt;/span>, &lt;span class="hljs-string">"lon"&lt;/span>, &lt;span class="hljs-string">"lat"&lt;/span>)
save(zh_posi, file = &lt;span class="hljs-string">"zh_posi.rda"&lt;/span>)
zh_posi$loc = apply(zh_posi[, &lt;span class="hljs-number">1&lt;/span>:&lt;span class="hljs-number">3&lt;/span>], &lt;span class="hljs-number">1&lt;/span>, paste, collapse = &lt;span class="hljs-string">" "&lt;/span>)
zh_posi[, &lt;span class="hljs-number">4&lt;/span>:&lt;span class="hljs-number">5&lt;/span>] = apply(zh_posi[, &lt;span class="hljs-number">4&lt;/span>:&lt;span class="hljs-number">5&lt;/span>], &lt;span class="hljs-number">2&lt;/span>, &lt;span class="hljs-keyword">as&lt;/span>.numeric)

get.loc &lt;- &lt;span class="hljs-function">&lt;span class="hljs-keyword">function&lt;/span>&lt;span class="hljs-params">(loc)&lt;/span> &lt;/span>{
    pro = grepl(loc[&lt;span class="hljs-number">1&lt;/span>], zh_posi$loc)
    cit = grepl(loc[&lt;span class="hljs-number">2&lt;/span>], zh_posi$loc)
    match = which(pro & cit)
    show(match)
    &lt;span class="hljs-keyword">return&lt;/span>(c(mean(zh_posi$lon[match]), mean(zh_posi$lat[match])))
}

b = apply(myfri[, &lt;span class="hljs-number">2&lt;/span>:&lt;span class="hljs-number">3&lt;/span>], &lt;span class="hljs-number">1&lt;/span>, get.loc)
myfri$lon = b[&lt;span class="hljs-number">1&lt;/span>, ]
myfri$lat = b[&lt;span class="hljs-number">2&lt;/span>, ]</code></pre>

鉴于关注人数在某些地区过于集中，此处只取在这些地区的均值表示：

    library(sqldf)
    myfri2 = sqldf("select province,city, avg(lon) as m_lon,avg(lat) as m_lat, avg(follower) as m_fol from myfri group by province,city")
    Encoding(myfri2$province) = "UTF-8"
    Encoding(myfri2$city) = "UTF-8"
    

<!--more-->

## 3. 结合Himsic与ggmap包绘制图形

作图，这里作图我借鉴了这位的[作品](http://quantifyingmemory.blogspot.com/2013/04/mapping-gdelt-data-in-r-and-some.html)（需科学上网），做了一点小修改。感觉很漂亮，可惜我做出来没这么好效果。重点在于对边的画法，方法是根据地图的中心点决定线的弯曲程度和方向，这里用到Hmisc包的bezier函数，相当于过任意三个点画平滑曲线。

    library(ggmap)
    library(Hmisc)
    edgeMaker 

与ggmap组合，效果图就是下面这张彩图啦。各个彩带起点的位置正是我目前的方位（广东 广州），终点就是我关注的各位的方位啦，用彩带可以表示出我们的关注关系。至于点的大小和线的粗细表示什么呢，它们的size被我设置成与被关注者的粉丝数目成正比（也就是可以表示传说中的微博名人）。几个大的微博名人聚集地多位于中国东部沿海的大城市中，而我的好友们大多数也位于东部由山东到广东的范围内。

    
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
    

“![](http://farm9.staticflickr.com/8395/8708205712_fc5f4d397d.jpg)”

## 4. 结合animation包绘制动态图形

用彩带表示还有一个有意思的地方就是可以用动画的形式呈现出我关注的顺序！用animation包做成gif形式就可以做到：

    library(animation)
    saveMovie({
        ani.options(interval = 0.1, convert = shQuote("C:/Program Files/ImageMagick-6.8.5-Q16/convert.exe"))
        for (i in seq(50, 3000, 50)) print(drawit(i))
    })
    

“![](http://www.puddingnnn.com/wp-content/uploads/2013/05/animation1.gif)”
  
可以看到我对微博名人的关注和对同学（粉丝较少的小点）的关注在时间上是有聚集效应的。为啥呢，这要感谢sina微博的推荐机制，它会把与你当前关注的同一“类别”的人群在你点击“关注”之后同时推送给你，于是你对这一类人的关注几乎就变成不分先后啦。

> 注：本文来自COS论坛的PuddingNnn，原帖<a href="https://cos.name/cn/topic/110269" target="_blank">请见此处</a>。
  
> 作者：朱雪宁，中山大学数学与应用数学专业（2009级）
  
> 个人主页：Pudding (<a href="http://www.puddingnnn.com/" target="_blank">http://www.puddingnnn.com/</a>)
