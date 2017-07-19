---
title: 中秋献礼——Layer图形设备
date: '2011-09-12T22:23:11+00:00'
author: 邱怡轩
categories:
  - 统计图形
  - 统计软件
  - 软件应用
tags:
  - Layer
  - R语言
  - 图层
  - 图形设备
slug: layer-graphics-device
forum_id: 418850
---

![Layer图形设备配图](https://uploads.cosx.org/2011/09/Festival2.png)
  
你在用R画图的时候，是否会遇到以下的麻烦：

  * 加图例或文字时总是对不准坐标，要花很多精力调整元素的位置；
  * 某个细节出错，整幅图得重新绘制；
  * 想要更酷的平移、拉伸、旋转操作，就好像在Gimp或Photoshop里面一样；
  * 想更方便地使用字体，特别是中文的显示。

于是接下来就有一个好消息和一个坏消息。好消息是有一个软件包可以解决上面的大部分问题了，而坏消息是这个包仍然处于开发阶段，所以各种bug是难以避免的。今天恰逢中秋，我便把这个自己编写的Layer软件包介绍给大家，算是送给大家的一份小礼物。

Layer顾名思义，指的是图层，而这个绘图设备正是采用了图层的思想。在你用Layer画图时，你可以将不同的图形元素放在不同的层上，彼此之间互不影响。例如，你可以将图例单独建立一个图层，当图例移动时，下层的图形并不会发生变化，再加上一定的鼠标操作，就可以方便地绘制出美观的图形。

为了让大家能直观地感受Layer的操作，我录制了一段[Layer的操作演示视频](http://v.youku.com/v_show/id_XMzAzNDkyNTU2)。

此外，Layer有着更方便的字体支持。在打开Layer图形设备时，你可以指定一个ttf字体文件作为图形字体的来源，如果参数为`NULL`，则图形会使用软件包自带的[文泉驿](http://wenq.org)微米黑字体。

Layer软件包的下载地址如下。需要说明的是，Layer需要GTK+环境的支持，对于Windows用户，如果你已经安装了GTK+环境，请选择第二个下载地址；如果尚未安装，可以直接下载第三个文件（软件包中附带了GTK+）。

[下载：源代码](http://yixuan.cos.name/cn/wp-content/uploads/2011/09/Layer_0.1-0.tar.gz)
  
[下载：Windows二进制包](http://yixuan.cos.name/cn/wp-content/uploads/2011/09/Layer_0.1-0.zip)
  
[下载：Windows二进制包（含GTK+运行库）](http://yixuan.cos.name/cn/wp-content/uploads/2011/09/Layer.zip)
