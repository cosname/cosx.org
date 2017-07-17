---
title: R与SAS之争：一个导读
date: '2009-01-13T11:41:11+00:00'
author: 胡江堂
categories:
  - 推荐文章
  - 统计软件
tags:
  - Ashlee Vance
  - R语言
  - SAS
  - SAS-L
  - 纽约时报
slug: r-and-sas-new-york-times
forum_id: 418767
---

现在R与SAS社区里，最热闹的大概是源于《纽约时报》的一篇文章而引发的R与SAS之争。

2009年1月7号，《纽约时报》科技版登了一篇注定要引起四方瞩目的文章, [Data Analysts Captivated by R’s Power](http://www.nytimes.com/2009/01/07/technology/business-computing/07program.html)（1月6号就有网络版），作者是该报的记者[Ashlee Vance](http://topics.nytimes.com/top/reference/timestopics/people/v/ashlee_vance/index.html?inline=nyt-per)。这大概是开源统计软件包R，自1996年诞生以来，第一次出现在公众视野，而且是出现在《纽约时报》这样的主流媒体。这篇文章里有一句，让R社区和SAS社区都颇为兴奋，而且有很多私人博客也积极跟进：
<!--more-->

> The popularity of R at universities could threaten SAS Institute.
>
> R软件的兴起，可能会威胁到SAS公司在数据分析领域的地位。

报道中有对SAS公司一位市场总监Anee Milley的采访。Anee Milley的一句回应也注定要引来不少争议（甚至是公关危机）：

> We have customers who build engines for aircraft. I am happy they are not using freeware when I get on a jet.
>
> 我们有一些客户，为整机制造引擎。当我乘机时，很高兴他们没有使用免费软件（来设计引擎）。

1月7号中午，就有用户在全球最主要的SAS论坛[SAS-L](http://www.listserv.uga.edu/cgi-bin/wa?A1=ind0901b&L=sas-l#44)发贴，提醒大家注意这篇报道。目前，这个帖子的跟贴不断，是目前SAS-L中最火的帖子，其中有不少R软件的支持者发言。SAS-L的大多活跃用户都是一些SAS老手，用SAS几十年，在最近的工作中意识到R的好处，所以对SAS与R的融合比较感兴趣。



1月7号晚上，在活跃的邮件组[R-help](http://groups.google.com/group/r-help-archive/browse_thread/thread/5502fdc60d063833/352fc11a5b833f12)里，也在开始讨论这篇报道。同样，它也成了该邮件组最具人气的讨论，很多R支持者欢呼R的胜利。不过，其间似乎缺少SAS支持者的声音。

1月8号下午，Ashlee Vance在他的《纽约时报》博客里，对读者提出的一些问题作出了回应，[R You Ready for R](http://bits.blogs.nytimes.com/2009/01/08/r-you-ready-for-r/)。现在已经有近30条条读者评论，其中不凡长期活跃在统计社区里的知名专家的长篇评论，像SAS for Dummies的作者[Stephen McDaniel](http://stephenmcdaniel.us)。出现在这篇引人注目的报道的另一位主人公，SAS公司的Anee Milley，在上面也有发言。

1月9号下午，SAS社区的另一个活跃用户组[SAS Consulting](http://groups.google.com/group/sasconsulting/topics)，由Ashlee Vance的博文引起，也展开了一场关于R和SAS的大讨论。毫无悬念，它也成了近期最为显眼的帖子。我的感觉是，SAS用户很多也是R的关注者，但R用户，相对而言，对SAS的关注以及了解程度，稍显不如（这一条欢迎大伙指正），——不过，这条也很可能是R占优的一个证据：多数人是先学SAS，再学R，于是两者皆熟；而一开始就学R的，可能对SAS的兴趣不够足。还有一个原因，我想，跟用户的背景有关，SAS支持者多在工业界，而R的支持者似乎学术界多些，软件获得的便利程度也不一样。还有，R的支持者似乎有一种类似Apple迷的气质，扯远了。

还是9号，出现在这篇引人注目的报道的另一位主人公，SAS公司的Anee Milley，在SAS的官方博客作出声明，[This Post Is Rated R](http://blogs.sas.com/sascom/index.php?/archives/434-This-post-is-rated-R.html)，认为她跟《纽约时报》半个小时的访谈，只有一两句断章取义的话语见诸报端，并重申了她与SAS公司对开源软件的看法（支持、参与）。

与此同时，很多个人博客就这个话题持续跟进。你可以在[Google Blog Search](http://blogsearch.google.com/blogsearch?hl=en&ie=UTF-8&q=R+SAS&btnG=Search+Blogs)找到更多的文章，比如：

一篇有趣的博文来自[Ajay Ohri](http://www.decisionstats.com/)，[Top ten RRReason R is bad for you?](http://smartdatacollective.com/Home/15756)，开玩笑提到：

> R programmers are lesser paid than SAS programmers.
>
> It is free. Your organization will not commend you for saving them money- they will question why you did not recommend this before. And why did you approve all those packages that expire in 2011.R is fReeeeee. Customers feel good while spending money.The more software budgets you approve the more your salary is. R thReatens all that.

Andrew Gelman认为，这是SAS公司面对一次健康的竞争的好机会，[Equal time for SAS](http://www.stat.columbia.edu/~cook/movabletype/archives/2009/01/equal-time-for.html)。

讨论正在持续中，我们不妨继续跟进。目前，各方的言论可以分为四类：

> -SAS优势说：处理海量数据，数据管理，并行计算，广泛的工业界认可，客服，文档

> -R优势说：免费，新算法，矩阵语言，作图，最近的广泛流行

> -SAS和R融合说：R的兴起，使数据分析的意识更为深入人心；在SAS里运行R；同时使用R和SAS；

> -我是出来打酱油说：Ooops

粗略看去，R的不足刚好是SAS所长，反之亦然。我个人期待它们有更多的融合。与SAS Proc SQL、Proc IML类似，一个Proc R将会非常有趣。这场争论，在网络上公开的，只是冰山一角，它的意义可能过几年才能显现出来。其他厂商，如IBM、SPSS、WPS、S-Plus等，一定也在密切观察此事。开源软件有个特点，到了某个临界点，其爆发速度就会超乎人们的想象。
