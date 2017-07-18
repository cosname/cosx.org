---
title: Google Visualization API 与在线数据分析
date: '2009-02-13T15:28:24+00:00'
author: 齐韬
categories:
  - 统计图形
  - 统计软件
tags:
  - Dymatic Graphic
  - Google
  - Online Data Analysis
  - Visualization API
slug: google-visualization-api-and-data-analysis-online
forum_id: 418769
---

![Visualization API](https://uploads.cosx.org/2009/02/gviz1.jpg)

近日Google推出了Google Visualization API为在线数据分析开拓了一条崭新的道路。这个项目的初衷就是希望提供一种灵活的在线数据分析的解决方案。之前的名声大噪的Google Map API已经应用到国内的许多诸如地图查询，导航信息，GIS等等诸多领域。也许你也曾是其中一员或将要成为其中一员呢。回过头来，Visualization API则将重点放在数据的探索性分析与结果的展现上。虽然现在没有提供丰富的分析类库，但是在不久的将来，功能强大的在线分析软件，甚至在线开发平台都将不再遥不可及。

下面我将给大家推荐一个Visualization API的实例，然后告诉大家如何把它应用到自己的博客或是主页上。把自己的统计分析结果放到网上供大家分享，这是多么有意思的一件事啊。既然是说API，也就是说任何人都可以创造自己的代码。这一点和R很相似啊。好了，先看看我们该从哪里开始呢？先去Google Visualization API的官方页面看看吧，了解一下基本的情况。<http://code.google.com/apis/visualization/>

在范例中随便找一个实例，如下：

```html
<script type="text/javascript" src="http://www.google.com/jsapi"></script>
 <script type="text/javascript">
 google.load('visualization', '1', {packages: ['motionchart']});
 function drawVisualization() {
 new google.visualization.Query(
 'http://spreadsheets.google.com/tq?key=pCQbetd-CptE1ZQeQk8LoNw').send(
 function(response) {
 new google.visualization.MotionChart(
 document.getElementById('visualization')).
 draw(response.getDataTable(), {'width': 800, 'height': 400});
 });
 }
 google.setOnLoadCallback(drawVisualization);
 </script>
```

登陆到你的博客，比如<http://chesswave.blogspot.com> 在博客布局->模板中`<head>`后面添加上面的代码。

创建一个新日志，在html模式下，添加

```html
<div id="visualization" style="width: 800px; height: 400px;"></div>
```

大功告成。很简单吧。

![Google Visualization API Sample](https://uploads.cosx.org/2009/02/google_sample.bmp)

动态图的优势一览无余。
