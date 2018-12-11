---
title: 可视化的另一种选择，Processing.R
date: '2018-12-11T0:10:32+00:00'
author: 高策
categories:
  - 统计图形
tags:
  - Processing
  - renjin
  - 新媒体艺术
  - 可视化
slug: processing-r
meta_extra: "审稿：郎大为"
forum_id: 420330
---

![processing.r](https://github.com/gaocegege/Processing.R/raw/master/raw-docs/img/logo/logo.png)

Processing 是一门运行在 JVM 上的编程语言，其最初目标是用来形象地教授计算机科学的基础知识。之后，它逐渐演变成了可用于创建图形可视化专业项目的一种环境。如今，Processing 已经形成了一个专门的社区，众多的库与多语言支持，使得 Processing 在动画、可视化、装置艺术、游戏设计以及相关领域有不少的应用。

![Processing Ecosystem](https://user-images.githubusercontent.com/5100735/29493064-fdb9c3fa-85c0-11e7-87ae-be96a7c40deb.png)

目前，Processing 已经有了多种语言的支持，其中包括 Javascript，Python 等。[Processing.R](https://github.com/gaocegege/Processing.R) 是今年 Processing 基金会在谷歌 2017 编程之夏（Google Summer of Code 2017）中接收的项目。通过 Processing.R，用户可以通过 R 语言来编写 Processing sketch。

本文将先介绍 Processing IDE，然后会通过 Processing.R，使用 R 语言来实现一个简单的 Processing Sketch。与此同时会介绍下 Processing.R 目前已经实现的功能以及未来的计划。最后探讨一下 Processing.R 背后用到的工具与开发过程。

阅读本文，需要事先了解以下姿势：

* R 语言，涉及使用层面。
* Java Virtual Machine(JVM)，会多次出现在文章中，涉及实现层面。

# Processing 环境

Processing 是运行在 JVM 上的，因此具有跨平台的特性。目前主流的操作系统（Windows, macOS, Ubuntu 等 Linux 发行版）都可以运行 Processing 程序和 IDE。Processing 不仅可以绘制 2D 的静态图形与动画，同时也有 3D 的支持。很多设计师和艺术家也会用这一语言来制作海报，完成创意作品等。

<p align="center">
<img src="https://raw.githubusercontent.com/processing-r/Processing.R/master/raw-docs/img/life.gif" height=150></img>
<img src="https://raw.githubusercontent.com/processing-r/Processing.R/master/raw-docs/img/plot.png" height=150></img>
<img src="https://raw.githubusercontent.com/processing-r/Processing.R/master/raw-docs/img/history.png" height=150></img>
</p>

<p align="center">
<img src="https://raw.githubusercontent.com/processing-r/Processing.R/master/raw-docs/img/noise.gif" height=150></img>
<img src="https://raw.githubusercontent.com/processing-r/Processing.R/master/raw-docs/img/demo-geo.gif" height=150></img>
<img src="https://raw.githubusercontent.com/processing-r/Processing.R/master/raw-docs/img/math.gif" height=150></img>
<img src="https://raw.githubusercontent.com/processing-r/Processing.R/master/raw-docs/img/demo.gif" height=150></img>
<img src="https://raw.githubusercontent.com/processing-r/Processing.R/master/raw-docs/img/people.gif" height=150></img>
</p>
<p align="center">由 Processing.R 实现的可视化作品</p>

在 Processing 的语境中，Processing Sketch 就是指一个可以运行的 Processing 程序。而 Processing IDE 是开发和测试 Processing Sketch 的集成开发环境，也被称作 PDE，可以从 [Processing.org](https://processing.org/download/) 下载，<del>这是梦开始的地方。</del>在上图右侧，就是 PDE 主要的界面。而左边的小窗口，是显示窗口。在 Processing Sketch 的代码被运行的时候，就会产生一个默认情况下是 100 * 100 的展示窗口，Processing Sketch 中编写的逻辑都会呈现在其中。

![](https://user-images.githubusercontent.com/5100735/29493291-d548ad1e-85c5-11e7-9950-51b361b206bd.png)

# Processing 语言

Processing 最初是重用了 Java 语言，实现了一个基于其语言规约的方言。而现在 Processing 成为了一种环境，在其上有不同的语言实现。目前除了默认的 Java 模式之外，Processing 在其 PDE 中共有 7 种语言模式可以选择，不过其中有两种是与最新版本的 PDE 不兼容的。与最新版本兼容的 5 种模式分别是：

![](https://user-images.githubusercontent.com/5100735/29493417-df2b614e-85c7-11e7-98c5-d9f20cf780a4.PNG)

* Android Mode；在安卓上运行 Processing Sktech 的模式
* p5.js Mode；Javascript 模式
* Python Mode；Python 模式
* **R for Processing；R 语言模式**
* REPL 模式；Processing Java 的 REPL 模式

而本文所要讨论的就是 Processing 的 R 语言模式。值得注意的是，Processing.R 并不是一个标准的 R 包，其只能配合 Processing IDE 使用。

# 实现一个 Processing.R Sketch

Processing.R 可以使得 R 语言下的动态图形编程变得异常简单，下面是一段不到 40 行的代码，但麻雀虽小五脏俱全，这是一个不断在做扩胸运动的正方体团体，通过这个例子介绍下 Processing 的编程模型。

![](https://raw.githubusercontent.com/processing-r/Processing.R/master/raw-docs/img/demo.gif)

```r
# 用于初始化窗口的大小
settings <- function() {
    size(500, 500, P3D)
}

# 用于初始化颜色与窗口的帧率
setup <- function() {
    colorMode(RGB, 1)
    frameRate(24)
}

# 每帧会被调用一次的绘制函数，绘制真正的图像或动画
draw <- function() {
    frames <- 24 * 3
    t <- frameCount/frames
    background(1)
    perspective(0.5, 1, 0.01, 100)
    camera(0, 0, 25 + sin(PI * 2 * t) * 3, 0, 0, 0, 0, 1, 0)
    rotateX(-0.5 - 0.05 * sin(PI * 4 * t))
    rotateY(-0.5 - 0.05 * cos(PI * 2 * t))
    columns <- 8
    for (ix in 1:columns - 1) {
        x <- ix - 0.5 * columns + 0.5
        for (iy in 1:columns - 1) {
            y <- iy - 0.5 * columns + 0.5
            for (iz in 1:columns - 1) {
                z <- iz - 0.5 * columns + 0.5
                d <- sqrt(x * x + y * y + z * z)
                s <- abs(sin(d - t * 4 * PI))
                pushMatrix()
                translate(x, z, y)
                box(s)
                popMatrix()
            }
        }
    }
}
```

`settings`，`setup`， 以及 `draw` 是 Processing 中三个可以被定义的函数。其中 `settings` 和 `setup` 函数用于初始化，由 Processing 运行时执行一次。通常 `settings` 函数包含 `size` 函数（用于定义窗口的边界），`setup` 函数则负责初始化在操作期间要使用的变量，以及设置系统的各种参数。Processing Sketch 在运行时会不断执行 `draw` 函数。每次 `draw` 函数结束后，就会在显示窗口绘制一个新的画面，并且 `draw` 函数也会被再次调用。默认的绘制速度是每秒 60 个画面，但是也可以通过调用 `frameRate` 函数来更改这个速度。这三个函数就像 C 语言中的 `main` 函数一样，是 Processing Sktech 的起点，所有的逻辑都从此开始。

除此之外，在这个示例中的其他函数，如 `background`，`perspective` 等等，都是 Processing 定义的一些原语，这些都可以在 [Processing Reference](https://processing.org/reference/) 中找到对应的文档。

# 已经实现的功能

目前，Processing.R 还在快速迭代之中，因此功能会越来越多。目前支持：

* R 语言原生的语法
* [绝大多数的 Processing 函数](https://processing-r.github.io/reference/)
* [部分 Processing 库](https://github.com/processing-r/Processing.R#processing-libraries-importlibrary)
* [部分 R 包](http://packages.renjin.org/)

# 实现细节

Processing.R 中最关键的一步是在 JVM 上解释 R 代码，这部分工作是由 [renjin](http://www.renjin.org/index.html) 完成的，renjin 是一个基于 JVM 的 R 语言的解释器。renjin 之于 R，就好比 Jython 之于 Python，JRuby 之于 Ruby。

```java
import javax.script.*;
import org.renjin.script.*;

public class TryRenjin {
  public static void main(String[] args) throws Exception {
    // create a script engine manager:
    RenjinScriptEngineFactory factory = new RenjinScriptEngineFactory();
    // create a Renjin engine:
    ScriptEngine engine = factory.getScriptEngine();

    engine.eval("df <- data.frame(x=1:10, y=(1:10)+rnorm(n=10))");
    engine.eval("print(df)");
    engine.eval("print(lm(y ~ x, df))");
  }
}
```

通过 renjin，R 可以非常自然地在 JVM 上被解释，而且 renjin 在[数据绑定上](http://docs.renjin.org/en/latest/importing-java-classes-in-r-code.html)也做了很好的工作，在 R 中可以访问到 Java 中的对象。因此 renjin 不单单可以作为一个 GNU R 的替代品，也可以被当作一个 Java Package，在 Java 项目中引入它来解释 R 代码，并且与 Java 对象交互。

之前提到 Processing 有三个特殊的函数，`settings`，`setup` 和 `draw`。而在 R 语言模式下，这三个函数是用 R 语言实现的，而为了能够让 Processing 理解 R 语言定义的函数，就需要 renjin 了。renjin 会在 R 代码中寻找所有的函数定义，如果定义的函数名为三个特殊函数之一，就会先 evaluate 这部分定义，保证 renjin 中已经定义了该函数。而当需要调用某一个函数时，会调用 renjin 来真正地解释这部分代码。

因为 renjin 是在 JVM 上实现的，所以很多 R 包目前是不可用的。如果是纯粹 R 语言实现的 R 包，理论上都是可用的，而如果依赖 Rcpp 等，就会出现问题。这样的限制就导致了 Processing.R 也不能支持所有的 CRAN R 包。所幸 renjin 是一个公司驱动的开源项目，有稳定的开发力量，目前也在努力改变这一情况。

# 展望

Processing.R 是一个没什么明确定位的轮子，说实话写出来我也不知道到底有没有用处，最初的动因只是因为看到了 renjin 这样一个超赞的东西，想帮助其发扬光大一下。跟目前现有工具对比的话，Processing.R 还是有一些优点的。

跟 Processing(Java) 对比，Processing 背靠 renjin，会支持越来越多的 R 包，更适合用来做统计计算，因此在计算方面有更大的优势。未来 Processing.R 也在思考对 Processing 原本的函数加入 Matrix 的支持，这样更符合 R 语言使用者的习惯。但是同样也存在一些劣势，比如目前还有一些小 Bug，以及性能问题等等。

跟 R 对比，图形化又成为了一个优势。但是 R 上也有很多诸如 ggplot 等等简单易用的包，而且与 RStudio 集成极好。Processing.R 的优势可能更多地是体现在动态效果上。

之前 Processing 的用户多是艺术家，或者偏向艺术的工程师。现在只有一些艺术院校的学生才会学习它。而 R 多数被用来做机器学习，数据统计分析等等。至于 Processing.R 的用户群，现在还不明朗。

总而言之，前途不明朗，但是应该会积极维护，未来可能会整个捐献给 Processing 基金会，换取更多的维护者。大家如果想尝试，可以自行下载 Processing IDE，再在 IDE 中下载 R for Processing Mode 即可。

# References

* [用 Processing 进行数据可视化，第 1 部分：语言和环境简介](https://www.ibm.com/developerworks/cn/opensource/os-datavis/index.html)
* [Getting Started - Processing.org](https://processing.org/tutorials/gettingstarted/)
* [Using Renjin as a Library - Renjin.org](http://docs.renjin.org/en/latest/library/index.html)
