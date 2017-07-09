---
title: 利用R语言进行交互数据可视化
date: '2016-06-05T14:18:51+00:00'
author: 谢佳标
categories:
  - 统计之都
  - 统计图形
  - 统计软件
tags:
  - dygraphs
  - ggplot2
  - plotly
  - rCharts
  - recharts
slug: using-r-for-interactive-data-visualization
forum_id: 419142
---

上周在中国R语言大会北京会场上，给大家分享了如何利用R语言交互数据可视化。现场同学对这块内容颇有兴趣，故今天把一些常用的交互可视化的R包搬出来与大家分享。

# rCharts包

说起R语言的交互包，第一个想到的应该就是rCharts包。该包直接在R中生成基于D3的Web界面。

rCharts包的安装

```r
require(devtools)
install_github('rCharts', 'ramnathv')
```

rCharts函数就像lattice函数一样，通过formula、data指定数据源和绘图方式，并通过type指定图表类型。

下面通过例子来了解下其工作原理。我们以鸢尾花数据集为例，首先通过name函数对列名进行重新赋值（去掉单词间的点），然后利用rPlot函数绘制散点图(type=“point”)，并利用颜色进行分组（color=“Species”）。<!--more-->

```r
library(rCharts)
names(iris) = gsub("\\.", "", names(iris))
p1 <- rPlot(SepalLength ~ SepalWidth | Species, data = iris, color = 'Species', type = 'point')
p1
```

