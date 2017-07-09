---
title: showtext：字体，好玩的字体和好玩的图形
date: '2014-01-06T11:23:32+00:00'
author: 邱怡轩
categories:
  - 统计图形
  - 统计软件
  - 软件应用
tags:
  - R语言
  - 图形
  - 字体
  - 论坛
  - 软件包
slug: showtext-interesting-fonts-and-graphs
forum_id: 418999
---

统计图形的作用想必不用我多说，一幅美观的图往往能让枯燥的数据变得有趣起来，而R恰巧就是这样一个作图的利器。然而，从论坛上的帖子来看，大家在用R画图时经常会遇到几个终极问题：

  1. [中文无法显示](https://cos.name/cn/topic/138868)
  2. [XX类型的图怎么画？](https://cos.name/cn/topic/147769)
  3. [中文无法显示](https://cos.name/cn/topic/147359)
  4. [中文无法显示](https://cos.name/cn/topic/109373)
  5. [中文无法显示](https://cos.name/cn/topic/121953)
  6. ……

第2个问题由于太过终极我还没法回答，所以就先试着解决第1个，第3个，第4个，第5个，第……个问题好了。

<!--more-->

# 使用字体

图片无法显示中文，究其原因，是R的很多图形设备只能使用一些标准的字体，但它们往往不包含中文的字符。而包含中文的字体，如Windows自带的宋体、黑体等，R又不知道如何使用它们。于是这就成了一个死循环：我们有中文字体吧，R不会用；R能用的字体吧，我们又看不上——所以说R和useR都不好伺候……

不过现在情况有了一定的改善，我们有了[sysfonts](http://cran.r-project.org/web/packages/sysfonts/index.html)这个包，专门用来加载系统里的字体文件，其中主要一个函数是`font.add()`，用法为

```r
font.add(family, regular, ...)
```

其中`family`是你给这个字体赋予的名称，在后面的绘图命令中你将通过它来引用这个字体。`regular`是字体文件的路径，如果字体在系统的标准位置（例如Windows的C:\Windows\Fonts）或是当前的工作目录，则可以直接输入文件名。例如，在Windows系统下，以下命令将导入系统中的楷体文件，并给它取名为“kaishu”：

```r
font.add("kaishu", "simkai.ttf")
```

添加完字体之后，可以使用`font.families()`函数来查看当前可用的字体名称，不出意外的话现在应该包含四种字体：sans，serif，mono和kaishu。其中前三个是`sysfonts`包自动加载的，而kaishu则是我们刚才添加进去的。

字体的加载过程完毕，接下来就是如何使用它们了。当然了，R本身是不认识这些字体的，我们需要使用[showtext](http://cran.r-project.org/web/packages/showtext/index.html)附加包来真正利用这些字体绘图。

`showtext`的用法更加简单，目前只有两个函数：`showtext.begin()`和`showtext.end()`。我们需要做的就是把绘图的命令包含在这两个语句中间，然后在适当的地方选取字体即可。不多说，直接上代码：

```r
# showtext会自动加载sysfonts包
library(showtext);
# 导入楷体
font.add("kaishu", "simkai.ttf");

library(Cairo);
# 打开图形设备
CairoPNG("chinese-char.png", 600, 600);
# 开始使用showtext
showtext.begin();
# 一系列绘图命令
set.seed(123);
plot(1, xlim = c(-3, 3), ylim = c(-3, 3), type = "n");
text(runif(100, -3, 3), runif(100, -3, 3),
     intToUtf8(round(runif(100, 19968, 40869)), multiple = TRUE),
     col = rgb(runif(100), runif(100), runif(100), 0.5 + runif(100)/2),
     cex = 2, family = "kaishu");    # 指定kaishu字体
title("随机汉字", family = "wqy");   # 指定wqy字体
# 停止使用showtext
showtext.end();
# 关闭图形设备
dev.off();
```

也就是说，要让R使用我们之前加载的字体，只需要将画图命令包含在一对`showtext.begin()`和`showtext.end()`中间，然后在绘图命令中选取`family = ...`即可。代码中的`wqy`是`showtext`包自带的[文泉驿微米黑](http://wenq.org/wqy2/index.cgi?MicroHei)字体，可以显示绝大多数的汉字，所以即使你的系统中没有中文字体，也可以用它来绘制带中文的图形。

上面的小程序会在图形中随机显示一些汉字，效果如下图：

![随机显示汉字](https://uploads.cosx.org/2014/01/chinese-char.png)

<p style="text-align: center;">
  图1：随机显示汉字
</p>

（我赌两块糖，你不认识上面一半以上的汉字……）

# 好玩的字体

有了上面介绍的`showtext`包，你基本上可以使用任何一种字体来显示文字了。这时候我们可以做一些有意思的事情：有些字体中包含的并不是字母和数字，而是一些符号或图标。例如这个[WM People 1](http://www.dafont.com/wm-people-1.font)字体，其中字母p和字母u分别是男人和女人的图案，利用这一点我们可以绘制出下面这幅图：

![教育程度统计](https://uploads.cosx.org/2014/01/edu-stat.png)
<p style="text-align: center;">
  图2：用特殊字体绘图
</p>

其实这幅图本质上就是一个堆叠的条形图，但这样画出来之后，可以很直观地体现出各个类别的人数和性别比例，而且图形本身就已经有解释性，不需要再额外添加图例等元素。

绘制这幅图的代码为：

```r
link = "http://img.dafont.com/dl/?f=wm_people_1";
download.file(link, "wmpeople1.zip", mode = "wb");
unzip("wmpeople1.zip");

library(showtext);
font.add("wmpeople1", "wmpeople1.TTF");

library(ggplot2);
library(plyr);
library(Cairo);

dat = read.csv(textConnection('
edu,educode,gender,population
未上过学,1,m,17464
未上过学,1,f,41268
小  学,2,m,139378
小  学,2,f,154854
初  中,3,m,236369
初  中,3,f,205537
高  中,4,m,94528
高  中,4,f,70521
大专及以上,5,m,57013
大专及以上,5,f,50334
'));

dat$int = round(dat$population / 10000);
gdat = ddply(dat, "educode", function(d) {
    male = d$int[d$gender == "m"];
    female = d$int[d$gender == "f"];
    data.frame(gender = c(rep("m", male), rep("f", female)),
               x = 1:(male + female));
});
gdat$char = ifelse(gdat$gender == "m", "p", "u");

CairoPNG("edu-stat.png", 600, 300);
showtext.begin();
theme_set(theme_grey(base_size = 15));
ggplot(gdat, aes(x = x, y = educode)) +
    geom_text(aes(label = char, colour = gender),
              family = "wmpeople1", size = 8) +
    scale_x_continuous("人数（千万）") +
    scale_y_discrete("受教育程度",
        labels = unique(dat$edu[order(dat$educode)])) +
    scale_colour_hue(guide = FALSE) +
    ggtitle("2012年人口统计数据");
showtext.end();
dev.off();
```

其实，图中的每一个小人都是一个p或者u的字符，只是因为在这种字体下，它们显示出不一样的图案罢了。

# 好玩的图形

更进一步，如果坐标轴也用不一样的字体来展现呢？结果当然是，被！玩！坏！了！！

![](https://raw.github.com/JiangXD/cos_post/master/showtext/edu.png)

<p style="text-align: center;">
  图3：暴漫版图形（图片来源：[https://cos.name/cn/topic/147769](https://cos.name/cn/topic/147769) @doctorjxd）
</p>

不过真的很贴切有木有！！小学的时候各种玩具枪！初中的时候哈哈哈笑个不停！高中的时候多么正经的好少年！去念大学之后就成了那副熊样了不是吗！！（请无视此刻暴走的作者）

不过这种思路确实很赞，试想一下，如果我们把一些枯燥的坐标轴说明文字变成了更形象的图案，那么整幅图的表现力是不是就更强了呢？像是下面这样：

![豆瓣评分](https://uploads.cosx.org/2014/01/douban.png)
<p style="text-align: center;">
  图4：坐标轴上放置表情
</p>

附上相应的R代码：

```r
link = "http://img.dafont.com/dl/?f=emoticons";
download.file(link, "emoticons.zip", mode = "wb");
unzip("emoticons.zip");

library(showtext);
font.add("emoticons", "emoticons.ttf");

library(ggplot2);
library(Cairo);
emotions = c("W", "s", "C", "A", "p");
score = c(0.5, 0.9, 5.5, 18.4, 74.7);
x = factor(emotions, emotions);
gdat2 = data.frame(x, score);
CairoPNG("douban.png", 600, 600);
showtext.begin();
ggplot(gdat2, aes(x = x, y = score)) +
    geom_bar(stat = "identity") +
    scale_x_discrete("") +
    scale_y_continuous("百分比") +
    theme(axis.text.x=element_text(size=rel(4), family="emoticons")) +
    ggtitle("《神探夏洛克第三季》豆瓣评分");
showtext.end();
dev.off();
```

所以，发挥你的想像力，绘制出更形象、更有趣的统计图形吧！

附：相关资源

  * [更多showtext包的介绍](http://yixuan.cos.name/cn/2014/01/fonts-in-r-graphics/)
  * [有趣的字体](http://www.dafont.com/search.php?q=people)，[这里](http://www.fontspace.com/category/people)，[还有这里](http://www.dafont.com/search.php?q=icon)
