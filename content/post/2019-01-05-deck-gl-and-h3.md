---
title: "大规模地理数据可视化入门：Deck.gl 和 H3"
author: "朱俊辉"
date: '2019-01-05'
output:
  html_document:
    theme: united
    toc: yes
    toc_depth: 2
  pdf_document:
    toc: yes
    toc_depth: '2'
slug: deck-gl-and-h3
tags:
- 数据可视化
- GIS与R
- Deckgl
categories:
- R语言
- 统计图形
forum_id: 420447
---

![](https://image-static.segmentfault.com/102/916/1029164137-5bcd1bffc11d7)


## 背景介绍

如何大规模可视化地理数据一直都是一个业界的难点，随着[2015年起 Uber 在这一领域的发力](https://segmentfault.com/a/1190000005154321)，构建了基于 Deck.gl + H3 ([deckgl](https://github.com/crazycapivara/deckgl),[h3r](https://github.com/scottmmjackson/h3r/)) 的大规模数据可视化方案。一方面，极大地满足了日常前端开发者的需求。另一方面，也极大地方便了数据科学家的可视化工作。在大规模空间轨迹分析、交通流量与供需预测等领域这一方案正得到广泛应用，突破了传统方法中数据量（通常不会超过10W个原始点）的瓶颈问题，实现百万点绘制无压力，并且可以结合 GPU 实现加速渲染。

## 举例

具体而言，比如，在移动互联网中常见的一个场景，预测城市中每个区域的供给和需求。在这个过程中，通常需要将预测的结果进行可视化以追踪模型的表现和问题。

![Uber Movement 展示供需情况](https://fortunedotcom.files.wordpress.com/2017/01/manila-02.png)

在传统的数据量下（比如以行政区或街道为单位）通常是1000个多边形或者点的数量级进行城市数据的汇总或者采样，在这种数据量条件下直接查询和渲染数据并不会出现瓶颈问题。

但是，随着移动互联网的发展，涌现出了精度更高的需求（10米或100米），以求更精细地追踪用户在末端网络上的需求。通常这种场景都是至少百万个多边形或者点的数据量级，在这种条件下粗暴地直接查询和渲染是完全不可行的。

为了实现大规模地理数据可视化中，需要从 空间划分 和 渲染引擎 两方面入手。

## 空间划分

### 什么是空间划分

通过空间划分，建立数据库索引可以实现高效的实时查询服务，比如[周边车辆位置查询](https://segmentfault.com/a/1190000008657566#articleHeader1)，[周边餐厅位置查询](https://tech.meituan.com/2014/09/05/lucene-distance.html)等。

传统的空间划分方法主要分为两类：

1. 以 [R-tree](https://en.wikipedia.org/wiki/R-tree) 为代表的动态单元
2. 以 [Geohash](https://en.wikipedia.org/wiki/Geohash) 为代表的静态单元

> R-tree 简单来说是将空间划分为若干个不规则的边界框矩形的b+树索引，适用于面、线数据，查询时间复杂度为 O(n)。

![R-tree 示意图](https://image-static.segmentfault.com/324/068/3240684669-58c3eafc3283a)

> Geohash 简单来说是将二维的经纬度转换成字符串的四叉树线性索引，适用于点数据，查询时间复杂度为 O(log(N))

![Geohash 示意图](http://ww1.sinaimg.cn/mw690/7178f37ejw1emyk4wbz4bj206i06lt9b.jpg)

下面是动态单元与静态单元的对比：

对比维度|动态单元/R-tree|静态单元/Geohash
---|---|---
实现难度| 难|易
邻近搜索| 难|易
水平扩张| 难|易
索引精度| 高|低

动态单元通常应用于对精度要求苛刻的场景，比如共享单车的违停区域判罚。

在本例中，供需预测对于几何边缘并没有高精度要求，所以牺牲一部分尽可能小的索引精度来换取计算性能是被允许的，此时，静态单元是优于动态单元的选择。

### 静态单元对比

常见的静态单元除 geohash 以外还有 S2 。其中 S2 和 geohash非常类似，也是基于四叉树的一种方法，只是在填充空间时使用了希尔伯特曲线而不是geohash中的Z阶曲线使得索引更加稳定，二者的详细原理分析见[高效的多维空间点索引算法 — Geohash 和 Google S2](https://halfrost.com/go_spatial_search/)。

![静态地理单元特点对比](https://image-static.segmentfault.com/176/708/1767087967-5b0a76ab645b5)

但是，一方面，传统的地理单元比如 S2和geohash，在国际化业务中却存在一个致命缺陷：在不同纬度的地区会出现地理单元单位面积差异较大的情况，比如北京和新加坡的 geohash 对应面积有将近30%的差异。这导致业务指标和模型输入的特征存在一定的分布倾斜和偏差，使用等面积、等形状的六边形地理单元可以减少指标和特征normalization的成本。

另一方面，在常用的地理范围查询中，基于矩形的查询方法，存在8邻域到中心网格的距离不相等的问题，四边形存在两类长度不等的距离，而六边形的周围邻居到中心网格的距离却是有且仅有一个，从形状上来说更加接近于圆形。

所以，基于hexagon的地理单元已经成为各大厂家的首选，比如 Uber 和 Didi 的峰时定价服务。

![图示为 Uber 峰时定价服务示意图](https://image-static.segmentfault.com/366/883/3668837560-5bcb33f58adcb)

在这样的背景下 Uber 基于六边形网格的地理单元开源解决方案 [H3](https://eng.uber.com/h3/) 应运而生，它使得部署 Hexagon 方案的成本非常低，通过UDF、R pacakge等方式可以以非常低的成本大规模推广。


### 什么是 H3

![DDGS](https://image-static.segmentfault.com/339/656/339656838-5bcb37dc36395)

H3 的前身其实是 DDGS(Discrete global grid systems) 中的 ISEA3H，其原理是把无限的不规则但体积相等的六棱柱从二十面体中心延伸，这样任何半径的球体都会穿过棱镜形成相等的面积cell，基于该标准使得每一个地理单元的面积大小就可以保证几乎相同。

然而原生的 ISEA3H 方案在任意级别中都存在12个五边形，H3 的主要改进是通过坐标系的调整将其中的五边形都转移到水域上，这样就不影响大多数业务的开展。

下面是 ISEA3H 五边形问题的示例：

```{r}
# 加载相关包
library(dggridR)
library(dplyr)

# 构建公里网格
dggs <- dgconstruct(spacing = 1000, metric = FALSE, resround = "down")

# 加载测试数据集
data(dgquakes)

# 获取每个震源中心对应的网格
dgquakes$cell <- dgGEO_to_SEQNUM(dggs, dgquakes$lon, dgquakes$lat)$seqnum

# 将 SEQNUM 转为网格中心
cellcenters <- dgSEQNUM_to_GEO(dggs, dgquakes$cell)

# 获取每个单元的地震次数
quakecounts <- dgquakes %>% group_by(cell) %>% summarise(count = n())

# 获取地震网格单元边界
grid <- dgcellstogrid(dggs, quakecounts$cell, frame = TRUE, wrapcells = TRUE)

# 更新网格单元的地震次数
grid <- merge(grid, quakecounts, by.x = "cell", by.y = "cell")

# Normarlize 指标便于展示
grid$count <- log(grid$count)
cutoff <- quantile(grid$count, 0.9)
grid <- grid %>% mutate(count = ifelse(count > cutoff, cutoff, count))

# 获取每个国家的多边形
countries <- map_data("world")

# 绘制地图
p <- ggplot() +
  geom_polygon(data = countries, aes(x = long, y = lat, group = group), fill = NA, color = "black") +
  geom_polygon(data = grid, aes(x = long, y = lat, group = group, fill = count), alpha = 0.4) +
  geom_path(data = grid, aes(x = long, y = lat, group = group), alpha = 0.4, color = "white") +
  geom_point(aes(x = cellcenters$lon_deg, y = cellcenters$lat_deg)) +
  scale_fill_gradient(low = "blue", high = "red")
p
```

![ISEA3H 墨卡托投影](https://image-static.segmentfault.com/151/592/1515926897-5bcb3905c18a4)

转化坐标系后：


```{r}
# 重新在球坐标上绘制
p + coord_map("ortho", orientation = c(-38.49831, -179.9223, 0)) +
  theme(
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_blank()
  ) +
  labs(x = "", y = "", title = "Your data could look like this")
```

![ISEA3H 正射投影](https://image-static.segmentfault.com/393/288/3932888592-5bcb3959e2629)

可以看到此时在若干个六边形中存在五边形的情形。

在 H3 开源后，也可以使用 `h3r` 实现六边形的编码与解码：

```{r}
# 以亮马桥地铁站为例
devtools::install_github("scottmmjackson/h3r") #或者 devtools::install_github("harryprince/h3r", ref="bug-fix/Makefile")
library(h3r)

df <- h3r::getBoundingHexFromCoords(39.949958, 116.46343, 11) %>% # 单边长为24米
  purrr::transpose() %>%
  purrr::simplify_all() %>%
  data.frame()

df %>%
  bind_rows(
    df %>% head(1)
  ) %>%
  leaflet::leaflet() %>%
  leafletCN::amap() %>%
  leaflet::addPolylines(lng = ~lon, lat = ~lat)
```

![Geohash-7/8 与 H3-11 对比](https://image-static.segmentfault.com/600/246/60024670-5bce4f9c1f336)

H3 中还提供了类似 S2 的六边形压缩技术，使得数据的存储空间可以极大压缩，在处理大规模稀疏数据时将体现出优势：

![H3 数据压缩技术](http://eng.uber.com/wp-content/uploads/2018/06/image11-1.png)

## 渲染引擎

### 什么是 Leaflet

在使用 Deck.gl 之前，业界主流的解决方案通常是另一个开源的轻量级地理数据可视化框架 Leaflet。Leaflet 经过十余年的积累已经拥有足够成熟的生态，支持各式各样的插件扩展。

序号|leaflet 插件|功能
---|---|---
1|[leaflet](https://github.com/rstudio/leaflet)|基础功能，几何元素CRUD，图层等，可结合 shiny，crosstalk
2|[leaflet.opacity](https://github.com/be-marc/leaflet.opacity)|透明度调节
3|[leaflet.extras](https://github.com/bhaskarvk/leaflet.extras)|高级功能, 包括热力图, 搜索, 米尺等
4|[leaflet.esri](https://github.com/bhaskarvk/leaflet.esri)|高级功能，ESRI插件 可结合 Arcgis
5|[mapview](https://github.com/r-spatial/mapview)|高级功能, 多图联动等
6|[mapedit](https://github.com/r-spatial/mapedit)|高级功能，地图编辑
7|[leafletCN](https://github.com/Lchiffon/leafletCN)|提供高德底图

虽然 Leaflet 功能强大，不过工业界的发展也暴露出一些新的问题。如何更好地支持诸如 轨迹、风向、三维空间、六边形网格的交互式可视化此前没有好的解决方案。好在近年来 Mapbox 和 Deck.gl 正在着手改变这一现状。

### 什么是 Deck.gl

[Deck.gl](http://deck.gl) 基于 WebGL 的大规模数据可视化框架，通过响应式编程和GPU并行加速的方式进行高效地 WebGL 渲染，与 Mapbox GL 深度结合能够呈现非凡的 3D 视觉效果。

下面是一个具体的例子，如何以Hexagon可视化百万个样本点：

```{r}
# 初始化
library(mapdeck)

# 生成 百万数据样本点
df = data.frame(lat = rnorm(1000000,40,1),lng =rnorm(1000000,160,1)) # 以二维正态生成随机数据

# 渲染
mapdeck::mapdeck(style = "mapbox://styles/mapbox/dark-v9",token = "pk.eyJ1IjoidWJlcmRhdGEiLCJhIjoiY2poczJzeGt2MGl1bTNkcm1lcXVqMXRpMyJ9.9o2DrYg8C8UWmprj-tcVpQ") %>%
  mapdeck::add_hexagon(lon = "lng",lat="lat",data = df,elevation_scale = 1000)

```

![Hexagon](https://s2.ax1x.com/2019/01/27/kKAPa9.md.png)


除了六边形之外 Deck.gl 也支持其他常见几何图形，比如 Grid、Arc、Contour、Polygon 等等。
更多信息可以见官方文档： https://crazycapivara.github.io/deckgl/

![](https://image-static.segmentfault.com/674/669/674669480-5bcb26c65920f)

### 地理仪表盘：结合 Shiny

Deck.gl 结合 Shiny 后，可将可视化结果输出到仪表盘上,举个例子：

```{r}
library(mapdeck)
library(shiny)
library(shinydashboard)
library(jsonlite)
ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(), dashboardBody(
    mapdeckOutput(
      outputId = "myMap"
    ),
    sliderInput(
      inputId =
        "longitudes", label =
        "Longitudes", min =
        -180, max =
        180, value = c(-90, 90)
    ), verbatimTextOutput(
      outputId = "observed_click"
    )
  )
)
server <- function(input, output) {
  set_token("pk.eyJ1IjoidWJlcmRhdGEiLCJhIjoiY2poczJzeGt2MGl1bTNkcm1lcXVqMXRpMyJ9.9o2DrYg8C8UWmprj-tcVpQ") ## 如果token 过期了，需要去Mapbox官网免费申请一个

  origin <- capitals[capitals$country == "Australia", ]
  destination <- capitals[capitals$country != "Australia", ]
  origin$key <- 1L
  destination$key <- 1L

  df <- merge(origin, destination, by = "key", all = T)

  output$myMap <- renderMapdeck({
    mapdeck(style = mapdeck_style("dark"))
  })

  ## plot points & lines according to the selected longitudes
  df_reactive <- reactive({
    if (is.null(input$longitudes)) return(NULL)
    lons <- input$longitudes
    return(
      df[df$lon.y >= lons[1] & df$lon.y <= lons[2], ]
    )
  })

  observeEvent({
    input$longitudes
  }, {
    if (is.null(input$longitudes)) return()

    mapdeck_update(map_id = "myMap") %>%
      add_scatterplot(
        data =
          df_reactive(), lon =
          "lon.y", lat =
          "lat.y", fill_colour =
          "country.y", radius =
          100000, layer_id = "myScatterLayer"
      ) %>%
      add_arc(
        data =
          df_reactive(), origin =
          c("lon.x", "lat.x"), destination =
          c("lon.y", "lat.y"), layer_id =
          "myArcLayer", stroke_width = 4
      )
  })

  ## observe clicking on a line and return the text
  observeEvent(input$myMap_arc_click, {
    event <- input$myMap_arc_click
    output$observed_click <- renderText({
      jsonlite::prettify(event)
    })
  })
}
shinyApp(ui, server)
```

![Deck.gl 结合 Shiny](https://image-static.segmentfault.com/379/159/3791590526-5bcb26a90ee91)

## 总结

目前，在空间划分上，H3 正在超越 S2/Geohash 成为新标准，相关生态也趋于成熟。在渲染引擎上，Deck.gl 在特定领域已经全面领先Leaflet, 相关产品不断涌现，比如对标 [carto](https://carto.com) 的地理数据分析工具 [kepler](http://kepler.gl) 和毫秒级OLAP交互式分析工具 [OmniSci](https://www.omnisci.com/)。

![OmniSci NYC Taxi Rides Demo](https://www.omnisci.com/globalassets/mapd-content/assets/animated/demos/nyctaxi_5.gif)

## 参考资料

* [RStudio Spark/Leaflet 与 GIS 最佳实践](https://segmentfault.com/a/1190000015048613)
* [Uber H3 原理分析](https://qiita.com/gshirato/items/d8cc928c4131f3292b14)
* http://strimas.com/spatial/hexagonal-grids/
* https://cran.r-project.org/web/packages/dggridR/vignettes/dggridR.html
* https://en.wikipedia.org/wiki/Discrete_Global_Grid
* http://www.pyxisinnovation.com/pyxwiki/index.php?title=How_PYXIS_Works
* [Large Scale Data Visualisation with Deck.gl and Shiny](https://www.youtube.com/watch?v=s0k_Hwn5Slg)
* https://uber.github.io/h3/
* https://eng.uber.com/shan-he/
* https://eng.uber.com/keplergl/
* [译 解密 Uber 数据团队的车辆定位查询算法](https://segmentfault.com/a/1190000008657566)
* [译 解密 Uber 数据部门的数据可视化最佳实践](https://segmentfault.com/a/1190000005154321)
* [gpu-accelerated-aggregation-in-deck-gl](https://medium.com/vis-gl/gpu-accelerated-aggregation-in-deck-gl-7e2c7d701fb0)
