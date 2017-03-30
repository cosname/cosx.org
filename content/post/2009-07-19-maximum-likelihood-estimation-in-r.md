---
title: R中的极大似然估计
date: '2009-07-19T08:36:31+00:00'
author: 胡荣兴
categories:
  - 优化与模拟
  - 统计推断
  - 统计软件
tags:
  - R语言
  - 似然函数
  - 数值优化
  - 极大似然估计
slug: maximum-likelihood-estimation-in-r
---

【注：本文的PDF格式版本可以从[这里](https://cos.name/wp-content/uploads/2009/07/ML.pdf "https://cos.name/wp-content/uploads/2009/07/ML.pdf")下载。】

什么？你问我什么是**极大似然估计**么？这个嘛，看看你手边的概率或统计教材吧。没有么？那就到[维基百科](http://zh.wikipedia.org/w/index.php?title=%E6%9C%80%E5%A4%A7%E4%BC%BC%E7%84%B6%E4%BC%B0%E8%AE%A1&variant=zh-cn)上去看看。

# 1. 数据与模型

我们要使用的数据来自于“MASS”包中的geyser数据。先把数据调出来，看看它长什么样子。

<pre class="brush: r">&gt; geyser
    waiting  duration
1        80 4.0166667
2        71 2.1500000
3        57 4.0000000
4        80 4.0000000
5        75 4.0000000
......</pre>

该数据采集自美国黄石公园内的一个名叫Old Faithful 的喷泉。“waiting”就是喷泉两次喷发的间隔时间，“duration”当然就是指每次喷发的持续时间。在这里，我们只用到“waiting”数据，为了简单一点，可以使用attach()函数。

<pre class="brush: r">&gt; attach(geyser)</pre>

<!--more-->

# 2. 模型

绘制出数据的频率分布直方图：

<pre class="brush: r">&gt; hist(waiting)</pre>

![ml_hist](https://cos.name/wp-content/uploads/2009/08/ml_hist.png "ml_hist")
  
从图中可以看出，其分布是两个正态分布的混合。可以用如下的分布函数来描述该数据

<div style="text-align: center;">
  $f(x)=pN(x_i;\mu_1,\sigma_1)+(1-p)N(x_i;\mu_2,\sigma_2)$
</div>

该函数中有5个参数[latex p$、$\mu\_1$、$\sigma\_1$、$\mu\_2$、$\sigma\_2$需要确定。上述分布函数的对数极大似然函数为：

<div style="text-align: center;">
  $l=\sum_{i=1}^n\log \{pN(x_i;\mu_1,\sigma_1)+(1-p)N(x_i;\mu_2,\sigma_2)\}$
</div>

# 3. 估计

## 3.1. 在R中定义对数似然函数：

<pre class="brush: r">&gt; #定义log-likelihood函数
&gt; LL&lt;-function(params,data)
+ {#参数"params"是一个向量，依次包含了五个参数：p,mu1,sigma1,
+ #mu2,sigma2.
+ #参数"data"，是观测数据。
+ t1&lt;-dnorm(data,params[2],params[3])
+ t2&lt;-dnorm(data,params[4],params[5])
+ #这里的dnorm()函数是用来生成正态密度函数的。
+ f&lt;-params[1]*t1+(1-params[1])*t2
+ #混合密度函数
+ ll&lt;-sum(log(f))
+ #log-likelihood函数
+ return(-ll)
+ #nlminb()函数是最小化一个函数的值，但我们是要最大化log-
+ #likeilhood函数，所以需要在“ll”前加个“-”号。
+ }</pre>

## 3.2. 参数估计

<pre class="brush: r">&gt; #用hist函数找出初始值
&gt; hist(waiting,freq=F)
&gt; lines(density(waiting))
&gt; #拟合函数####optim####
&gt; geyser.res&lt;-nlminb(c(0.5,50,10,80,10),LL,data=waiting,
+ lower=c(0.0001,-Inf,0.0001,-Inf,-Inf,0.0001),
+ upper=c(0.9999,Inf,Inf,Inf,Inf))
&gt; #初始值为p=0.5,mu1=50,sigma1=10,mu2=80,sigma2=10
&gt; #LL是被最小化的函数。
&gt; #data是拟合用的数据
&gt; #lower和upper分别指定参数的上界和下界。</pre>

## 3.3. 估计结果

<pre class="brush: r">&gt; #查看拟合的参数
&gt; geyser.res$par
[1] 0.3075937 54.2026518 4.9520026 80.3603085 7.5076330
&gt; #拟合的效果
&gt; X&lt;-seq(40,120,length=100)
&gt; #读出估计的参数
&gt; p&lt;-geyser.res$par[1]
&gt; mu1&lt;-geyser.res$par[2]
&gt; sig1&lt;-geyser.res$par[3]
&gt; mu2&lt;-geyser.res$par[4]
&gt; sig2&lt;-geyser.res$par[5]
&gt; #将估计的参数函数代入原密度函数。
&gt; f&lt;-p*dnorm(X,mu1,sig1)+(1-p)*dnorm(X,mu2,sig2)
&gt; #作出数据的直方图
&gt; hist(waiting,probability=T,col=0,ylab="Density",
+ ylim=c(0,0.04),xlab="Eruption waiting times")
&gt; #画出拟合的曲线
&gt; lines(X,f)</pre>

![clip_image004.jpg](https://cos.name/wp-content/uploads/2009/07/clip_image004.jpg "clip_image004.jpg")

<pre class="brush: r">&gt; detach()</pre>

# 小结

从上面的例子可以看出，在R中作极大似然估计，主要就是定义似然后函数，然后再用nlminb函数对参数进行估计。

## 参考文献：

l Brian S. Everitt(2002). _A Handbook of Statistical Analyses Using S-Plus_(Second Edition). CRC Press LLC
