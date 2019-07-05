---
title: "基于 R Markdown 的演示文稿和报告模板使用经验"
author: "李家郡"
date: "2019-06-19"
tags: [R Markdown, slides]
categories: ["统计软件"]
slug: r-markdown-slides-ljj
forum_id: 420750
---

## 背景介绍

英语演讲课曾说，幻灯片只是辅助工具，而内容才是演讲的核心和本质。报告和幻灯片，其本质都是服务于“展示知识”这个过程，两者有着相通之处。利用 R Markdown 可以特别方便地将一份课程报告转化为课程答辩幻灯片，也可以将幻灯片填充些内容后形成总结报告。这四年来，利用两者的转换关系，我节约了不少时间。

作为排版困难者，我尝试着探索了一些只关注内容的幻灯片和报告的写法。随着四年统计学习，R 虽然已经快脱离我的常用语言名单，但不希望我积累的那些利用 R Markdown 制作幻灯片和课程报告的经验随着我的不用而消亡，故记录下一些改装模板的经验。本文适合会 R Markdown、想自定义模板的人阅读。

## 从YAML说起

R Markdown 的用户里，或许有的甚至不知道什么是 YAML，其实就是在生成模板时，上下三条横杠框住的参数设置。要学会自定义模板，首先要知道有什么可以改，才能下手，类似于编译链接生成机器代码的那一段——虽然学编程初期时有人总对它不屑一顾。而写 YAML 文件类似于在命令行写的参数，决定了使用什么参数制作报告。

```
---
title: "Untitled"
author: "author"
date: "2019年6月14日"
output: html_document
---
```

从最简单地生成一个普通 HTML 报告来说，看似这四行代码没什么好解释的，但实际上，可使用的参数可以根据这四行代码推出。其中最重要的一行是第四行—— output:html_document，在我只会套用模板而没深入研究时，无法注意到这行代码的重要性。实际上，只需在 R 中引入 rmarkdown 包后，然后输入 ?html_document，之后新世界便打开了，那 html_document 后加的参数根本就是这个函数的参数：

```
library("rmarkdown")
?html_document
```

rmarkdown 生成报告的命令可以在 R Markdown console 界面中看到，如下：

```
C:/PROGRA~2/Pandoc/pandoc" +RTS -K512m -RTS example.utf8.md --to html4 --from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash+smart --output example.html --email-obfuscation none --self-contained --standalone --section-divs --template "C:\Users\m1881\Documents\R\win-library\3.5\rmarkdown\rmd\h\default.html" --no-highlight --variable highlightjs=1 --variable "theme:bootstrap" --include-in-header "C:\Users\m1881\AppData\Local\Temp\Rtmpc5GI7B\rmarkdown-str37d03d181e60.html" --mathjax --variable "mathjax-url:https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML
```

虽然看起来一样没有很多信息，对某些同学来说，也许就是一堆乱码。实际上熟悉编程的小朋友都知道，这些参数指定着编译过程中的各种参数。Knitr 这个包怎么写我不清楚，但我能读出来：从 Rmd 生成的 md 文件，被 Pandoc 转换为了各种其他的文件，中间有的文件是库的引用，有的文件是模板的引用。

而更改模板的下手点，也就在 --template 这里。对于“高手”来说，只需重新写一个包，就可以重新写一个 html_document，也就更改了模板的内容这类的东西。如果不想重新写包的话，毫无疑问，改模板只需要把默认模板的位置找到，然后自定义其中的 CSS 即可。

对于最初级的同学，不妨根据 html_document 的帮助，将参数 toc 改一下，会发现输出文档里会添加一个目录，这也是最基础修改报告的方式，当然完全算不上自定义。

## 报告

课程报告一般要求 PDF 的形式，HTML 形式也比较常用。例如在狗熊会人才计划中，大多数报告都要求 HTML 形式。利用 R Markdown 做展示报告对统计学生来说，已经算习以为常了。R Markdown 形式的报告，可以方便地在报告中插入 R 所绘制的统计图片。可以说报告都是相似的，我甚至计算机学业课程所要求的实验报告都是使用 R Markdown 完成的。

### prettydoc 的千篇一律

这里得感谢邱怡轩制作的 prettydoc 包，对我大学多年来作业报告提供了很大帮助。prettydoc 从我大二第一次从李智凡处看到的样子，发展到现在是个统计学院稍微高年级同学都会的 R Markdown 模板，不得不说 prettydoc 有其迷人之处。

prettydoc 包模板的修改方法，在 YAML 和 prettydoc::html_pretty 的帮助文档里说明得比较清楚。

```
---
title: "Your Document Title"
author: "Document Author"
date: "`r Sys.Date()`"
output:
  prettydoc::html_pretty:
    theme: architect
    highlight: github
---
```

