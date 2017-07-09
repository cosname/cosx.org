---
title: R时代，你要怎样画地图？
date: '2013-01-11T09:01:53+00:00'
author: 苏建冲
categories:
  - 统计图形
  - 统计软件
  - 软件应用
tags:
  - ggmap
  - ggplot2
  - R语言
  - 可视化
  - 地图
slug: drawing-map-in-r-era
forum_id: 418895
---

不知道各位平常有没有过需要画地图的需求，有的时候需要在地图上标出特定位置的数据表现或者一些数值，然而怎么实现？

这里主要介绍下在R语言中绘制地图的个人琢磨的思路。绘制地图步骤有三：

  1. 你得需要绘制地图；（约等于废话）
  1. 你得有要绘制地图的地理信息，经纬度啊，边界啊等等；
  1. 你得利用2的数据在R中画出来。

以上步骤中，目前最关键的是2，一旦2的数据有了，在R中不就是把它们连起来嘛，这个对于R来说就是调戏它，就跟全民调戏小黄鸡一样。

R语言中绘制地图的思路也是由于2的获取方式不一样而分开的。

第一种思路：有一些R包中存储着常见地图的数据，比如maps包中存有世界地图、美国地图、美国各州郡地图、法国地图以及加拿大城市地图等，加载了这个包，就可以轻松愉快地绘制上述地图。mapdata包中存有中国地图的数据，但是比较旧了，这个数据，重庆还没有从四川分出来呢。

总体来讲，第一种思路受包中已有的数据数量限制（但我R包多！），如果各个包中都没有梵蒂冈的信息，那咋办啊（其实可以通过绘制世界地图，然后限制区域把梵蒂冈画出来）。而且，如果我想画中国人民大学的地图怎么办？？？哭……

