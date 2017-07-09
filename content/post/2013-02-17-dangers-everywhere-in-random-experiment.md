---
title: COS每周精选:随机试验处处坑
date: '2013-02-17T04:04:27+00:00'
author: 潘岚锋
categories:
  - 经典理论
  - 网站导读
  - 试验设计
tags:
  - 每周精选
slug: dangers-everywhere-in-random-experiment
forum_id: 418908
---

By [陈丽云](https://cos.name/author/liyun/)

自从Fisher大神种地种出心得来，搞出了随机对照试验，这样的简单有效方法就如春风一般席卷了五湖四海。很多时候，你不整出来个控制的分毫不差的随机试验，再好的契合直觉的结果也没人相信。人们对于因果关系的定义，好像一瞬间都集中在了统计分析的一致性上…显著吗？亲，几个星号？^[注：Fisher的炫目人生和随机试验的来龙去脉，请参见书籍《女士品茶》(《The Lady Tasting Tea——How Statistics Revolutionized Science in the Twentieth Century》)]。

然而孩子们，醒醒吧，以为你会个随机试验世界都完美了？果然是图样图森破，sometimes naïve。现实世界里面的随机试验可不简单是你在实验室里面那么舒舒服服的摆弄仪器就可以搞出来的。一旦试验的对象是人，一切都皆有可能。来来，先别急着算什么 p-value 这种东西，随机试验（业界俗称A/B Test）的坑那可是一个又一个，先跟着微软的专家们来玩玩踩雷，然后听听他们的血泪诉说吧！别以为他们西装革履或者拖鞋T恤的坐在看起来很气派很高端的办公室里面，一样是一个小坑陷一个，一个大坑坑一群。正所谓，随机试验处处坑，坑爹也坑娘，专家一样坑。

原文章：[Trustworthy Online Controlled Experiments: Five Puzzling Outcomes Explained](http://www.exp-platform.com/Pages/PuzzingOutcomesExplained.aspx), by Ronny Kohavi with Alex Deng, Brian Frasca, Roger Longbotham, Toby Walker, Ya Xu from Microsoft.

# 大坑1：Bug会提高收入？

曾经有一次，Bing的技术团队不小心搞出来一个bug，导致分在test组里面的用户查询到的结果都是非常差的，control组返回的是没有变化正常的结果。结果当他们去评估的时候，发现有两个指标格外的高：人均查询量（排除重复查询语句）和人均收入，前者上升了10%而后者上升了30%！

其实这样的结果也没有意外，因为返回的查询结果不是用户想要的，所以他们不得不反复尝试其他关键词，或者误点很多广告。短期来看，这样也不错嘛~可是长期呢？用户肯定转投其他谷哥或度娘的怀抱了。所以如果以这样的短期指标来衡量某项改变的效果，可能反而会带来长期的损失。微软的分析师建议，制定衡量指标的时候要多多考虑顾客的生命周期价值（Customer Lifetime Value），而不只是某些眼前顺手可取的指标。

# 大坑2：多加网页JavaScript脚本会带来更多点击量？

有一次微软的前端工程师在网页脚本里面加了一段JS代码，结果带来了点击量的很大上升。乍一看到这个结果，估计写JavaScript脚本的攻城师们真的是“今夜做梦也会笑”了，我们的春天就此到来！然而事实证明这只是一场短暂的春梦带来的幻觉，sorry sir。

事实上，当我们在跟踪用户的网页点击行为(click)的时候，会用一些特殊的“暗黑技巧”，比如[1*1像素的小图片](http://en.wikipedia.org/wiki/Web_bug)。用户点击了网页就会加载这个小图片，这样服务器就知道有人点击了该网页。这样多少会带来一些页面加载的延迟。很多分析表明，人们在上网时往往是非常没有耐心的，哪怕只有几百毫秒的也会带来用户体验的极大下降。Chrome、Firefox和Safari等浏览器对于页面跳转时刻的请求是非常没有耐心的，会直接中断那个1*1图片的请求然后跳到新的页面（IE此时则会继续耐心的等），这样就导致很多的点击无法跟踪。而这段JS代码增加了浏览器等待的时间，牺牲用户体验，使更多的点击行为被捕捉、数据更准确了。所以如果分析的时候看一下不同浏览器的用户行为差异，就很清晰明白点击量上升的原因是以前丢失太多数据了。

# 大坑3：一直向上走直线？

我们经常觉得，用户总是讨厌变化的——每次网页一改版，一定会有一群用户在那里各种埋怨。我们称之为Primacy and Novelty Effects。然而随着时间的消逝，人们适应了新的排版，就会越用越舒服了。

有一次，微软上线了一个新的产品功能，然后在开始的几天，用户的体验（累计值）有了显著的下降，如下图所示。

![Effect appears to trend over time](https://i.imgur.com/8AdCj0P.png)

Effect appears to trend over time

于是产品经理说，看这个线性预测，马上就会变正的了。用户都是这样的，你看随着时间的增长这种下降不是在缓和么？结果事实证明，随着时间的延长，最后只是收敛到0了而已。

![95% confidence interval over time](https://i.imgur.com/K9jVPtM.png)

95% confidence interval over time

其实道理很简单，用户的点击行为并不是一个独立的分布，而明明是时间上自相关的。随着时间的延长，95%的置信区间会逐渐的减小。

![Effect stabilizes over time](https://i.imgur.com/shESUUW.png)

Effect stabilizes over time

所以当我们只看人均值的时候，他的趋势会是逐渐的上升，最终收敛于实际效果0。实践的教训就是，由于Primacy and Novelty Effects导致序列自相关，早期的随机试验结果可能是不可信的，如果贸然的做线性拟合和预测往往会与真实情形大相径庭。随着时间的延长，结果才会累积到真实情况。

# 大坑4：时间长了一定可信？

上面刚说完早期的结果可能有问题，不能贸然下结论，那么时间长了、样本大了一切都平静了？统计检验的势就一定上升？果然还是too young too simple呀。

一般说来，线下的实验用户都是固定的；但是线上实验中，用户可能是不断的加入的，所以时间越长，样本量也就越大。那么置信区间随着时间的增长就应该逐渐变窄啊！一切仿佛那么美好！

但是世界美好的前提是分布函数随着时间不变啊。比如我们在关注session per user这个指标的时候，随着时间的变化虽然样本量增加，但均值、标准差也都在变化。

![Change in Mean, Standard Deviation and Sqrt(sample size) for Sessions/user over 31 day period](https://i.imgur.com/fCHsyEo.png)

Change in Mean, Standard Deviation and  
Sqrt(sample size) for Sessions/user over 31 day period

在这个问题里，置信区间并不会收敛，反而会扩张。对于类似的计数数据，比较合适的方式则是考虑引入负二项分布（见原文参考文献26）。

# 大坑5：别以为随机就没有干扰

有一次他们试验的时候发现，不仅仅是他们关注的指标很高，很多看起来并不相关的指标表现也格外的好。这到底是怎么回事呢？于是他们重新找了一个更大的样本做了一次实验以提高统计预测能力，结果这些显著的效果很多都消失不见了。

后来他们分析发现，因为很多实验都在同时进行（2009年Google大约实施了1.2万次实验，虽然只有不到10%真正的影响了商业运行），导致用户被不停的重用。在微软，他们倚仗一套bucket system进行用户的随机分组，即随机把用户分在几个“篮子”里。然而不幸的是，在他们进行实验以前，另外一项实验带来了指标很大程度的提升，并且有着强烈的滞后效应（carryover effect）。解决这一问题的途径只能是对每次实验都进行随机的分群，保证上一次试验的bucket没有被照样重用。
