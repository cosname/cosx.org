---
title: 利用shiny包快速搭建可视化原型系统
date: '2016-06-16T12:07:03+00:00'
author: 谢佳标
categories:
  - 统计图形
  - 统计软件
  - 软件应用
tags:
  - shiny包
  - 可视化原型系统
slug: use-shiny-fleetly-set-up-visual-prototype-system
forum_id: 419145
---

前几周给大家分享了一篇[《利用R语言进行交互数据可视化》](/2016/06/using-r-for-interactive-data-visualization/)的文章。文章末尾提到的在R的环境中，动态交互图形的优势在于能和knitr、shiny等框架整合在一起，能迅速建立一套可视化原型系统。今天接着给大家分享如何将动态交互图形与shiny框架整合在一起，迅速建立一套可视化原型系统。

Shiny是R中的一种Web开发框架，使得R的使用者不必太了解css、js只需要了解一些html的知识就可以快速完成web开发，且shiny包集成了bootstrap、jquery、ajax等特性，极大解放了作为统计语言的R的生产力。

Shiny应用包含连个基本的组成部分：一个是用户界面脚本（a user-interface script），另一个是服务器脚本(a server script)。

![Shiny应用包含连个基本的组成部分](https://uploads.cosx.org/2016/06/M_86@S224HFW_AKSLVEN.png)

<!--more-->

  * 用户界面(ui)脚本控制应用的布局与外表，它定义在一个称作R的源脚本中。
  * 服务器(server)脚本包含构建应用所需要的一些重要指示，它定义在一个称作R的源脚本中。

你可以在一个目录中保存一个ui.R文件和server.R文件来创建一个Shiny应用。每一个应用都需要自己独特的存放位置。运行应用的方法是在函数runApp中置入目录名称。例如你的应用目录名称为myapp,且放在D盘目录下，那么键入以下代码可以执行应用：

```r
library(shiny)
runApp("D:/myapp")
```

运行完成后自动生成一个网页展示结果。

也可以将ui和server代码写在一个脚本内，通过shinyApp执行该app。运行以下脚本将得到一个简单的web版直方图。

```r
# app.R#
if(require(shiny)) install.packages("shiny")
ui <- fluidPage(
numericInput(inputId = "n",
"Sample size", value = 25),
plotOutput(outputId = "hist")
)

server <- function(input, output) {
output$hist <- renderPlot({
hist(rnorm(input$n))
})
}
shinyApp(ui = ui, server = server)
```

![~M4UT2WID$7MR462EO9M~F6](https://uploads.cosx.org/2016/06/M4UT2WID7MR462EO9MF6.png)

shinydashboard扩展包为shiny框架提供了BI框架，一个dashboard由三部分组成：标题栏、侧边栏、主面板。通过install.packages("shinydashboard")完成安装。执行以下脚本可以得到shinydashboard的基本框架。

```r
# app.R #
library(shiny)
if(require(shinydashboard)) install.packages("shinydashboard")
ui <- dashboardPage(
dashboardHeader(),
dashboardSidebar(),
dashboardBody()
)

server <- function(input, output) { }
shinyApp(ui, server)
```

![LA_74B35XI8Q2GO71L_T)V](https://uploads.cosx.org/2016/06/LA_74B35XI8Q2GO71L_TV.png)

到此，关于shiny和shinydashboard框架我们已经掌握了。接下来，我们将前面学到的动态交互绘图包与Shiny Web开发框架结合，一步步搭建数据可视化平台demo。先创建新文件夹myapp，并在myapp文件夹里面创建两个脚本ui.R和server.R，用来存放客户端和服务端的脚本。

```r
# server.R #
output$mygraph <- renderPlot({
graph_function(formula,data=,…)
})

# ui.R #
plotOutput("mygraph")
```

例如，我们想在网页上输出了lattice函数绘制的散点图矩阵和三维曲面图，server.R及ui.R的核心代码如下：

```r
# server.R #
# 利用lattice包中的绘图函数
output$splom <- renderPlot({
splom(mtcars[c(1, 3:7)], groups = mtcars$cyl,
pscales = 0,pch=1:3,col=1:3,
varnames = c("Miles\nper\ngallon", "Displacement\n(cu. in.)",
"Gross\nhorsepower", "Rear\naxle\nratio",
"Weight", "1/4 mile\ntime"),
key = list(columns = 3, title = "Number of Cylinders",
text=list(levels(factor(mtcars$cyl))),
points=list(pch=1:3,col=1:3)))
})

output$wireframe <- renderPlot({
wireframe(volcano, shade = TRUE,
aspect = c(61/87, 0.4),
light.source = c(10,0,10))
})
```

```r
# ui.R #
plotOutput("splom"),
plotOutput("wireframe")
```

平台界面如下图所示：

![6VR87SQB8W65HT08](https://uploads.cosx.org/2016/06/6VR87SQB8W65HT08.png)

对于rCharts包绘制的图形，我们在server.R中用renderChart( )函数将图形赋予输出对象mygraph，并在ui.R中用showOutput("mygraph" )将图形输出到web中。形式如下（以hPlot函数为例）：

```r
# server.R #
output$mygraph <- renderChart({
p1 <- hPlot(formula,data,type, ...)
p1$addParams(dom="mygraph")
return(p1)
})
```

```r
# ui.R #
showOutput("mygraph","highcharts")
```

如下图所示，我们在网页上输出了nPlot函数绘制的交互柱状图。

```r
# server.R #
output$mychart1 <- renderChart({
hair_eye_male <- subset(as.data.frame(HairEyeColor), Sex == "Male")
hair_eye_male[,1] <- paste0("Hair",hair_eye_male[,1])
hair_eye_male[,2] <- paste0("Eye",hair_eye_male[,2])
p1 <- nPlot(Freq ~ Hair, group = "Eye", data = hair_eye_male, type = "multiBarChart")
p1$chart(color = c('brown', 'blue', '#594c26', 'green'))
p1$addParams(dom="mychart1")
return(p1)
})
```

```r
# ui.R #
showOutput("mychart1","nvd3")
```

![ZG9Q9WYN071IKW8UVRXC](https://uploads.cosx.org/2016/06/ZG9Q9WYN0_71IKW8UVRXC.png)

如下图所示，我们在网页上输出了hPlot函数绘制的交互气泡图。

```r
# server.R #
output$mychart2 <- renderChart({
a <- hPlot(Pulse ~ Height, data = MASS::survey, type = "bubble", title = "Zoom demo", subtitle = "bubble chart", size = "Age", group = "Exer")
a$colors('rgba(223, 83, 83, .5)', 'rgba(119, 152, 191, .5)', 'rgba(60, 179, 113, .5)')
a$chart(zoomType = "xy")
a$exporting(enabled = T)
a$addParams(dom="mychart2")
return(a)
})
```

```r
# ui.R #
showOutput("mychart2","highcharts")
```

![NNW9QYQ8XA6CV%SLCKQ5A](https://uploads.cosx.org/2016/06/NNW@9QYQ8XA6CVSLCKQ5A.png)

对于DT包制作的数据表格，我们在server.R中用renderDataTable ( )函数将表格赋予输出对象mytable，并在ui.R中用dataTableOutput ("mytable" )将图形输出到web中。形式如下：

```r
# server.R #
output$mytable <- renderDataTable({
datatable(data)
})
```

```r
# ui.R #
dataTableOutput("mytable")
```

![BC3E.tmp](https://uploads.cosx.org/2016/06/BC3E.tmp_.png)

对于networkD3包制作的网络图，我们在server.R中用renderForceNetwork ( )函数将表格赋予输出对象mygraph，并在ui.R中用forceNetworkOutput ("mygraph" )将图形输出到web中。形式如下：

```r
# server.R #
output$mygraph <- renderForceNetwork ({
forceNetwork (…)
})<
```

```r
# ui.R #
forceNetworkOutput ("mygraph")
```

如下图所示，我们在网页上展示力导向网络图。

```r
# server.R #
output$networkD3 <- renderForceNetwork({
forceNetwork(Links = MisLinks, Nodes = MisNodes,
Source = "source", Target = "target",
Value = "value", NodeID = "name",
Group = "group", opacity = 0.8,zoom = T)
})
```

```r
# ui.R #
forceNetworkOutput("networkD3")
```

![4EDD.tmp](https://uploads.cosx.org/2016/06/4EDD.tmp_.png)

好了，以上就是关于如何将一些数据可视化包结合shiny，快速搭建一套可视化原型系统。由于篇幅有限，本文不能将页面设计及控件代码都一一罗列出。对shiny包感兴趣的读者可以自己上RStudio官网自行学习。

<http://shiny.rstudio.com/>

<http://rstudio.github.io/shinydashboard/>

最后，shiny除了能完美结合数据可视化包绘制出的精美动态图表，对于模型结果可视化，我们也可以使用这种方式把可视化结果在网页上输出。我们对关联规则和kmeans聚类结果进行了可视化，并增加了选择栏和数字输入选项来调整关联规则可视化的方法和聚类的K值。

![85E.tmp](https://uploads.cosx.org/2016/06/85E.tmp_.png)

可以通过控件去控制关联规则可视化中的method类型及K-Means聚类中的K值。

![FD59.tmp](https://uploads.cosx.org/2016/06/FD59.tmp_.png)
