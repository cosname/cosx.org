---
title: COS每周精选:Simply Statistics为你解释GMM
date: '2013-10-29T00:40:36+00:00'
author: 霍志骥
categories:
  - 推荐文章
  - 网站导读
tags:
  - 数据挖掘
  - 文本挖掘
  - 机器学习
  - 每周精选
slug: simply-statistics-of-gmm
forum_id: 418978
---


  本期投稿  [冷静](http://www.weibo.com/p/1005051756465937/home?from=page_100505&mod=TAB#place) [肖楠](http://www.road2stat.com) [魏太云](http://www.weibo.com/taiyun?topnav=1&wvr=5&topsug=1) [谢益辉](http://yihui.name)


  * 统计学家在其他领域大放异彩已经不是什么新鲜事，最近公布的三位诺贝尔经济学奖获得者之一，Lars Hansen，就是其中一员。有趣的是，因为Hansen 的理论过于复杂以致于众多新闻报道乃至经济学评论都对他的成果支支吾吾，一带而过。以至于Chicago Magazine 称之为[the forgotten Nobel Prize winner](http://www.chicagomag.com/city-life/October-2013/Lars-Peter-Hansen-The-Forgotten-Nobel-Prize-Winner/)。甚至在是诺贝尔奖委员会（Nobel Prize Committee）对三人研究的[介绍](http://www.nobelprize.org/nobel_prizes/economic-sciences/laureates/2013/popular-economicsciences2013.pdf)中，对GMM究竟是什么也是暧昧不清。其实这一点早就有人担忧过了，[Tyler Cowen](http://marginalrevolution.com/marginalrevolution/2013/10/lars-peter-hansen-nobel-laureate.html)就说了：“For years now journalists have asked me if Hansen might win, and if so, how they might explain his work to the general reading public.  Good luck with that one.”读到这里，学统计的优越感出来了有没有！要解释统计学家的研究还是得由统计学家来。Wikipedia上的GMM词条被认为太过难懂，正在召唤有志之士把它解释得简单点。Alex Peter 尝试着用基本的统计符号解释[GMM](http://marginalrevolution.com/marginalrevolution/2013/10/lars-peter-hansen-nobelist.html) ，不过门槛还是有点高。Simply Statistics 决心为普罗大众（general audience）写一篇[科普文](http://simplystatistics.org/2013/10/14/why-did-lars-peter-hansen-win-the-nobel-prize-generalized-method-of-moments-explained/)，如果你看懂了，恭喜你，你已经超越了一般的普罗大众，而成为一个统计学家眼中的普罗大众了。
  
    当然这一切高深晦涩都不影响Hansen 的GMM模型在资产定价、行为经济学中的广泛应用，因为它的普适性，以后还会应用得更广。这或许就是统计学朴实而深刻的终极目标——有用。与众位共勉。
  * [R 的生物信息学小书](http://a-little-book-of-r-for-bioinformatics.readthedocs.org/en/latest/): 之所以说是小书源于作者将其称为 a simple introduction to bioinformatics，但麻雀虽小，五脏俱全，该有的从头到尾一点不少。本书专注于与热带疾病有关的基因组分析，当然，也少不了我们的主人公R~
  * [Julia的福利](http://strata.oreilly.com/2013/10/julias-role-in-data-science.html)：Julia 的主要开发者之一在 Strata 站点上撰文阐释了 Julia 在数据科学中的定位： 文章娓娓道来，解释了 Julia 语言的设计、与 R 和  Python 的关系，综述了生态系统的现状，以及对未来的展望~
  * Python: [Troll Detection with Scikit-Learn](http://blog.kaggle.com/2012/09/26/impermium-andreas-blog/) 漂亮的简单模型 + 模型集成。话不多说，同道中人请点赞~这里附上[scikit-learn](http://scikit-learn.org/stable/)的网站。
  * 微博速递：刚刚过去的kdd2013上有大牛wright做了一个“Optimization in Learning and Data Analysis“的keynote , [slides](http://t.cn/zRxRuM2)里面对这方面的新旧内容做了一个很好的review, 实在是一份极好的导引。@[晓风_机器学习](http://weibo.com/1780877950/AfiWyjfTh)
  * [Xi’an给Beta分布手写了](http://xianblog.wordpress.com/2013/10/17/beta-hpd/)一个计算最高概率密度区间的函数（看看人家教授整天还在捣鼓R代码），下面有读者回复了一个更通用的函数，可是都是假设概率密度函数是单峰的，小编几年前对这个问题也[有些兴趣](https://cos.name/cn/topic/18001)，不过这次小编放狗搜了一下，发现Rob Hyndman十几年前（R诞生的前一年）就有一篇小文章来解决这个问题了：Computing and Graphing Highest Density Regions
