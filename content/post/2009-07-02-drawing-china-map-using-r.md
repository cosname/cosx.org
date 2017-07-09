---
title: 用R软件绘制中国分省市地图
date: '2009-07-02T13:25:03+00:00'
author: 邱怡轩
categories:
  - 推荐文章
  - 统计之都
  - 统计软件
tags:
  - GIS数据
  - R软件
  - 中国地图
slug: drawing-china-map-using-r
forum_id: 418798
---

>【注】新版本的`maptools`包对很多函数进行了修改，对于修改的内容，文章中用粗体文字进行了说明。

鉴于最近有不少人在讨论用R软件绘制地图的问题，我也就跟着凑了凑热闹，对相应的方法学习了一番。下面的这篇文章是一个初步的介绍，还有很多内容仍在学习和探索中，如果大家有什么意见或建议，我将根据自己学习的情况对文章进行进一步的补充。

在R中绘制地图其实是十分方便的，最直接的办法大概就是安装`maps`和`mapdata`这两个包，然后输入下面的命令：

```r
library(maps)
library(mapdata)
map("china")
```

其中`map()`函数还可以加上很多参数，在这里就不一一详述，具体的用法只需问号之。然而仔细看一看这张地图你会发现重庆市和四川省仍然是浑然一体，可见该地图的数据应该是有些年头了。<!--more-->

