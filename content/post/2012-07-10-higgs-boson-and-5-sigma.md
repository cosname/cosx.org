---
title: 希格斯玻色子与5σ
date: '2012-07-10T23:26:02+00:00'
author: 施涛
categories:
  - 经典理论
  - 统计之都
  - 统计推断
  - 高校课堂
tags:
  - 5sigma
  - Tukey
  - 假设检验
  - 希格斯玻色子
  - 数据分析
  - 物理
  - 置信区间
slug: higgs-boson-and-5-sigma
forum_id: 418876
---

> 本文转自施涛博客，原文链接请[点击此处](http://blog.cos.name/taoshi/2012/07/06/%E5%B8%8C%E6%A0%BC%E6%96%AF%E6%B3%A2%E8%89%B2%E5%AD%90/)。 

2012年7月4日，欧洲核子研究组织（CERN， [the European Organization for Nuclear Research](http://public.web.cern.ch/public/en/About/Name-en.html)）的物理学家们宣布发现在欧洲大型强子对撞机中一种疑似希格斯玻色子（[Higgs Boson](http://en.wikipedia.org/wiki/Higgs_boson)）。<!--more-->

> ［抄自wikipedia］：希格斯玻色子是粒子物理學的标准模型所预言的一种基本粒子。标准模型预言了62种基本粒子，希格斯玻色子是最后一种有待被实验证实的粒子。在希格斯玻色子是以物理学者彼得·希格斯命名。由于它对于基本粒子的基础性质扮演极为重要的角色，因此在大众传媒中又被称为「上帝粒子」


作为只有高中物理水平的民科，我也能从物理学家们在宣布这发现时的激动（看下面视频）中感到这发现的重大。


另外，推荐对数据分析有兴趣的听一下这神粒子的声音（[Listen to the decay of a god particle](http://lhcsound.hep.ucl.ac.uk/page_sounds_higgs/Higgs.html)）。一群粒子物理学家，编曲家，软件工程师，和艺术家用[粒子对撞机的数据编成的曲目](http://lhcsound.hep.ucl.ac.uk/page_about/About.html)。另类的数据展示，太强大了！

除了表达对科学家的敬仰外，我也对其中提到的 5`$\sigma$` 很感兴趣。既然祖师爷[John Tukey](http://en.wikipedia.org/wiki/John_Tukey)说过

> The best thing about being a statistician is that you get to play in everyone’s backyard，

我倍受鼓励的来看看这 5`$\sigma$` 到底是怎么回事。视频中的点睛之笔：

> We have observed a new boson with a mass of 125.3 +- 0.6 GeV at 4.9 σ significance.

念玩后大家鼓掌拥抱，热泪盈眶。一番周折后，我才终于找到了CERN的 [原版视频](https://cdsweb.cern.ch/record/1459565)（将近两小时，值得看看）。

开始时只是想搞清楚这 5`$\sigma $`怎么回事（35：10,第84页），没想到听到一堆统计词汇“multivariate analysis technique”，“p-value”,“sensitivity”, 等等劈头盖脸的飞来。最给力的是 Rolf Heuer 讲了一些用[Boosted decision tree](http://en.wikipedia.org/wiki/Boosting)来提高分类器准确性的过程（18：20,第33页）。不出所料，研究中用到了很前沿的数据分析方法。老祖师果然没错。看来欲知其中细节，得看数据分析啊！

比较遗憾的是我比较看不懂的是[环球科学（科学美国人中文版）的文章 “希格斯粒子现身LHC](http://www.huanqiukexue.com/html/newqqkj/newwl/2012/0704/22320.html)？”最后对 5`$\sigma$` 的解释：

> 估计总体参数落在某一区间内，可能犯错误的概率为显著性水平，用`$\alpha$`表示。1-`$\alpha$` 为置信度或置信水平，其表明了区间估计的可靠性。显著性水平不是一个固定不变的数字，其越大，则原假设被拒绝的可能性愈大，文章中置信度为5`$\sigma$`（5个标准误差），说明原假设的可信程度达到了99.99997%。

好像这是把假设检验和置信区间绞在一起解释了。本来看了视频还我还觉着我这物理外行也看懂了，现在又被解释糊涂了。谁能看懂给解释一下？

  <http://tourpartner.com.ua/ru/visy/visy-v-italy-IT.html>
