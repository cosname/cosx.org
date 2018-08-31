---
title: use R for fun系列之玩转图像篇
date: '2013-09-01T12:35:13+00:00'
author: 刘辰昂
categories:
  - 推荐文章
  - 统计图形
tags:
  - biOps
  - EBImage
  - fun
  - R语言
  - 图像处理
slug: cos-series-use-r-for-fun-image
forum_id: 418964
---

系列以use R for fun为主题，以[COS论坛](https://cos.name/cn/)上的精华帖、相关package以及自己的一些code为素材，结合自身的一些编程体会，从而整合成文。本文是第三篇[玩转图像篇](http://chenangliu.info/cn/use-r-for-fun-image/)。

**本文素材出处均已在正文中注明**

接着for fun的话题往下讲，大家或多或少都曾经用过PS来玩过图片，其强大的功能令我们不得不赞叹，无论是美图还是是恶搞都曾给我们带来了不少的乐趣。今天我们就要让这种乐趣在万能的R中实现！当然实现的过程是艰辛的，因为这一切一部分需要依靠自己码代码，但同时也是轻松的，因为与之前不同的是这里开始涉及到很多其他的扩展包，带来了很大的便利，接下来会一一介绍。<!--more-->

# 1 从画一张红色毛爷爷说起

<!-- ![More...](http://chenangliu.info/cn/wp-includes/js/tinymce/plugins/wordpress/img/trans.gif) -->

关于这一篇得先从一张红色毛爷爷说起，有一次跟朋友聊天谈起无比艰辛的生活，聊着聊着那哥们就开始质疑R的作图功能，突然冒了一句R能画张人民币出来么，我一想这不简轻松加愉快么，网上下张图片读进去不就完了(具体读图方法后面会讲)，结果那哥们也不是白痴，跟了一句一定要画不能读图而且不能用扩展包，听起来好像有点难度，于是就在完全不考虑代码美观性的前提下三下五除二码了一段交了差，画出来了一张高仿假钞，还顺便借这玩意去某论坛刷了下人气(好吧确实有点猥琐)。

```r
r <-read.table("r100.txt",header=F);
g <-read.table("g100.txt",header=F);
b <-read.table("b100.txt",header=F);
r <- t(r);r <-r[,ncol(r):1];
g <- t(g);g <- g[,ncol(g):1];
b <- t(b);b <- b[,ncol(b):1];
par(mar=rep(0, 4));
Rcolor1 <- rgb(1:255,0,0,alpha=120,maxColorValue=255);
Rcolor2 <- rgb(0,1:255,0,alpha=80,maxColorValue=255);
Rcolor3 <- rgb(0,0,1:255,alpha=30,maxColorValue=255);
image(1:457,1:225,r,col=Rcolor1,add=F,axes=F,ann=F);
image(1:457,1:225,g,col=Rcolor2,add=T,axes=F,ann=F);
image(1:457,1:225,b,col=Rcolor3,add=T,axes=F,ann=F);
```

其实代码非常水，是一个非常典型的反面教材。而且从某种意义上讲是一种耍赖行为，因为没说不能读数据于是我就光明正大的把RGB矩阵给读了进来，最后借助了颜色图也就是image函数(该函数在之后的文章中会有比较高的出场频率)。
  
![100rmb](https://github.com/StevenBoys/photo/blob/master/100rmb.png?raw=true)

这里简单介绍一下颜色图和image函数，颜色图本质上是一种网格图，每个网格可以展示一种颜色，正是因为这一特点，它可以用于在平面上展示三维数据，很多时候将其与等高图结合使用描述地理信息时往往会有非常不错的视觉效果。不过在这里就被我用来画位图了，即把每一个网格当成一个像素点，通过读进来的颜色矩阵来上色。关于image函数，不妨先来看看它的用法

```r
image(x, y, z, zlim, xlim, ylim, col = heat.colors(12),
add = FALSE, xaxs = "i", yaxs = "i", xlab, ylab,
breaks, oldstyle = FALSE, useRaster, ...)
```

参数x、y、z与等高线的参数类似，x和y相当于横纵坐标(数值向量)，用于划分网格，z则是对应的矩阵，也就是每一格对应一个数字。此外还可以通过把x,y,z整合成列表的形式赋予函数，因此它是一个泛型函数。col参数用于设置颜色，可以通过某些特定的颜色主题生成，如rainbow()等，缺省值是heat.colors(12)，生成的颜色序列会根据z中的数据对应填充到每一个格子中。另一个重要参数是add，当然add 为TRUE 是，image就会成为低级绘图函数在原图上添加(故此时必须有已经打开的作图设备)，为FALSE则具有高级绘图的功能，缺省值FALSE。剩余参数含义大多与plot()中参数含义无异，这里不再赘述。

掌握一个函数光靠看了usage是没用的，很快就会忘掉，因此最快最有效的方法就是通过一个富有趣味性的例子，于是这里冒着离题的风险盗用帮助文档中与等高图(contour函数)结合的示例来给大家加深印象：

```r
x <- 10*(1:nrow(volcano))
y <- 10*(1:ncol(volcano))
image(x,y,volcano,col=terrain.colors(100),axes=FALSE)
contour(x,y,volcano,levels = seq(90, 200, by = 5),
add=TRUE, col="peru")
axis(1,at=seq(100,800,by = 100))
axis(2,at=seq(100,600,by = 100))
box()
title(main="Maunga Whau Volcano",font.main = 4)
```

# 2 把图片读进来

玩图片的第一步自然就是把图给读进来，读图的方法R倒是提供了不少，光package就有n多个。这里主要提一提专门用来读图的包(指除读写外基本没有其他的图片处理扩展功能)，我在CRAN上初步找了一下主要有这么几个，可以那面向的图片格式分为两类，第一类是专注于某一种格式的包，分别有jpeg、png、tiff、bmp三个包，这几个包分别只能读自己名字所对应的图片格式，相信这几种格式大家都不陌生了，都比较常用，而且除bmp外，都出自同一人之手(Simon Urbanek)所以函数用法什么的都基本一致故而非常好记，不妨以jpeg为例，读图函数readJPEG(另外对应的readPNG和readTIFF则参数更多一些)的用法为

```r
readJPEG(source, native = FALSE)
```

source比较容易理解即目标对象的路径，而native则有必要简单解释下，它主要影响到图片读进来后存储的内容，如果是FALSE那么读进来后就是一个数组，取值均在0,1之间，这样也就便于我们之后的处理，所以一般都采用缺省值(F)，但如果选择了TRUE则返回的对象为nativeRaster类，它的优点在于很容易通过rasterImage()把图绘制出来。举个例子

```r
library(jpeg);
img <- readJPEG(system.file("img","Rlogo.jpg",package="jpeg"))
img.n <- readJPEG(system.file("img","Rlogo.jpg",package="jpeg"),TRUE)
```

读者不妨可以看看这两者之间的区别。bmp包略有不同，对应的函数名为read.bmp()，用法为

```r
read.bmp(f, Verbose = FALSE)
```

f类似于source，Verbose指是否给出详细警告，一般采用默认的F。接下来顺便提一下raster和rasterImage()函数，Raster 是R 中用于展示位图的一类对象，与matrix、vector等类似，is.raster和as.raster 可以分别用于判别和转换，而rasterImage()则事实上是一个低级作图函数，可以看一下他的用法

```r
rasterImage(image,
xleft, ybottom, xright, ytop,
angle = 0, interpolate = TRUE, ...)
```

image的对象必须是raster或者可以通过as.raster强行转换，中间四个参数指定了绘制的区域，含义可直接根据字面意思理解，angle 指的是旋转的角度，默认是不旋转也就是0，interpolate则是询问是否插值。

```r
plot(1:2,type="n");
rasterImage(img.n,1.2,1.27,1.8,1.73,angle=30);
```

除此之外剩下的一个就是readbitmap包(目前依赖于上述三个包)包，它的特点在于可以同时包含出tiff之外的三种格式了，同样通过例子来看一看它的用法

```r
read.bitmap(f, channel, IdentifyByExtension = FALSE, ...)
```

两者相比只能说各有优势吧，孰好孰坏这里就不妄下定论了，毕竟笔者也不太专业只是本着玩的心态来看故而从不执着于此。此外值得一提的是，关于bmp包其目前支持的bmp 格式局限于8位的灰度图和24、32位的RGB图，另外它与jpeg、png和tiff包还有一点不同的是该包的实现仅仅依靠R本身而并没有外部依赖(jpeg和png分别依赖于libjpeg和libpng库)，关于上述扩展包的具体信息在帮助文档中都有叙述(部分包中还包含实现判别格式等功能的函数)，其中文档中的一些相对专业的概念一方面为防止跑题另一方面也为了防止误导故本文并未涉及，读者可自行查看。

除了本节所说的这些，事实上在之后提到的几个综合性的玩图的包中也都包含了这些功能，后面会简单提到。

# 3 聊一聊图形设备

只要用过R的相信对图形设备一点都不陌生，前两篇的问世大多也大多仰仗于R强大的图形设备，所以在具体阐述之前，得先把常用的几个图形设备函数罗列了一下，供大家参考，当然还是那句老话，欲知详情，烦请help

```
dev.new()：创建新的图形窗口
dev.cur()：显示当前的图形窗口
dev.list()：查看图形窗列表口
dev.next()：下一个图形窗口
dev.prev()：上一个图形窗口
dev.set(which=dev.next())：切换下一个图形窗口为当前图形窗口
dev.off()：关闭当前图形窗口
graphics.off()：关闭所有图形窗口
```

因为后面各式各样的图片效果会比较多，所以难免会需要同时打开多个图形窗口，如果读者跟着我的步伐一起玩的话，掌握这几条最基本的命令是很有必要的。然后就正式切入正题！

# 4 有一个包名叫biOps

其实写这篇文章最初的动力就来自于这个包，事实上在这之前还有一个图像处理的包rimage，可惜因为本人接触R的时间比较短，等我开始玩R的时候这个包早已离我而去了，还有ripa包什么的现在也早已都通通不见了踪影，如今还在CRAN上坚强的活着的还算完整的包基本也就只剩下biOps了。

关于它的安装，笔者安装时并没有出现什么问题，所以也并没有去留意具体安装方面的注意事项，如果安装出现错误不妨参考下COS论坛上的这个[帖子](https://cos.name/cn/topic/16346)，如果是其他的错误那就只能麻烦自行google之了。

从帮助文档来看，它的功能很强大，因为函数众多，光函数列表就列了三页，也算是一个集大成之作了(但其实有很多函数都是功能重复的并没有存在的必要，后面提到的EBImage 则走的是简洁路线，各有特点)，它的历史也算是比较“悠久”了，估计也是各种继承了前人的血汗造福我们这种后辈，小的在此谢过。但也非常遗憾这么“好”的包却没有一篇好的小品文来指导我们(我只能说包实在是太混乱了)，着实让我伤心不已，于是就只能谨遵伟大领袖毛主席的教诲“自己动手，丰衣足食”，根据帮助文档来简单整理一下仅供参考。另外肖凯老师也有一篇博文提到这个包，参考[这里](http://xccds.github.io/2012/06/r_27.html/)。

## 4.1 读、写那些事

包中所带的读图函数为readJpeg()和readTiff()，参数只有一个就是文件，依赖于libtiff和libjpeg库，对应的还有writeJpeg()和writeTiff()作用和原理我想也没必要再说了吧，至于图像的展示该包则是提供了plot.imagedata()函数。

```r
ima <- readJpeg(system.file("samples","violet.jpg",package="biOps"))
plot(ima)
```

![violet1](https://github.com/StevenBoys/photo/blob/master/violet1.png?raw=true)

## 4.2 简单的啰嗦一下空间变换

空间变换包括了放缩旋转等，之前也提到了完成这些大多得依赖于插值实现，而插值的方式有不少一般比较常用的有最近邻、双线性以及样条等等，各有优势也各有致命伤。biOps在这方面就做的很全面，例如做旋转，就有针对各种插值方式的imgCubicRotate()、imgBilinearRotate()、imgNearestNeighborRotate()、img-SplineRotate()等(见名思意即可)函数，参数均只有一个angle，指的是顺时针旋转的角度，当然如果觉得记这么多函数名麻烦的话，包中还有一个imgRotate()函数则是集合了上述函数的功能，多了一个参数interpolation用于选择插值方式(nearest neighbor, bilinear, cubic, spline)。

```r
x <- readJpeg(system.file("samples","violet.jpg",package="biOps"))
y <- imgRotate(x,45,"spline")
plot(y);
```

![violet2](https://github.com/StevenBoys/photo/blob/master/violet2.png?raw=true)

此外如果是放缩只需把上述函数名后的Rotate改成Scale就OK了，类似的也有imgScale()函数是一个综合的函数，同样的interpolation 参数用于选择插值方式(一般用于放大)。同时开发者们本着宁缺毋滥的精神还提供了imgAverageShrink()和imgMedianShrink()主要用于缩小。除旋转放缩外，切割图像用的是imgCrop()函数，例如

```r
y <- imgCrop(x,100,50,100,50);
```

## 4.3 关于色彩

imageType()函数可以用来判别图片的颜色类型(RGB与灰度)，而imgRGB2Grey()则可以将RGB图转换为灰度图(其实这点非常有用)。

```r
imageType(x);
y <- imgRGB2Grey(x);
plot(y);
```

而图像的对比度、亮度分别可以通过imgDecreaseContrast, imgDecreaseIntensity(把Decrease改成Increase就是增加)实现，imgGamma则用于伽马校正。

如果需要提取RGB图中某一颜色的矩阵，则可以分别通过imgRedBand(x)等函数(换中间的单词即可)实现，如

```r
imgBlueBand(x);
plot(imgBlueBand(x));
```

则是提取了图中的蓝色，但注意画出来的图可不是蓝色的哦。

## 4.4 来点实在的糟蹋——滤镜

对于玩图这件事情包中提供了大量img系列函数(当然也包括之前提到的)，让人应接不暇，而滤镜自然是最值得倒腾的(前面其实已经设涉及到一些)，相信玩过PS的应该对滤镜一点都不陌生，于是笔者就挑一些既简单又好玩的与大家分享。

### 4.4.1 最简单的模糊与锐化

模糊和锐化不出意外应该是最为人熟知的滤镜了，他们的实现方法也不难，一般都是通过取平均值减少相邻像素间的差异从而柔化图像。当然这么简单的工作自己写程序就太浪费时间浪费生命了，biOps的作者们已经给我们备好了函数imgBlur()和imgSharpen()，用起来很方便

```r
y1 <- imgBlur(x)
plot(y2);
dev.new();
y2 <- imgSharpen(x,2)
plot(y2);
```

但是也有一个不能容忍的地方就是它的灵活性实在是太差了，主要体现在滤波器掩模的选择上，例如模糊仅仅提供了一种选择，而锐化则只有三种(实在是无力吐槽啊)，所以说简洁很多时候还是得付出代价，不过这并不意味着当函数满足不了我们的时候就得自己码代码，因为biOps中的imgConvolve()函数事实上包含了上述功能(模糊和锐化属于卷积处理)，另外后面隆重推出的EBImage也能解决这个问题(鼓掌! )。

### 4.4.2 浮雕效果

所谓浮雕效果就是通过勾画图象轮廓和降低周围像素颜色值,从而体现出有凹凸感。其原理是对图像的每一个点进行卷积处理，跟刚刚所说的模糊和锐化最大的区别即在于滤波器掩模(一般是三乘三矩阵)的选择上，当然同样没必要自己去码，刚刚提到的imgConvolve()函数可以帮你排忧解难。一个例子说明一切

```r
m <- matrix(c(1,0,0,0,0,0,0,0,-1),3,3)
y <- imgConvolve(x,m,12)
plot(y)
```

m即为所用到的滤波器掩模，如此一来，明显的浮雕效果就出来了。

![violetfudiao](https://github.com/StevenBoys/photo/blob/master/violetfudiao.png?raw=true)

如果还想玩的再high一点的话，那就不妨用这招给自己做枚纪念币？

### 4.4.3 添加杂色

很多时候杂色也是不可或缺的，添加程度的不同效果也会有明显的差异，函数imgGaussianNoise可用于添加高斯杂色

```r
y <- imgGaussianNoise(x,0,200);
plot(y)
```

![violetrain](https://github.com/StevenBoys/photo/blob/master/violetrain.png?raw=true)
  
是否能看出一丝下雨的效果呢？

### 4.4.4 边缘探测

边缘探测(Edge Detection)常见于遥感，即针对遥感图像的分析，既如此那么边缘探测的算法也则必然是一个很重要的角色，因此biOps包的作者们往包里塞了一大坨的各式各样的边缘探测的函数唯恐遗漏，不同的函数算法大多不同， 故请自行help或google。

![violetedge](https://github.com/StevenBoys/photo/blob/master/violetedge.png?raw=true)

如此并勾勒出了大致的轮廓，看起来效果还是很不错的。稍作改动也可以做出壁画的感觉

![violetbihua](https://github.com/StevenBoys/photo/blob/master/violetbihua.png?raw=true)

### 4.4.5 素描效果

这条来自于轩哥博客，算法也略微要复杂些，在他博文中有详细的说明和代码，感兴趣的读者请猛戳[这里](http://yixuan.cos.name/cn/2010/05/processing-pictures-with-a-pencil-sketch-effect-using-r/) ，但千万不要复制下来直接跑，不要忘了rimage已经不复存在了，至于怎么改的问题看了前文这里应该不需要多说了吧。顺便盗用一下效果图
  
![pencil2](https://github.com/StevenBoys/photo/blob/master/pencil2.jpg?raw=true) 

![pencil1](https://github.com/StevenBoys/photo/blob/master/pencil1.jpg?raw=true)

由于很多功能与接下来介绍的EBImage包重复，故某些地方并未详细叙述，此外由于函数众多且很多函数的存在实在是没必要(并且解释也及其简单)所以并无法面面俱到，所以希望进一步了解的可以自行参考帮助文档或者google。跟biOps包有着紧密联系的还有一个biOpsGUI 包。biOpsGUI 提供了一个GUI 用于展示图片，需要GTK+ 的支持，也就是得事先安装RGtk2包，他的优点在于展示图片方便，而且鼠标所到支出可以返回该点的坐标和颜色值(RGB)，缺点则是除此之外就没什么其他功能了，仅仅是一个展示。用帮助文档中所给的例子也就足以说明一切了。

```r
x <- readJpeg(system.file("samples", "violet.jpg", package="biOps"));
imgDisplay(x);
```

读者可自行查看效果。

# 5 有时候CRAN并非最佳选择——EBImage

看完了CRAN中的图像处理包biOps，优点不少但槽点也实在是略多，充分体现了理想与现实的差距，所以这里我们不妨把视角转移R的另一大软件包仓库——bioconductor，或许不从事生物信息学或者医学统计的朋友对此并不熟悉。事实上在bioconductor上给我们提供了非常好的资源有好的数据也有好的程序，谢大对其也有着非常高的评价。所谓统计的都是相通的(当然玩也是想通的)，bioconductor上的也并不是只有搞生统的才能用，因此这里也借EBImage包简单介绍一下bioconductor的使用。

bioconductor的一大好处在于它的包基本都配有小品文(Vignettes)，个人觉得小品文可以很好的帮助我们理清包的思路以及主要函数的用法(如果写的好的话)，这对快速的上手有着很大的帮助，因为帮助文档的函数都是按首字母排序的，学习起来会没有条理(与带给我强烈坑爹感的biOps形成鲜明对比)。

先从包的安装说起，bioconductor中包的安装与CRAN略有不同，每次在安装包之前需要额外运行一段脚本biocLite.R，该脚本存放在官网上，运行之后就可以进行安装，安装函数也略有不同，这里使用的是biocLite()即相当于我们平时常用的install.package函数，以EBImage包为例，就可以通过如下代码进行安装：

```r
source("http://bioconductor.org/biocLite.R")
biocLite("EBImage")
```

事实上在每个包的主页上都会有关于安装的说明，此外还有其他相关的信息，内容结构大致与CRAN相同(Document的内容更丰富了些)，按需下载即可。

接下来简单说说EBImage的十八般武艺(内容大多来源于文档的翻译，所以使用过该包的读者可以略过此段)。

## 5.1 图片的读、显、写

该包作者给它的定位是一个在R中图像处理和分析的工具包，既然如此那处理图像最基本的三件事同样也是必不可少，图片的读取前面已经提了不少，CRAN的包也纷纷各显神通，EBImage自然也自带了一个，就是readImage()函数，它既可以读取本地文件中的图片也可以读取网络中的图片(url)，不过目前支持的格式并不多，只有JPEG、PNG、TIFF三种，但其实也足够用了，我们平时所用的图片格式其实也基本不外乎这几种。举个例子

```r
pic <- system.file("images","lena-color.png",package="EBImage")
lenac <- readImage(pic)
```

读进去了之后还得显示出来，当然包的作者也是不会把这茬给漏掉的，display()函数就承担起了这一历史使命。接着上面的代码我们继续写下

```r
display(lenac)
```

运行之后一个美女就出现了(换个口味这节就以她为素材了)，而且估计大家也不会陌生，她的出境频率的确是很高(lena就是她的名字，是一个瑞典模特，为防止跑题故请欲知详情者自行google)。值得一提的是，默认的显示方式是在电脑的默认浏览器中显示也就是网页显示，如果需要在R 的作图窗口中显示则需要把display函数中method参数改为raster，即

```r
display(lenac,method="raster")
```

![lenac](https://github.com/StevenBoys/photo/blob/master/lenac.png?raw=true)

写入图片可以通过writeImage()函数实现，文件格式可以通过文件扩展名推断。事实上这一功能也是用来实现图片格式转换的一个不错方式，比方说下面这句命令就在眨眼之间把图片从png转换成了jpeg格式。

```r
writeImage(lenac,"lenac.jpeg",quality=85)
```

这里quality参数指的就是图片的质量，缺省值是100。

## 5.2 再谈图像矩阵

同样在这里也不免俗的通过多维数组来存储图像。因此正是因为这一点，我们同样可以通过一些很简单的语句来把原本好端端的一幅美图给糟蹋掉。远的不说，就是最基本的加减乘除就可以做到，接着之前的代码

```r
lenac1 <- lenac+0.5
lenac2 <- 3*lenac
lenac3 <- (0.2+lenac)^3
```

温馨提示下定决心看效果图前请保护好你的双眼。相比不用多说大家也应该大致明白了这几条命令的意义了，”\verb|+|”可以调整图片的亮度(如果对RGB有一定了解的相信对这些用法都不难理解)，”\verb|\*|”用来调整图片对比度，而”\verb|^|”则是可以用来控制gamma 校正参数。这也进一步说明了biOps中有些函数的的确确太多余了。当然还不止这些，不妨再列举三条

```r
lena <- system.file("images", "lena.png", package="EBImage");
lena <- readImage(lena);
lena4 <- lena[299:376, 224:301];
lenac5 <- lenac > 0.2;
lena6 <- t(lena);
```

这几条怕是不用说大家也能知道是怎么回事了，相比而言取个阈值出来的效果更带感一点(读者可自行把该命令用于彩色图中，同样请保护双眼)。

![lenac2](https://github.com/StevenBoys/photo/blob/master/lenac2.png?raw=true)

是不是能看出一点剪纸效果呢？此外该包还提供了combine()函数用于多重画面的制作，例如

```r
lenacomb <- combine(lenac, lenac+0.1, lenac+0.2, lenac+0.4)
display(lenacomb,method="raster",all=T)
```

![lenac3](https://github.com/StevenBoys/photo/blob/master/lenac3.png?raw=true)

需要注意的是如果这里不选择浏览器显示，那么参数all一定要改为TRUE即显示全部图片，否则只会显示第一张图。

## 5.3 再来试试最简单的空间变换

这几招在之前也早已都玩过了，不过这里还是要简单提一下，毕竟一句命令解决问题的事情，多一种方法多一条路，方便好记何乐而不为呢？

```r
lenac7 <- rotate(lenac, 30)
lenac8 <- translate(lenac, c(40, 70))
lenac9 <- flip(lenac)
lenacomb <- combine(lenac, lenac7, lenac8, lenac9)
display(lenacomb,method="raster",all=T)
```

![lenac4](https://github.com/StevenBoys/photo/blob/master/lenac4.png?raw=true)

不过按照惯例最后多嘴一句，这些函数同样可以用在常规的矩阵操作上(因为本质就是对矩阵操作)。

## 5.4 颜色管理

不知大家是否了解通道这一概念，不过不了解也无妨，这里只需对颜色模式有一定了解就行了，这里提供的颜色模式同样只有两种灰度模式和彩色模式，两者之间是可以相互转换的。此外也可以把图像中某一颜色通道提取出来(可以理解为把某一种颜色提取出来)，这一点与biOps类似。对应的函数为colorMode()，一看例子便知。

```r
colorMode(lenac) <- Grayscale
display(lenac)
colorMode(lenac) <- Color
```

此外帮助文档中也给了我们一个非常有意思的例子，不妨看一下

```r
lenab <- rgbImage(red=lena,green=flip(lena),blue=flop(lena))
display(lenab,method="raster")
```

![lenaccolor](https://github.com/StevenBoys/photo/blob/master/lenaccolor.png?raw=true)

是不是有种幻影的感觉呢？

## 5.5 再玩滤镜效果

在我看来滤镜永远是重点，因为它总能带给我们惊喜，不妨先来回顾一下之前玩过的模糊与锐化，看看它们在EBImage中是如何实现的

```r
flo <- -makeBrush(21, shape='disc', step=FALSE)
flo <- flo/sum(flo)
lenaflo <- filter2(lenac, flo)
fhi <- matrix(1, nc=3, nr=3)
fhi[1,1] <- -3;fhi[1,3]&lt;--3
lenafhi1 <- filter2(lenac, fhi)
fhi <- matrix(1, nc=3, nr=3)
fhi[2,2] <- -8
lenafhi2 <- filter2(lenac, fhi)
lenacomb <- combine(lenac,lenaflo,lenafhi1,lenafhi2)
display(lenacomb,method="raster",all=T)
```

![lenac5](https://github.com/StevenBoys/photo/blob/master/lenac5.png?raw=true)
  
操作方法大体类似，只不过换了一个函数(filter2)而已，函数makeBrush()用于指定画刷的大小类型等，当然之前所提到的浮雕等效果在这里同样OK，矩阵变着变着就各式各样的效果都出来了，并且我觉得EBImage所提供的相比用起来更顺手也更灵活些。这里再提一些之前没有提到的

### 5.5.1 高斯模糊

EBImage特意提供了gblur()函数来实现，用法同样很简单只需提供方差和半径即可

```
x <- readImage(system.file("images","lena.png",package="EBImage"))
y <- gblur(x,sigma=4)
display(y,method="raster",all=T)
```

如果对高斯模糊具体的原理和在R如何DIY是实现感兴趣的读者可以参考[轩哥的博文](http://yixuan.cos.name/cn/)，这里为防止误导不再赘述。

### 5.5.2 老照片效果

老照片效果的作用是把一张正常的照片通过线性变换糟蹋成年久泛黄的效果，自然也就给人一种老照片的感觉。实现起来同样非常简单，自己动手写几句即可，本着能水则水的原则不到一分钟就可以搞定

![lenacold](https://github.com/StevenBoys/photo/blob/master/lenacold.png?raw=true)

效果大致是有了，但还有很多不尽如人意的地方，这点大家可以根据喜好自行修改(如变换的矩阵，亮度对比的调整等)。

```r
lenac <- readImage(pic);
R1 <- lenac[,,1];
G1 <- lenac[,,1];
B1 <- lenac[,,1];
R <- 0.393*R1+0.769*G1+0.189*B1;
G <- 0.349*R1+0.686*G1+0.168*B1;
B <- 0.272*R1+0.534*G1+0.131*B1;
lenact <- lenac;
lenact[,,1] <- R;
lenact[,,2] <- G;
lenact[,,3] <- B;
display(lenact,method="raster",all=T)
```

变换矩阵引用自网上

## 5.6 形态学处理

这里再讲一讲该包的形态学处理功能。这一点在对文字图片的处理上有更直观的体现，包中自带了一张用于演示的例图，效果一看便知。
  
![qinshi](https://github.com/StevenBoys/photo/blob/master/qinshi.png?raw=true) 

![pengzhang](https://github.com/StevenBoys/photo/blob/master/pengzhang.png?raw=true)

一张是冲刷的效果，而另一张则是膨胀的效果，分别通过erode(),dilate()函数实现，最后附上代码

```r
ei <- readImage(system.file('images', 'shapes.png', package='EBImage'))
ei <- ei[110:512,1:130]
display(ei,method="raster",all=T);
dev.new()
kern <- makeBrush(5, shape='diamond')
eierode <- erode(ei, kern)
eidilat <- dilate(ei, kern)
display(eierode,method="raster",all=T)
dev.new()
display(eidilat,method="raster",all=T)
```

## 5.7 还能有点啥

其实没提到的玩法还有很多很多，包括图像的分割算法实现等(医学和生物学上的应用)，考虑到篇幅这里就不再多说了，感兴趣的可以随着帮助文档继续探索。

# 6  零零碎碎

除了之前所说之外，还有一些零零碎碎的包也能对图像处理提供一些帮助，这里略微提一提，具体请直接参考文档。

## 6.1 adimpro包

该包也是CRAN提供的一个可以用于简单图像处理的包，依赖于Image Magick，用法大多类似，到这也已没有了多嘴的必要，包的作者给大部分函数都写了demo，所以想继续了解该包的读者可以通过包中提供的demo学习。

## 6.2 pixmap包

pixmap也是一个用于位图处理的扩展包，包中的函数仅仅提供了最最基本的获取、绘制等功能，不过它提供的read.pnm()函数可以用来读取PBM(黑白),PGM(灰度)以及PPM(彩色)等并不太常见格式的图片。

# 7 挖掘潜力是一件永无止境的事情

其实说到底前面所说的都是一些皮毛只能算是抛砖引玉，R的潜力是不可估量的(各方面都一样)，需要我们去挖掘，轩哥的layer包(致敬!)就是一个很好的典型，在R中引入了图层，仰慕至极，相关的资料可以在统计之都主站找到。再比如说，利用前两篇文章所用到的交互事实上就可以做出一个建议图像处理界面(GUI则更佳)。当然也可以从文献中的找些图像处理算法在R实现等等，不怕做不到就怕想不到。

# 8 最后再来fun一把！

讲了这么多包，扯了这么多无聊的东西，在本文临近尾声之际，也该放松一下来好好fun一把了！

## 8.1 马赛克拼图

这玩意看起来是比较高端的，所以用于装逼是非常合适。这个玩法源于刘思喆(更早些)和波波版主两位大佬的博客，里面都有非常详细的叙述和代码，所以感兴趣的读者不妨直接访问他们的博客。

需要提一下的是博文中部分代码可能已经过时了(更新的原因)，但都可以通过上文提到的函数代替，所以如果出现报错等情况麻烦自行修改。

## 8.2 平面图的炫酷3D化

这个想法来自于rgl包的帮助文档中一个展示地球仪的例子，“3D+交互”的效果着实令我赞叹不已，更有意思的是可以把处理好的图片在一个更好的环境下展现出来，遂萌生将此招盗用过来之意。后来考证一下后发现其实这招在论坛中也有曾经有出现，但也没引起深入的讨论故也没引起大家的注意。代码先行

```r
library(rgl)
library(EBImage)
lat <- matrix(seq(90,-90, len=50)*pi/180, 50, 50, byrow=TRUE)
long <- matrix(seq(-180, 180, len=50)*pi/180, 50, 50)
x <- cos(lat)*cos(long)
y <- cos(lat)*sin(long)
z <- sin(lat)
open3d()
persp3d(x, y, z, col="white",
texture=system.file("images/lena-color.png",package="EBImage"),
specular="black", axes=FALSE, box=FALSE,
xlab="", ylab="", zlab="",
normal_x=x, normal_y=y, normal_z=z)
```

效果一看便知，不过记得要转到一个合适角度哦，不然就不堪入目了。

# 9  致歉与展望

事实上关于图像处理，早已不是一个新话题，不止COS的前辈们早就在搞，在2010年的London R 上就有题为Image Analysis Using R的报告，来自mango-solutions，并且他们在CRAN 上也早已为我们准备好了Task View，只不过题目为医学图像处理(Medical Image Analysis)，本该为这些成果在医学上的推广尽一份力的，可惜思想觉悟不够高，在这里误导各位，实在是罪过罪过。因此在这里表示最诚挚的歉意！以上胡言乱语图个乐即可。

以上内容也可供各位码代码打发时间时参考，说不定哪位仁兄一无聊我的文章又能更新了，那我就再高兴不过了，定当感激涕零。本文篇幅略长，浪费各位宝贵时间，再次深表歉意！