这里的 theme 可以换五种形式的主题，五种主题的名字从何而来，也是从编译过程可以看出来


```
"C:/PROGRA~2/Pandoc/pandoc" +RTS -K512m -RTS Untitled.utf8.md --to html4 --from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash+smart --output Untitled.html --email-obfuscation none --self-contained --standalone --section-divs --template "C:/Users/m1881/Documents/R/win-library/3.5/prettydoc/resources/templates/architect.html" --highlight-style pygments --mathjax --variable "mathjax-url:https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" --css Untitled_files/style.css
```

这里编译使用模板的路径为"C:/Users/m1881/Documents/R/win-library/3.5/prettydoc/resources/templates/architect.html"。顺藤摸瓜，翻到这个目录下，看到的五个 HTML 的名字就是可以定制的模板名。探索到这一步，稍微懂一点 HTML 的同学都应该明白了，所谓改模板就把这个 HTML 复制一份，顺便把 CSS 也复制一份，然后直接改颜色参数，有能力者做点水印和选择保护，很容易就可以定制模板了。

或许我水平真的一般，平常也没考虑过这些问题。当我探索到这一步时，已经是学 R 的两年后了，写这一文章的目的，一定程度上也是希望读文章的人能少走弯路。

基于 Cayman 的模板，我稍加修改，定义出了 homework 、homeworkdark 两个模板。其特点是除了稍微修改了颜色，还让 HTML 模板不可复制粘贴。这样是为了在别人抄作业的时候，不得不自己打一下代码，而不是完全复制粘贴。仔细看的话，可以发现还加了水印，加水印防粘贴的代码网上很多，这里不作详解，效果图如下：

