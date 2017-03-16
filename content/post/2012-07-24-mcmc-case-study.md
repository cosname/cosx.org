---
title: MCMC案例学习
date: '2012-07-24T14:49:32+00:00'
author: COS编辑部
categories:
  - 优化与模拟
  - 统计计算
  - 统计软件
  - 软件应用
tags:
  - MCMC
  - R语言
  - 参数估计
  - 广义线性模型
  - 模拟
  - 计算
  - 贝叶斯
slug: mcmc-case-study
---

> 本文是R中mcmc包的一篇<a href="http://www.stat.umn.edu/geyer/mcmc/library/mcmc/doc/demo.pdf" target="_blank">帮助文档</a>，作者为Charles J.Geyer。经过<a href="https://cos.name/2012/06/reproducible-research-with-knitr/" target="_blank">knitr</a>编译后的pdf文档<a href='http://cloud.github.com/downloads/cosname/editor/mcmc.pdf' target="_blank">可见此处</a>，提供中文译稿的作者：
  
> 闫超，天津财经大学统计系2011级研究生，方向：非寿险准备金评估。
  
> 高磊，天津财经大学统计系2011级研究生，方向：非寿险准备金评估。 

这个案例，我们不关心题目的具体意义，重点放在利用贝叶斯的观点来解决问题时，MCMC在后续的计算中所发挥的巨大作用。我们知道，贝叶斯的结果往往是一个后验分布。这个后验分布往往很复杂，我们难以用经典的方法求解其期望与方差等一系列的数据特征，这时MCMC来了，将这一系列问题通过模拟来解决。从这个意义上说，MCMC是一种计算手段。依频率学派看来，题目利用广义线性模型可以解决，在贝叶斯看来同样以解决，但是遇到了一个问题，就是我们得到的非标准后验分布很复杂。我们正是利用MCMC来解决了这个分布的处理问题。本文的重点也在于此。

在使用MCMC时作者遵循了这样的思路，首先依照贝叶斯解决问题的套路，构建了非标准后验分布函数。然后初步运行MCMC，确定合适的scale。继而，确定适当的模拟批次和每批长度(以克服模拟取样的相关性)。最后，估计参数并利用delta方法估计标准误。

## 1. 问题的提出

这是一个关于R软件中**mcmc**包的应用案例。问题出自明尼苏达大学统计系博士入学考试试题。这个问题所需要的数据存放在`logit`数据集中。在这个数据集中有五个变量，其中四个自变量`x1、x2、x3、x4`，一个响应变量`y`。

对于这个问题，频率学派的处理方法是利用广义线性模型进行参数估计，下面是相应的R代码以及结果：

<pre><code class="r">library(mcmc)
data(logit)
out &lt;- glm(y ~ x1 + x2 + x3 + x4, data = logit, family = binomial(), x = T)
summary(out)
</code></pre>

    
    Call:
    glm(formula = y ~ x1 + x2 + x3 + x4, family = binomial(), data = logit, 
        x = T)
    
    Deviance Residuals: 
       Min      1Q  Median      3Q     Max  
    -1.746  -0.691   0.154   0.704   2.194  
    
    Coefficients:
                Estimate Std. Error z value Pr(>|z|)   
    (Intercept)    0.633      0.301    2.10   0.0354 * 
    x1             0.739      0.362    2.04   0.0410 * 
    x2             1.114      0.363    3.07   0.0021 **
    x3             0.478      0.354    1.35   0.1766   
    x4             0.694      0.399    1.74   0.0817 . 
    ---
    Signif. codes:  0 &#39;***&#39; 0.001 &#39;**&#39; 0.01 &#39;*&#39; 0.05 &#39;.&#39; 0.1 &#39; &#39; 1 
    
    (Dispersion parameter for binomial family taken to be 1)
    
        Null deviance: 137.628  on 99  degrees of freedom
    Residual deviance:  87.668  on 95  degrees of freedom
    AIC: 97.67
    
    Number of Fisher Scoring iterations: 6
    
    

但是，使用频率学派的分析方法解决这个问题并不是我们想要的，我们希望使用Bayesian分析方法。对于Bayesian分析而言，我们假定数据模型(即广义线性模型)与频率学派一致。同时假定，五个参数(回归系数)相互独立，并服从均值为0、标准差为2的先验正态分布。

