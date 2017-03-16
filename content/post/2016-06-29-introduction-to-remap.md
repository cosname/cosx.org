---
title: REmap入门示例
date: '2016-06-29T09:57:01+00:00'
author: 郎大为
categories:
  - 统计图形
  - 统计软件
  - 软件应用
tags:
  - Echarts
  - REmap
  - 可视化
  - 地图
slug: introduction-to-remap
---

![](http://lchiffon.github.io/REmap/REmapExamples/Nanchang/pic/remap.png)

REmap是一个基于Echarts2.0 <http://echarts.baidu.com>{.uri} 的一个R包。主要的目的是为广大数据玩家提供一个简便的，可交互的地图数据可视化工具。目前托管在github，<https://github.com/lchiffon/REmap>{.uri}

使用如下步骤安装：

<pre class="r"><code>library(devtools)
install_github('lchiffon/REmap')</code></pre>

REmap目前更新到V0.3，提供百度迁徙，分级统计，百度地图，热力图等功能的实现。

**提示:请使用Chrome或者Firefox来作为默认浏览器**

最后要声明的一点：这个包的目的是简化使用和学习的流程，如果你是一个好学的geek，请深入的学习Echarts！

### 特性

<ol style="list-style-type: decimal;">
  <li>
    使用Echarts2.0封包，地图绘制使用的是SVG图形
  </li>
  <li>
    采用百度API来自动获取城市的经纬度数据
  </li>
  <li>
    支持Windows！
  </li>
</ol>

<!--more-->

### 使用向导

#### 获取经纬度

获取经纬度的函数是基于BaiduAPI的一个获取地理位置的功能。这个函数不仅是REmap下的一个功能，实际上，你也可以用它来抓取城市经纬度数据：

基本函数:

  * `get_city_coord` 获取一个城市的经纬度
  * `get_geo_position` 获取一个城市向量的经纬度

<pre class="r"><code>library(REmap)
city_vec = c("北京","Shanghai","广州")
get_city_coord("Shanghai")</code></pre>

<pre class="r"><code>[1] 121.47865  31.21562</code></pre>

<pre class="r"><code>get_geo_position (city_vec)</code></pre>

<pre class="r"><code>        lon      lat     city
1  116.6212 40.06107     北京
2  121.4786 31.21562 Shanghai
3  113.3094 23.39237     广州</code></pre>

注：windows用户会看到city一列为utf-8编码，可以使用`get_geo_position (city_vec2)$city`查看列向量的信息。(我能说我最好的建议是换Mac么？)

#### 绘制迁徙地图

绘制地图使用的是主函数`remap`

    remap(mapdata, title = "", subtitle = "", 
          theme =get_theme("Dark"))

  * `mapdata` 一个数据框对象，第一列为出发地点，第二列为到达地点
  * `title` 标题
  * `subtitle` 副标题
  * `theme` 控制生成地图的颜色，具体将会在`get_theme`部分说明

<pre class="r"><code>set.seed(125)
origin = rep("北京",10)
destination = c('上海','广州','大连','南宁','南昌',
                '拉萨','长春','包头','重庆','常州')
dat = data.frame(origin,destination)
out = remap(dat,title = "REmap实例数据",subtitle = "theme:Dark")
plot(out)</code></pre>



该地图会写成一个html文件，保存在电脑里面，并通过浏览器打开该文件。以下的方式都可以看到这个地图：

<pre class="r"><code>## Method 1
remap(dat,title = "REmap实例数据",subtitle = "theme:Dark")

## Method 2 
out = remap(dat,title = "REmap实例数据",subtitle = "theme:Dark")
out

## Method 3
plot(out)</code></pre>

#### 个性化地图

正如之前所说的，为了简化学习和使用的流程，REmap并没有封装太多的参数。（真的不是我懒）如果想更个性化地调整Echarts的参数，请移步Echarts的官方文档<http://echarts.baidu.com/doc/doc.html>{.uri}

REmap中`get_theme`提供了迁徙地图中常用颜色的调整：

<pre class="r"><code>get_theme(theme = "Dark", lineColor = "Random",
  backgroundColor = "#1b1b1b", titleColor = "#fff",
  borderColor = "rgba(100,149,237,1)", regionColor = "#1b1b1b")</code></pre>

  * `theme` 默认主题，除了三个内置主题，可以使用“none”来自定义颜色 
      * a character object in (“Dark”,“Bright,”Sky“,”none“)
  * `lineColor` 线条颜色，默认随机，也可以使用固定颜色 
      * Control the color of the line, “Random” for random color
  * `backgroundColor` 背景颜色 
      * Control the color of the background
  * `titleColor` 标题颜色 
      * Control the color of the title
  * `borderColor` 边界颜色（省与省之间的信息） 
      * Control the color of the border
  * `regionColor` 区域颜色 
      * Control the color of the region

颜色可以使用颜色名（比如’red’,’skyblue’等），RGB（“#1b1b1b”,“#fff”）或者一个rgba的形式（“rgba(100,100,100,1)”），可以在[这里](http://www.114la.com/other/rgb.htm)找到颜色对照表。

  * 默认模板：Bright

<pre class="r"><code>## default theme:"Bright"
set.seed(125)
out = remap(dat,title = "REmap实例数据",subtitle = "theme:Bright",
            theme = get_theme("Bright"))
plot(out)</code></pre>



  * 更改线条颜色

<pre class="r"><code>## set Line color as 'orange'
set.seed(125)
out = remap(dat,title = "REmap实例数据",subtitle = "theme:Bright",
            theme = get_theme("None",
                             lineColor = "orange"))
plot(out)</code></pre>



  * 更改其他颜色

<pre class="r"><code>## Set Region Color
out = remap(dat,title = "REmap实例数据",subtitle = "theme:Bright",
            theme = get_theme("None",
                              lineColor = "orange",
                              backgroundColor = "#FFC1C1",
                              titleColor = "#1b1b1b",
                              regionColor = '#ADD8E6'))
plot(out)</code></pre>



### 参考资料

  * <a href="https://github.com/lchiffon/REmap" target="_blank">Github链接</a>
  * <a href="http://chiffon.ninja" target="_blank">我的博客：七风阁</a>
  * <a href="http://lchiffon.github.io/REmap/REmapExamples/Nanchang/?theme=sky#/slide-1" target="_blank">REmap，重新定义你的地图slides</a>
