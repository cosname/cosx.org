---
title: P-value：一个注脚
date: '2008-12-08T16:58:17+00:00'
author: 胡江堂
categories:
  - 经典理论
  - 统计推断
tags:
  - George H. Weinberg
  - John Abraham Schumaker
  - P-value
  - P值
  - SAS
  - 'Statistics: An Intuitive Approach'
  - 数理统计初级教程
  - 经典理论
slug: p-value-notes
forum_id: 418754
---

[郑冰刚提到P值](/2008/12/p-value/)，说P值的定义（着重号是笔者加的，英文是从WikiPedia摘来的）：

> P值就是当原假设为真时，**比**所得到的样本观察结果**更极端**的结果出现的概率。
>
> [The P-value is the probability of obtaining a result at least as extreme as the one that was actually observed, given that the null hypothesis is true.](http://en.wikipedia.org/wiki/P-value)

以下延续[白话系列](/2008/12/decision-and-risk/)，解释一下，“什么是P值，什么是极端”，算是郑文的一个长长的注脚。

回到[上次的硬币试验](/2008/12/decision-and-risk/)，那是一次二项试验，每次试验投100次，记下出现正面的次数,比如，如果

> 每次出现的正面数都是50，你就有把握认为这是一枚均匀的硬币；
>
> 正面数等于45或者等于55，你就有一点点的怀疑它是均匀的；
>
> 正面数等于30或者等于70，比较怀疑；
>
> 正面数等于10或者等于90，非常怀疑。

如上，正面数和反面数的差异越大，你就越有把握认为硬币不是均匀的（拒绝原假设）。重复一下P值的定义，“P值就是当原假设为真时，**比**所得到的样本观察结果**更极端**的结果出现的概率”，把这个定义套入上述硬币试验的场景中，比如你观察到“正面数是10或者90，正反面次数差异是80”：

> 如果原假设为真（硬币是均匀的），P值就是你投100次，所得的正反面数差异大于80的概率。
>
> 如果这个P值很大，表明，每次投100次均匀的硬币，经常有正反面差异大于80的情形出现。如果这个P值很小，表明，每次投100次均匀的硬币，你很难看到正反面的差异会超过80。

以前说过，10-90是A博士的接受区域。如果一枚硬币投出的正反面次数，差异大于80，——这真是一个“极端”的情形，连保守的A博士看了都摇摇头，不能接受原假设，只好认为原假设不对，硬币是有偏的。这里的逻辑是：

> 在假定原假设为真的情况下，出现所看到的偏差（正反面差异为80），是这么地不可能（P值很小），以至于我们不再继续相信原假设。

参考资料:

1. 维恩堡《数理统计初级教程》（常学将等译，太原：山西人民出版社，1986，Statistics: An Intuitive Approach By George H. Weinberg and John Abraham Schumaker）
1. Statistics I: Course Notes, 2008 SAS Institute Inc. Cary, NC, USA
