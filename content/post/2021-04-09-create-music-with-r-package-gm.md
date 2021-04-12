---
title: "用 R 包 gm 写音乐"
date: 2021-04-09
author: "flujoo"
categories: ["R 语言 ", "R 包"]
tags: ["音乐"]
slug: create-music-with-r-package-gm
---


本文要介绍 R 包 [gm](https://github.com/flujoo/gm)，你可以用它来生成音乐。

具体来说，gm 有三大特点：

1. 它设计了一套非常简单的语言，你可以用这个语言来描述音乐。
2. gm 会将你的描述转化成乐谱和音频，你几乎不需要考虑记谱的技术细节。
3. gm 可以在 R Markdown 文档或 R Jupyter 笔记本里自动将乐谱嵌入生成的文档中。

先来看一个简单的例子。


## 小例子

```r
# 加载 gm
library(gm)

# 创建 Music 对象
m <- 
  # 初始化 Music 对象
  Music() +
  # 加上 4/4 拍号
  Meter(4, 4) +
  # 加上一条包含四个音的声部
  Line(list("C5", "D5", "E5", "F5"), list(1, 1, 1, 1))

# 转化成乐谱和音频
show(m, c("score", "audio"))
```

![](https://flujoo.github.io/gm/reference/figures/readme.png)

<audio controls>
  <source src="https://flujoo.github.io/gm/reference/figures/readme_audio.mp3" type="audio/mpeg">
</audio>


相信这个例子足够让你感受 gm 的简单和直观。深入之前，先来看看如何下载。


## 下载与设置

从 CRAN 上下载：

```r
install.packages("gm")
```

从 Github 上下载开发版：

```r
# 请先下载 devtools
# install.packages("devtools")

devtools::install_github("flujoo/gm")
```

你还需要[安装 MuseScore](https://musescore.org/)，它是一款开源免费的打谱软件。

MuseScore 有[默认的安装路径](https://musescore.org/en/handbook/3/revert-factory-settings)，如果你下载到其它路径，请在 .Renviron 文件中设置：

1. 打开 .Renviron 文件。可以用命令 `file.edit("~/.Renviron")`。
2. 在其中加入 `MUSESCORE_PATH=<MuseScore 可执行文件的路径>`，比如 `MUSESCORE_PATH="C:/Program Files (x86)/MuseScore 3/bin/MuseScore3.exe"`。
3. 重启 R。


## 深入一点

使用 gm 时，我们通常需要初始化一个 `Music` 对象：

```r
m <- Music()
```

我们可以直接打印它来查看它的结构：

```r
m

#> Music
```

在这个空的 `Music` 对象之上，我们可以加上其它的成分。比如加上拍号：

```r
m <- m + Meter(4, 4)
m

#> Music
#>
#> Meter 4/4 
```

加上声部：

```r
m <- m + Line(pitches = list("C5"), durations = list("whole"))
m

#> Music
#> 
#> Line 1
#> 
#> * as part 1 staff 1 voice 1
#> * of length 1
#> * of pitch C5
#> * of duration 4
#> 
#> Meter 4/4
```

当然，更直观的方式是将其转化成乐谱查看：

```r
show(m)
```

![](https://raw.githubusercontent.com/flujoo/gm/master/man/figures/cn/1.png)

gm 的语法有点像 ggplot2，你可以不断添加新的成分，然后查看，然后再添加，不断反复。

我们还可以加上拍速记号：

```r
m <- m + Tempo(120)
show(m)
```

![](https://raw.githubusercontent.com/flujoo/gm/master/man/figures/cn/2_tempo.png)

加上新的声部：

```r
m <- m + Line(
  pitches = list("C3", "G3"),
  durations = list("half", "half")
)

show(m)
```

![](https://raw.githubusercontent.com/flujoo/gm/master/man/figures/cn/3_lines.png)

这个过程可以继续，但我们在此打住。你可以查看[完整的文档](https://flujoo.github.io/gm/articles/gm.html)解锁所有功能。


## 与其它包的比较

在 R 中，我所知的有类似功能且较为成熟的包只有 [tabr](https://github.com/leonawicz/tabr). 但两者依然有明显的区别：

- gm 仅用来生成音乐，而 tabr 除了生成音乐，还可以分析音乐。
- 就生成音乐来说，gm 更关注高阶地描述音乐，而 tabr 更关注记谱，比如它可以生成吉他谱，并且支持更多的记谱功能。
- gm 直接将生成的音乐嵌入在 R Markdown 文档或 R Jupyter 笔记本中，tabr 则需要导出查看。
- gm 使用 R 的基本数据结构来表征音乐结构，比如向量和列表，而 tabr 则使用字符串。
- gm 的语言更简单直观，结合上面这点，gm 更适合音乐编程。

Python 有一个非常成熟的库 [music21](http://web.mit.edu/music21/)，它提供了非常丰富的工具用来分析和生成音乐。就生成音乐的功能来说，music21 能生成相对更加专业的乐谱，同时支持在 Python Jupyter 笔记本中嵌入生成的音乐。 相比之下，gm 的优势依然是更为简单的语言。比如，在 music21 中，

1. 创建音符并组合成旋律线的过程非常繁琐笨重，
2. 用户有时候必须关注乐谱的技术细节，哪怕他们只想高阶地描述音乐结构，
3. 处理复杂的连音时不够直观。


## 自动作曲

gm 的一个有趣的应用是算法作曲，也就是用算法来生成音乐。下面是一个例子：

```r
pitches <- as.list(c(64, 65, 69, 71, 72, 76))
durations <- rep(list(1), length(pitches))

m <- Music() + Meter(4, 4) + Tempo(120)

for (i in 0:8) {
  m <- m + Line(pitches, durations, offset = 0.5 * i)
}

show(m, to = c("score", "audio"))
```

![](https://raw.githubusercontent.com/flujoo/gm/master/man/figures/cn/4_ac.png)

<audio controls>
  <source src="https://raw.githubusercontent.com/flujoo/gm/master/man/figures/cn/4_ac.mp3" type="audio/mpeg">
</audio>

上面的代码生成了九条声部，所有声部的音符都是相同的，区别是每条声部加入的时间都比前一条声部慢一点，因此形成了有趣的回音效果。

从这个例子你也可以感受到，gm 利用 R 的基本数据结构来表征音高和时值，语法简单，非常适合用编程的方式产生音乐。


## 总结

综合来说，gm 的优点是，语言高阶简单，并且适用于常见的 R 工作环境，方便传播生成的音乐。
而如果你想要专业级别的记谱软件，gm 目前还不够。
但在之后的版本中，gm 会实现更多的功能，包括添加乐器、力度记号等。

如果你喜欢 gm 可以[在 Github 上点赞](https://github.com/flujoo/gm)。有任何建议或分享，也欢迎联系作者。