幸运的是，通过[谢益辉的这篇博文](http://yihui.name/cn/2007/09/china-map-at-province-level/ "终于搞定了中国分省市地图")我们已经可以大体知道该如何操作了，下面就为大家介绍一下具体的步骤。

首先，从[这里](https://uploads.cosx.org/2009/07/chinaprovinceborderdata_tar_gz.zip)下载中国地图的GIS数据，这是一个压缩包，完全解压后包含三个文件（bou2\_4p.dbf、bou2\_4p.shp和bou2\_4p.shx），将这三个文件解压到同一个目录下，并在R中设好相应的工作空间，然后安装`maptools`包，运行如下程序：

```r
library(maptools);
x=read.shape('bou2_4p.shp');#下文中会继续用到x这个变量，
                            #如果你用的是其它的名称，
                            #请在下文的程序中也进行相应的改动。
plot(x);
```

**【修改】新版本的maptools包不再提供read.shape()函数，请用readShapePoly()代替。**

这时一张完整的中国地图就已经画好了。但是在实际使用的过程中，我们往往会根据自己的需要对地图中的某些省份着以特定的颜色，这时就可以通过调节`plot`命令中的`fg`参数来予以实现。然而为了清楚地说明这部分的内容，我需要插播一段R绘制地图的原理。

<p style="text-align: center;">
  ======================传说中的分割线=====================
</p>

在绘制地图时，每一个省市自治区或者岛屿都是用一个多边形来表示的。之前的GIS数据，其实就是提供了每一个行政区其多边形逐点的坐标，然后R软件通过顺次连接这些坐标，就绘制出了一个多边形区域。在上面的数据中，一共包含了925个多边形的信息，之所以有这么多是因为一些省份有很多小的附属岛屿。在这925个多边形中，每一个都对应一个唯一的ID，编号分别从1到925。

<p style="text-align: center;">
  ======================传说中的分割线=====================
</p>

回到刚才的话题，`plot`命令中的`fg`参数在本例中应该是一个长度为925的向量，其第i个分量的取值就代表了地图中第i个多边形的颜色。一个简单的尝试是运行下面这个命令看看效果：

```r
plot(x,fg=gray(924:0/924));
```

**【修改】新版本的`maptools`包的绘图参数也有所改变，请将`fg`换成`col`。**

于是自然就产生了一个问题：如何获取某一个特定地区的ID，进而设置我们想要的颜色？事实上，在变量x中，就已经存储了我们想要的信息。在R中输入“`x[[2]]`”或“`x$att.data`”，会得到一个925行7列的数据框，这其实是bou2_4p.dbf这个文件中存储的信息，之前的`read.shape()`函数虽然读取的是bou2_4p.shp文件，但在默认情况下会把dbf文件的信息也放到变量之中。对于这个数据框，其行名就是每一个区域的ID编号，第一列和第二列分别是面积和周长，最后一列是该区域所属的行政区名，其它的列应该也是一些编号性质的变量。于是，通过查找相应的行政区对应的行名，就可以对`fg`参数进行赋值了。下面是我编的一个函数，用来生成所需的`fg`向量：

```r
getColor = function(mapdata, provname, provcol, othercol){
	f = function(x, y) ifelse(x %in% y, which(y == x), 0);
	colIndex = sapply(mapdata$att.data$NAME, f, provname);
	fg = c(othercol, provcol)[colIndex + 1];
	return(fg);
}
```

**【修改】地图数据的组织形式有所变化，上面函数中的`mapdata$att.data$NAME`需要替换为`mapdata@data$NAME`。**

其中`mapdata`是存放地图数据的变量，在上面的例子中就是x，`provname`是需要改变颜色的地区的名称，`provcol`是对应于`provname`的代表颜色的向量（名称和数字均可），`othercol`是其它地区的颜色。举例如下：

```r
provname = c("北京市", "天津市", "上海市", "重庆市");
provcol = c("red", "green", "yellow", "purple");
plot(x, fg = getColor(x, provname, provcol, "white"));
```

![map00](https://uploads.cosx.org/2009/07/map00-e1262748931991.png "map00")

注意`provname`一定要写地区的全称，写法可以参照下面这条命令生成的向量：

```r
as.character(na.omit(unique(x$att.data$NAME)));
```

由此生成的向量有33个元素，少了澳门特别行政区，这是这个数据中的一块瑕疵。在`x$att.data`的第899行有一个`NA`，不知道它代表的是否就是澳门。

利用类似的方法就可以根据自己的需要对不同的区域进行着色，下面再举一例。从国家统计局获取2007年我国各地区的人口数据，然后根据人口的多少对各省份进行着色。程序如下：

```r
provname = c("北京市", "天津市", "河北省", "山西省", "内蒙古自治区",
		"辽宁省", "吉林省", "黑龙江省", "上海市", "江苏省",
		"浙江省", "安徽省", "福建省", "江西省", "山东省",
		"河南省", "湖北省", "湖南省", "广东省",
		"广西壮族自治区", "海南省", "重庆市", "四川省", "贵州省",
		"云南省", "西藏自治区", "陕西省", "甘肃省", "青海省",
		"宁夏回族自治区", "新疆维吾尔自治区", "台湾省",
		"香港特别行政区");
pop = c(1633, 1115, 6943, 3393, 2405, 4298, 2730, 3824, 1858, 7625,
		5060, 6118, 3581, 4368, 9367, 9360, 5699, 6355, 9449,
		4768, 845, 2816, 8127, 3762, 4514, 284, 3748, 2617,
		552, 610, 2095, 2296, 693);
provcol = rgb(red = 1 - pop/max(pop)/2, green = 1-pop/max(pop)/2, blue = 0);
plot(x, fg = getColor(x, provname, provcol, "white"), xlab = "", ylab = "");
```

![map01](https://uploads.cosx.org/2009/07/map01-e1262748729327.png "map01")

其中颜色越深的地方代表人口数越多，反之为人口数越少。

此外，在绘制地图的过程中，还有一个比较有用的参数是`recs`，它是一个由多边形ID组成的向量，表示在地图中只画出这些ID所代表的区域。利用这个参数，就可以画出某一部分的地图，例如下面的例子是我国中部六省的地图：

```r
getID = function(mapdata, provname){
	index = mapdata$att.data$NAME %in% provname;
	ids = rownames(mapdata$att.data[index, ]);
	return(as.numeric(ids));
}
midchina = c("河南省", "山西省", "湖北省", "安徽省", "湖南省", "江西省");
plot(x, recs = getID(x, midchina), fg = "green", ol = "white", xlab = "",
		ylab = "");
```

![map02](https://uploads.cosx.org/2009/07/map02-e1262748890424.png "map02")

上面的`getID()`是我编写的一个功能与`getColor()`类似的函数，用来返回指定省份的ID。

**【修改】新版本的`maptools`包的绘图函数已经取消了`recs`这个参数，现在要实现这个功能，可以在颜色上把不需要的省份变成白色，其中填充色用`col`参数，边界颜色用`border`参数。例如上面的例子可以用下面的函数来实现：**

```r
plot(x, col = getColor(x, midchina, rep("green", 6),
    "white"), border = "white", xlab = "", ylab = "")
```

最后要说的是，在画出的图上仍然可以用`points()`函数和`text()`函数加上点和文字，而`maptools`包中还提供了一个`pointLabel()`函数，用来解决文本标签的重叠问题。这部分内容请参阅博文：[用R画中国地图并标注城市位置](http://yihui.name/cn/2008/10/china-map-and-city-locations-with-r/)，以及[避免文本标签重叠：maptools中的pointLabel()](http://yihui.name/cn/2008/10/avoid-label-overlap-pointlabel-in-maptools/)。

从以上的内容来看，本文所述的都是一些最基本的绘图方法，还没有对地理信息数据进行更进一步的分析。如果有机会的话，这一主题的下一篇文章将为大家介绍地图数据的组成结构，并说明如何将不同格式的地理数据整合起来，例如如何在上面的地图上绘制出我国的铁路、水系分布等内容。