![白色调自制作业模板](https://llijiajun.github.io/github-io/images/homework.png)
![黑色调自制作业模板](https://llijiajun.github.io/github-io/images/homeworkdark.png)

### rticles

记得两年前，有人问我 PDF 生成怎么老是出错，老是有问题。其实我也没有完全探索明白，但有个很好用的 R 包，那就是rticles。rticles 是谢益辉开发的，比较方便的是使用 CTeX 这个模板。其他模板并不是不能用，很多时候 bug 甚至都不在 R，而是在于 LaTeX 本身，出于沉迷 R Markdown 的探索，我起初并不是很会写 LaTeX 命令。使用时大部分情况下也是从网上抄代码。探索自己到底在使用那个 LaTeX 编译，最重要的方式仍然是看console的命令。从命令中，很容易就可以抓取到模板的位置，如下：

```
"C:/PROGRA~2/Pandoc/pandoc" +RTS -K512m -RTS 00.utf8.md --to latex --from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash --output 00.tex --table-of-contents --toc-depth 2 --template "C:\Users\m1881\Documents\R\win-library\3.5\rticles\rmarkdown\templates\ctex\resources\default.latex" --number-sections --highlight-style tango --pdf-engine xelatex 
```

从这里可以看出每个模板的路径，之后 --pdf-engine 也就表明了所用的 LaTeX 引擎，具体使用 LaTeX 的引擎目录则要看 Rstudio 的配置。

困扰大多数人，不用 rticles 写 PDF 的根本原因可能是这个包的其他模板不支持中文。解决的思路很简单，就像其他的 LaTeX 模板一样，只需要在模板中添加一样的 LaTeX 支持即可。但是运行时依然可能出问题，这些 bug 并不是由 R Markdown 导致的，而很有可能是因为 LaTeX 没有下载所引用模板的库。探索之初，我仅在 TeXstudio 中自动下载包，出于当时认知的局限性，当我需要某个模板加中文时，我的策略是:

- 更改所需要的模板 tex 文件，添加需要的包（除了添加中文支持，添加其他支持也可以，如算法写作支持）
- 利用 RStudio 生成中间的 LaTeX 文件，XX.tex
- 利用 TeXstudio 编译 tex 文件，过程中会弹出是否安装新包的命令，点击安装即可
- 如果在 TeXstudio 中能生成 PDF，那么在 RStudio 中自然也可以将.Rmd成功编译。

谢益辉之前填坑写的包,可以参考 <https://yihui.name/tinytex/>，根据这个包，其实可以取消掉 TeXstudio 这一步，利用tinytex 可以做到自动下载 LaTeX 的包。在 TeXstudio 中尝试加入新的支持方式，是我个人的一些习惯，可以借鉴，但不是最优解决方案。

## 幻灯片

R Markdown 可以生成的幻灯片模板挺多，但仅从生成的格式上，可以有 HTML、PPT、PDF三种，这取决于调用的是什么包。HTML 类型的幻灯片可以很好的加入交互效果，而以 beamer 为代表的 PDF 类型的幻灯片，则更适合做学术展示。直接生成 PPT 格式的幻灯片，私以为技术还不算成熟，不如直接用 PPT 做。下面就以三种我比较常用的模板聊一聊。

### remarkjs

谈到 remark.js，必定要谈的是谢益辉写的写轮眼包。起初知道可以用 RStudio 写好看的幻灯片也是从这里开始。我曾经用两个周末探索了一下这个包，整体来说满足了普通展示幻灯片的所有要素。在这里，我并不建议去更改这个包的模板。一方面是麻烦，且没有必要，另一方面是这个包其实已经含有很多扩展，问题只是在于如何使用。

正如之前所说的，阅读 YAML 文件就能做到当时我所没注意到的一件事，即更改主题。起初我并没有注意到写轮眼有着许多自定义主题，于是自己写了一个CSS，甚至在一次讲座上把 CSS 改得特别复杂，可以加 logo、横条色等，但实际对于一般人使用来说，换主题只需要知道主题名字即可。

主题的更改方法仍然可以通过阅读 YAML 的帮助探索出来，也就是看 xaringan::moon_reader 的帮助。很容易发现在css定义里说明了换主题可以根据 xaringan:::list_css() 的结果更改。 names(xaringan:::list_css()) 列出了可以更改的主题和字体。不看名字看整个结果的路径则可以看到 CSS 文件所放置的位置。也就是说，增加新主题也就是加个 CSS 的事。当我再回顾谢益辉的博客时发现，其实早在2017年，他就建议大家可以提交更新主题到他的 Github 下，之后下包自然可以自动更新。我估计并没有很多有闲心的人会去专门设计一款主题。如若是有人大主题的请回复我，也许 xaringan 在我使用的幻灯片名单中会排位更往前一点。

特别想说的一点是，利用网页类型的幻灯片，用 R Markdown 书写是可以直接添加 HTML 标签的。出于这个优势，往幻灯片中加歌曲、下拉表单也就变成了一件很容易的事。唯一的缺憾是，在 R Markdown 中，不能直接写 JS 代码。JS 代码需要用代码块，或是可以在整个 RStudio 编译完成之后再进行添加。稍微需要注意的是，应该提前保存代码，或者是单独写 JS 文件后添加引用。在 RStudio 每一次重新编译幻灯片的过程中，代码必不可免的会被重写和覆盖，从外部添加 JS 的过程也就需要重新完成。

xaringan 虽然好，但依然没有达到心中的目标：不再需要额外添加代码或者是排版动作就能构造清爽的幻灯片。这一定程度上是这个包自身的局限性。这里囿于篇幅，不去详解如何完整地更改主题，嵌入歌曲、嵌入下拉表单和加 logo 的过程。或许未来能完整地梳理，取决于这条路是否在未来还有可行性，制作一个完整而有各种功能的 xaringa 幻灯片通常也可能耗费我一晚的时间。


### revealjs

remark.js 让人最无奈的问题莫过于当内容过长时，无法下拉，只能切成多页幻灯片。一年前，我无法解决这个问题。但在一次偶然回顾中发现，reveal.js 似乎是更新了，或者是之前没注意到，某页的背景可以上下拉动，这也就是说在 R Markdown 的 reveal.js 一样可以克服这个问题。其原理是在网页中嵌入框架，利用框架可以接入子 HTML，而子 HTML 可以上下拖动。由于 R Markdown 中引用的是 reveal.js 的 JS 文件，也就说明在 R Markdown 中嵌入相应的标签代码，JS 自然会完成渲染。此外，我突发奇想，可以嵌入可以下拉的网页，自然也可以嵌入 PDF，在展示幻灯片中嵌入论文或者是 bearmer 的PDF 也可以得到实现，在给他人展示时，假使需要使用论文中的结果，直接引用论文或别人的结果可是再方便不过了。

或许我唠叨的这些，除了我以外没人看懂在说什么，但具体效果可以参照我 Github 中 frSVD，为了在 R 会中做展示的幻灯片，再阅读对应的 R Markdown 文件，对这个流程就比较清楚了。具体的链接如下：
<https://llijiajun.github.io/frSVD/#/>

reveal.js 区别于 remark.js 而吸引我的是，同样是 HTML 类型幻灯片，它的主题设置和转场效果也许都更加酷炫。

还是不得不说，也许有人觉得学这些制作方式，无非是炫技，但从更长远的角度说，与 R 和 Python 的联动才是我认为利用 R 做幻灯片的根本优势。现在关于 R 的动态框架接口并不是特别多，但至少嵌入地图、嵌入表单是很容易的一件事( DT 等包)，作为专业的统计人员，交互式幻灯片可以将意思表达得更清晰。被误解是表达者的宿命，但越多人能更易于理解，更能推动思想地传播。


### beamer

最初接触 beamer 的时候，还是上课时，老师们版式一致的 PDF。后来在偶然之间，发现可以用R生成 beamer。也许大部分老师或者学生都是直接利用 LaTeX 模板生成，但 LaTeX 毕竟对新人不是特别友好，对新手最友好的语言莫过于 Markdown 了，半小时基本可以学会流利的 Markdown 文章的书写，利用 R Markdown 生成 beamer 远比直接写tex要方便得多。

直接利用 beamer_presentation 生成的 beamer 幻灯片比较干净，可以根据主题和颜色主题修改，即可得到老师们常展示的幻灯片样式，参考的样式可以去看官方的链接：
<https://hartwork.org/beamer-theme-matrix/>

但仅仅使用默认的 beamer 是远远不够的，课程作业必须使用中文，英文也太过为难读者，加入中文的方式很简单，同样是去读编译的方式，还是利用 Pandoc 转换，而 Pandoc 可以直接生成 beamer 的模板：

```
pandoc -D beamer > beamer-template.tex
```

在我的 LaTeX 中加中文，通常就一句

```
\usepackage[UTF8, heading = false, scheme = plain]{ctex}
```

也就是在 \documentclass 后加一句，做出的幻灯片就能加入中文。这里也可以呼应一下前文，在 rticles 包里有很多论文的模板，一般来说，写这些论文或许全英文比较好，但如果课程报告中需要中文论文，又想用这些论文模板，也可以在中间加这一段，那么对应的 rticles 模板即可引入中文。

借此启发， LaTeX 能做到的事不仅仅如此，例如插入规范的算法，插入合适的参考文献，流程图等等，而所需要做的仅仅是在模板中引入 LaTeX 代码即可在未来的所有幻灯片中都而可以使用。举个最简单的例子，在 beamer 幻灯片中加入 logo 和背景，效果如图：

![自制人大beamer模板](https://llijiajun.github.io/github-io/images/beamer.png)

受到香港大学同学的启发，自定义自己领域常用的符号和公式，或者是自定义公式图片，可以大幅度地减轻编写压力。而我未来要做的事，也就是积累足够多的LaTeX经验，并总结出一套适合自己使用的模板，利用 R Markdown 加速编写，总结一套人大模板也许只是第一步。最终一样能开发出 beamer 下的 prettydoc 包，以我懒散的性子，或许也就是有生之年系列。

## 总结

本文对每个 R Markdown 的具体实现都并不是写得特别详细，也并非教程，只是汇总。也许有人有更好的想法和手段，希望也可以和我交流，但具体实现过程，写成博客也是有生之年系列。更多广泛的可能性，可以阅读谢益辉的书<https://bookdown.org/yihui/rmarkdown/>，每每回顾都有所感，启发了我整个探索的过程。

## 参考资料

* [JJ Allaire and Yihui Xie and Jonathan McPherson and Javier Luraschi and Kevin Ushey and Aron Atkins and Hadley Wickham and Joe Cheng and Winston Chang and Richard Iannone (2019).rmarkdown: Dynamic Documents for R. R package](https://rmarkdown.rstudio.com)
* [Yihui Xie and J.J. Allaire and Garrett Grolemund (2018). R Markdown: The Definitive Guide. Chapman and Hall/CRC. ISBN 9781138359338.](https://bookdown.org/yihui/rmarkdown)
* Yihui Xie (2019). knitr: A General-Purpose Package for Dynamic Report Generation in R. R package version 1.23.
* [Yixuan Qiu (2018). prettydoc: Creating Pretty Documents from R Markdown. R package version 0.2.1.](https://CRAN.R-project.org/package=prettydoc)
* [JJ Allaire, Yihui Xie, R Foundation, Hadley Wickham, Journal of Statistical Software, Ramnath Vaidyanathan, Association for Computing Machinery, Carl Boettiger, Elsevier, Karl Broman, Kirill Mueller, Bastiaan Quast, Randall Pruim, Ben Marwick, Charlotte Wickham, Oliver Keyes, Miao Yu, Daniel Emaasit, Thierry Onkelinx, Alessandro Gasparini, Marc-Andre  Desautels, Dominik Leutnant, MDPI, O?uzhan ??reden, Dalton Hance and Daniel Nüst (2018). rticles: Article Formats for R Markdown. R package version 0.6.](https://CRAN.R-project.org/package=rticles)
* [Yihui Xie (2019). tinytex: Helper Functions to Install and Maintain 'TeX Live', and Compile 'LaTeX' Documents. R package version 0.13.](https://CRAN.R-project.org/package=tinytex)
* [Yihui Xie (2018). xaringan: Presentation Ninja. R package version 0.8.](https://CRAN.R-project.org/package=xaringan)
* [Hakim El Hattab and JJ Allaire (2017). revealjs: R Markdown Format for 'reveal.js' Presentations. R package version 0.9.](https://CRAN.R-project.org/package=revealjs)

