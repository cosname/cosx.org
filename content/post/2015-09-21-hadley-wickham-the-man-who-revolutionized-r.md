---
title: Hadley Wickham：一个改变了R的人
date: '2015-09-21T10:16:43+00:00'
author: Dan Kopf
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
forum_id: 419098
meta_extra: "译者：冯俊晨、王小宁；审校：邱怡轩、朱雪宁、蔡寒蕴；编辑：王小宁"
---

【COS编辑部按】本译文得到了原英文作者的授权同意，翻译：[冯俊晨](http://www.fengjunchen.com)、王小宁。

[Hadley Wickham](http://had.co.nz/) 是 RStudio 的首席科学家以及 Rice University 统计系的助理教授。他是著名图形可视化软件包`ggplot2`的开发者，以及其他许多被广泛使用的软件包的作者，代表作品如`plyr`、`reshape2`等。本文取自[PRICEONOMICS](http://priceonomics.com/hadley-wickham-the-man-who-revolutionized-r/).<!--more-->

![HadleyObama](https://uploads.cosx.org/2015/09/HadleyObama.png)

**通过数据从根本上了解世界真的是一件非常，非常酷的事情。**

**多产的R开发者Hadley Wickham**

如果你不花很多时间在开源统计编程语言R中写代码的话，他的名字你可能并不熟悉——但统计学家Hadley Wickham用他自己的话说是那种“以书呆子出名”的人。他是那种在统计会议上人们排队要和他拍照，问他要签名的人，并且人们对他充满了尊敬。他也承认“这种现象实在太奇特了。因为写R程序而出名？这太疯狂了。”

R 是一种为数据分析而设计的编程语言，Wickham正是因为成为了卓越的R包开发者而赢得了他的名声。R包是用于简化诸如整合和绘制数据等常见任务代码的编程工具。Wickham已经帮助了数以万计的人，使他们的工作变得更有效率，这使得大家都[很感激他](http://blog.revolutionanalytics.com/2010/09/competition-data-visualization-with-ggplot2.html)，甚至为之而[欣喜若狂](http://rebeccmeister.livejournal.com/695823.html)。他开发的R包的用户包括众科技巨头，例如Google，Facebook和Twitter，新闻巨擘诸如[纽约时报](http://www.nytimes.com/interactive/sports/football/2013-fantasy-football-tier-charts-QB.html?ref=football&_r=1&)和 [FiveThirtyEight](http://fivethirtyeight.com/datalab/girls-are-rare-at-the-international-math-olympiad/)，政府机构诸如食品与药品管理局（FDA）以及美国禁毒署（DEA）等。

诚然，他是书呆子中的巨人。

Wickham出生在新西兰汉密尔顿的一个统计学世家。他父亲[Brian Wickham](https://www.linkedin.com/pub/brian-wickham/4/3b8/193)在康奈尔大学获得动物繁殖专业的博士，该学科大量使用统计学；而他[姐姐](http://cwick.co.nz/)则拥有加州大学伯克利分校的统计学博士学位。

如果这个世界上真有数据结构神童，那么Wickham可能就是其中之一。谈起他早年的经历，他颇为自豪：

“我的第一份工作，那时我才15岁，就是开发一个微软Access数据库。我觉得这事儿挺有意思的。我为数据库编写了文档，他们至今都在用这个数据库。”

从第一份工作开始，Wickham就开始反思存储和操纵数据是否存在一种更好的办法。“对于找到更好的解决之道，我一直颇为自信”，他解释说，“并且这个办法可以造福他人。”虽然彼时的他依然在懵懂中，但正在那时他“内化”了[第三范式](https://en.wikipedia.org/wiki/Third_normal_form)（Third Normal Form）的概念，这将在他未来的工作中扮演重要的角色。第三范式的本质是一种降低数据冗余且保证数据一致性的数据构架方法。Wickham把这种数据叫做“干净”（tidy）数据，而他的工具推广了并依赖于这种数据结构。

![RLogo](https://uploads.cosx.org/2015/09/RLogo.png)

R的标志，该语言的革命性演化部分归功于Hadley Wickham

Wickham第一次接触R语言是在新西兰奥克兰大学攻读统计学本科学位时。他将其描述为“一种理解数据的程序语言”。比肩SQL和Python，R是最受数据科学家欢迎的语言之一。

和Wickham一样，这个将被他革新的语言也来自新西兰。1993年，奥克兰大学的统计学家Ross Ihaka和Robert Gentleman创制了R。由于该语言是为数据分析量身定制，并且某些地方它与众不同（例如数据结构的索引方式以及数据强制存储于内存中），因此熟悉其他语言的程序员往往觉得R非常奇怪。在编写过Java，VBA和PHP后，Wickham发现R截然不同：“（许多程序员）接触R会后觉得它不伦不类，但我却不这么想，我觉得它可有意思了。”

从在爱荷华州立大学攻读博士学位起，Wickham就开始开发R工具包。用Wickham的话说，编写一个工具包是“编写一些帮助人们解决问题的代码，然后编写代码文档来帮助人们理解这玩意该怎么用”。作为课程项目的一部分，他编写的第一个工具包旨在实现生化信息的可视化。尽管这个包从未面世，他却坚定了分享个人工具的念头。

在2005年，Wickham发布了reshape工具包，这是他一连串“网红”工具包的开始。自发布以来，这个工具包已经被下载了几十万次。reshape希望让数据的聚合和操纵变得不那么“枯燥和烦人”。对于非程序员而言，简化数据变形过程可能不是什么事儿，但是对于数据科学家和统计学家而言，这往往是他们工作中最费时的事儿。

Wickham显然被reshape的成功所鼓舞。他开发这个工具包正是因为他认为他可以比前人做的更好。尽管不爱自夸，他却绝不缺乏自信。“我坚信我知道解决问题的正确方法”，他反复强调，“这种念头是好是坏就不知道了。”

在reshape和其他几个工具包大受欢迎的同时，Wickham对于统计学的憧憬却逐渐幻灭。在攻读PhD的过程中，他注意到“学校里教的东西和人们理解数据真正需要的东西根本不沾边”。与那些专注于高深莫测的中心极限定理变体的统计学家不同，Wickham致力于让普罗大众能够更容易地上手数据分析。他阐述说：		

“肯定会有象牙塔的统计学家否认我所做的工作是统计学，但是我认为他们错了。我所做的工作正是回归到统计学的根源。存在数据科学这一学科这件事本身就说明正统统计学存在巨大缺陷。对我而言，这涉及到什么是统计：统计即是通过建模和可视化从数据中获得洞见。数据清洗和操纵是个脏活累活，而正统统计学拍拍屁股说这不归我们管。”

在幻灭之旅上，Wickham开发了ggplot2这个工具包。迄今为止，该工具包已经被下载了几百万次，它不仅是Wickham最成功的作品，也改变了许多人对于数据可视化的观念。ggplot2的巨大成功也促使他离开学术界去[Rstudio](https://www.rstudio.com/)担任首席科学家，从而专心致志地改进R。（Rstudio是R语言最受欢迎的集成开发环境的盈利开发机构。）		

![HadleyObama2](https://uploads.cosx.org/2015/09/HadleyObama2.png)		
	
Hadley Wickham放了一个用ggplot2画的图片。[图片](https://github.com/hadley/ggplot2/wiki/Crime-in-Downtown-Houston,-Texas-:-Combining-ggplot2-and-Google-Maps)由David Kahle和Garrett Grolemund提供

ggplot2 包是以统计学家Leland Wilkinson 的“图形语法”为基础，以一种数据可视化的形式开发的。Wickham把 ggplot2 和图形语法看成是“不作为一系列机械操作的可视化思维方式（如从这里到那里画一条线，在这里画一点，把长方形涂上颜色）而是以可视化的思维将数据映射到你能看到的事物上。”		
	
在图形语法背后的概念是相当抽象的。最大的想法是图是由“几何对象”（我们在图表上看到的一个点或柱子的图形元素）和“图形属性”（关于其中几何形状被放置的方向）组成的。这听起来可能不是革命性的，但由Wickham实现的这个概念使得成千上万的人可以更加容易地画图。问答网站[Stack Overflow](http://stackoverflow.com/tags/ggplot2/info)上已经有近9000个问题标记为ggplot2，甚至说 ggplot2 在R中让作图变得更“好玩”。用 ggplot2 画的图已经出现在了[Nature](http://www.nature.com/)，[FiveThirtyEight](http://fivethirtyeight.com/features/what-12-months-of-record-setting-temperatures-looks-like-across-the-u-s/)和[纽约时报](http://www.nytimes.com/interactive/sports/football/2013-fantasy-football-tier-charts-QB.html?ref=football&_r=1&)上。		

![China](https://uploads.cosx.org/2015/09/China.png)		
	
Hadley Wickham手里拿着一本关于他的可视化软件包ggplot2的中文译本。图片来源于[statr](http://statr.me/2013/09/a-conversation-with-hadley-wickham/)

除了开发ggplot2和reshape包外，Wickham也设计了一些其他广受欢迎的包来为数据科学家解决其他的重要问题。想用字（字符串）的形式很容易地操纵数据么？想从网上爬取数据么？需要轻松地编写自己的包么？Wickham已经帮你解决了。		

在[Quora](http://www.quora.com/How-is-Hadley-Wickham-able-to-contribute-so-much-to-R-particularly-in-the-form-of-packages)（一个问答SNS网站，译者注）上，一个R 用户问道：“Hadley Wickham为什么能对R做出这么大的贡献，尤其是在R包上？我依然不能详细地算出Hadley到底做出了多少。他做出这么多东西看起来是不可能的……”R 社区的活跃会员Eduardo Arino de la Rubia说所有成功的编程语言需要像Hadley这样的“[名人](http://www.r-bloggers.com/a-conversation-with-hadley-wickham-the-user-2014-interview/)”。他把Hadley与David Heinemeier Hansson（Web应用程序框架的Ruby on Rails的创建者）和Tatsuhiko Miyagawa（编程语言Perl 的重要开发者）进行了比较。		

下面的图标展示了Hadley的超过2000次下载的17个包（有时候它们被戏称为“[Hadley宇宙](http://barryrowlingson.github.io/hadleyverse/#1)”）的发布日期和下载的数量。这些下载数字少得可怜，因为它们只反映了从2012年年底其中一个流行的下载来源的数据。并且，是的，这个图是用Hadley的包（[ggvis](http://ggvis.rstudio.com/)）绘制的。

![Chart](https://uploads.cosx.org/2015/09/Chart.png)
	
Dan Kopf, Priceonomics；数据来源：[cranlogs](https://github.com/metacran/cranlogs)		

那么为什么Hadley创造了这一切？R是免费下载的，所有的包也是免费的，所以金钱的激励是次要的。简单地说，当一个问题比它应有的状态更难以解决时，Wickham就会耿耿于怀。虽然“其他大多数人都可以接受生活多艰这一事实”，但是Wickham却做不到。		

他说：“让我成功的原因之一是我对挫折是极其敏感的。”		

这种敏感性为他赢得了一个“奇特的恶名”。		

在大多数情况下，Wickham是不起眼的，但是当他在R聚会或是统计数据发布会上，他就会变成一个摇滚明星。他说：“我能看到我的名誉达到了一种令人不安的水平。”他希望有人会写一本关于“如何在一个非常特殊的领域做一个名人”的书，并且他担心当人们滔滔不绝地谈论他时不知道该如何正确行事。		

虽然现在习惯了“恶名”，但他仍然会因为人们使用他创造的工具而感到兴奋。他乐于在“Facebook，Google，Twitter，Tumblr……”中查看有多少人在使用他的工具。他说，只有在旧金山，人们在街上认出他的几率会更大一些。他还提到最近对新闻媒体FiveThirtyEight的访问让他很高兴，他觉得了解他人如何使用自己的工具是很酷的一件事（他们使用一个高度定制的ggplot2来绘制图形）。		

最重要的是，Wickham乐于给那些喜欢摆弄数据的人提供力量和支持。他解释说：“通过数据从根本上了解世界真的是一件非常，非常酷的事情。让我感到兴奋的分析不是谷歌爬取了1 TB的网络广告数据来优化收入，而是那些有着绝对热情的生物学家，现在他们可以使用，并理解R了。”
