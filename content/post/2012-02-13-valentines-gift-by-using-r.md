---
title: 用R绘制情人节的礼物
date: '2012-02-13T20:00:05+00:00'
author: 林宇
categories:
  - 统计图形
tags:
  - R语言
  - 情人节
slug: valentines-gift-by-using-r
forum_id: 418859
---

> 作者简介：林宇，加拿大西安大略大学精算专业在读硕士。

据说笛卡尔死前寄出的最后一封信，里面只有短短的一行：`\(r = a(1- \text{sin}\theta)\)`，这就是有名的心形函数。情人节将至，我用R语言的**grid**包画了几幅图片，希望借此平台赠与我相恋五年的男友，也希望与各位统计爱好者分享快乐。<!--more-->

首先，我利用**grid.lines()**把转化为直角坐标系的(x, y)两两相连围成心形，构建了一个heart function作为基本图形。

`$$\begin{split}
x & = 16(\text{sin}t)^3 \\  
y & = 13\text{cos}t – 5\text{cos}2t – 2\text{cos}3t – \text{cos}4t  
\end{split}$$`

![](https://uploads.cosx.org/2012/02/heart.png)

为了得到嵌套心形图案，我使用了**grid**包创建了多个viewport。viewport是**grid**包的一个重要特色，此概念类似于photoshop的图层。

创建一个viewport，我们需要设置它的位置、长度和宽度，下图虚线实际上并不出现在R的output里面，但这个矩形区域图层会成为接下来画图的区域。构建了新的viewport以后，我们可以用**pushViewport()**命令锁定该图层，使之成为目标区域。我们也可以构建多个viewport，几个viewport之间可以通过命令相互切换。

![](https://uploads.cosx.org/2012/02/region.png)

例如，在第一个图层的基础上在新建一个图层，调整新图层的长度与宽度使之稍微小于第一个图层， 用**pushViewport()**锁定新图层，再调用一次心形函数，以此类推，循环创建多个嵌套图层，并依次在各个图层上画心形函数，于是我们可以得到一系列嵌套的心形。

![](https://uploads.cosx.org/2012/02/manyHearts.png)

此外，**grid**包允许我们对图形进行复制、旋转、放缩等修改。要旋转心形函数，我们并不需要修改函数本身，而是可以通过旋转viewport的方式旋转我们所需要绘制的图形。设置新viewport，调整angle函数，那么在此图层下绘制的任何图形将会被旋转。

利用viewport对图形进行修改，我们可以绘制各种有趣的图形pattern，本人只是**grid**包的初学者，如有偏颇之处望多多包涵。最后，祝愿大家情人节快乐！

![](https://uploads.cosx.org/2012/02/twoHearts.png)

以下是“情人节礼物”的代码：

```r
library(grid)
# heart function
heart <- function(lcolor) {
  t = seq(0, 2 * pi, by = 0.1)
  x = 16 * sin(t)^3
  y = 13 * cos(t) - 5 * cos(2 * t) - 2 * cos(3 * t) - cos(4 * t)
  a = (x - min(x))/(max(x) - min(x))
  b = (y - min(y))/(max(y) - min(y))
  grid.lines(a, b, gp = gpar(col = lcolor, lty = "solid", lwd = 3))
}
heart("hotpink")

# rose function
grid.newpage()
rose = function() {
  grid.circle(x = 0.5, y = 0.5, r = 0.5, gp = gpar(fill = "red", 
    lwd = 3))
  vp <- viewport(0.5, 0.5, w = 0.9, h = 0.9)
  pushViewport(vp)
  grid.polygon(x = c(0.08, 0.5, 0.94), y = c(0.22, 1.03, 0.22), 
    gp = gpar(lwd = 3))
  vp2 <- viewport(0.5, 0.5, w = 0.4, h = 0.4)
  pushViewport(vp2)
  grid.circle(x = 0.5, y = 0.5, r = 0.5, gp = gpar(fill = "red", 
    lwd = 3))
  vp3 <- viewport(0.5, 0.5, w = 0.9, h = 0.9, angle = 180)
  pushViewport(vp3)
  grid.polygon(x = c(0.08, 0.5, 0.94), y = c(0.22, 1.03, 0.22), 
    gp = gpar(lwd = 3))
}
rose()

# pattern 1
grid.newpage()
pushViewport(viewport(x = 0.1, y = 0.1, w = 0.2, h = 0.2))
grid.newpage()
for (j in 1:30) {
  vp <- viewport(0.5, 0.5, w = 0.9, h = 0.9)
  pushViewport(vp)
  heart("hotpink")
}

# pattern 2
grid.newpage()
vp1 <- viewport(0.4, 0.5, w = 0.5, h = 0.5, angle = 15)
pushViewport(vp1)
heart("red")
vp2 <- viewport(0.9, 0.27, w = 0.7, h = 0.7, angle = -30)
pushViewport(vp2)
heart("hotpink")
grid.text("Happy valentine's day!", x = 0.2, y = 1.2, just = c("center", 
  "bottom"), gp = gpar(fontsize = 20), vp = vp)
vp3 <- viewport(-0.65, 1.2, w = 0.3, h = 0.3, angle = -30)
pushViewport(vp3)
rose()
```
