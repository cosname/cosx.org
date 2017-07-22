---
title: 如何更好的展示你的研究成果
date: '2015-09-11T18:02:07+00:00'
author: Dianne Cook
categories:
  - 可视化
  - 推荐文章
  - 经典理论
  - 统计之都
  - 统计图形
  - 统计软件
  - 职业事业
tags:
  - Dianne Cook
  - useR
  - 汇报展示
  - 海报
  - 研究成果
slug: tips-for-presenting-your-work
forum_id: 419095
meta_extra: "译者：陈妍；审校：高涛、肖楠、谢益辉；编辑：王小宁"
---

>【COS编辑部按】本文作者是美国统计协会（ASA）的会员、莫纳什大学教授
>[Dianne Cook](http://dicook.github.io/)。她的研究方向包括数据可视化，探索性数据分析，多元方法，数据挖掘和统计计算。曾参与制作软件XGobi，ggobi，cranvas和几个R包。

>原文发表在[The R journal](http://journal.r-project.org/archive/2011-1/RJournal_2011-1_Cook.pdf)，本文由陈妍翻译，
>[高涛](http://joegaotao.github.io/)、肖楠和[谢益辉](http://yihui.name/)审校，王小宁编辑。

![](https://uploads.cosx.org/2015/09/dicook-2014-500x314.jpg)

# 摘要

随着国际R用户会议“user!2011”的临近，许多与会者可能正在思考如何通过演讲集中展现自己的一些想法，本文便为大家就演讲和制作海报等问题提供了一些建议。

# 背景

在即将到来的几次学院工作面试中，我准备介绍我的博士研究项目，就在我刚完成一次面试的演练时，我的导师安德烈·布加(Andreas Buja)让我坐下来：重新起草我的讲稿！我本初是参照罗格斯大学每周一次的研讨会上许多演讲者那样做的——通过幻灯片一张接一张的展示自己研究工作的细节，但安德烈说，那可能很适合论文的展示，但并不是作为讲稿的最佳选择。我们列出了我的研究中的重点问题，然后插入了一张幻灯片简单的写道“欲知后事如何，请听下回分解”。我们在之后的几张幻灯片中阐述了研究方法，在报告临近结束时才给出了问题的答案。<!--more-->

这个“欲知后事如何，请听下回分解”深深打动了我。

# 核心要点

Schoeberl&Toon（2011）网站和Marle（2007）网站有一些关于做科学报告的很有用的建议。下面是从我自己的经验中总结出的一些要点：

  * 做一个整体规划，仔细安排开头（包括如何激发听众的兴趣）、中间和结尾部分。做出幻灯片的框架，概述你想在每张幻灯片讲述的问题。
  * 避免一张一张幻灯片的罗列要点（PPT综合症），或者一页又一页的方程式。
  * 建立你的理论依据。对于一个传统的听众，可能需要写出一些方程式或者一个证明的核心部分。对于那些关心统计计算和计算统计的人，可能需要展示一段程序代码—比如一段写得十分优雅的，或者解决关键问题的代码。（我和我的同事偶尔会开玩笑说，看程序员写程序可能比听报告要更有意思。当然这是半开玩笑性质的，不过有时看一个老练的程序员调试程序是很有启发性的。）
  * 使用基于数据绘制的图形。但是一定不要直接说“我们可以从图上看出……”，要加一些解释性的语句，例如“因为这些点符合某某曲线形式”。也就是说，要解释图形的特征，这样才可以让人们思维保持连续性。
  * 使用图形或者卡通画来辅助解释一些概念。
  * 使用图片以产生视觉刺激。但这并不是因为图片“是让无知者了解常识的工具”，也不是因为图片可以“防止一些傻瓜听众瞌睡”（Tufte，1990），而是因为图形很美观，可以激发听众灵感。
  * 讲一个故事。

# 实战建议

许多统计学家用LaTeX的Beamer模板来制作幻灯片。它用来编辑方程式很方便，排版也很漂亮。并且它在文本颜色、字体选择、导航条及图形和动画的制作上灵活性很大。但我自己更喜欢苹果电脑的Keynote。它在格式编排上灵活的多，并且能够使用极富个性的字体（例如我的手写体），还可以无缝结合动画和电影。我的电脑上有一个“tmp.tex” 文件专门用来收集方程式，里面存着所有我曾使用过的方程式，我是从从pdf的预览文件中剪切并粘贴过去的。在调整方程式和图形的尺寸时，Keynote可以保证原图的成像质量，这点Powerpoint做不到。Keynote和TeX一样，可以把图形存储在相互独立的文件中，“slide.key”可能很像一个文件夹，但它实际上是个目录。

Robbins（2006）是绘图的一个基本指导。R中的ggplot2包（Wickham，2009）提供了很漂亮而且透视效果很好的图形默认色。

# 海报的威力

  * 注意海报的版面布局和画面连贯性。
  * 确定你的报告想阐述的主要问题，明确谁是你的听众。
  * 选好你的配色方案，要考虑它是否便于色盲者辨认，要避免合在一起有特殊意义的颜色组合，例如：红、黄、黑，它们合在一起是德国国旗的颜色。
  * 选好字号和字体。题目要字号大约100pt，小标题字号50pt，正文字号至少25pt。要避免全部大写。
  * 基于数据的图形很好的焦点。一个联系上下文的图形可以帮助人们迅速的抓住数据的重点，还可以让人们看到一些熟悉的东西，吸引他们的注意力。高质量的图画（例如用R做出来的）是很重要的。
  * 动画音频都可以吸引过路者的注意力，但它们不能用来吸引听众参与小组讨论。

要知道，做得不好的统计会议海报比比皆是。因此，用“其他人都这么做海报”来为自己才疏学浅开脱并不合适。随着我们对优秀的海报策划认识的逐步加深，对每个海报制作的标准也是越来越高。我们可以在Cape 高等教育联盟（2011）的网站上找到非常好的关于制作海报的建议，另外，Purrington（2011）的网站上有关于设计科学海报的很有价值的讨论。与联合统计会议结合进行的Data Expo竞赛（ASA，2011）上也经常有一些制作很好的海报。此外，我们也可以在<https://www.r-project.org/conferences.html>上找到以往的国际R用户会议的海报。

# 负责的听众？

我偶尔或者更经常的发现一些听众在赞扬某场报告的精彩之处，但是很明显他们又根本不知道报告讲了些什么。因此听众有责任不表现出赞扬，因为他们对演讲者的良好印象很容易被演讲者被过于放大。听众也有权期望演讲者把报告做的清晰而容易理解，并且能把报告讲解的明白。

# 结语

一定要记住，在同僚面前做报告是很荣幸的——不是所有人都有机会在说出他们的想法并且被聆听，特别是在高规格的会议上（例如useR！）。

很多人对TED演讲（Rosling，2006）很感兴趣，而我最近却被最近被Chris Wild（2009）做的一个报告吸引了，这是一个很出色的统计方面的报告。

# 参考书目

[1] American Statistical Association. (2011) Data Expo Posters URL  http://stat-computing.org/dataexpo/

[2] Beamer Developers. (2011) Beamer—A LaTeX class for producing presentations. URL https://bitbucket.org/rivanvx/beamer/wiki/Home.

[3] Radford M Neal, Bayesian Learning for Neural Networks, , 1994

[4] Cape Higher Education Consortium. (2011) Information Literacy URL  http://www.lib.uct.ac.za/infolit/poster.htm.

[5] D.Cook. (2007) Improving Statistical Posters. URLhttp://www.amstat.org/meetings/jsm/2008/pdfs/ImprovingStatisticalPosters.pdf.

[6] B.Dougherty and A.Wade. (2011) URL http://www.vischeck.com/vischeck/.

[7] Etre Limited. (2011) URL http://www.etre.com/tools/colourblindsimulator/.

[8] R.Ihaka, P. Murrell, K. Hornik, A. Zeleis. (2011) colorspace:Color Space Manipulation. URL http://cran.r-project.org

[9] E.Neuwirth. (2011) RColorBrewer: ColorBrewer palettes. URL http://cran.r-project.org.

[10] C.Purrington. (2011) Advice on Designing Scientific Posters. URL http://www.swarthmore.edu/NatSci/cpurrin1/posteradvice.htm.

[11] N.Robbins. (2006) Creating More Effective Graphs. URL http://www.wiley.com.

[12] M.Schoeberl and B. Toon. (2011) Ten Secrets to Giving a Good Scientific Talk. URL http://www.cgd.ucar.edu/cms/agu/scientific_talk.html.

[13] E.Tufte. (1990) The Visual Display of QuantitativeInformation. Graphics Press. Cheshire, CT.

[14] A.J. van Marle. (2007) The Art of Scientific Presentations. URL https://www.cfa.harvard.edu/~scranmer/vanmarle\_talks.html#Technical\_preparation.

[15] H.Wickham. (2009) ggplot2: Elegant graphics for data analysis. useR. Springer.

[16] C.Wild. (2009) Early Statistical Inferences: The Eyes Have It.  URL http://www.stat.auckland.ac.nz/~wild/09.wild.USCOTS.html.

