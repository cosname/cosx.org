---
title: COS每周精选:让祸害人间的显著性星号消失吧！
date: '2013-02-11T00:47:55+00:00'
author: 潘岚锋
categories:
  - 网站导读
tags:
  - 每周精选
slug: remove-significance-stars
forum_id: 418905
---

本期材料由[谢益辉](http://yihui.name/)、[肖楠](http://www.road2stat.com/)整理提供。

统计之都将会定期为大家精选若干有猛料和干货的海外统计日志、文章、项目。如果大家读到好的统计博客，可以向我们推荐(editor@cos.name)。如果有人愿意把或已经把这些博客翻译成中文，请与我们联系(editor@cos.name)。我们将会收录在主站的博客翻译模块，供更多读者阅读。

  * [让祸害人间的显著性星号消失吧！](https://stat.ethz.ch/pipermail/r-devel/2013-February/subject.html#65770)！Vanderbilt大学生统系主任Frank Harrell如此请愿。楼下有重磅人物John Fox、Terry Therneau、Norm Matloff顶帖。丰富的统计分析中，为什么人们就只看重一个P值呢？软件的默认设置应该体现出一种态度，例如我们不应该用三个星号去“误导”大众。R不仅仅只有丰富的代码库和漂亮的作图系统，更要有最正确的统计！<!--more-->
  * [为啥样本方差的分母是n-1？](http://bulletin.imstat.org/2012/12/terences-stuff-n-vs-n-1/)这个看似简单的问题，你确定你能解释得清楚吗？伯克利大神Terry Speed说自己从来没有想到过一个能让所有学生都明白的答案。所以大神要有奖征集最早讨论这个问题的统计文献！
  * 著名的标题党Larry Wasserman（卡耐基梅隆统计学和机器学习教授）发表了一篇日志名为“[统计学向机器学习宣战](http://normaldeviate.wordpress.com/2013/02/09/statistics-declares-war-on-machine-learning/)”。其实也就是解释“为毛这些该死的统计学家总是用正态近似去求区间估计”。
  * 据ISI Web of Knowledge的最新报告，统计与概率学科下的刊物当前影响因子排名最高的是……是……竟然是[Journal of Statistical Software](http://www.jstatsoft.org/)！一份软件刊物、R语言的后花园竟然超越了英国皇家统计协会的招牌刊物JRSSB以及Annals of Statistics和JASA等大家心中的神话，苦逼推几十页公式还不如写个R包，这世道还有没有王法！
  
    ![](https://i.imgur.com/xC0MI6P.png)   
  * Huffington邮报发表了一篇关于可重复性研究的文章，它是去年年底在布朗大学召开的[可重复性研究研讨会](http://icerm.brown.edu/tw12-5-rcem)的一份总结（[这里](http://www.huffingtonpost.com/david-h-bailey/set-the-default-to-open-r_b_2635850.html)）。
  
    **谢益辉点评**：参加了这个研讨会，深感码农仍然是次等公民，码农光靠剑宗很难翻身，要有一定的气宗功夫，无论如何，借助一定的工具，可重复性研究其实可以比手工操作点鼠标更简单。另外我们需要从软件工程中借鉴一些研究方法，例如测试、版本控制等。可是，我给你提供所有的代码和数据，你能给我什么奖励呢？现在的答案是，没有任何奖励。因为科学研究的文化缺失了激励机制，作者何必浪费时间去整理代码和数据给别人用？
  * (Win|Open)BUGS用户们，[Stan来了](http://mc-stan.org/)！源代码库在[这里](https://github.com/stan-dev/stan)。Github粉丝们，快去说一句，Fork You！看到现在还没有走的人里如果还有knitr用户的话，[赶快考虑一下给knitr贡献一个Stan引擎吧](http://yihui.name/knitr/demo/engines/)！
  * 一别西风又一年。继机器学习和数据挖掘领域的盛会 KDD 去年在北京成功举办后，本周 KDD Cup 2013 也正式开始[征集竞赛提议](http://www.kaggle.com/KddCup2013CallForProposals)。据悉，本届 KDD 会议将于今年 8 月 在芝加哥举行。 同时，作为近两届 KDD Cup 的技术支持提供方，Kaggle 也在本周上线了新竞赛。[机器学习拯救鲸鱼](http://www.kaggle.com/c/whale-detection-challenge)，玩家需要通过航海记录的音频数据，探索海洋中鲸鱼的位置分布。这项竞赛由康奈尔大学生物声学研究组和海洋研究专业社区 Marinexplore 共同发起。另一项开放式竞赛的主题则是[利用智能手机传感器数据评估帕金森病症状](http://www.kaggle.com/c/predicting-parkinson-s-disease-progression-with-smartphone-data)，该项竞赛由迈克尔·J·福克斯基金会发起，旨在促进对帕金森综合症病理及治愈方法的研究。数据科学，是否会让世界更美好？
