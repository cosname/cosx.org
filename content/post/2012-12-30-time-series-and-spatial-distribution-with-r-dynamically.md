---
title: 用R动态的显示开店序列和空间分布
date: '2012-12-30T10:38:06+00:00'
author: COS编辑部
categories:
  - 统计图形
  - 统计软件
  - 软件应用
tags:
  - 7-Eleven
  - animation
  - 动画
  - 时间序列
  - 空间统计
slug: time-series-and-spatial-distribution-with-r-dynamically
---

> 作者简介：陈少飞，美国Tango Management Consulting公司高级地理研究分析员，主要工作为在连锁零售/餐饮的商业地产咨询中，从空间优化的角度给客户制订选址方案，并预测店面销售额。05年开始接触R，主要研究R在地理信息科学方面的应用，包括可视化，空间回归，地统计和空间最优化等。

一张图可以解说一个场景，而很多张图连续起来形成的动画就可以讲一个故事。

<p style="text-align: center;">
  <embed src="http://www.tudou.com/v/EvWrnasuQdc/&#038;resourceId=0_05_05_99&#038;bid=05/v.swf" type="application/x-shockwave-flash" allowfullscreen="true" width="480" height="400" />
</p>

7-Eleven 便利店是源于美国的全球最大的便利连锁店，后来被日本伊藤洋华堂公司收购，在全球拥有42000家持有或连锁的店面，在美国本土也有超过8000家店。动态的显示美国8000家店的开店序列和空间分布，可以揭示这家连锁企业的发展规律，也对其他零售连锁企业的发展有着借鉴作用。

从这个动画中，我们可以看到7-Eleven起源于达拉斯，但是很快就把店面开到东西海岸。在发展早期迅速走出本地市场的举动，让其很快占领了美国的主要市场，赢得了口碑，接下来不断的在这些已有市场增加店的密度。80年代后期，前阶段的扩张导致7-Eleven遭遇财政危机，频临破产，开店速度明显降低。进入到2000年后，随着日资的收购，资金获得保障，开店速度重新加快。2010年后，不受金融危机的影响，开始跳出现有市场，在新的市场迅速拓展，这一阶段又稍显盲目。

结合开店数目的静态时序图，我们可以更直观的了解7-Eleven的扩张速度。

[<img src="http://cos.name/wp-content/uploads/2012/12/7-11-500x404.png" alt="7-11" width="500" height="404" class="aligncenter size-large wp-image-6752" srcset="http://cos.name/wp-content/uploads/2012/12/7-11-500x404.png 500w, http://cos.name/wp-content/uploads/2012/12/7-11-300x242.png 300w, http://cos.name/wp-content/uploads/2012/12/7-11-370x300.png 370w, http://cos.name/wp-content/uploads/2012/12/7-11.png 777w" sizes="(max-width: 500px) 100vw, 500px" />](http://cos.name/wp-content/uploads/2012/12/7-11.png)

该动画采用了R里的animation 包，并得到了该包的作者谢益辉的指点。数据来自于现任美国7-Eleven市场规划部的总监，分析解读来自前任美国7-Eleven地产部副总裁。
