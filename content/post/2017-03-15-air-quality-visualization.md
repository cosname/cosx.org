---
title: 十行代码看到空气质量指数
date: 2017-03-15T22:25:09+00:00
author: 郎大为
slug: "air-quality-visualization"
categories:
  - 统计之都
---

### 故事部分

我错了, 我承认我是标题党, 怎么可能用十行代码完成全国三百个多个城市AQI的**抓取, 清洗与可视化呢**

我仔细数了数, 去掉注释, 一共是9行, 凑个整才是10行 耶~

空气质量指数（Air Quality Index，简称AQI）是定量描述空气质量状况的无量纲指数.

关于空气质量的段子已经层出不穷， 连呆在上海的我都已经开始关注北京的天气了:

_受朋友委托，大家帮个忙：北京人，女，26岁，未婚，1.68米，体重50公斤，英国海归。貌美，爱好健身。目前在一家世界500强做产品经理，工作稳定，年薪近90万。三环内有四套学区房，一套按揭，三套全款。 名下有一辆宝马7系，上班时开。父母均是国家领导干部。朋友和家人现在非常着急，想让介绍一个效果比较好的防霾口罩。_

正常不过三秒, [手动债见]

咳咳, 回归正题, 代码之前, 先介绍下出场的一个新包, leafletCN. [leafletCN](https://github.com/lchiffon/leafletCN) 是一个基于[leaflet](https://github.com/rstudio/leaflet)包做的大中华扩展, 优势在于有细分到**县级市**级别的区划数据, 虽然没那么准, 但是也基本能用了~

<div id="leafletcn" class="section level4">
  <p>
    <del><em>开始写本文的时候, 这玩意连个文档都没有. 作者真懒. 诶诶诶, 但截止发稿, 作者好像写了点乱七八糟的文档. omg, 中间好像隔了两个月, 我和作者一样懒.</em></del>
  </p>
  
  <p>
    AQI的数据来源于pm25.in, 网页上是一个html的表格, 可以简单的用XML的readHTMLtable来完成读取.
  </p>
  
  <p>
    <img class="wp-image-13657 size-large aligncenter" src="http://cos.name/wp-content/uploads/2017/02/web-500x345.png" width="500" height="345" srcset="http://cos.name/wp-content/uploads/2017/02/web-500x345.png 500w, http://cos.name/wp-content/uploads/2017/02/web-300x207.png 300w, http://cos.name/wp-content/uploads/2017/02/web-768x530.png 768w, http://cos.name/wp-content/uploads/2017/02/web.png 1234w" sizes="(max-width: 500px) 100vw, 500px" />
  </p>
  
  <p>
    好了, 以下是代码, 分成三个部分:
  </p>
  
  <ol>
    <li>
      载入包, 并读取网页的数据
    </li>
    <li>
      整理数据并进行命名, 包含了获取其中的城市, AQI以及将其转化为数值
    </li>
    <li>
      使用geojsonMap绘制细分到城市的污染情况
    </li>
  </ol>
  
  <p>
    这部分代码运行之后会出现一个以高德地图为底图, 可缩放可点击的地图~
  </p>
  
  <pre class="remark-code-line"><span class="hljs-keyword">library</span>(XML)
<span class="hljs-keyword">library</span>(leafletCN)
# 读取网页的表格
# Sorry for 爬了你家网站
table = readHTMLTable(<span class="hljs-string">"http://www.pm25.in/rank"</span>,  
                      encoding = <span class="hljs-string">"UTF-8"</span>, stringsAsFactors = <span class="hljs-literal">F</span>)[[<span class="hljs-number">1</span>]]

# 整理数据并命名
dat = table[ , <span class="hljs-number">2:</span><span class="hljs-number">3</span>]
names(dat) = c(<span class="hljs-string">"city"</span>,<span class="hljs-string">"AQI"</span>)
dat$AQI = as.numeric(dat$AQI)

# 调用geojsonMap进行绘制
geojsonMap(dat, <span class="hljs-string">"city"</span>,
           popup =  paste0(dat$city, <span class="hljs-string">":"</span>, dat$AQI),
           palette = <span class="hljs-string">"Reds"</span>, legendTitle = <span class="hljs-string">"AQI"</span>)</pre>
  
  <p>
    猛击图片查看这个可交互的地图吧！<br /> <a href="http://langdawei.com/reveal_slidify/cos/ldw/aqi.html"><img class="aligncenter wp-image-13675 size-large" src="http://cos.name/wp-content/uploads/2017/02/leaflet-500x280.png" width="500" height="280" srcset="http://cos.name/wp-content/uploads/2017/02/leaflet-500x280.png 500w, http://cos.name/wp-content/uploads/2017/02/leaflet-300x168.png 300w, http://cos.name/wp-content/uploads/2017/02/leaflet-768x430.png 768w, http://cos.name/wp-content/uploads/2017/02/leaflet.png 1369w" sizes="(max-width: 500px) 100vw, 500px" /></a>
  </p>
  
  <p>
    &nbsp;
  </p>
  
  <p>
    &nbsp;
  </p>
  
  <p>
    故事讲完了, 吃瓜群众们可以点转发了, 无聊的user们可以继续读<code>leafletCN</code>的使用
  </p>
  
  <p>
    leafletCN是一个基于<a href="https://github.com/rstudio/leaflet">leaflet</a>的中国扩展包, 里面保存了一些适用于中国的区域划分数据以及一些有帮助的函数, 地理区划数据来源于github的<a href="https://github.com/longwosion/geojson-map-china">geojson-map-china</a>项目. 数据细分到县级市.
  </p>
</div>

<div class="section level3">
  <h3>
    安装
  </h3>
  
  <pre>## 稳定版
 install.packages("leafletCN") 
## 开发版 
devtools::install_github("lchiffon/leafletCN")</pre>
</div>

<div class="section level3">
  <h3>
    基本使用
  </h3>
  
  <h4>
    常用的函数
  </h4>
  
  <ul>
    <li>
      <code>regionNames</code> 返回某个地图的区域名
    </li>
    <li>
      <code>demomap</code> 传入地图名绘制示例地图
    </li>
    <li>
      <code>geojsonMap</code> 将一个分层颜色图绘制在一个实时地图上
    </li>
    <li>
      <code>amap</code> 在leaflet地图上叠加高德地图
    </li>
    <li>
      <code>read.geoShape</code> 读取一个geojson的对象,保存成spdataframe,以方便leaflet调用
    </li>
    <li>
      <code>leafletGeo </code>用地图名以及一个数据框创建一个sp的对象
    </li>
  </ul>
</div>

<div class="section level3">
  <h6>
    regionNames
  </h6>
  
  <div class="section level4">
    <p>
      传入需要查看的城市名, 显示这个城市支持的区域信息, 比如查看成都:
    </p>
    
    <pre>regionNames("成都") 
[1] "成华区" "崇州市" "大邑县" "都江堰市" "金牛区" 
[6] "金堂县" "锦江区" "龙泉驿区" "彭州市" "蒲江县" 
[11] "青白江区" "青羊区" "双流县" "温江区" "武侯区" 
[16] "新都区" "新津县" "邛崃市" "郫县"</pre>
    
    <p>
      如果不传入对象, 会自动返回300多个支持的名字列表,包括各个城市,省,以及三个特殊的名字:
    </p>
    
    <ol style="list-style-type: decimal;">
      <li>
        <code>world </code>世界地图
      </li>
      <li>
        <code>china </code>中国分省份地图
      </li>
      <li>
        <code>city </code>中国分城市地图
      </li>
    </ol>
  </div>
  
  <div id="demomap" class="section level4">
    <h6>
      demomap
    </h6>
    
    <p>
      传入城市名(省名),显示这个城市(省)的示例地图
    </p>
    
    <pre>demomap("台湾")</pre>
    
    <div class="figure">
    </div>
  </div>
  
  <div id="geojsonmap" class="section level4">
    <h6>
      <img class="aligncenter wp-image-13663 size-large" src="http://cos.name/wp-content/uploads/2017/02/demo1-500x335.png" width="500" height="335" srcset="http://cos.name/wp-content/uploads/2017/02/demo1-500x335.png 500w, http://cos.name/wp-content/uploads/2017/02/demo1-300x201.png 300w, http://cos.name/wp-content/uploads/2017/02/demo1-768x514.png 768w, http://cos.name/wp-content/uploads/2017/02/demo1.png 1190w" sizes="(max-width: 500px) 100vw, 500px" />
    </h6>
    
    <h6>
      geojsonmap
    </h6>
    
    <p>
      将一个数据框显示在需要展示的地图上. 在函数中做了一些有趣的设置, leafletCN会自动匹配传入的前两个字符来寻找合适的位置进行绘制, 所以基本不需要纠结是写’上海市’还是’上海’了
    </p>
    
    <p>
      图做出来可以在上面点点点…
    </p>
    
    <pre>dat = data.frame(name = regionNames("china"),
     value = runif(34)) 
geojsonMap(dat,"china")</pre>
    
    <div class="figure">
      <img class="aligncenter wp-image-13664 size-large" src="http://cos.name/wp-content/uploads/2017/02/demo2-500x353.png" width="500" height="353" srcset="http://cos.name/wp-content/uploads/2017/02/demo2-500x353.png 500w, http://cos.name/wp-content/uploads/2017/02/demo2-300x212.png 300w, http://cos.name/wp-content/uploads/2017/02/demo2-768x543.png 768w, http://cos.name/wp-content/uploads/2017/02/demo2.png 852w" sizes="(max-width: 500px) 100vw, 500px" />
    </div>
  </div>
</div>

<div class="section level3">
  <h5>
     amap
  </h5>
  
  <div id="amap" class="section level4">
    <p>
      为leaflet叠加一个高德地图, 使用:
    </p>
    
    <pre>leaflet() %&gt;% 
    amap() %&gt;%
    addMarkers(lng = 116.3125774825, lat = 39.9707249401, 
       popup = "The birthplace of COS")</pre>
    
    <div class="figure">
      <img class="aligncenter wp-image-13665 size-large" src="http://cos.name/wp-content/uploads/2017/02/demo3-500x353.png" width="500" height="353" srcset="http://cos.name/wp-content/uploads/2017/02/demo3-500x353.png 500w, http://cos.name/wp-content/uploads/2017/02/demo3-300x212.png 300w, http://cos.name/wp-content/uploads/2017/02/demo3-768x543.png 768w, http://cos.name/wp-content/uploads/2017/02/demo3.png 856w" sizes="(max-width: 500px) 100vw, 500px" />
    </div>
  </div>
  
  <div id="read.geoshape" class="section level4">
    <h6>
      read.geoShape
    </h6>
    
    <p>
      <code>read.geoShape</code>这个函数可以把一个geojson格式的数据读取为一个<code>SpatialPolygonsDataFrame</code>对象, 方便sp或者leaflet包中的调用.
    </p>
    
    <pre>if(require(sp)){
   filePath = system.file("geojson/china.json",package = "leafletCN")
   map = read.geoShape(filePath) 
   plot(map)
}</pre>
    
    <div class="figure">
      <img class="aligncenter wp-image-13666 size-large" src="http://cos.name/wp-content/uploads/2017/02/demo4-500x365.png" width="500" height="365" srcset="http://cos.name/wp-content/uploads/2017/02/demo4-500x365.png 500w, http://cos.name/wp-content/uploads/2017/02/demo4-300x219.png 300w, http://cos.name/wp-content/uploads/2017/02/demo4.png 631w" sizes="(max-width: 500px) 100vw, 500px" />
    </div>
  </div>
  
  <div id="leafletgeo" class="section level4">
    <h6>
      leafletGeo
    </h6>
    
    <p>
      <code>leafletGeo</code>这个函数可以把一个数据框和一个地图组合在一起, 方便用leaflet调用, 其中名字的 变量为<code>name</code>, 数值的变量为<code>value</code>~
    </p>
    
    <pre>if(require(leaflet)){
  dat = data.frame(regionNames("china"),
                                runif(34))
  map = leafletGeo("china", dat)

   pal &lt;- colorNumeric(
     palette = "Blues",
     domain = map$value)

  leaflet(map) %&gt;% addTiles() %&gt;%
     addPolygons(stroke = TRUE,
     smoothFactor = 1,
     fillOpacity = 0.7,
     weight = 1,
     color = ~pal(value),
     popup = ~htmltools::htmlEscape(popup)
     ) %&gt;%
   addLegend("bottomright", pal = pal, values = ~value,
                        title = "legendTitle",
                 labFormat = leaflet::labelFormat(prefix = ""),
                 opacity = 1)
}</pre>
    
    <div class="figure">
      <img class="aligncenter wp-image-13667 size-large" src="http://cos.name/wp-content/uploads/2017/02/demo5-500x354.png" width="500" height="354" srcset="http://cos.name/wp-content/uploads/2017/02/demo5-500x354.png 500w, http://cos.name/wp-content/uploads/2017/02/demo5-300x213.png 300w, http://cos.name/wp-content/uploads/2017/02/demo5-768x544.png 768w, http://cos.name/wp-content/uploads/2017/02/demo5.png 847w" sizes="(max-width: 500px) 100vw, 500px" />
    </div>
  </div>
  
  <p>
    &nbsp;
  </p>
  
  <p>
    &nbsp;
  </p>
  
  <p>
    如果你看到这里还没有走, 说明你还是有心找彩蛋的, 或者你什么都没看, 但是本文没啥彩蛋, 只有我的<a href="http://github.com/lchiffon/leafletCN">github求赞</a>.
  </p>
  
  <p>
    然后, 如果想了解leafletCN背后强大的leaflet家族, 可以查看它的<a href="http://rstudio.github.com/leaflet">官方文档</a>, 或者我写的这个<a href="http://langdawei.com/leafletIntro/leafletSlides.html">小分享</a>.
  </p>
  
  <p>
    祝你也早日成为地图狂魔!
  </p>
  
  <p>
    &nbsp;
  </p>
</div>
