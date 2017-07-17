---
title: R与SAS的集成
date: '2013-02-16T15:01:54+00:00'
author: 高燕
categories:
  - 统计软件
  - 软件应用
tags:
  - R语言
  - SAS
  - 集成
slug: integrating-sas-with-r
forum_id: 418906
---

# 一、为什么R与SAS要集成？

一位优秀的分析师不仅要有深厚的理论功底、丰富的实战经验，还要熟悉几款常用的分析软件，并有一款自己精通的软件。就像武林高手既有独门秘器，又要熟悉各门各派，这样才能博采众长，兼收并蓄，为己所用。

竞争促进创新，合作带来双赢。R与SAS各有优势，也各有问题，国内外网上骂战得多，思考如何将两者集成并能拿出可行方案的人则少之又少，即便有也基本都是老外或者外籍华人想出来的。这里不想贬低国人，只想建议大家多一些独创和研究精神。

有人会问，为何要集成？这里引用网上一位作者给出的观点，虽是一面之词，但不妨参考，有些观点还是比较中肯的。
 <!--more-->
> I work in an environment dominated by SAS, and I am looking to integrate R into our environment.
> 
> Why would I want to do such a thing? First, I do not want to get rid of SAS. That would not only take away most of our investment in SAS training and hiring good quality SAS programmers, but it would also remove the advantages of SAS from our environment. These advantages include the following:
> 
> •Many years of collective experience in pharmaceutical data management, analysis, and reporting
>   
> •Workflow that is second to none (with the exception of reproducible research, where R excels)
>  
> •Reporting tools based on ODS that are second to none
>   
> •SAS has much better validation tools than R, unless you get a commercial version of R (which makes IT folks happy)
>   
> •SAS automatically does parallel processing for several common functions
> 
> So, if SAS is so great, why do I want R?
> 
> •SAS’s pricing model makes it so that if I get a package that does everything I want, I pay thousands of dollars per year more than the basic package and end up with a system that does way more than I need. For example, if I want to do a CART analysis, I have to buy Enterprise Miner, which does way more than I would need.
>   
> •R is more agile and flexible than SAS
>   
> •R more easily integrates with Fortran and C++ than SAS (I’ve tried the SAS integration with DLLs, and it’s doable, but hard)
>   
> •R is better at custom algorithms than SAS, unless you delve into the world of IML (which is sometimes a good solution).

原文地址：<http://www.r-bloggers.com/integrating-r-into-a-sas-shop/>

# 二、集成的方式有哪些？

R与SAS的集成方式主要有以下几种：

1）SAS官方的支持：通过 SAS/IML 在SAS里面提交R代码

优点：

  * 因为R代码本质上是在R里运行，所以全面支持R的各种模型和函数。
  * 支持32位或64位的Windows、Linux操作系统
  * 数据交换、错误捕获等方面表现不错，支持SAS Format（关于Format是从资料上看到的，我没验证这个）。

缺点：

  * 需要购买 SAS/IML（9.22版本或更高版本），成本高

2）SAS官方的支持：通过 SAS Model Manager 将R模型导出生成的PMML文件翻译成SAS代码

优点：

  * 可以将生成的SAS代码快速集成到各种基于SAS开发的应用系统中
  * 可以将R模型和SAS模型进行预测性能方面的比较
  * 可以对R模型和SAS模型进行性能监测

缺点：

  * 需要购买 SAS Model Manager（12.1版本），成本高
  * 目前仅支持几种常用的PMML模型

3）民间研发：通过宏 Proc_R 实现在SAS里面提交R代码

PROC_R 于2012年发表在 Journal of Statistical Software 上，是一位华人 Wei Xin 在美国罗氏制药公司工作期间发表的。

优点：

  * 因为R代码本质上是在R里运行，所以全面支持R的各种模型和函数。
  * 不需要购买 SAS/IML，成本低。

缺点：

  * 只支持 Windows 系统，使用者如果有一定编程功底，可以将源代码改造成Linux可用的版本。
  * 数据交换通过 csv 文件实现，可能不支持 SAS FORMAT（有待验证）。
  * 错误捕获等方面略弱

4）民间研发：将R生成的神经网络和决策树模型翻译成SAS代码

优点：

  * 可以将生成的SAS代码快速集成到各种基于SAS开发的应用系统中
  * Windows、Linux都支持
  * 不需要购买SAS/IML或者SAS/EM，成本低。

缺点：

  * 目前只支持神经网络和决策树模型
  * 没有处理自变量取值缺失的情况

# 三、集成方式的详细介绍

以上四种方式我在下面的文章中有详细的介绍，有兴趣的同学可以阅读。

[R与SAS的集成（一）](http://blog.sina.com.cn/s/blog_8db50cf70101dmo4.html)

[R与SAS的集成（二）](http://blog.sina.com.cn/s/blog_8db50cf70101dmoa.html)

[R与SAS的集成（三）](http://blog.sina.com.cn/s/blog_8db50cf70101dn4z.html)

[R与SAS的集成（四）](http://blog.sina.com.cn/s/blog_8db50cf70101dlp6.html)