定义下面的R函数来计算非标准的对数后验分布概率密度(先验密度与似然函数相乘)。我们为什么要定义成密度函数的对数形式？因为虽然我们是从分布中采样，但是MCMC算法的执行函数`metrop()`需要的一个参数正是这个分布的密度函数的对数形式。

<pre><code class="r">x &lt;- out$x
y &lt;- out$y
lupost &lt;- function(beta, x, y) {
    eta &lt;- as.numeric(x %*% beta)
    logp &lt;- ifelse(eta &lt; 0, eta - log1p(exp(eta)), -log1p(exp(-eta)))
    logq &lt;- ifelse(eta &lt; 0, -log1p(exp(eta)), -eta - log1p(exp(-eta)))
    logl &lt;- sum(logp[y == 1]) + sum(logq[y == 0])
    return(logl - sum(beta^2)/8)
}
</code></pre>

<!--more-->

## 2. 开始MCMC处理

在完成上面数据以及函数的定义(它们都是mcmc算法的输入参数)之后，我们就可以利用**mcmc**包中的`metrop()`来产生随机数据，模拟模型的后验分布。也就是说，我们将要从后验分布中进行取样。

<pre><code class="r">set.seed(42)
beta.init &lt;- as.numeric(coefficients(out))
out &lt;- metrop(lupost, beta.init, 1000, x = x, y = y)
names(out)
</code></pre>

     [1] "accept"       "batch"        "initial"      "final"       
     [5] "initial.seed" "final.seed"   "time"         "lud"         
     [9] "nbatch"       "blen"         "nspac"        "scale"       
    [13] "debug"       
    

此处`metrop()`使用到了如下几种参数：

  * `lupost`一个函数对象，即后验分布概率密度函数的对数。
  * `beta.init`用来设定马氏链的初始状态。这里是上面广义线性模型的参数估计结果。
  * `nbatch = 1000`是采样的样本容量，也就是马氏链的转移次数。
  * `x、y`，是传入`lupost`函数中的一些参数。

`metrop()`函数的结果是一个list(列表)。模拟的数据存放在`out$batch`里。刚才的函数运行结果显示接受概率(accept)很低，所以我们调整一下proposal(建议分布)的重要参数`scale`(即随机游走MH算法的方差)来获得一个更合理的接受概率。什么是接受概率？我们用马氏链的方法对状态空间进行采样，那必然我们有一些值是访问不到的，接受概率就是对这种状况进行衡量的。接受概率大，说明访问越充分，接受概率小，访问就受到了一定的限制，访问不是很细致，但样本的自相关性会减弱。因此，接受概率不是越大越好，也不是越小越好。到底多大的接受概率我们认为才是合理的呢？理论显示，在五个需要估计参数的条件下，接受概率达到20%即可。我们开始尝试不同的`scale`值进行测试：

<pre><code class="r">out &lt;- metrop(out, scale = 0.1, x = x, y = y)
out$accept
</code></pre>

    [1] 0.739
    

<pre><code class="r">out &lt;- metrop(out, scale = 0.3, x = x, y = y)
out$accept
</code></pre>

    [1] 0.371
    

<pre><code class="r">out &lt;- metrop(out, scale = 0.5, x = x, y = y)
out$accept
</code></pre>

    [1] 0.148
    

<pre><code class="r">out &lt;- metrop(out, scale = 0.4, x = x, y = y)
out$accept
</code></pre>

    [1] 0.209
    

<pre><code class="r">out &lt;- metrop(out, nbatch = 10000, x = x, y = y)
out$accept
</code></pre>

    [1] 0.2345
    

可以看到，每个`metrop()`中第一个参数均为`out`,它的含义是`metrop()`的许多参数与生成`out`的那一次模拟的参数一致，除了这次又修改的部分外，比如`scale`。这里改变的是`scale`，这是`Metropolis`随机游走算法中的一个参数值越大，那么马尔可夫链状态转移就越明显(样本自相关性减弱)，但同时接受概率就越低，所以这是一个需要兼顾两者的选择。从运行结果可以看到`scale=0.4`时满足了我们的要求。

<!--more-->

## 3. 诊断，确定批次长度

我们找到了适合接受概率的`scale`值，下面我们按此参数增加模拟次数，然后观察结果。

<pre><code class="r">out &lt;- metrop(out, nbatch = 10000, x = x, y = y)
out$accept
</code></pre>

    [1] 0.2332
    

