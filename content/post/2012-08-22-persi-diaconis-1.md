---
title: Persi Diaconis (1)
date: '2012-08-22T07:26:18+00:00'
author: 韩钧
categories:
  - 优化与模拟
  - 统计之都
  - 统计计算
  - 贝叶斯方法
slug: persi-diaconis-1
forum_id: 418881
---

作为统计之美的开篇，我一直想找一篇我非常愿意写的统计故事，尽管有很多，但都不能让我觉得可以发泄笔头之愤。最近在听贝叶斯统计课，刘军老师（哈佛大学统计系教授）提起了叫Persi Diaconis的人，他的故事和他的工作，这让我找到了写这篇文章的灵感。
<!--more-->

你能想象，一个人在14岁离家出走，学习魔术，浪迹江湖，24岁后潜心学术，之后成为斯坦福大学的教授？

Persi Diaconis（[维基](http://en.wikipedia.org/wiki/Persi_Diaconis)）确实如此，他在搞魔术的时候，为了想研究如何防止被其他魔术师骗，买了本 William Feller 的 **An Introduction to Probability Theory and Its Applications**，但是里面涉及到了微积分等知识，看不懂，那年他18岁。他发誓要回学校学习，以此能够看得懂这本书。24岁重返校园（[City College of New York](http://en.wikipedia.org/wiki/City_College_of_New_York "City College of New York")）。他向《科学美国人》投稿介绍他两个有意思的洗牌方法。这样被一个马丁·葛登能的人看重，给他写了推荐信去哈佛大学，当时哈佛的统计学家 Fred Mosteller 正在研究魔术，于是就要了他（<http://blog.sciencenet.cn/home.php?mod=space&uid=1557&do=blog&id=418859>）。

Persi Diaconis 做了几个很有意思的工作，如洗牌多少次能够洗得比较彻底（我希望在统计之美里面，能够有一篇来单独介绍洗牌问题）等。他还有个绝活，据刘军老师说，他总可以抛硬币时，抛出他想要的那一面。而他每次的学术报告之前，都会表演一番，很多人实际上不是去听他的报告的，而是看看他的绝活。

这次就要介绍的，是他在一篇 MCMC 算法（Markov Chain Monte Carlo，马氏链蒙特卡洛方法，有文章将其评为20世纪最有名的10个算法之一）综述的文章（The Markov Chain Monte Carlo Revolution）中，给出的破译犯人密码的例子。

有一天，一个来自了解关押囚犯心理的心理医生，来到斯坦福统计系，给出了如下一个囚犯写的密码信息：

![MCMC_code](https://uploads.cosx.org/2012/08/MCMC_code.jpg)

上图是囚犯写的密码信息的一部分，你可以看到很多出现频繁的字符。

问题来了，该心理医生想知道，这个密码信息的内容是什么？

我们可以想到，上图看起来怪怪的字符，每个都应该对应一个字母，只要我们找到字符和字母的对应关系，我们就可以解码了。但是怎么找到这个对应关系呢？（我想到了福尔摩斯探案集里面有这样一个例子，不过那个例子中的字符代表体系和这个不同，但是福尔摩斯的推断相当惊人！）

在下一篇我给出他的想法，从而写完MCMC算法的引子。
