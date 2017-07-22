---
title: R绘制中国地图，并展示流行病学数据
date: '2014-08-14T23:24:13+00:00'
author: 姜晓东
categories:
  - 生物与医学统计
  - 统计图形
  - 统计软件
  - 软件应用
tags:
  - ggplot2
  - GIS数据
  - 地图
  - 流行病学
slug: r-maps-for-china
forum_id: 419030
---

> 本文作者：姜晓东，博士毕业于上海交通大学，目前任教于湖南师范大学医学院，专业神经毒理学。

  流行病学的数据讲究“三间分布”，即人群分布、时间分布和空间分布。其中的“空间分布”最好是在地图上展示，才比较清楚。R软件集统计分析与高级绘图于大成，是最适合做这项工作了。关于地图的绘制过程，谢益辉、邱怡轩和陈丽云等人都早有文章讲述，开R地图中文教程之先河。由于目前指导毕业论文用到，因此研究了一下。本来因为网上教程很多，曾打消了写些文字的计划，但怡轩版主鼓励说“教程者众，整合者鲜”，所以才战胜拖延症，提起拙笔综述整合一下，并对DIY统计GIS地图提出了一点自己的想法。
<!--more-->

# 1、地图GIS数据的来源与R绘制软件包

中国地图GIS数据的官方数据可以在国家基础地理信息中心的网站（[http://nfgis.nsdi.gov.cn](http://nfgis.nsdi.gov.cn)） 里面可以免费下载。官方公开的数据包括：地图数据，及居住地、交通、河流等辅助数据。今年6月开始，官方正组织开始制作新版数据。老数据暂时无法下载，读者要自行百度搜索，本文以旧版数据为例。旧版地图数据中部分地名和地市区划已经过时，使用时需注意。

地图数据有4个压缩文件：bou1\_4m.zip、bou2\_4m.zip、bou3\_4m.zip和bou4\_4m.zip。bou代表边界的意思，数字1~4代表国家、省、市、县的4级行政划分；4m代表比例是400万分之一，这个比例的图形是公开的。每个文件解压缩后含有两类文件：以字母p结尾的表示多边形数据，用来绘制区域；以字母l结尾的文件是线形数据，用来绘制边界。但是老版数据中，市级数据中缺少绘制区域的多边形数据，让市级分布图的绘制稍麻烦一些，新版中也许会有改进。

用R绘制地图比较简单。比如画一下全国范围的区域，可以用如下代码：

```r
library(maptools)
mydat = readShapePoly("maps/bou1/bou1_4p.shp")
plot(mydat)
```

[![unnamed-chunk-1](https://uploads.cosx.org/2014/08/unnamed-chunk-1-e1408027878462.png)](https://uploads.cosx.org/2014/08/unnamed-chunk-1.png)
  
但是，可以看出这样绘制的地图的形状有些扁平。这是因为，在绘图的过程中，默认把经度和纬度作为普通数据，均匀平等对待，绘制在笛卡尔坐标系上造成的。其实，地球的球面图形如何映射到平面图上，在地理学上是有一系列不同的专业算法的。地图不应该画在普通的笛卡尔坐标系上，而是要画在地理学专业的坐标系上。在这一点上，R的ggplot2包提供了专门的`coord_map()`函数。所以推荐R的ggplot2包来绘制地图。

```r
library(ggplot2)
mymap = ggplot(data = fortify(mydat)) +
    geom_polygon(aes(x = long, y = lat, group = id), colour = "black",
                 fill = NA) +
    theme_grey()
print(mymap + coord_map())
```

![unnamed-chunk-2](https://uploads.cosx.org/2014/08/unnamed-chunk-2.png)
  
这次中国地图的形状与百度地图一样了。

ggplot2包的`coord_map`函数默认的映射类型是mercator。如果有其他需要，可以使用其他的映射类型来绘制地图，如：

```r
mymap + coord_map(projection = "azequidistant")
```

[![unnamed-chunk-3](https://uploads.cosx.org/2014/08/unnamed-chunk-3-e1408027824797.png)](https://uploads.cosx.org/2014/08/unnamed-chunk-3.png)`coord_map`函数的映射类型及其含义可以通过下列代码查询帮助，一般我们用默认的就可以。

```r
library(mapproj)
?mapproject
```

# 2、GIS地图的数据结构及省市地图的绘制

GIS地图有很多种存储格式，其中shapefile格式（.shp）可以通过R的maptools包打开。其他格式可以去R官网查询相应的软件包。

地图数据基本可以分为点、线、面三种数据，在maptools包内分别有对应的函数来读取（`readShapePoints`、`readShapeLines`和`readShapePoly`函数）。首先以面（poly）型数据介绍。先看代码，通过`readShapePoly`函数读入省级地图：

```r
library(maptools)
mydat = readShapePoly("maps/bou2/bou2_4p.shp")
```

此时，`mydat`中保存的是各个省/直辖市的多边形面图，数据类型是`SpatialPolygonsDataFrame`。我们可以：

```r
length(mydat)

## [1] 925

names(mydat)

## [1] "AREA" "PERIMETER" "BOU2_4M_" "BOU2_4M_ID" "ADCODE93"
## [6] "ADCODE99" "NAME"
```

可以发现`mydat`中有925条记录，每条记录中含有面积（AREA）、周长（PERIMETER）、各种编号、中文名（NAME）等字段。其中中文名（NAME）字段是以GBK编码的。

这个`SpatialPolygonsDataFrame`类型并不是真正的`data.frame`类型，而是一个sp包定义的类，只不过重载了 `[]` 和 `$` 运算符，使得一些行为上与`data.frame`相类似。

可以进一步统计一下，每个省/直辖市的多边形数目。

```r
table(iconv(mydat$NAME, from = "GBK"))

## 
##           上海市           云南省     内蒙古自治区           北京市 
##               12                1                1                1 
##           台湾省           吉林省           四川省           天津市 
##               57                1                1                1 
##   宁夏回族自治区           安徽省           山东省           山西省 
##                1                1               86                1 
##           广东省   广西壮族自治区 新疆维吾尔自治区           江苏省 
##              154                6                1                5 
##           江西省           河北省           河南省           浙江省 
##                1                9                1              179 
##           海南省           湖北省           湖南省           甘肃省 
##               79                1                1                1 
##           福建省       西藏自治区           贵州省           辽宁省 
##              168                1                2               94 
##           重庆市           陕西省           青海省   香港特别行政区 
##                1                1                1               53 
##         黑龙江省 
##                1
```

我的环境是UTF-8，所以需要`iconv`函数转化一下才能正常显示。

结果显示多数省的地图都是由一个多边形构成，少数临海省/直辖市由于有很多附属岛屿，多边形数目比较多。

利用与`data.frame`相似的 `[]` 和 `$` 运算符操作，我们可以迅速提取出一个省市的数据，比如上海及附属崇明岛：

```r
Shanghai = mydat[mydat$ADCODE99 == 310000,]
plot(Shanghai)
```

[![unnamed-chunk-8](https://uploads.cosx.org/2014/08/unnamed-chunk-8-e1408027792888.png)](https://uploads.cosx.org/2014/08/unnamed-chunk-8.png)

其中ADCODE99是国家基础地理信息中心定义的区域代码，共有6位数字，由省、地市、县各两位代码组成。

为了进一步在ggplot2包中绘图，需要把`SpatialPolygonsDataFrame`数据类型转化为真正的`data.frame`类型才可以。ggplot2包专门针对地理数据提供了特化版本的`fortify`函数来做这个工作：

```r
head(fortify(Shanghai))

##    long   lat order  hole piece group  id
## 1 121.3 31.85     1 FALSE     1 208.1 208
## 2 121.3 31.85     2 FALSE     1 208.1 208
## 3 121.3 31.85     3 FALSE     1 208.1 208
## 4 121.3 31.85     4 FALSE     1 208.1 208
## 5 121.3 31.84     5 FALSE     1 208.1 208
## 6 121.4 31.83     6 FALSE     1 208.1 208
```

# 3、在地图上展示流行病学数据

## 3.1 一地名对应一区域，长沙为例

首先把长沙所辖地区找到，这个可以根据ADCODE99编码的前4位定位长沙，去查表就可以了。但是这个地名是99年的标准，新版正在制定过程中，随时会变。我们权且以此为例。如果找不到表，可以通过代码在命令行下手工查找：

```r
mydat = readShapePoly("maps/bou4/BOUNT_poly.shp")
tmp = iconv(mydat$NAME99, from = "GBK")
grep("长沙", tmp, value = TRUE)

## [1] "长沙县"       "长沙市市辖区"

grep("长沙", tmp)

## [1] 2122 2183

mydat$ADCODE99[grep("长沙", tmp)]

## [1] 430121 430101
## 2368 Levels: 0 110100 110112 110113 110221 110224 110226 110227 ... 820000
```

这样我们就知道了长沙ADCODE99编码的前4位是4301，其中43代表湖南省，01就是长沙市。接着就可以筛选出长沙的地图数据：

```r
Changsha = mydat[substr(as.character(mydat$ADCODE99), 1, 4) == "4301",]
mysh = fortify(Changsha, region = 'NAME99')
mysh = transform(mysh, id = iconv(id, from = 'GBK'), group = iconv(group, from = 'GBK'))
head(mysh, n = 2)

##    long   lat order  hole piece          group           id
## 1 113.1 28.18     1 FALSE     1 长沙市市辖区.1 长沙市市辖区
## 2 113.1 28.18     2 FALSE     1 长沙市市辖区.1 长沙市市辖区

names(mysh)[1:2] = c("x","y")   #这句是不得已而为之的黑魔法
```

接着我们给一串随机数当成是流行病学数据，并用颜色填充到地图上。

```r
myepidat = data.frame(id = unique(sort(mysh$id)))
myepidat$rand = runif(length(myepidat$id))
myepidat

##             id    rand
## 1       宁乡县 0.98076
## 2       望城县 0.32123
## 3       浏阳市 0.66957
## 4       长沙县 0.09655
## 5 长沙市市辖区 0.19437

csmap = ggplot(myepidat) +
    geom_map(aes(map_id = id, fill = rand), color = "white", map = mysh) +
    scale_fill_gradient(high = "darkgreen",low = "lightgreen") +
    expand_limits(mysh) + coord_map()
print(csmap)
```

[![unnamed-chunk-12](https://uploads.cosx.org/2014/08/unnamed-chunk-12-e1408027716212.png)](https://uploads.cosx.org/2014/08/unnamed-chunk-12.png)接下来的工作就是添加地名，sp包提供了`coordinates`函数，来计算地图的中心坐标：

```r
tmp = coordinates(Changsha)
print(tmp)

##       [,1]  [,2]
## 2121 113.2 28.32
## 2134 113.7 28.23
## 2136 112.8 28.29
## 2149 112.3 28.13
## 2182 113.0 28.17

tmp = as.data.frame(tmp)
tmp$names = iconv(Changsha$NAME99, from = 'GBK')
print(tmp)

##         V1    V2        names
## 2121 113.2 28.32       长沙县
## 2134 113.7 28.23       浏阳市
## 2136 112.8 28.29       望城县
## 2149 112.3 28.13       宁乡县
## 2182 113.0 28.17 长沙市市辖区

csmap + geom_text(aes(x = V1,y = V2,label = names), family = "GB1", data = tmp)
```

[![unnamed-chunk-13](https://uploads.cosx.org/2014/08/unnamed-chunk-13-e1408027752719.png)](https://uploads.cosx.org/2014/08/unnamed-chunk-13.png)如果需要支持更多字体，可以配合使用showtext包。

## 3.2 内地省份的地市级图的情况

如果国家基础地理信息中心的GIS地图数据的地市文件`bou3_4m.zip`中含有polygon文件，那么我们就可以根据上一节的内容绘制省内地市级分布图了。官方恰恰缺少了这个文件，给绘图造成了麻烦。解决方案有两个：一个是另辟蹊径，从非官方的[www.gadm.org](http://www.gadm.org) 下载一份shp格式的中国地图来绘制；另一个解决方案是从官方发布的县级地图入手，根据ADCODE99编码适当合并，绘制省内地市分布图，同时利用bou3_4m.zip仅存的边界文件绘制边界。

相信官方新版本的GIS地图数据会包含旧版本所缺失的这份文件。目前还是建议暂时使用gadm的省级地图。旧版官方地图信息比较陈旧落后，比如湖南没有标注出湘西州的规划。

## 3.3 一地名对应多区域，上海为例

中国很多沿海省/直辖市有很多附属岛屿，导致地名和区域（Polygon）存在一对多的情况。这种情况下，在`fortify`处理数据的时候一定要特别注意索引与多边形一一对应，同时又要保持地名信息，黑魔法在代码中：

```r
# mydat = readShapePoly("maps/bou4/BOUNT_poly.shp")
Shanghai = mydat[substr(as.character(mydat$ADCODE99), 1, 2) == '31',]
mysh = fortify(Shanghai, region = 'NAME99')
mysh = transform(mysh, id = iconv(id, from = 'GBK'), group = iconv(group, from = 'GBK'))
head(mysh)

##    long   lat order  hole piece    group     id
## 1 121.2 31.85     1 FALSE     1 崇明县.1 崇明县
## 2 121.3 31.85     2 FALSE     1 崇明县.1 崇明县
## 3 121.3 31.85     3 FALSE     1 崇明县.1 崇明县
## 4 121.3 31.85     4 FALSE     1 崇明县.1 崇明县
## 5 121.3 31.85     5 FALSE     1 崇明县.1 崇明县
## 6 121.3 31.84     6 FALSE     1 崇明县.1 崇明县

# 黑魔法在此
names(mysh)[c(1, 2, 6, 7)] = c("x", "y", "id", "code")

myepidat = data.frame(id = unique(sort(mysh$id)))
# 随机数字替代数据
myepidat$rand = runif(length(myepidat$id))

# 官方地图区划比较落后过时，目前上海是16区1县，神码“市直辖5区”的称呼已经过时。
myepidat

##                id    rand
## 1  上海市市辖区.1 0.21673
## 2  上海市市辖区.2 0.74173
## 3  上海市市辖区.3 0.02462
## 4  上海市市辖区.4 0.20619
## 5  上海市市辖区.5 0.89970
## 6        南汇县.1 0.77084
## 7        嘉定区.1 0.21771
## 8        奉贤县.1 0.91729
## 9        崇明县.1 0.04879
## 10       崇明县.2 0.02462
## 11       崇明县.3 0.03397
## 12       崇明县.4 0.72591
## 13       崇明县.5 0.72059
## 14       崇明县.6 0.43981
## 15       松江区.1 0.18296
## 16       金山区.1 0.78371
## 17       金山区.2 0.88552
## 18       闵行区.1 0.54186
## 19       青浦县.1 0.12003

ggplot(myepidat) + geom_map(aes(map_id = id, fill = rand), map = mysh) +
    expand_limits(mysh) + coord_map()
```

![unnamed-chunk-14](https://uploads.cosx.org/2014/08/unnamed-chunk-14.png)

## 3.4 其他问题

如果需要县级以下的地图GIS数据，比如街道、乡村的地图，国家地理信息中心并不提供。要么去民政部索取，要么自己绘制。

另外，提醒大家，流行病学数据并不是仅仅画在地图上就完事了。针对空间数据，R里面有很多空间数据的分析软件包。推荐Roger S. Bivand的《Applied Spatial Data Analysis with R》，尤其是里面第11章“Disease Mapping”，对医学背景同学很有益处。如果能找到一个地理资源环境学院的研究生一同讨论的话就更好了。毕竟，它山之石可以攻玉，我们要承认自己的不足。

# 4、自己绘制简单的GIS地图

在制作流行病学统计地图的过程中，对于很多区、街道、乡村级别的地图，无法获得GIS数据。很多人的做法是到百度地图上用绘图软件摹描出区域线图，然后再把自己的数据计算成相应颜色，再手工填充颜色绘成统计地图。这个过程枯燥繁琐，而且数据映射成颜色的时候容易出错。不如把你已经描好的线图，制成shp格式的GIS数据地图，分享给大家用。辛苦你一个，幸福千万家。这个过程其实有专业的GIS软件可以做，若你能找到专业人士，就直接“幸福千万家”了。

如果地图结构简单，我们可以“土法”来做。先去NIH（美国国立卫生研究院）网站下载一个免费的图像软件ImageJ，用来采集地区边界数据。然后再把采集好的数据在R软件里面把像素坐标换算成地理坐标，在利用R软件sp包和maptools的函数整合成`SpatialPolygonsDataFrame`，最后保存为shp格式的地图文件。

我们以起点中文网小说《江山美人志》开篇所附地图为例，绘制虚拟世界里面“中南郡”的GIS地图。为了和实际问题类似，我在地图中画上了参考坐标线。

![mymap](https://uploads.cosx.org/2014/08/mymap.png)

利用ImageJ“点”工具，同时按住Shift键一次批量多点采样，再点击分析菜的测量，最后保存结果。

ImageJ采集的点坐标是位图像素相对坐标，为了能换算为地理经纬度坐标。我们先采集图上参考坐标线上的经纬交点坐标，在R中建立换算关系：

```r
mg_pos = data.frame(x = c(103,103,403,403), y = c(75,275,75,275))
real_pos = data.frame(x = c(105,105,115,115), y = c(27,20,27,20))

data_x = data.frame(img = img_pos$x, rel = real_pos$x)
data_y = data.frame(img = img_pos$y, rel = real_pos$y)

lm_x = lm(rel~img, data = data_x)
lm_y = lm(rel~img, data = data_y)

mytrans_x = function(myimg) {
     predict(lm_x, newdata = data.frame(img = myimg))
}
mytrans_y = function(myimg) {
     predict(lm_y, newdata = data.frame(img = myimg))
}
```

然后，再利用ImageJ软件对中南郡的每个区域轮廓线单独描边采样，这样做的缺点就是两个区域相邻边会有些不一致，出现小幅的咬合错位现象，但这个对美观影响不大。优点是大大节省时间。

把每个区域的边界保存在单独的文件中。然后在R中把这些数据转化为GIS数据，保存为shp格式的标准地图文件。关于代码中函数的意义及范例（比我的代码更清晰），请参考sp和maptools包的帮助文件。

```r
library(maptools)

myfiles = c("Jiana.xls", "Kutedan.xls", "Miyaluo.xls", "Woda.xls", "Yada.xls")
mypolys = lapply(myfiles,
                 function(x) {
                     tmp = read.table(paste0("data/", x));
                     tmp = rbind(tmp, tmp[1, ]);
                     tmp$X = mytrans_x(tmp$X);
                     tmp$Y = mytrans_y(tmp$Y);
                     tmp
                 })

mynames = sub(".xls$", "", myfiles)
names(mypolys) = mynames

myPolygons = lapply(mynames,
                    function(x) {
                        tmp = mypolys[[x]];
                        Polygons(list(Polygon(cbind(tmp$X, tmp$Y))), x)
                    })

mySpn = SpatialPolygons(myPolygons)
myCNnames = c("嘉纳", "库特丹", "米亚洛", "沃达", "雅达")
myshpdata = SpatialPolygonsDataFrame(mySpn,
                                     data = data.frame(
                                         Names = mynames,
                                         CNnames = myCNnames,
                                         row.names = row.names(mySpn)))

# 我们要注意到：SpatialPolygonsDataFrame类的data成员的字段是可以自定义的，
# 这个是暴露给names函数以及$、[]运算符的。
writePolyShape(x = myshpdata, fn = "data/myDIYmap_poly")
```

这样我们在就成功保存了shp格式的地图文件（一共生成三个文件，一个shp文件，两个辅助文件）。生成的地图文件可以留给别人用，也可以正常打开绘图了。

```r
mydat = readShapePoly("data/myDIYmap_poly.shp")
plot(mydat)
```

![unnamed-chunk-17](https://uploads.cosx.org/2014/08/unnamed-chunk-17.png)

可以发现，在区域相邻的边界，有咬合分离现象，这是由于我们采样的时候，每个区单独描边，产生了共享边的不一致。不过，我们绘制地图是为了展示流行病学数据，这个误差是可以接受的。

```r
library(ggplot2)
mysh = fortify(mydat, region = "CNnames")
names(mysh)[1:2] = c("x", "y")
myepidat = data.frame(id = unique(sort(mysh$id)))
myepidat$rand = runif(length(myepidat$id))
tmp = coordinates(mydat)
tmp = as.data.frame(tmp)
tmp$names = mydat$CNnames
ggplot(myepidat) + geom_map(aes(map_id = id, fill = rand), color = "white", map = mysh) +
    geom_text(aes(x = V1,y = V2,label = names), family = "GB1", data = tmp)+
    scale_fill_gradient(high = "red", low = "yellow") +
    expand_limits(mysh) + coord_map()
```

![unnamed-chunk-18](https://uploads.cosx.org/2014/08/unnamed-chunk-18.png)

如上，画成统计地图，还算美观。

如果非要消除这种边界交错的不完美，就需要预先制定规划，在位图上分段采集边界线，再拼接组合成区域轮廓。由于共享边只采集一次，你能得到边界完美的地图。问题是，随着地图区域增多，你将在轮廓的拼接组合上，面临几何级数增长的复杂度。不过，离开现实的功利和胁迫，去追求完美，不也是推动这个世界前进的原动力么？

# 5、小结

尽管我在写作中使用了这个星球上最强大的knitr软件包来保证本文的可重复性，但是随着官方新版数据在未来的发布，数据的字段名称甚至组织布局将会有些变化，也会使本文代码无法直接拷贝运行。还是希望读者能自己掌握R，以无招胜有招。

喜欢读统计之都主页文章的结尾部分，因为常在此部分读到作者“不着调”的话，发人深省。最爱杨灿兄改编的这段：

问：世间是否此山最高，或者另有高处比天高？

答：在世间自有山比此山更高，Open-mind要比天高。

### 参考文献

  1. 谢益辉，2007，<http://yihui.name/cn/2007/09/china-map-at-province-level/>
  2. 邱怡轩，2009，<https://cos.name/2009/07/drawing-china-map-using-r/?replytocom=749>
  3. 陈丽云，2011，<http://www.loyhome.com/用R画（中国）地图-2/>
  4. 写长城的诗，2012，<http://www.r-bloggers.com/lang/chinese/1010>
  5. 杨灿，2011，<https://cos.name/2011/12/stories-about-statistical-learning/>

附：本文所用地图数据[下载](https://uploads.cosx.org/2014/08/maps_data.7z)

