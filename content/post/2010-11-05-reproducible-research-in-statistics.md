---
title: "Sweave：打造一个可重复的统计研究流程"
date: '2010-11-05T22:37:03+00:00'
author: 谢益辉
categories:
  - 统计软件
tags:
  - LaTeX
  - LyX
  - pgfSweave
  - R语言
  - Sweave
  - 可重复研究
  - 开源软件
  - 统计分析
  - 统计数据
  - 统计研究
slug: reproducible-research-in-statistics
forum_id: 418822
---

**警告**：本文提到的工具在更新中，请暂时不要按本文的配置去做，静候LyX 2.0.3的发布。

我们都痛恨统计造假。我们都对重复性的工作感到厌倦。如果你同意这两句话或这两句话适用于你的现状，那么本文将介绍一套开源、免费的工具来克服这两个问题。当然，前提是你愿意改变，这里的工具可以让这两种现象没有藏身之地，但无法改变造假和重复劳动的现实。以下为吊胃口视频（墙外观众可以看[Vimeo](https://vimeo.com/16374405)；墙内看不到视频的可以任选一个链接下载本视频的AVI文件：[链接1](https://www.mediafire.com/?iyp62cmyi8vmwd3)、[链接2](https://www.filefactory.com/file/b422e9f/n/31632916.avi)、[链接3](https://www.filedropper.com/31632916))：

# 1. 统计研究流程

“收集、整理、分析和表述数据”是从流程上对统计学的定义，大部分统计研究都会全部或部分包括这四个步骤。其中，收集和整理数据有相当大部分的体力活（抽样设计除外），分析数据基本上是脑力活（当然也有人把它做成了体力活，Excel可能是个代表），表述数据则是二者兼有。统计造假无非有两种：一种是捏造数据，另一种是捏造结果。前者很难从工具的角度解决，它是个道德问题，但如果数据源是大家都可以公开获得的，那么这个造假也可以从工具角度消除；后者则是我们更容易控制的，比如对于刊物的审稿编辑来说，他可以要求作者提供数据分析的详细过程，用以检验整个分析是否可以在自己手中被重复生成（reproduce）。

整个统计分析的流程如果能一遍成功，那么我们可能是太幸运了，更多情况是，我们要一遍又一遍重复劳动，因为这个流程中出差错或变故的可能性太多了。例如，发现数据源中有错误数据，或是过了一段时间又有新数据增加进来，或是分析的目标变量改变了，或是变量变换的计算公式变了，等等。通常我们面对变化的解决方案就是从头再来：更新数据，重新计算，重新复制，重新粘贴结果，重新调整报告格式……这一系列过程之所以变得不可自动重复进行，本质原因是我们把本应该流程化的操作分解成了不可替代的手工劳动。什么样的手工劳动是不可替代的？最常见的可能就是复制粘贴和点菜单。例如从Excel表中复制一部分数据，粘贴到统计软件中，点菜单“统计分析–>回归–>选入因变量自变量–>输出结果–>复制回归系数–>粘贴到Word中并调整格式”。据我所知，目前计算机还没有发展到能智能记忆这些手工操作过程、过一段时间之后再自动“回放”的地步。计算机能“记忆”和执行的只有代码。

# 2. 可重复的统计研究

所谓可重复的（reproducible）统计研究，就是一个研究结果既可以在作者手中生成出来，也可以“移植”到他人的平台中用同样的工具重复生成出来，就像物理或化学或生物实验一样，需要每一位实验者在相同条件下都能观察到实验结果。如果一个回归系数仅仅在作者的结果中显著，而在他人手中无法重现，那么这就是不可重复的统计分析。这里“无法重现”的原因有很多，包括：数据不可获得、软件不可获得、分析代码不可获得或分析过程缺乏详细说明。如果用“读者可重复”的标准来要求统计论文或报告，当今（尤其国内）恐怕能发表的统计分析可能就不会剩下太多了，因为提供数据和分析过程似乎偏离了论文的主题。（题外话：在统计之都主站发表的文章中，凡是涉及到数据和分析的，都一律提供详细过程，保证可重复性，这一点对于“珍惜版面”的纸质刊物来说可能不太现实）

当然，有些统计研究不可重复是可以理解的，典型的如数据需要保密。但期望“透明”总是人类本性，即使我们不把它考虑为一个道德问题，也应该从自身工作便利角度考虑一下这个问题。

经过这一大段云里雾里的介绍，我将要推荐的是用代码工作，并且尽量在代码中减少“硬编码”部分，即：让代码具有广泛适用性，而不要仅仅对一个特定大小的数据的特定变量做特定处理。即使使用“硬编码”，也要考虑将来维护的便利性，例如只需要改一下文件名，重新跑一遍程序，所有的流程可以不变就可以**一步**重新生成最终的报告。这可能吗？当然。Sweave就是一种工具。

# 3. Sweave介绍

首先声明，用代码工作并不适合所有人和所有情况，尽管磨刀不误砍柴工，但这把刀并不好磨。如果我们希望统计分析的流程能畅通无阻，那么这个过程中我们使用的工具必须能相互“沟通”。从统计软件中复制粘贴结果到Word中这样的做法很难重复，是因为Word很难自动从统计软件中获取结果，换句话说，它们太难相互沟通。软件之间沟通的最便利途径就是大家都能基于源代码工作，或基于纯文本工作，因为即使回到石器时代，计算机总是能处理纯文本文件的。Sweave生存的重要原因就是，LaTeX（一流的排版工具）和R语言都基于源代码工作。下面简单介绍一些什么是Sweave。

从形式上来看，Sweave也没太多新奇之处：它无非就是将LaTeX文档和R代码混合起来，先调用R执行一遍这个文档中有特定标记的代码，并输出相应的结果到这个文档中（源代码都被相应的计算结果代替），然后再调用LaTeX编译文档为PDF。了解动态网页的人可能觉得这完全是动态网页的概念——输出是动态的，而非写死的结果。举个例子，Sweave文档看起来是这样的：

```tex
\documentclass{article}
\title{A Test Sweave Document}
\author{Yihui Xie}
\usepackage{Sweave}

\SweaveOpts{pdf=TRUE, eps=FALSE}

\begin{document}
\maketitle

We can take a look at some random numbers from N(0, 1):
<<test1>>=
x = rnorm(5)
x
@

The 3rd number is \Sexpr{x[3]}.

Draw a plot for the iris data:
<<test2, fig=TRUE, results=hide>>=
plot(iris[, 1:2])
@

\end{document}
```

表面看来这就是一篇LaTeX文档，只不过其中插入了一些用`<<>>=`标记开头、用`@`结尾的R代码段（PHP程序员可以想象`<?php ?>`）。R自带一个`Sweave()`函数，可以用来预处理这些代码段以及其中的`\Sexpr{}`宏。我们可以将以上代码保存为一个`.Rnw`文件如`myfile.Rnw`，然后在R中`Sweave('myfile.Rnw')`，这样`myfile.Rnw`就被替换为`myfile.tex`（即LaTeX文档），而其中的内容则被替换为了相应的输出：

```tex
\documentclass{article}
\title{A Test Sweave Document}
\author{Yihui Xie}

\usepackage{Sweave}

\begin{document}
\maketitle

We can take a look at some random numbers from N(0, 1):
\begin{Schunk}
\begin{Sinput}
> x = rnorm(5)
> x
\end{Sinput}
\begin{Soutput}
[1]  0.74541470 -1.49287775 -1.66834084  0.08252667  0.92772016
\end{Soutput}
\end{Schunk}

The 3rd number is -1.6683408359077.

Draw a plot for the iris data:
\begin{Schunk}
\begin{Sinput}
> plot(iris[, 1:2])
\end{Sinput}
\end{Schunk}
\includegraphics{myfile-test2}

\end{document}
```

从这个极端简化的例子来看，我们完全不必复制粘贴结果，比如我们生成了一个变量`x`，从中提取第三个数字`x[3]`输出在正文中，而不必写死`-1.668`；图形也一样，它可以根据数据动态生成，而不必先画好一幅图再插入文档中。最后我们运行`pdflatex`编译这份文档，就得到了最终的报告（[本例PDF下载](https://uploads.cosx.org/2010/11/myfile.pdf)）。

为什么Sweave是一个具有“可重复”性质的工具？原因就是代码控制了流程。比如我们可以用代码读取数据，进行变量转换，建模，输出我们需要的部分（而不是甭管有用没用、一气儿输出三十页统计报告）。代码的灵活性是无限的，它也忠实记录了统计分析的详细过程，所以我们不可能捏造结果，另外也能大大减轻手工重复劳动。

# 4. 懒人的工具

既然Sweave是基于LaTeX的，那么先说LaTeX：我用了几年LaTeX，对它是又爱又恨。它在排版上当然是超一流的工具，输出的PDF文档整洁利索、结构分明，一看就是科学范儿，但我实在痛恨敲LaTeX命令。传说中的LaTeX介绍都说它能让你专注于写作而不必担心格式，可对我来说这是不太可能的，确实LaTeX可以自动安排格式，而且调整起来也方便，但我一直觉得写LaTeX文档很不直观，我对章节分布很难形成概念，光是`\section{}`这种命令，让人很难有章节标题的感觉；还有图表，完全不形象，看着`\includegraphics{}`根本不知道这里插的是哪幅图。所以从某种程度上来说，LaTeX本身是很考验人的记忆力的，你要记住哪个标签是什么意思，现在在写哪一节，等等。直到后来用上了[LyX](https://www.lyx.org)，这些“不满”才一扫而光。LyX是一个看起来“所见即所得”（WYSIWYG）的工具，但实际上是“所见即所想”（What You See Is What You Mean），换句话说，它是披着Word外衣的LaTeX，尽管内部运行方式和Word截然不同。如果你熟悉LaTeX，那么打开LyX的菜单你将几乎处处发现LaTeX的踪迹。LyX对LaTeX用户可以说是体贴细致入微：我们不必担心特殊字符问题（都会被替换为`\`引导的字符或等价的命令），不必担心图片的格式（会自动转换），不必担心忘记引用某个需要的LaTeX宏包（比如插入图片时会自动在导言区加上`\usepackage{graphicx}`），写列表的时候不必反复敲`\item`命令（写完一个，回车就会自动生成下一个），当文档含有目录时会自动调用两次或三次`pdflatex`来编译目录，数学公式可以直接用眼睛看到，……易用性不亚于Word（前提是你懂LaTeX），排版质量高出Word百倍。这就是个“不给马儿吃草又要让马儿跑得快”的懒人工具。

幸运的是这个懒人工具在设计时竟然也考虑了“文学编程”（literate programming，这翻译有点奇怪），因此也就为Sweave嵌入LyX留下了铺垫。先岔开话题回到第3节：Sweave的这种编程方式就是文学编程的一种实现，而文学编程如其字面意思所指，是将程序融入文学作品中（这里文学泛指普通文本），这些程序运行之后将输出结果到文字中。与文学编程相对应的便是常见的结构化编程，也就是我们经常看见的大篇纯程序代码。文学编程的提出者为Donald Knuth——也就是TeX的作者。

LyX给文学编程留下的后路基本上在一个叫`literate-scrap.inc`的文件中（安装目录的`Resources/layouts/`或者用户目录的`layouts`文件夹下），它定义了文学编程文档的输出类型（`literate`），而另外在LyX的选项文件`preferences`中，我们又可以定义从`literate`到LaTeX的转换器，也就是Sweave()函数或等价的Sweave处理方式——将Rnw文件用R运行得到tex文件。比如我们可以这样定义：

```tex
\converter "literate" "pdflatex" "R -e Sweave($$i)" ""
```

这里面的血腥细节我就不详细介绍了，后面我会给出普通用户可以接受的配置方式。总之这里大意就是：`literate`类型的LyX文档可以输出为Sweave文档，通过R执行转化之后可以生成tex文档，LyX此时再进来调用`pdflatex`编译生成报告。这就是Sweave在LyX中的执行过程。在外面看来，也就是本文开头的视频中所展示的过程。

# 5. 自动配置工具

配置这一套工具对于初学者来说显得有些困难，因为这里面的新概念和高级概念太多了。比如可能大多数Windows用户一辈子都不会遇到一个叫“PATH环境变量”的东西，还有LaTeX宏包的安装过程，以及大量的命令行工作细节（例如[命令行重定向](https://technet.microsoft.com/en-us/library/bb490982.aspx)），等等。即使抛开配置不谈，光是LaTeX和R的学习也够折腾好一阵子了。抱着“苦不苦想想红军两万五”的信念，这里的三个月学习时间也许能替代十年的重复劳动（也许，只是也许，不要轻易相信我的广告）。

如果你已经装好了LyX（及其配套LaTeX程序如[MikTeX](https://www.miktex.org)、[TeXLive](https://tug.org/texlive/)或[MacTeX](https://tug.org/mactex/)和[R](https://www.r-project.org)（版本 >= 2.12.0），整个配置过程只需要在R中执行一句话：

```r
source('http://gitorious.org/yihui/lyx-sweave/blobs/raw/master/lyx-sweave-config.R')
```

R会自动处理那些血腥细节：下载文件并解压缩、复制到正确的文件夹，安装需要的LaTeX宏包和更新LaTeX的文件名数据库、重新配置LyX、设定环境变量PATH（放入R的bin路径）。这段代码适用于Windows、Ubuntu（理论上其它Linux发行版也不会有问题）和Mac OS。

大部分血腥细节的解释参见：[How to Start Using (pgf)Sweave in LyX in One Minute](https://yihui.name/en/2010/10/how-to-start-using-pgfsweave-in-lyx-in-one-minute/ "How to Start Using (pgf)Sweave in LyX in One Minute")

这里需要说明的是，我倾向于用pgfSweave包，它是对Sweave的一个扩展，R自身的Sweave尽管已经很强大了，但我对它有几点不满（非偏执狂请略过）：

  * 它对代码的自动整理功能：大多数人都痛恨阅读源代码，尤其是乱糟糟的源代码（没有空格没有缩进），或者是没有注释的源代码，为了不要折磨读者，我们应该保持代码的整洁，而另一方面我们也不希望折磨写代码的人，因此我们需要一个自动整理代码的工具。R自身的Sweave中有一个keep.source选项，若为TRUE，则完整保留用户输入的代码并原样输出，这在很多情况下都很糟糕；若为FALSE，则会自动整理代码，但代价是除掉注释，这也很糟糕。这件事长期以来无法找到平衡点：既自动整理代码，又保留注释。最终这个问题[被邱怡轩以一个小技巧部分解决了](https://yihui.name/cn/2009/03/smart-trick-to-tidy-r-source/)，但这种技巧并不“优雅”，所以指望R core收录是无望了，最终我把这段代码提供给pgfSweave包的作者被收录在这个包中（嘿嘿，俺们草根有力量），所以pgfSweave有自动整理代码的功能，并且可以保留注释；注意pgfSweave包默认是不整理代码的，必须在全局选项中设置tidy为TRUE才行，即插入LaTeX命令：`\SweaveOpts{tidy=TRUE}`，然后在最开头的R代码段中使用`options(keep.blank.line = FALSE)`，这样能得到最好的输出。
  * 图形格式和大小设定：Sweave默认会生成PDF和postscript格式的图片（分别可用pdf = TRUE/FALSE和eps = TRUE/FALSE控制），通常矢量图当然比位图强百倍，美观、无损缩放，但R图形有个小问题（纯属挑剔）就是字体，默认情况下图形都是用无衬线字体（Windows底下如Arial字体），这和LaTeX文档的字体可能不一致（尽管[这个不一致可以在一定程度上减轻](https://yihui.name/en/2010/03/font-families-for-the-r-pdf-device/)，而pgfSweave直接从根本上解决了这个问题，因为它是以tikz格式记录R图形，这种格式实际上就是LaTeX代码，因此编译文档的时候图形也会被重新编译，所以图中的文本的字体和正文就完全一致了（[例](https://yihui.name/cn/wp-content/uploads/2010/02/lyx-pgfsweave.pdf)）；另外，默认Sweave中图形大小的控制方式也很不直观，选项width和height是控制图形设备的宽和高的，而非实际LaTeX文档中图形的宽高，我们只能通过LaTeX命令`\setkeys{Gin}{width=?}`来设定（尽管这个也有办法绕过去），而pgfSweave则默认采取了直观的指定宽高方式，即：直接在选项中指定。
  * Sweave本身没有缓存功能，这对于大批量的计算来说是个灾难：所谓缓存就是计算结果被缓存在某个位置，下次运行Sweave文档的时候如果代码没有修改，这些结果则可以不必被重新计算一遍，直接从缓存里读出来就可以了，这是cacheSweave包的功能； pgfSweave在这个基础上更进一步，让图形也有缓存功能了。缓存可以让整篇文档在R层面上的编译速度加快（但事实上由于pgfSweave用tikz图形而这种图形需要LaTeX编译，所以整体速度未必真的加快了）；

![LyX和pgfSweave包生成的图形](https://uploads.cosx.org/2010/11/lyx-formula.png "LyX和pgfSweave包生成的图形")

LyX和pgfSweave包生成的图形

# 6. 演示和问题

如果工具都准备齐全了，那么可以下载两个演示文件了解一下LyX/pgfSweave的效果（[demo 1](https://gitorious.org/yihui/lyx-sweave/blobs/raw/master/demo/LyX-pgfSweave-minimal-demo.lyx)；或[demo 2](http://gitorious.org/yihui/lyx-sweave/blobs/raw/master/demo/LyX-pgfSweave-demo-Yihui-Xie.lyx)^和相应的[BibTeX文献库](http://gitorious.org/yihui/lyx-sweave/blobs/raw/master/demo/LyX-pgfSweave-demo-Yihui-Xie.bib)[编者注：这三个链接现在已经失效，抱歉。]），其中一个例子简单，一个复杂。简单例子就像前面视频中显示的一样，只是感觉一下基本功能；复杂例子实际上是我自己的一次作业，略作改编：它演示了从URL读入数据，并进行一些极大似然估计、似然比检验和基于Delta方法的区间估计，还有简单的t检验和画图（包括base图形和ggplot2图形）。其中图表都是动态生成，几乎没有任何写死的数字。

这个例子的数据在所有人都可以公开访问的网站上，所以数据有可重复性；分析代码全都嵌在LyX文档中，所以分析过程也有可重复性。这里面不涉及到生成随机数，所有计算都是确定性的，因此所有人用相同的工具可以重复生成我的结果。

除了可重复性之外，由于分析流程全都用代码记录，所以我不必担心数据的提供者突然更换源数据中的几个数值，如果发生这种情况，我只需要重新点一次按钮就可以了。当然，有时候要是数据发生了很大的变化，导致结论都变了，那么就需要修改正文文本了（实际上结论也是有可能动态化的，这里对于一份普通作业来说就没必要搞那么复杂了）。

另外，LyX文档本身其实也是纯文本文件，这也为文件的版本控制留出了一条路。我们可以使用版本控制工具SVN或GIT来管理我们的文档，每次的修改和更新部分一目了然，而且可以团队合作共同写一份报告（版本控制工具会自动合并各位成员的修改），这比Word里面笨重的“审核修订”功能又强了百倍，你再也不必总是发送邮件附件“某主题报告张三20101104.doc”或“某主题报告李四20101103.doc”给你的同事，然后用肉眼修订。LyX本身支持SVN，（预计）到本年年末，LyX 2.0横空出世时，这个版本控制功能将极大增强。这似乎有点离题，但我要说的是“透明”工作方式带来的天然优势。

免费的午餐是不存在的，用LyX和pgfSweave也要付出一些代价，这些可能的痛苦我都在[上面提到的英文博客](https://yihui.name/en/2010/10/how-to-start-using-pgfsweave-in-lyx-in-one-minute/)中解释了，这里简要提一下：

1. 查错略有些麻烦：如果R代码没有错误，那么万事大吉，点一下按钮就可以生成PDF报告了，但这种情况恐怕少之又少，当代码运行出错的时候，LyX无法知道R出了什么错，它不会记录R运行的日志，这个问题可以通过命令行重定向解决。我在自动配置文件中已经写好了，读者可以不必关心细节，如果R运行出错，那么可以到LyX临时目录下找一个`*.Rnw.log`文件，这里的`*`是你的LyX文档名称，临时目录可以在LyX菜单“工具–>选项–>路径–>临时文件夹”中找到，也可以自行设置（我通常把默认的目录换成一个更“浅”一些的目录，方便我查看日志，要不然得走到系统默认的很深的隐藏目录中去）。这个日志文件会记录R的运行过程，你可以从最后几行看出来到底运行到哪个代码段出了错；
1. 警惕LaTeX特殊字符：LaTeX本身大概有十来个特殊字符，如果要使用它们本身，则需要用\引导，比如百分号需要写成`\%`，否则`%`意思是注释；由于pgfSweave生成的是LaTeX代码图形，里面要是含有特殊字符则会让LaTeX编译失败，这种情况可以手工处理，比如`plot(x_1, y)`会生成x轴标签x_1，我们可以手工指定x轴标签`plot(x_1, y, xlab = "x\\_1")`，这样就不会编译出错了；另外一个办法是看tikzDevice包的帮助文档，它有办法自动处理这样的特殊字符；最后一个办法就是不用tikz图形，改用PDF图形，在代码段的选项中设定`<<tikz=FALSE, pdf=TRUE>>=`，损失样式，换取“安全”；
3. 超大图形：如果一幅图形非常复杂，则相应的tikz文件也会非常大，这会让LaTeX抱怨内存不够用，编不过去，这种情况下也可以取道pdf（例如[我的硕士论文图1和图9](https://yihui.name/cn/publication/#GSM)）；
4. 使用lattice和ggplot2图形的时候一定要记得`print()`图形，否则图不会被画出来，这和base图形是不一样的；

可以看到，尽管这些痛苦存在，但并非跨不过去。只是初学者一定要注意，免得处处受挫。

# 7. 小结

本文看似很长，但如果仅仅从使用角度来说，可能五分钟就足够你完成配置并写出一篇动态统计分析报告了。这里面的细节太繁杂，为了避免“欲练此功，挥刀自宫”，我把配置过程揉进了一个R脚本，随后的事情就是理解各种工具的工作原理（理不理解其实关系也不大）、学习基本用法（主要是各种Sweave选项，参见`?RweaveLaTeX`和`?pgfSweave`），我想新手上手可能也不一定就那么难。我要强调的是时刻保持挑剔的心态，不要制造垃圾代码，让文档尽量简洁。如果真把LyX当Word用（这里选12号字、那里强制换行），那就糟糕了——你没领悟LaTeX的排版哲学。

统计的透明，仅仅靠道德宣传和约束恐怕是永远都不可能实现的，我们需要使用透明的工具。很多人认为工具只是低层次的东西，然而也许我们能通过工具推动一套制度。本文也可以说是象牙塔中的一种想象，它是否能得到实际应用，还要经过实践检验。不管怎样，如果能真正步入Sweave殿堂，一切报表工具将是浮云。

总之，自由软件的自由，不仅仅是开源这么简单。

# 8. 参考资料

  * LaTeX学习材料：A Not So Short Introduction to LaTeX （[英文](https://www.ctan.org/tex-archive/info/lshort/english/lshort.pdf)、[中文1](http://zelmanov.ptep-online.com/ctan/lshort_chineese.pdf)、[中文2](http://ctan.math.utah.edu/ctan/tex-archive/info/lshort/chinese/lshort-zh-cn.pdf)）；这是几年前我的LaTeX入门材料
  * [Sweave手册及相关信息](http://www.statistik.lmu.de/~leisch/Sweave/)^[编者注：这个链接现在已经失效，抱歉。]
  * [pgfSweave包开发网站](https://github.com/cameronbracken/pgfSweave)
  * [LaTeX and Sweave without Tears](https://cloud.github.com/downloads/yihui/yihui.github.com/LaTeX-Sweave-2011-Yihui-Xie.pdf)（个人报告）

# 致谢

这里要特别感谢爱荷华州立大学统计系579课程的同学们不断向我反馈程序问题，才能使得这段程序日臻完善，让看起来遥不可及的Sweave能飞入寻常百姓家。
