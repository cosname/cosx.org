---
title: 大话统计：Frequentist or Bayesian
date: '2012-12-11T12:44:25+00:00'
author: 施涛
categories:
  - 经典理论
  - 统计推断
  - 职业事业
tags:
  - frequentist
  - Nate Silver
  - 论战
  - 贝叶斯
  - 贝叶斯派
  - 频率
  - 频率派
slug: the-odyssey-of-stat-frequentist-or-bayesian
forum_id: 418890
---

本文引自施涛的博客，其中重要的英文都进行了翻译，原文请[点击此处](http://blog.cos.name/taoshi/2012/12/07/frequentist-or-bayesian/)

前言：先向无法科学上网的客官作揖抱歉了，有些江湖野史可能被墙

![Nate_Silver](https://uploads.cosx.org/2012/12/Nate_Silver.png) 话说江湖风云人物，神算子 [Nate Silver](http://en.wikipedia.org/wiki/Nate_Silver)， 在纽约时报[开博占卜](http://fivethirtyeight.blogs.nytimes.com/)各项江湖话题，每每言中。并著书立传， [The Signal and the Noise](http://www.us.penguingroup.com/static/pages/features/the_signal_and_the_noise.html)，一时引来[各相追捧](/2012/11/the-rise-of-data-scientists/)。

这日，曾留下武林秘籍 [All of Statistics: A Concise Course in Statistical Inference](http://www.amazon.com/All-Statistics-Statistical-Inference-Springer/dp/0387402721/) 的大侠 [Larry Wasserman](http://www.stat.cmu.edu/~larry/) (Department of Statistics, Department of Machine Learning, Carnegie Mellon University) 突发感想，在自己博客 [Normal Deviate ](http://normaldeviate.wordpress.com/)中写下大号书评：
  
Nate Silver is a Frequentist: Review of “the signal and the noise”

[……]就如你可以看到的，我非常喜欢这本书，并强烈推荐它。
  
但是……
  
我有一点要倾诉。Silver非常热衷于贝叶斯推断，这是很好的。不幸的是，他属于我[前几篇文章](http://normaldeviate.wordpress.com/2012/11/17/what-is-bayesianfrequentist-inference/)所写的这一类人—— 混淆了“贝叶斯推理”与“使用贝叶斯定理”两个概念。他对于频率派统计推断的描述是比较糟的。他似乎把频率推断等同于了常用于正态分布的费歇尔显著性检验。也许他是从一本劣质的书中学习的统计学，抑或他天天跟一群激进的反频率学派的统计学家厮混，以至于持这样的观点。<!--more-->

但毫无疑问的是：Nate Silver是属于频率派的。比如，他说过：

**“预测中最重要的检验之一，而我认为又是重中之重的，便是校准(calibration)。虽然每次你说有40%的概率会下雨，而实际上雨会多久下一次呢？如果在整个预测时程中（从长远来看），真的大约有40%的时间在下雨，那么这意味着你的预测充分校准（误差很小）。”**

这绝对是一种频率派的观点。如果使用贝叶斯定理可以有助于实现长程频率校准，那没问题，也挺好。如果没有，我便毫不怀疑他用了别的东西。总之他的目标很明确，就是得到优良的**长期频率行为**。[……]

一时间风雨突起，这个关于 Frequentist or Bayesian 的争议话题又现江湖。第一个杀出来的是？没错！正是大侠 [Andrew Gelman](http://andrewgelman.com/) (Department of Statistics, Columbia University)，著名的 [Statistical Modeling, Causal Inference, and Social Science](http://andrewgelman.com/) 的博主。

Larry：
  
下面是一个预测概率的贝叶斯校准的例子。如果你用贝叶斯预测值p.hat（p.hat是后验期望E (y.new|y)）来预测一个二元结果y.new，贝叶斯校准需要的条件是对于任何的 y.hat值都必须满足E (y.new|y.hat) = y.hat。但这并不是全部需要满足的条件（比如，校准很重要，精度也很重要），它与频率派校准以及无偏性都不同。在频率派校准中，期望值依赖模型中未知参数`$\theta$`的取值。而你上述所言的校准（可以往下滚动看看另外[一个例子](http://andrewgelman.com/2010/11/some_thoughts_o_8/)）并不依赖参数`$\theta$`，所以我并不同意这些校准是频率派而不是贝叶斯派的说法。当然，我完全同意评价频率表现的概念是非常重要的，不过它只是贝叶斯校准没有依赖于参数`$\theta$`取值的情况而已。

江湖不宁，争论又起，各路人马[加入论战](http://normaldeviate.wordpress.com/2012/12/04/nate-silver-is-a-frequentist-review-of-the-signal-and-the-noise/#comments)。大侠 [XI’AN’ OG](http://xianblog.wordpress.com/) 也出面提出把这场论战记入江湖册：

如果有可能的话，你们介意把这些评述发表在[CHANCE](http://chance.amstat.org/)上么？

看大侠们挥舞这各项理论和哲学思想，小的不尽倒吸一口凉气。问题原来是神算子是否属于少林派，还是武当派。怎么忽然就变成各派根据其所著之书，来统计推断其个人取向了呢？然后有演变为了两派镇派宝典根基的争论了。要是实在关心神算子心仪那派的问题，不如找来神算子本人问一下，到底人家对哪里更有归属感，不就行了。实在找不到本人，就@他，tweet 一下好了。

笔者觉得频率派像少林派，拳谱放哪里，你有足够数据就打，不够就回去收集更多的或回家洗洗睡。贝叶斯派则像太极拳，讲究以柔克刚。不管什么问题，有无数据都能对付。频率派与贝叶斯派间的硝烟仍在继续，不过何时使用频率派方法，何时使用贝叶斯派方法，还真是一个艺术问题。你就觉得呢？
