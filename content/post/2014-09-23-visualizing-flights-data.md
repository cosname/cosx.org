---
title: R绘制中国航线分布夜景图
date: '2014-09-23T11:05:19+00:00'
author: 李根
categories:
  - 统计图形
  - 统计软件
  - 软件应用
tags:
  - 可视化
  - 地图
  - 夜景图
  - 空间数据
  - 航线
slug: visualizing-flights-data
forum_id: 419032
---

本文作者：李根，资深数据分析师，数学爱好者。

绘制数据地图是一种有效展现空间数据的方法，美丽的数据展示更容易引起读者的共鸣。本地图设计的初衷是展示中国航线的分布规律，进而可以分析成本、客流量等问题。

![flight-night-scene](https://uploads.cosx.org/2014/09/flight-night-scene.png) 本文参考了以下文献进行绘制：
  
<http://spatialanalysis.co.uk/2012/06/mapping-worlds-biggest-airlines/>

# 一、地图数据来源

地图所使用的数据均可以从网上下免费下载。
  
航线、机场坐标：<http://openflights.org/data.html>

  * 机场：airports.dat
  * 航线：routes.dat

板块地图、都市地图：<http://www.naturalearthdata.com/downloads/>

  * 世界地图：ne\_10m\_admin\_0\_countries.shp
  * 都市地图：ne\_10m\_urban_areas.shp

（注：都市地图是用来绘制灯光效果的。）

# 二、地图绘制所需的包

以下软件包均是绘制地图相关的，其中有一些可能没有被直接使用。

```r
library(maptools)
library(ggplot2)
library(ggmap)
library(maps)
library(rgeos)
library(shapefiles)
library(geosphere)
library(plyr)
library(sp)
```

在Linux下，R语言中与地理相关的包可能需要安装如下工具：

  * geos-devel-3.2.2
  * geos-3.2.2

这两个软件互相依赖，需要同时安装、更新。例如对于Linux CentOS 5.5，可以运行如下命令:

```bash
yum install geos-devel-3.2.2*.rpm geos-3.2.2*.rpm
```

# 三、数据处理

这一部分的主要工作是将shapefile文件转化为R可以识别的格式，然后建立数据与地图坐标间的关联。本文使用了航线频数来计算地图航线绘制的亮度。读者根据需要可以自行关联所需数据，例如成本，平均成本，旅客人次等，以达到不同的研究目的。

函数介绍：

  * `readShapePoly()`：读取图形文件用，建议直接将解压后的图形文件放在工程环境中。
  * `fortify()`：将地图数据转化为ggplot可以使用的格式。
  * `gcIntermediate()`：模拟圆弧，将两点间连线圆弧化。

代码如下：

```r
# 读取都市地图文件 读取版图地图文件
urbanareasin <- readShapePoly("ne_10m_urban_areas.shp")
worldmapsin <- readShapePoly("ne_10m_admin_0_countries.shp")
# 以下为格式转化
worldmap <- fortify(worldmapsin)
urbanareas <- fortify(urbanareasin)
gpclibPermit()
# 开始抽取机场数据
airports <- read.table("airports.dat", sep = ",", header = FALSE)
worldport <- airports[airports$V5 != "", c("V3", "V5", 
    "V7", "V8", "V9")]
names(worldport) <- c("city", "code", "lan", "lon", "att")
worldport$lan <- as.numeric(as.character(worldport$lan))
worldport$lon <- as.numeric(as.character(worldport$lon))
# 找出所有航线有标识的机场（这里的data3.redu2s是我个人的航线数据
# 读者可以用上文提到的航线数据routes.dat代替）
lineinworld <- (data3.redu2s$AIRPORT_FROM_CODE %in% 
    worldport$code) & (data3.redu2s$AIRPORT_TO_CODE %in% 
    worldport$code)
# 有243条航线无标识
table(lineinworld)
# colnames(data3.upro1)
worldline <- data3.redu2s[lineinworld, c("AIRPORT_FROM_CODE", 
    "AIRPORT_TO_CODE")]
flights.ag <- ddply(worldline, c("AIRPORT_FROM_CODE", 
    "AIRPORT_TO_CODE"), function(x) count(x$AIRPORT_TO_CODE))
# 计算三字码映射到机场
flights.ll <- merge(flights.ag, worldport, by.x = "AIRPORT_TO_CODE", 
    by.y = "code", all.x = T)
flights.ll <- flights.ll[order(flights.ll$AIRPORT_FROM_CODE, 
    flights.ll$AIRPORT_TO_CODE), ]
flights.lf <- merge(flights.ag, worldport, by.x = "AIRPORT_FROM_CODE", 
    by.y = "code", all.x = T)
flights.lf <- flights.lf[order(flights.lf$AIRPORT_FROM_CODE, 
    flights.lf$AIRPORT_TO_CODE), ]
# beijing.ll <-
# c(worldport$lon[worldport$code=='PEK'], worldport$lan[worldport$code=='PEK'])
rts <- gcIntermediate(flights.lf[, c("lon", "lan")], 
    flights.ll[, c("lon", "lan")], 100, breakAtDateLine = FALSE, 
    addStartEnd = TRUE, sp = TRUE)
# rts.ff <-
# fortify.SpatialLinesDataFrame(rts)flights.lf[,c('lon', 'lan')]
rts <- as(rts, "SpatialLinesDataFrame")
# 航线坐标数据
rts.ff <- fortify(rts)
# 航线信息与航线坐标信息关联
flights.ll$id <- as.character(c(1:nrow(flights.ll)))
table(gcircles$freq)
gcircles <- merge(rts.ff, flights.ll, all.x = T, by = "id")
```

如代码中的注释所述，data3.redu2s这个变量可以从routes.dat读取得到，过程如下：

```r
data3.redu2s <- read.table("routes.dat", sep = ",", header = FALSE)
colnames(data3.redu2s)[c(3, 5)] <- c("AIRPORT_FROM_CODE",
                                     "AIRPORT_TO_CODE")
```

# 四、地图旋转

这一步是对地图进行坐标变换，设置中国为世界中心，这里做了简单的坐标加减运算。代码如下：

```r
center <- 115
# 航线坐标计算中心距离
gcircles$long.recenter <- ifelse(gcircles$long < center - 
    180, gcircles$long + 360, gcircles$long)
# shift coordinates to recenter worldmap worldmap
# <- map_data ('world') 地图坐标偏移
worldmap$long.recenter <- ifelse(worldmap$long < center - 
    180, worldmap$long + 360, worldmap$long)
urbanareas$long.recenter <- ifelse(urbanareas$long < 
    center - 180, urbanareas$long + 360, urbanareas$long
 ```

由于地图是图形数据，若是简单移动，地图会被切割，绘制时会出现图形变形等错误，故需要对地图数据进行再处理。该过程分为两步：

  * 处理1：图形切割后，切割图形重分组。
  * 处理2：重分组后，非闭合图形，闭合处理。

## 1. 切割图形重分组

在参考文献中提到的方法如下：

```r
RegroupElements <- function(df, longcol, idcol) {
    g <- rep(1, length(df[, longcol]))
    if (diff(range(df[, longcol])) > 300) {
        # check if longitude within group differs more than
        # 300 deg, ie if element was split
        # we use the mean to help us separate the extreme values
        d <- df[, longcol] > mean(range(df[, longcol]))
        # some marker for parts that stay in place
        # (we cheat here a little, as we do not take into account concave polygons)
        g[!d] <- 1
        g[d] <- 2  # parts that are moved
    }
    # attach to id to create unique group variable for the dataset
    g <- paste(df[, idcol], g, sep = ".")
    df$group.regroup <- g
    df
}
gcircles.rg <- ddply(gcircles, .(id), RegroupElements, "long.recenter", "id")
```

以上方法，计算少量图形数据时（如gcircles）效果尚可。但一旦数据量级提高，其计算效率将极低。笔者电脑（10G内存）运行 urbanareas 数据，内存占用一度爆表，而且40多分钟未出结果。所以笔者重写了该算法，重写后占用内存可忽略，10秒内计算完成。

改进算法如下：

```r
# 开始写原始算法替换函数 世界地图重分组
worldmap.mean <- aggregate(x = worldmap[, c("long.recenter")], 
    by = list(worldmap$group), FUN = mean)
worldmap.min <- aggregate(x = worldmap[, c("long.recenter")], 
    by = list(worldmap$group), FUN = min)
worldmap.max <- aggregate(x = worldmap[, c("long.recenter")], 
    by = list(worldmap$group), FUN = max)
worldmap.md <- cbind(worldmap.mean, worldmap.min[, 
    2], worldmap.max[, 2])
colnames(worldmap.md) <- c("group", "mean", "min", "max")
worldmapt <- join(x = worldmap, y = worldmap.md, by = c("group"))
worldmapt$group.regroup <- 1
worldmapt[(worldmapt$max > 180) & (worldmapt$min < 
    180) & (worldmapt$long.recenter > 180), c("group.regroup")] <- 2
worldmapt$group.regroup <- paste(worldmapt$group, worldmapt$group.regroup, 
    sep = ".")
worldmap.rg <- worldmapt

# 都市地图重分组
urbanareas.mean <- aggregate(x = urbanareas[, c("long.recenter")], 
    by = list(urbanareas$group), FUN = mean)
urbanareas.min <- aggregate(x = urbanareas[, c("long.recenter")], 
    by = list(urbanareas$group), FUN = min)
urbanareas.max <- aggregate(x = urbanareas[, c("long.recenter")], 
    by = list(urbanareas$group), FUN = max)
urbanareas.md <- cbind(urbanareas.mean, urbanareas.min[, 
    2], urbanareas.max[, 2])
colnames(urbanareas.md) <- c("group", "mean", "min", "max")
urbanareast <- join(x = urbanareas, y = urbanareas.md, 
    by = c("group"))
urbanareast$group.regroup <- 1
urbanareast[(urbanareast$max > 180) & (urbanareast$min < 
    180) & (urbanareast$long.recenter > 180), c("group.regroup")] <- 2
urbanareast$group.regroup <- paste(urbanareast$group, 
    urbanareast$group.regroup, sep = ".")
urbanareas.rg <- urbanareast
```

## 2. 闭合曲线

闭合曲线原文也存在算法效率低缺陷，直接上重写的算法：

```r
# 闭合曲线
worldmap.rg <- worldmap.rg[order(worldmap.rg$group.regroup, 
    worldmap.rg$order), ]
worldmap.begin <- worldmap.rg[!duplicated(worldmap.rg$group.regroup), 
    ]
worldmap.end <- worldmap.rg[c(!duplicated(worldmap.rg$group.regroup)[-1], 
    TRUE), ]
worldmap.flag <- (worldmap.begin$long.recenter == worldmap.end$long.recenter) & 
    (worldmap.begin$lat == worldmap.end$lat)
table(worldmap.flag)
worldmap.plus <- worldmap.begin[!worldmap.flag, ]
worldmap.end[!worldmap.flag, ]
worldmap.plus$order <- worldmap.end$order[!worldmap.flag] + 1
worldmap.cp <- rbind(worldmap.rg, worldmap.plus)
worldmap.cp <- worldmap.cp[order(worldmap.cp$group.regroup, 
    worldmap.cp$order), ]
urbanareas.rg <- urbanareas.rg[order(urbanareas.rg$group.regroup, 
    urbanareas.rg$order), ]
urbanareas.begin <- urbanareas.rg[!duplicated(urbanareas.rg$group.regroup), ]
urbanareas.end <- urbanareas.rg[c(!duplicated(urbanareas.rg$group.regroup)[-1], 
    TRUE), ]
urbanareas.flag <- (urbanareas.begin$long.recenter == 
    urbanareas.end$long.recenter) & (urbanareas.begin$lat == 
    urbanareas.end$lat)
table(urbanareas.flag)
urbanareas.plus <- urbanareas.begin[!urbanareas.flag, ]
urbanareas.end[!urbanareas.flag, ]
urbanareas.plus$order <- urbanareas.end$order[!urbanareas.flag] + 1
urbanareas.cp <- rbind(urbanareas.rg, urbanareas.plus)
urbanareas.cp <- urbanareas.cp[order(urbanareas.cp$group.regroup, 
    urbanareas.cp$order), ]
```

# 五、绘制图像

数据齐全了，该绘制图像了。本文绘制图像使用了ggplot函数，由于ggplot2的参考书籍较多，因此相关函数就不一一介绍。地图的设计是可通过调节放大系数以输出不同品质的图像，主要分两步：

## 1. 绘制背景

背景是点线地图，而且精度较高，夜景图边界线意义不大，因此处理起来较简单。代码如下：

```r
wrld <- geom_polygon(aes(long.recenter, lat, group = group.regroup), 
    size = 0.1, colour = "#090D2A", fill = "#090D2A", 
    alpha = 1, data = worldmap.cp)
urb <- geom_polygon(aes(long.recenter, lat, group = group.regroup), 
    size = 0.3, color = "#FDF5E6", fill = "#FDF5E6", 
    alpha = 1, data = urbanareas.cp)
```

## 2. 绘制航线

航线是由线组成的，放大时线的宽度、光晕宽度变化比例与图形变化比例不一致，需要分开调节。根据图形知识，该变化应是函数关系。这里给出一种较美观的函数关系，有兴趣的同学可以继续优化该函数。另外本文与原地图的一个不同之处是增加了光晕效果，图片十分绚丽。其原理是使用高透明度的辅助线。线的光晕亮度和航线频率相关，相关的代码如下：

```r
# 放大系数
bigmap <- 1
airline <- geom_line(aes(long.recenter, lat, group = group.regroup, 
    alpha = max(freq)^0.6 * freq^0.4, color = 0.9 * 
        max(freq)^0.6 * freq^0.4), size = 0.2 * bigmap, 
    data = gcircles.rg)
airlinep <- geom_line(aes(long.recenter, lat, group = group.regroup, 
    alpha = 0.04 * max(freq)^0.6 * freq^0.4), color = "#FFFFFF", 
    size = 2 * bigmap, data = gcircles.rg)
# table(gcircles.rg$freq)
airlinepp <- geom_line(aes(long.recenter, lat, group = group.regroup, 
    alpha = 0.02 * max(freq)^0.6 * freq^0.4), color = "#ECFFFF", 
    size = 4 * bigmap, data = gcircles.rg)
airlineppp <- geom_line(aes(long.recenter, lat, group = group.regroup, 
    alpha = 0.01 * max(freq)^0.6 * freq^0.4), color = "#ECFFFF", 
    size = 8 * bigmap, data = gcircles.rg)
airlinepppp <- geom_line(aes(long.recenter, lat,
    group = group.regroup, 
    alpha = 0.005 * max(freq)^0.6 * freq^0.4), color = "#BBFFFF", 
    size = 16 * bigmap, data = gcircles.rg)
gcircles.rg[gcircles.rg$group.regroup == 1.1, ]

# plot画图到文件plot2.png
png(6000 * (bigmap^0.8), 2000 * (bigmap^0.8), file = "plot2.png", 
    bg = "white")
ggplot() + wrld + urb + airline +
    scale_colour_gradient(low = "#D9FFFF", high = "#ECFFFF") +
    scale_alpha(range = c(0, 1)) + 
    airlineppp +
    # scale_alpha_discrete(range = c(0.001, 0.005)) +
    airlinepp +
    # scale_alpha(range = c(0.005, 0.015))+
    airlinep +
    # scale_alpha(range = c(0.015, 0.08)) +
# geom_polygon(aes(long,lat,group = group), size = 0.2,
#     fill = '#f9f9f9', colour = 'grey65', data = worldmap) +
# geom_line(aes(long.recenter,lat,group = group.regroup, color = freq,
#     alpha = freq), size = 0.4, data = gcircles.rg) +
    theme(
        panel.background = element_rect(fill = "#00001C",
            color = "#00001C"),
        panel.grid = element_blank(), 
        axis.ticks = element_blank(), 
        axis.title = element_blank(),
        axis.text = element_blank(),
        legend.position = "none")
    ) + ylim(-65, 75) + coord_equal()
dev.off()
```

完整尺寸的超清航线夜景图可以在[这里下载](https://uploads.cosx.org/2014/09/flight-night-scene-HD.png)得到（7.9M）。
