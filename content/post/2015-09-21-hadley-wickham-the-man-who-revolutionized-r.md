---
title: Hadley Wickham：一个改变了R的人
date: '2015-09-21T10:16:43+00:00'
author: COS编辑部
categories:
  - 推荐文章
  - 统计图形
  - 统计软件
tags:
  - ggplot2
  - Hadley Wickham
  - R软件
  - 数据可视化
  - 统计图形
slug: hadley-wickham-the-man-who-revolutionized-r
---

【COS编辑部按】本译文得到了原英文作者的授权同意，翻译：[冯俊晨](http://www.fengjunchen.com)、王小宁， 审校：邱怡轩、朱雪宁、蔡寒蕴，编辑：王小宁。

[Hadley Wickham](http://had.co.nz/) 是 RStudio 的首席科学家以及 Rice University 统计系的助理教授。他是著名图形可视化软件包`ggplot2`的开发者，以及其他许多被广泛使用的软件包的作者，代表作品如`plyr`、`reshape2`等。本文取自[PRICEONOMICS](http://priceonomics.com/hadley-wickham-the-man-who-revolutionized-r/).<!--more-->

![HadleyObama](https://cos.name/wp-content/uploads/2015/09/HadleyObama.png)

**通过数据从根本上了解世界真的是一件非常，非常酷的事情。**

**多产的R开发者Hadley Wickham**

如果你不花很多时间在开源统计编程语言R中写代码的话，他的名字你可能并不熟悉——但统计学家Hadley Wickham用他自己的话说是那种“以书呆子出名”的人。他是那种在统计会议上人们排队要和他拍照，问他要签名的人，并且人们对他充满了尊敬。他也承认“这种现象实在太奇特了。因为写R程序而出名？这太疯狂了。”

R 是一种为数据分析而设计的编程语言，Wickham正是因为成为了卓越的R包开发者而赢得了他的名声。R包是用于简化诸如整合和绘制数据等常见任务代码的编程工具。Wickham已经帮助了数以万计的人，使他们的工作变得更有效率，这使得大家都[很感激他](http://blog.revolutionanalytics.com/2010/09/competition-data-visualization-with-ggplot2.html)，甚至为之而[欣喜若狂](http://rebeccmeister.livejournal.com/695823.html)。他开发的R包的用户包括众科技巨头，例如Google，Facebook和Twitter，新闻巨擘诸如[纽约时报](http://www.nytimes.com/interactive/sports/football/2013-fantasy-football-tier-charts-QB.html?ref=football&_r=1&)和 [FiveThirtyEight](http://fivethirtyeight.com/datalab/girls-are-rare-at-the-international-math-olympiad/)，政府机构诸如食品与药品管理局（FDA）以及美国禁毒署（DEA）等。

诚然，他是书呆子中的巨人。

Wickham出生在新西兰汉密尔顿的一个统计学世家。他父亲[Brian Wickham](https://www.linkedin.com/pub/brian-wickham/4/3b8/193)在康奈尔大学获得动物繁殖专业的博士，该学科大量使用统计学；而他[姐姐](http://cwick.co.nz/)则拥有加州大学伯克利分校的统计学博士学位。

如果这个世界上真有数据结构神童，那么Wickham可能就是其中之一。谈起他早年的经历，他颇为自豪：

“我的第一份工作，那时我才15岁，就是开发一个微软Access数据库。我觉得这事儿挺有意思的。我为数据库编写了文档，他们至今都在用这个数据库。”

从第一份工作开始，Wickham就开始反思存储和操纵数据是否存在一种更好的办法。“对于找到更好的解决之道，我一直颇为自信”，他解释说，“并且这个办法可以造福他人。”虽然彼时的他依然在懵懂中，但正在那时他“内化”了[第三范式](https://en.wikipedia.org/wiki/Third_normal_form)（Third Normal Form）的概念，这将在他未来的工作中扮演重要的角色。第三范式的本质是一种降低数据冗余且保证数据一致性的数据构架方法。Wickham把这种数据叫做“干净”（tidy）数据，而他的工具推广了并依赖于这种数据结构。

![RLogo](https://cos.name/wp-content/uploads/2015/09/RLogo.png)

R的标志，该语言的革命性演化部分归功于Hadley Wickham

Wickham第一次接触R语言是在新西兰奥克兰大学攻读统计学本科学位时。他将其描述为“一种理解数据的程序语言”。比肩SQL和Python，R是最受数据科学家欢迎的语言之一。

和Wickham一样，这个将被他革新的语言也来自新西兰。1993年，奥克兰大学的统计学家Ross Ihaka和Robert Gentleman创制了R。由于该语言是为数据分析量身定制，并且某些地方它与众不同（例如数据结构的索引方式以及数据强制存储于内存中），因此熟悉其他语言的程序员往往觉得R非常奇怪。在编写过Java，VBA和PHP后，Wickham发现R截然不同：“（许多程序员）接触R会后觉得它不伦不类，但我却不这么想，我觉得它可有意思了。”

从在爱荷华州立大学攻读博士学位起，Wickham就开始开发R工具包。用Wickham的话说，编写一个工具包是“编写一些帮助人们解决问题的代码，然后编写代码文档来帮助人们理解这玩意该怎么用”。作为课程项目的一部分，他编写的第一个工具包旨在实现生化信息的可视化。尽管这个包从未面世，他却坚定了分享个人工具的念头。

在2005年，Wickham发布了reshape工具包，这是他一连串“网红”工具包的开始。自发布以来，这个工具包已经被下载了几十万次。reshape希望让数据的聚合和操纵变得不那么“枯燥和烦人”。对于非程序员而言，简化数据变形过程可能不是什么事儿，但是对于数据科学家和统计学家而言，这往往是他们工作中最费时的事儿。

Wickham显然被reshape的成功所鼓舞。他开发这个工具包正是因为他认为他可以比前人做的更好。尽管不爱自夸，他却绝不缺乏自信。“我坚信我知道解决问题的正确方法”，他反复强调，“这种念头是好是坏就不知道了。”