<pre><code class="r">out$time
</code></pre>

       user  system elapsed 
       2.40    0.00    2.41 
    

<pre><code class="r">plot(ts(out$batch))
</code></pre><p align = "center">

 ![plot of chunk tsplot](data:image/png;base64,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)</p> 

解释一下`metrop()`中的参数`nbatch`，其实与它对应的还有一个参数是`blen`；`nbatch`是要模拟的批数，`blen`是要模拟的每批的长度，`blen`默认为1。假如`nbatch=100`，`blen=100`，那么马氏链共转移100*100=10000次.

<pre><code class="r">acf(out$batch)
</code></pre><p align = "center">

 ![plot of chunk acfplot](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAYwAAAGMCAMAAAD+52V4AAAAk1BMVEX9/v0AAAAAADkAAGUAAP8AOTkAOY8AZo8AZrU5AAA5ADk5AGU5OTk5OY85ZmU5ZrU5j7U5j9plAABlADllAGVlOTllOY9lZgBlZjllZrVltbVltf2POQCPOWWPZgCPjzmP2/21ZgC1Zjm1ZmW1jzm124+1/v3ajznaj2Xa24/a29ra/v39tWX924/9/rX9/tr9/v27LQydAAAAMXRSTlP///////////////////////////////////////////////////////////////8AH5pOIQAAAAlwSFlzAAALEgAACxIB0t1+/AAAEGNJREFUeJztnY1228YRhQO7deT+pXb658hNzbgVnZiS+f5PVy5ASQtgdncGOwDviveenFAWiQ8DXgIgKYnfd0cGJt9degDmOSwDKCwDKCwDKCwDKCwDKCwDKCwDKCwDKCwDKCwDKCwDKCwDKPoy7t++vjt/uX8Xff/w9G0T47zcrhu+E11z/7a7dUO9+uSEOj786IU6beA7aWFDGft3u3dh4/bd6//0Xwx32uEvf9SXERin5f93WnJY7rSFu9vJNacvbtxQO3mz7ajjXtOrCnVIbZ6hjFOdu9v9zf7N1xM4fHHzW/j+vaWMEyMsH5Ycltt3N7Nrjqp7UIVKbrcZ9fD3P2jK0KD2XWLXN5wzDt33H7vuzX9vjvu/hi9+HfY2SxknxqnDYT/tlzu8+fnNz7eTa3QHPhXqqNnJVKj9T5rDVN1U+jLC0WPYIY7DnnE+nFjKCIucFuqX7Jc77QO74dD6fM295iGoQ+mOeBpU/zj8uvJU+jIOp50rnIX6MsIX5xOtpYzAGB4et8Nyp69e//NmfM2u6xT3oAqlO4GrULoTeN1UfGoLFJYBFJYBFJYBFJYBFJYBFJYBFJYBlEIZnTVEVaDmZey7n96H90/OC2TWLg2UQ9lyZaiQWRkPH46f78J/5wUqypiibLkuVB+5jG//disjQtlyXag+6cPUeQHb3ifvxYl1EzWJfAKP94yKMiYoW64QlX429XgCN7Uh39bp/PbiUXEZ+/4nUrvAvXlaoKaMCcqWK0OFzMp4+MfXyWHKchIfn98mqIpZXzyqT1zG6X5/fccyLoLqMz9nPO560TlDf6SS92KHQ+qLR4WU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)</p> 

在这个问题中，我们不研究收敛的问题。从自相关图可以看出，25阶以后的自相关系数可以忽略不计。所以每批次长度25就够了，为了更加保险，我们在下面的模拟中设置每批次长度为100。什么是批次？这是我们为了估计参数而对模拟的结果进行分组时的一个分组长度，之所以要分组，是因为这样才能克服相关性，使批次的均值之间近似独立。这样估计参数才更有效。

## 4. MCMC 的参数估计值与标准误

首先，运行以下程序：

<pre><code class="r">out &lt;- metrop(out, nbatch = 100, blen = 100, outfun = function(z, ...) c(z, 
    z^2), x = x, y = y)
out$accept
</code></pre>

    [1] 0.2345
    

<pre><code class="r">out$time
</code></pre>

       user  system elapsed 
       2.46    0.00    2.54 
    

`outfun`函数的作用是方便构建一些统计量。对于这个问题，我们关心的是后验均值和方差。均值的计算相对简单，只需要对涉及的变量进行平均。但是方差的计算有点棘手。我们需要利用等式
  
$$
  
var(X)=E(X^2)-E(X)^2
  
$$

将方差表示为可以通过简单的平均进行估计的两部分的方程。因此，我们只需要得到样本的一阶矩和二阶矩。此处，函数`outfun`可针对参数(状态向量)`z`返回`c(z, z`$^2$`)`。`function() c(z, z`$^2$`)`的含义是，每次马氏链转移取样时，得到的一个状态`x`,把这个状态带入函数中，得到状态本身值，以及它的平方值。这样我们可以求解样本一阶距及二阶矩。

<pre><code class="r">nrow(out$batch)
</code></pre>

    [1] 100
    

<pre><code class="r">out$batch[1, ]
</code></pre>

     [1] 0.6239 0.8217 1.1411 0.4686 0.7494 0.4520 0.7730 1.3696 0.3048 0.6358
    

`out$batch[1, 1]` = `0.6239`是第一批样本的一阶样本矩，`out$batch[1, 6]` = `0.452`是第一批样本的二阶样本矩，注意这里`out$ batch[1, 1]`$^2$与`out$batch[1, 6]`并不相等，因为这里的每批长度(`blen`)是100,只有当`blen=1`时，它们才相等。

`outfun()`函数中参数&hellip;是必要的，因为函数同样需要传递其他参数(如这里的`x`和`y`)到`metrop()`。

### 4.1 简单均值的计算

对每批次的均值再求均值

<pre><code class="r">apply(out$batch, 2, mean)
</code></pre>

     [1] 0.6712 0.7771 1.1814 0.5114 0.7729 0.5465 0.7336 1.5399 0.3878 0.7453
    

前五个数就是对后验参数均值的蒙特卡洛估计值，紧随其后的五个数是对后验参数二阶矩的估计值。通过下面的程序，得到参数的方差估计.

<pre><code class="r">foo &lt;- apply(out$batch, 2, mean)
mu &lt;- foo[1:5]
sigmasq &lt;- foo[6:10] - mu^2
mu
</code></pre>

    [1] 0.6712 0.7771 1.1814 0.5114 0.7729
    

蒙特卡洛标准误(MCSE)通过批次均值进行计算。这是求均值对简单的方法。
  
(注：方差和标准误是两个不同的概念。方差是一个参数估计，而标准误是对参数估计好坏评价的度量。)

<pre><code class="r">mu.muce &lt;- apply(out$batch[, 1:5], 2, sd)/sqrt(out$nbatch)
mu.muce
</code></pre>

    = NA [1] 0.01367 0.01518 0.01785 0.01585 0.01622
    

额外因素`sqrt(out$nbatch)`的出现是因为批次均值的方差为$\sigma^{2}/b $，其中b是批次长度，即`out$blen`；而整体均值的方差为$\sigma^{2}/n$，其中n是迭代总数,即`out$blen` * `out$nbatch`。

### 4.2 均值的函数

下面我们使用delta method 得到后验方差的MC标准误。$ u\_{i} $ 代表某个参数单批次的一阶矩的估计值,$\overline u $代表某个参数所有批次均值的均值，它们都是针对一阶矩而言。对于二阶矩而言样有$ v\_{i} $和$ \overline v $ 。令$ u=E(\overline u)$, $ v=E(\overline v) $ 。采用delta方法将非线性函数线性化：

$$g(u,v)=v-u^{2}$$
  
$$\Delta g(u,v)=\Delta v-2u\Delta u $$

也就是说，$ g(\overline u, \overline v)-g(u,v) $ 与 $ (\overline v &#8211; v)- 2u(\overline u &#8211; u) $具有相同的渐进正态分布。而 $ (\overline v &#8211; v)- 2u(\overline u &#8211; u) $的方差是$ (v\_{i} -v)-2u(u\_{i} -u) $方差的1/nbatch倍。这样MCSE可以这样计算：

$$\frac{1}{n\_{batch}} \displaystyle \sum\_{i=1}^{n\_{batch}}[(v\_{i} &#8211; \overline v)-2\overline u
   
(u_{i} &#8211; \overline u)]^2 $$

我们将以上的计算过程用程序实现:

<pre><code class="r">u &lt;- out$batch[, 1:5]
v &lt;- out$batch[, 6:10]
ubar &lt;- apply(u, 2, mean)
vbar &lt;- apply(v, 2, mean)
deltau &lt;- sweep(u, 2, ubar)
deltav &lt;- sweep(v, 2, vbar)
foo &lt;- sweep(deltau, 2, ubar, "*")
sigmasq.mcse &lt;- sqrt(apply((deltav - 2 * foo)^2, 2, mean)/out$nbatch)
sigmasq.mcse
</code></pre>

    [1] 0.004687 0.008586 0.007195 0.007666 0.007714
    

这五个值就是后验方差的蒙特卡洛标准误(MCSE)。

### 4.3 均值函数的函数

如果我们对后验标准差也感兴趣的话，也可以通过delta method计算它的标准误，程序如下

<pre><code class="r">sigma &lt;- sqrt(sigmasq)
sigma.mcse &lt;- sigmasq.mcse/(2 * sigma)
sigma.mcse
</code></pre>

    [1] 0.007565 0.011923 0.009470 0.010789 0.010029
    

## 5. 最后的运行

问题已经解决。现在唯一需要改进的就是提高结果的精确度。(试题要求“你的马尔科夫链采样器必须足够长以保证参数估计的标准误低于0.01”)。取模拟批次为500，每批长度为400，运行如下：

<pre><code class="r">out &lt;- metrop(out, nbatch = 500, blen = 400, x = x, y = y)
out$accept
</code></pre>

    [1] 0.2352
    

<pre><code class="r">out$time
</code></pre>

       user  system elapsed 
      50.40    0.01   51.01 
    

(显然，由于模拟的次数增大，程序运行时间变长，当然不同运算速度的计算机可能显示结果并不一样。下面进行均值和方差的估计。)

<pre><code class="r">foo &lt;- apply(out$batch, 2, mean)
mu &lt;- foo[1:5]
sigmasq &lt;- foo[6:10] - mu^2
mu
</code></pre>

    [1] 0.6636 0.7961 1.1712 0.5075 0.7241
    

然后计算均值估计的标准误

<pre><code class="r">mu.muce &lt;- apply(out$batch[, 1:5], 2, sd)/sqrt(out$nbatch)
mu.muce
</code></pre>

    [1] 0.002972 0.003611 0.003828 0.003604 0.004242
    

紧接着计算方差估计的标准误

<pre><code class="r">u &lt;- out$batch[, 1:5]
v &lt;- out$batch[, 6:10]
ubar &lt;- apply(u, 2, mean)
vbar &lt;- apply(v, 2, mean)
deltau &lt;- sweep(u, 2, ubar)
deltav &lt;- sweep(v, 2, vbar)
foo &lt;- sweep(deltau, 2, ubar, "*")
sigmasq.mcse &lt;- sqrt(apply((deltav - 2 * foo)^2, 2, mean)/out$nbatch)
sigmasq.mcse
</code></pre>

    [1] 0.001062 0.001718 0.001538 0.001574 0.002007
    

给出标准差的估计以及标准误

<pre><code class="r">sigma &lt;- sqrt(sigmasq)
sigma.mcse &lt;- sigmasq.mcse/(2 * sigma)
sigma.mcse
</code></pre>

    [1] 0.001752 0.002355 0.002116 0.002192 0.002509
    

以表格形式展示结果。

  * 后验均值估计：

<pre><code class="r">library(xtable)
data1 &lt;- rbind(mu, mu.muce)
colnames(data1) &lt;- c("constant", "x1", "x2", "x3", "x4")
rownames(data1) &lt;- c("estimate", "MCSE")
data1.table &lt;- xtable(data1, digits = 5)
print(data1.table, type = "html")
</code></pre><table border=1> 

</table> 

  * 后验方差估计

<pre><code class="r">data2 &lt;- rbind(sigmasq, sigmasq.mcse)
colnames(data2) &lt;- c("constant", "x1", "x2", "x3", "x4")
rownames(data2) &lt;- c("estimate", "MCSE")
data2.table &lt;- xtable(data2, digits = 5)
print(data2.table, type = "html")
</code></pre><table border=1> 

</table> 

  * 后验标准差估计

<pre><code class="r">data3 &lt;- rbind(sigma, sigma.mcse)
colnames(data3) &lt;- c("constant", "x1", "x2", "x3", "x4")
rownames(data3) &lt;- c("estimate", "MCSE")
data3.table &lt;- xtable(data3, digits = 5)
print(data3.table, type = "html")
</code></pre><table border=1> 

</table>
