---
title: 在R中实现动态气泡图
date: '2013-01-07T12:52:47+00:00'
author: 何通
categories:
  - 统计图形
  - 统计软件
  - 软件应用
tags:
  - animation
  - ggplot2
  - 动画
  - 可视化
  - 气泡图
slug: dynamic-bubble-plot-in-r
forum_id: 418894
---

最近我逐渐发现了ggplot2这个包的好处——只要用过一次，就再也不想回头使用R中自带的作图函数了。前两天鼓捣完一个地图的数据，又受到统计之都[最新文章](/2013/01/cos.name/2012/12/time-series-and-spatial-distribution-with-r-dynamically/)的影响，我忽然想起了Hans Rosling在TED上的[精彩演讲](http://www.ted.com/talks/hans_rosling_shows_the_best_stats_you_ve_ever_seen.html)。在图中横坐标是国民收入，纵坐标是国民的期望寿命，气泡的大小则是该国人口。整个图从1800年的统计数据开始，一直到2009年不断动态地展示，图上的气泡也随着时间变化不停地抖动上升。有一位在斯坦福专做可视化的博士用JavaScript在网页上重现了这段动态效果图，点开页面即可观看：<http://bost.ocks.org/mike/nations/>。

于是今天我便将这个图尝试着用R中的ggplot2与animation包实现了出来，边实现边研究ggplot2的用法，花了一天的时间做成了[这个视频](http://v.youku.com/v_show/id_XNDk4MjYyMTUy.html)。

简单地说一下流程：首先是数据文件的获取。[数据](https://bost.ocks.org/mike/nations/nations.json)能够在github上找到，但是数据是JSON格式的，只有一行，因此我的大部分代码都在为让数据变成一个二维矩阵的形式而努力着……很多国家会出现某些年没有统计数据的情况，因此我用了线性插值填补。最后，有两个国家只有一年有数据，我只能将它们删掉了。

弄好了数据就可以使用ggplot2画图了。为了让图像好看，我调整了图像的属性，比如圆圈的大小范围，学习加边框，学习图中加文字（annotate）等语法。但我现在感觉还是有一些地方能够微调改进。

最后使用animation包中的saveMovie函数，结合ffmpeg导出成了一个视频。

最后附上[代码](https://github.com/hetong007/code4cos/tree/master/Animated%20Bubble%20Plot%20in%20R)。