第二种思路：我先去一个地方下载所画图的地理数据，然后读入R进行绘制。比如由于mapdata中的中国地图比较久远了，谢老大的[《终于搞定中国分省市地图》](http://yihui.name/cn/2007/09/china-map-at-province-level/)一文中就介绍了，先从国家基础地理信息中心下载中国各省市的地理数据，之后再绘制。后来肖凯老师又介绍googleVis包也可以按照这个思路来绘制地图，具体可参考[《利用googleVis包实现环境数据可视化》](http://xccds1977.blogspot.com/2011/09/test_901.html)（友情提示，需科学上网）。之后的OpenStreetMap包也是提供了方便下载地理数据的途径。

如您所看到的，第二种途径的步骤稍多，不利于大家上手。我知道，如果过程越长，越艰辛，最终绘制出地图的那一刻的快感就越强烈，但是“少折腾”的指示，还是提醒我们，尽量化繁为简。于是第三种的思路，就是既继承了第一种思路简洁的操作方式，又吸取了第二种思路的数据来源广泛的优势。

  第三种思路：既然R是自由的，那我能不能直接去调取专业的地图企业或者网站的数据呢，这样就不会受包中数据集所限，我只需要有一个途径去专业的地图供应商那取数据就可以了，比如Google Map，Baidu Map等，这可都是专业的地图网站，里面的地理数据应有尽有，想取啥取啥。自由的R只需要连接Google Map的API，一切就都有了，当然Google大爷不会让你无限制的取数据，目前的限制是2000次（应该是单天的限制），于是ggmap包诞生了，两位作者David Kahle和 Hadley Wickham真是太会解放全球人民了，并且该包中有几个让我无比激动的命令，下文见！！！

  好，我们先来按照第一种思路来画几个图：

##  1、 画世界地图

  如果是首次使用，需要在R中装载maps包
  
  ```r
  install.packages('maps')
  ```
  
  这个包中存有世界地图和美国地图的地图数据，所以，几行代码便可以画出世界地图。

代码如下：

```r
library(maps)
map("world", fill = TRUE, col = rainbow(200),
    ylim = c(-60, 90), mar = c(0, 0, 0, 0))
title("世界地图")
```

输出为：

![world_map](https://uploads.cosx.org/2013/01/world_map.png)</a>

  无比绚丽的世界，引无数骚客竞折腰啊……

## 2、 画美国地图

  同样在maps包中包含了美国地图和美国各州郡的详细地图数据，同样的，也可以用简单的代码画出美国地图，便于我们使用。

  代码如下：

```r
library(maps)
map("state", fill = TRUE, col = rainbow(209),
    mar = c(0, 0, 2, 0))
title("美国地图")
```

输出为：

![us_map](https://uploads.cosx.org/2013/01/us_map.png)

整体形状这是像啥啊，山姆大叔……

对于美国地图，该包提供画出指定几个州的图，比如这里只画出New York, New Jersey, Penn三州的地图：

代码如下：

```r
library(maps)
map('state', region = c('new york', 'new jersey', 'penn'),
    fill = TRUE, col = rainbow(3), mar = c(2, 3, 4, 3))
title("美国三州地图")
```

输出结果为：

![states_map](https://uploads.cosx.org/2013/01/states_map.png)

三州鼎力！！

## 3、 画中国地图

上述的maps包中并没有中国地图的数据 ，在另外一个包mapdata中有中国地图的数据（比较旧的数据）。

代码如下：

```r
library(maps)
library(mapdata)
map("china", col = "red4", ylim = c(18, 54), panel.first = grid())
title(" 中国地图")
```

输出为：

![China_map](https://uploads.cosx.org/2013/01/China_map.png)

哭，重庆在哪里，重庆在哪里？？

好，我们来强力介绍ggmap包，先来说下该包让我惊讶的几个命令：

## 1、geocode()

比如：

```r
> geocode("Beijing")
       lon      lat
1 116.4075 39.90403
```

这大哥可以返回一个地方的经纬度，那我再调戏之：

```r
> #这意思就是大哥你多给点！！
> geocode("Renmin University of China", output = "more")
       lon      lat              type     loctype
1 116.3184 39.96998 point_of_interest approximate
                                                                                address
1 renmin university of china, 59号 zhongguancun street, haidian, beijing, china, 100086
     north    south     east     west postal_code country
1 39.97853 39.96142 116.3345 116.3024      100086   china
  administrative_area_level_2 administrative_area_level_1 locality
1                        <NA>                     beijing  beijing
               street streetNo          point_of_interest
1 zhongguancun street       NA renmin university of china                       
                       query
1 Renmin University of China
```

信息给多了，我说几个点，不但有人民大学的经纬度，还有该大学的详细地址（中国人民大学，中关村大街59号，海淀，北京，中国），还有邮编好吧100086！！！！但是好像跟我们实际的100872有差距（倒是跟10086很接近啊），但是它确实是返回了邮政编码，还有zhongguancun street就不说了……这完全就是返回的Google地图存储的人民大学的信息啊……

## 2、mapdist()

第二个颠颤颤的命令式mapdist()。比如：

```r
> mapdist('China Agricultural University',
+     'Renmin University of China', 'walking')
                           from                         to    m    km
1 China Agricultural University Renmin University of China 6022 6.022
     miles seconds  minutes    hours
1 3.742071    4523 75.38333 1.256389
```

1 mile = 1609米。

这意思就是说从农大到人大距离6022米，如果您步行，需要4523秒……汗，我下次考虑下步行试试。不过，您说的是农大东校区还是农大西校区啊……

另，ggmap包中不仅仅可以调取Google Map的数据，还可以调取OpenStreetMap (‘osm’)、Stamen Maps (‘stamen’)和CloudMade maps (‘cloudmade’)。亲，这够用了吧。那地图的表现形式也是个性化的，有’terrain’（地势图）、’satellite’（卫星图）、’roadmap’（道路图）和 ‘hybrid’（混合）等。您自个儿选。

其他的不谈了，直接画地图：

```r
library(ggmap)
library(mapproj)
## Google啊Google给我China的地图数据吧
map <- get_map(location = 'China', zoom = 4)
ggmap(map)
```

于是：

![China_map_2](https://uploads.cosx.org/2013/01/China_map_2.png)

我天朝雄赳赳，气昂昂啊！！请注意左下角的Google logo！！

再来北京道路地图：

```r
#Google啊Google给我Beijing的公路地图数据吧
map <- get_map(location = 'Beijing', zoom = 10, maptype = 'roadmap')
ggmap(map)
```

于是：

![Beijing_map](https://uploads.cosx.org/2013/01/Beijing_map.png)

最后，我想看下大冬天的有没有人在人民大学的各个楼顶上晒太阳浴：

```r
## Google啊Google给我RUC的卫星地图数据吧
map <- get_map(location = 'Renmin University of China', zoom = 14,
    maptype = 'satellite')
ggmap(map)
```

![RUC_map](https://uploads.cosx.org/2013/01/RUC_map.png)

太不清楚了，根本看不清楚哪跟哪啊。就这么着吧，我估计快够当天限制数了。

最后来个正经的，借用[肖凯老师编好的代码](http://xccds1977.blogspot.com/2012/06/ggmap.html)（肖老师的原文后面还有用谢老大animation包做的动态图呢），从[中国地震数据中心](http://data.earthquake.cn/datashare/globeEarthquake_csn.html)下载 2013.1.5-2013.1.11 这一周发生在中国的小地震，呃，应该都是小地震，因为没有听到相关的大地震的新闻报道。

![earthquake_map](https://uploads.cosx.org/2013/01/earthquake_map.png)

从这图上看，每周发生在我亲爱的祖国上的地震真心不少啊，我大台湾也饱受其苦啊。向天祈祷，让地震少震我中国吧……

参考文献：

  * 邱怡轩：[用R软件绘制中国分省市地图](/2009/07/drawing-china-map-using-r/)
  * 谢益辉：[用R画中国地图并标注城市位置](http://yihui.name/cn/2008/10/china-map-and-city-locations-with-r/)
  * 谢益辉：[终于搞定了中国分省市地图](http://yihui.name/cn/2007/09/china-map-at-province-level/)
  * 肖凯：[用ggmap包进行地震数据的可视化](http://xccds1977.blogspot.com/2012/06/ggmap.html)
  * 肖凯：[用ggplot2包来绘制地图](http://xccds1977.blogspot.com/2012/05/ggplot2.html)
  * 肖凯：[基于OpenStreetMap的地理信息绘图](http://xccds1977.blogspot.com/2012/04/openstreetmap.html)
  * 肖凯：[利用googleVis包实现环境数据可视化](http://xccds1977.blogspot.com/2011/09/test_901.html)
  * 肖凯：[中国国内航线信息的可视化](http://xccds1977.blogspot.com/2012/07/blog-post_26.html)
  * Earth At Night: [Mapping the World’s Biggest Airlines](http://spatialanalysis.co.uk/2012/06/mapping-worlds-biggest-airlines/)
  * ggmap: [ggmap包文档](http://cran.r-project.org/web/packages/ggmap/index.html)