![001](https://uploads.cosx.org/2016/06/001.png)

rCharts支持多个javascript图表库,每个都有自己的长处。每一个图表库有多个定制选项,其中大部分rCharts都支持。

NVD3 是一个旨在建立可复用的图表和组件的 d3.js 项目——它提供了同样强大的功能，但更容易使用。它可以让我们处理复杂的数据集来创建更高级的可视化。在rCharts包中提供了nPlot函数来实现。

下面以眼睛和头发颜色的数据(HairEyeColor)为例说明nPlot绘图的基本原理。我们按照眼睛的颜色进行分组(group=“eye”),对头发颜色人数绘制柱状图，并将类型设置为柱状图组合方式(type=“multiBarChart”)，这样可以实现分组和叠加效果。

```r
library(rCharts)
hair_eye_male <- subset(as.data.frame(HairEyeColor), Sex == "Male")
hair_eye_male[,1] <- paste0("Hair",hair_eye_male[,1])
hair_eye_male[,2] <- paste0("Eye",hair_eye_male[,2])
n1 <- nPlot(Freq ~ Hair, group = "Eye", data = hair_eye_male,
type = "multiBarChart")
n1
```

![002](https://uploads.cosx.org/2016/06/002.png) 

可以通过图形右上角选择需要查看或隐藏的类别（默认是全部类别显示的），也能通过左上角选择柱子是按照分组还是叠加的方式进行摆放（默认是分组方式）。如果选择Stacked，就会绘制叠加柱状图。



![rcharts-003](https://uploads.cosx.org/2016/06/rcharts-003.png)

Highcharts是一个制作图表的纯Javascript类库，支持大部分的图表类型：直线图，曲线图、区域图、区域曲线图、柱状图、饼状图、散布图等。在rCharts包中提供了hPlot函数来实现。

以MASS包中的学生调查数据集survery为例，说明hPlot绘图的基本原理。我们绘制学生身高和每分钟脉搏跳动次数的气泡图，以年龄变量作为调整气泡大小的变量。

```r
library(rCharts)
a <- hPlot(Pulse ~ Height, data = MASS::survey, type = "bubble",
title = "Zoom demo", subtitle = "bubble chart",
size = "Age", group = "Exer")
a$colors('rgba(223, 83, 83, .5)', 'rgba(119, 152, 191, .5)',
'rgba(60, 179, 113, .5)')
a$chart(zoomType = "xy")
a$exporting(enabled = T)
a
```

![rcharts-004](https://uploads.cosx.org/2016/06/rcharts-004.png)

rCharts包可以画出更多漂亮的交互图， <http://ramnathv.github.io/rCharts/>和<https://github.com/ramnathv/rCharts/tree/master/demo>有更多的例子可供大家学习。

# recharts包

学习完rCharts包，可能有读者会问，我们有没有国人开发的包实现相似的效果呢？这边给大家推荐一个同样功能强大的recharts包。

本包来源于百度开发的国内顶尖水平的开源d3-js可视项目Echarts(Github Repo)。Yang Zhou和Taiyun Wei基于该工具开发了recharts包，经Yihui Xie修改后，可通过htmlwidgets传递js参数，大大简化了开发难度。但此包开发仍未完成。为了赶紧上手用，基于该包做了一个函数echartR（下载至本地，以后通过source命令加载），用于制作基础Echart交互图。需要R版本>=3.2.0.

安装方式如下：

```r
library(devtools)
install_github('yihui/recharts')
```

安装完后，需要在<https://github.com/madlogos/recharts/blob/master/R/echartR.R>将echartR.R脚本下载到本地。

假如想对鸢尾花数据集绘制散点图，可以执行如下代码：

```r
source("~echartR.R")
names(iris) = gsub("\\.", "", names(iris))
echartR(data=iris,x=~SepalLength,y=~PetalWidth,series = ~Species,
type = 'scatter')
```

![rcharts-005](https://uploads.cosx.org/2016/06/rcharts-005.png)

绘制柱状图：

```r
hair_eye_male <- subset(as.data.frame(HairEyeColor), Sex == "Male")
hair_eye_male[,1] <- paste0("Hair",hair_eye_male[,1])
hair_eye_male[,2] <- paste0("Eye",hair_eye_male[,2])
echartR(data = hair_eye_male, x = Hair, y = ~Freq,  series = ~Eye,
type = 'bar', palette='fivethirtyeight',
xlab = 'Hair', ylab = 'Freq')
```

![rcharts-006](https://uploads.cosx.org/2016/06/rcharts-006.png)

![rcharts-007](https://uploads.cosx.org/2016/06/rcharts-007.png) 

玫瑰图：

```r
dtcars <- mtcars
dtcars$car <- row.names(dtcars)
dtcars$transmission <- as.factor(dtcars$am)
levels(dtcars$transmission) <- c("Automatic","Manual")
dtcars$cylinder <- as.factor(dtcars$cyl)
dtcars$carburetor <-as.factor(dtcars$carb)
echartR(dtcars, x = ~cylinder,  y = ~car, type='rose',
palette='colorblind', title='Number of Cylinders',
subtitle = '(source: mtcars)')
```

![rcharts-007](https://uploads.cosx.org/2016/06/rcharts-007.png)

雷达图：

```r
player <- data.frame(name=c(rep("Philipp Lahm",8),rep("Dani Alves",8)),
para=rep(c("Passing%","Key passing","Comp crosses",
"Crossing%","Successful dribbles",
"Dispossessed","Dribbled past","Fouls"),2),
value=c(89.67, 1.51, 0.97, 24.32, 0.83, 0.86, 1.15, 0.47,
86.62, 2.11, 0.99, 20.78, 1.58, 1.64, 0.9, 1.71))
echartR(player, x= ~para, y= ~value, series= ~name, type='radarfill',
symbolList='none', palette=c('firebrick1','dodgerblue'),
title='Lahm vs Alves', subtitle= '(by @mixedknuts)')
```

![rcharts-008](https://uploads.cosx.org/2016/06/rcharts-008.png)

# plotly包

接下来要给大家介绍的是另一个功能强大的plotly包。它是一个基于浏览器的交互式图表库，它建立在开源的JavaScript图表库plotly.js之上。

有两种安装方式：

```r
install.packages("plotly")
```

或者

```r
devtools::install_github("ropensci/plotly")
```

plotly包利用函数plot_ly函数绘制交互图。

如果相对鸢尾花数据集绘制散点图，需要将mode参数设置为“markers”。

```r
library(plotly)
p <- plot_ly(iris, x = Petal.Length, y = Petal.Width,
color = Species, colors = "Set1", mode = "markers")
p
```

![rcharts-009](https://uploads.cosx.org/2016/06/rcharts-009.png)

如果想绘制交互箱线图，需要将type参数设置为box。

```r
library(plotly)
plot_ly(midwest, x = percollege, color = state, type = "box")
```

![rcharts-010](https://uploads.cosx.org/2016/06/rcharts-010.png)

如果你已熟悉ggplot2的绘图系统，也可以针对ggplot2绘制的对象p，利用ggplotly函数实现交互效果。例如我们想对ggplot绘制的密度图实现交互效果，执行以下代码即可。

```r
library(plotly)
p <- ggplot(data=lattice::singer,aes(x=height,fill=voice.part))+
geom_density()+
facet_grid(voice.part~.)
(gg <- ggplotly(p))
```

![rcharts-011](https://uploads.cosx.org/2016/06/rcharts-011.png)

# 其他

此外还有很多好玩有用的交互包。例如专门用来画交互时序图的dygraphs包，可通过install.packages(“dygraphs”)安装。

```r
library(dygraphs)
lungDeaths <- cbind(mdeaths, fdeaths)
dygraph(lungDeaths) %&gt;%
dySeries("mdeaths", label = "Male") %&gt;%
dySeries("fdeaths", label = "Female") %&gt;%
dyOptions(stackedGraph = TRUE) %&gt;%
dyRangeSelector(height = 20)
```

![rcharts-012](https://uploads.cosx.org/2016/06/rcharts-012.png)

DT包实现R数据对象可以在HTML页面中实现过滤、分页、排序以及其他许多功能。通过install.packages(“DT”)安装。

以鸢尾花数据集iris为例，执行以下代码：

```r
library(DT)
datatable(iris)
```

networkD3包可实现D3 JavaScript的网络图，通过install.packages(“networkD3”)安装。

下面是绘制一个力导向的网络图的例子。

```r
# 加载数据
data(MisLinks)
data(MisNodes)

# 画图
forceNetwork(Links = MisLinks, Nodes = MisNodes,
Source = "source", Target = "target",
Value = "value", NodeID = "name",
Group = "group", opacity = 0.8)
```

![rcharts-014](https://uploads.cosx.org/2016/06/rcharts-014.png) 

我们可以通过d3treeR包绘制交互treemap图，利用

```r
devtools::install_github("timelyportfolio/d3treeR")
```

完成d3treeR包安装。

```r
library(treemap)
library(d3treeR)
data("GNI2014")
tm <-  treemap(
GNI2014,
index=c("continent", "iso3"),
vSize="population",
vColor="GNI",
type="value"
)
d3tree( tm,rootname = "World" )
```



![rcharts-015](https://uploads.cosx.org/2016/06/rcharts-015.png)

今天主要是介绍了几个R常用的交互包。在R的环境中，动态交互图形的优势在于能和knitr、shiny等框架整合在一起，能迅速建立一套可视化原型系统。希望以后再跟各位分享这部分的内容。
