---
title: "大规模地理数据可视化入门：Deck.gl 和 H3"
author: "朱俊辉"
date: '2019-01-05'
slug: deck-gl-and-h3
tags:
- 数据可视化
- GIS与R
- Deckgl
categories:
- R 语言
- 统计图形
---

![](https://image-static.segmentfault.com/102/916/1029164137-5bcd1bffc11d7)


## 背景介绍

如何大规模可视化地理数据一直都是一个业界的难点，随着[2015年起 Uber 在这一领域的发力](https://segmentfault.com/a/1190000005154321)，构建了基于 Deck.gl + H3 ([deckgl](https://github.com/crazycapivara/deckgl),[h3r](https://github.com/scottmmjackson/h3r/)) 的大规模数据可视化方案。一方面，极大地满足了日常前端开发者的需求。另一方面，也极大地方便了数据科学家的可视化工作。在大规模空间轨迹分析、交通流量与供需预测等领域这一方案正得到广泛应用，突破了传统方法中数据量（通常不会超过10W个原始点）的瓶颈问题，实现百万点绘制无压力，并且可以结合 GPU 实现加速渲染。

在大规模地理数据可视化中，有两个核心要素：

1. 空间划分
2. 渲染引擎

本文将着重从这两个角度入手，讲解大规模地理数据可视化入门的方法。

## 空间划分

### 什么是空间划分

随着移动互联网公司的全球化扩张，为了提供更加快捷方便的用户体验，越来越多的公司涌现出对空间划分的需求。

通常，通过空间的划分，建立数据库索引可以实现高效的实时查询服务，比如周边车辆位置查询，周边餐厅位置查询等。

传统的空间划分方法主要分为两类：

1. 以 R-tree 为代表的动态单元
2. 以 Geohash 为代表的静态单元

对比维度|动态单元/R-tree|静态单元/Geohash
---|---|---
实现难度| 难|易
邻近搜索| 难|易
水平扩张| 难|易
索引精度| 高|低

可以在大多数对精度要求不严格的场景下，牺牲一部分尽可能小的索引精度，此时，静态单元是优于动态单元的选择。

![静态地理单元特点](https://image-static.segmentfault.com/176/708/1767087967-5b0a76ab645b5)

但是，一方面，传统的地理单元比如 S2和geohash，在不同纬度的地区会出现地理单元单位面积差异较大的情况，这导致业务指标和模型输入的特征存在一定的分布倾斜和偏差，使用等面积、等形状的六边形地理单元可以减少指标和特征normalization的成本。

另一方面，在常用的地理范围查询中，基于矩形的查询方法，存在8邻域到中心网格的距离不相等的问题，四边形存在两类长度不等的距离，而六边形的周围邻居到中心网格的距离却是有且仅有一个，从形状上来说更加接近于圆形。

所以，基于hexagon的地理单元已经成为各大厂家的首选，比如 Uber 和 Didi 的峰时定价服务。

![图示为 Uber 峰时定价服务示意图](https://image-static.segmentfault.com/366/883/3668837560-5bcb33f58adcb)


在这样的背景下 Uber 基于六边形网格的地理单元开源解决方案 [H3](https://eng.uber.com/h3/) 应运而生，它使得部署 Hexagon 方案的成本非常低，通过UDF、R pacakge等方式可以以非常低的成本大规模推广。

### 什么是 H3

![DDGS](https://image-static.segmentfault.com/339/656/339656838-5bcb37dc36395)

H3 的前身其实是 DDGS(Discrete global grid systems) 中的 ISEA3H，其原理是把无限的不规则但体积相等的六棱柱从二十面体中心延伸，这样任何半径的球体都会穿过棱镜形成相等的面积cell，基于该标准使得每一个地理单元的面积大小就可以保证几乎相同。

然而原生的 ISEA3H 方案在任意级别中都存在12个五边形，H3 的主要改进是通过坐标系的调整将其中的五边形都转移到水域上，这样就不影响大多数业务的开展。

下面是 ISEA3H 五边形问题的示例：

```
#Include libraries
library(dggridR)
library(dplyr)

#Construct a global grid with cells approximately 1000 miles across
dggs <- dgconstruct(spacing=1000, metric=FALSE, resround='down')

#Load included test data set
data(dgquakes)

#Get the corresponding grid cells for each earthquake epicenter (lat-long pair)
dgquakes$cell <- dgGEO_to_SEQNUM(dggs,dgquakes$lon,dgquakes$lat)$seqnum

#Converting SEQNUM to GEO gives the center coordinates of the cells
cellcenters <- dgSEQNUM_to_GEO(dggs,dgquakes$cell)

#Get the number of earthquakes in each cell
quakecounts <- dgquakes %>% group_by(cell) %>% summarise(count=n())

#Get the grid cell boundaries for cells which had quakes
grid <- dgcellstogrid(dggs,quakecounts$cell,frame=TRUE,wrapcells=TRUE)

#Update the grid cells' properties to include the number of earthquakes
#in each cell
grid <- merge(grid,quakecounts,by.x="cell",by.y="cell")

#Make adjustments so the output is more visually interesting
grid$count <- log(grid$count)
cutoff <- quantile(grid$count,0.9)
grid <- grid %>% mutate(count=ifelse(count>cutoff,cutoff,count))

#Get polygons for each country of the world
countries <- map_data("world")

#Plot everything on a flat map
p<- ggplot() + 
 geom_polygon(data=countries, aes(x=long, y=lat, group=group), fill=NA, color="black") +
 geom_polygon(data=grid, aes(x=long, y=lat, group=group, fill=count), alpha=0.4) +
 geom_path (data=grid, aes(x=long, y=lat, group=group), alpha=0.4, color="white") +
 geom_point (aes(x=cellcenters$lon_deg, y=cellcenters$lat_deg)) +
 scale_fill_gradient(low="blue", high="red")
p
```

![ISEA3H 墨卡托投影](https://image-static.segmentfault.com/151/592/1515926897-5bcb3905c18a4)

转化坐标系后：

```
#Replot on a spherical projection
p+coord_map("ortho", orientation = c(-38.49831, -179.9223, 0))+
  xlab('')+ylab('')+
  theme(axis.ticks.x=element_blank())+
  theme(axis.ticks.y=element_blank())+
  theme(axis.text.x=element_blank())+
  theme(axis.text.y=element_blank())+
  ggtitle('Your data could look like this')
```

![ISEA3H 正射投影](https://image-static.segmentfault.com/393/288/3932888592-5bcb3959e2629)

在 H3 开源后，你也可以使用 `h3r` 实现六边形的编码与解码：

```
# 以亮马桥地铁站为例
devtools::install_github("scottmmjackson/h3r")
library(h3r)

df <- h3r::getBoundingHexFromCoords(39.949958,116.46343,11) %>% # 单边长为24米
 purrr::transpose() %>% 
 purrr::simplify_all() %>%
 data.frame()

df %>% bind_rows(
 df %>% head(1)
) %>% 
 leaflet::leaflet() %>% 
 leafletCN::amap() %>% 
 leaflet::addPolylines(lng = ~lon,lat=~lat)
```


![Geohash 与 H3 对比](https://image-static.segmentfault.com/600/246/60024670-5bce4f9c1f336)


H3 中还提供了类似 S2 的六边形压缩技术，使得数据的存储空间可以极大压缩，在处理大规模稀疏数据时将体现出优势：

![H3 数据压缩技术](http://eng.uber.com/wp-content/uploads/2018/06/image11-1.png)

## 渲染引擎

### 什么是 Leaflet

在使用 Deck.gl 之前，业界主流的解决方案通常是另一个开源的轻量级地理数据可视化框架 Leaflet。Leaflet 经过十余年的积累已经拥有足够成熟的生态，支持各式各样的插件扩展。

序号|leaflet 插件|功能
---|---|---
1|leaflet|基础功能，几何元素CRUD，图层等，可结合 shiny，crosstalk
2|leaflet.opacity|透明度调节
3|leaflet.extras|高级功能, 包括热力图, 搜索, 米尺等
4|leaflet.esri|高级功能，ESRI插件 可结合 Arcgis
5|mapview|高级功能, 多图联动等
6|mapedit|高级功能，地图编辑
7|leafletCN|提供高德底图

虽然 Leaflet 功能强大，不过工业界的发展也暴露出一些新的问题。虽然 leaflet 也有大规模地理数据渲染的成功案例，比如 [Windy](https://www.windy.com),  如何更好地支持诸如 轨迹、风向、六边形网格的交互式可视化此前没有好的解决方案。好在近年来 Mapbox 和 Deck.gl 正在着手改变这一现状。

### 什么是 Deck.gl

[Deck.gl](http://deck.gl) 基于 WebGL 的大规模数据可视化框架，通过响应式编程和GPU并行加速的方式进行高效地 WebGL 渲染，与 Mapbox GL 深度结合能够呈现非凡的 3D 视觉效果。

下面是一个具体的例子，如何可视化Hexagon：

```
# 初始化
devtools::install_github("crazycapivara/deckgl")

library(deckgl)

# 设置 Mapbox token，过期需要免费在 Mapbox 官网申请
Sys.setenv(MAPBOX_API_TOKEN = "pk.eyJ1IjoidWJlcmRhdGEiLCJhIjoiY2poczJzeGt2MGl1bTNkcm1lcXVqMXRpMyJ9.9o2DrYg8C8UWmprj-tcVpQ")


# 数据集合
sample_data <- paste0(
  "https://raw.githubusercontent.com/",
  "uber-common/deck.gl-data/",
  "master/website/sf-bike-parking.json"
)

properties <- list(
  pickable = TRUE,
  extruded = TRUE,
  cellSize = 200,
  elevationScale = 4,
  getPosition = JS("data => data.COORDINATES"),
  getTooltip = JS("object => object.count")
)

# 可视化
deckgl(zoom = 11, pitch = 45) %>%
  add_hexagon_layer(data = sample_data, properties = properties) %>%
  add_mapbox_basemap(style = "mapbox://styles/mapbox/light-v9") 
```

![Hexagon](https://image-static.segmentfault.com/365/269/3652694454-5bcd06406e3ad)


除了六边形之外 Deck.gl 也支持其他常见几何图形，比如 Grid、Arc、Contour、Polygon 等等。
更多信息可以见官方文档： https://crazycapivara.github.io/deckgl/

![](https://image-static.segmentfault.com/674/669/674669480-5bcb26c65920f)

### 地理仪表盘：结合 Shiny

Deck.gl 结合 Shiny 后，可将可视化结果输出到仪表盘上：


```
library(mapdeck)
library(shiny)
library(shinydashboard)
library(jsonlite)
ui <- dashboardPage(
	dashboardHeader()
	, dashboardSidebar()
	, dashboardBody(
		mapdeckOutput(
			outputId = 'myMap'
			),
		sliderInput(
			inputId = "longitudes"
			, label = "Longitudes"
			, min = -180
			, max = 180
			, value = c(-90, 90)
		)
		, verbatimTextOutput(
			outputId = "observed_click"
		)
	)
)
server <- function(input, output) {
	
	set_token('pk.eyJ1IjoidWJlcmRhdGEiLCJhIjoiY2poczJzeGt2MGl1bTNkcm1lcXVqMXRpMyJ9.9o2DrYg8C8UWmprj-tcVpQ') ## 如果token 过期了，需要去Mapbox官网免费申请一个
	
	origin <- capitals[capitals$country == "Australia", ]
	destination <- capitals[capitals$country != "Australia", ]
	origin$key <- 1L
	destination$key <- 1L
	
	df <- merge(origin, destination, by = 'key', all = T)
	
	output$myMap <- renderMapdeck({
		mapdeck(style = mapdeck_style('dark')) 
	})
	
	## plot points & lines according to the selected longitudes
	df_reactive <- reactive({
		if(is.null(input$longitudes)) return(NULL)
		lons <- input$longitudes
		return(
			df[df$lon.y >= lons[1] & df$lon.y <= lons[2], ]
		)
	})
	
	observeEvent({input$longitudes}, {
		if(is.null(input$longitudes)) return()
		
		mapdeck_update(map_id = 'myMap') %>%
			add_scatterplot(
				data = df_reactive()
				, lon = "lon.y"
				, lat = "lat.y"
				, fill_colour = "country.y"
				, radius = 100000
				, layer_id = "myScatterLayer"
			) %>%
			add_arc(
				data = df_reactive()
				, origin = c("lon.x", "lat.x")
				, destination = c("lon.y", "lat.y")
				, layer_id = "myArcLayer"
				, stroke_width = 4
			)
	})
	
	## observe clicking on a line and return the text
	observeEvent(input$myMap_arc_click, {
		
		event <- input$myMap_arc_click
		output$observed_click <- renderText({
			jsonlite::prettify( event )
		})
	})
}
shinyApp(ui, server)
```

![Deck.gl 结合 Shiny](https://image-static.segmentfault.com/379/159/3791590526-5bcb26a90ee91)


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
* [译 解密 Uber 数据部门的数据可视化最佳实践](https://segmentfault.com/a/1190000005154321)
* [gpu-accelerated-aggregation-in-deck-gl](https://medium.com/vis-gl/gpu-accelerated-aggregation-in-deck-gl-7e2c7d701fb0)

> 作为分享主义者(sharism)，本人所有互联网发布的图文均遵从CC版权，转载请保留作者信息并注明作者 Harry Zhu 的 FinanceR专栏:https://segmentfault.com/blog/harryprince，如果涉及源代码请注明GitHub地址：https://github.com/harryprince。微信号: harryzhustudio
> 商业使用请联系作者。
