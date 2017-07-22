---
title: MCMC案例学习
date: '2012-07-24T14:49:32+00:00'
author: Charles J. Geyer
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
forum_id: 418878
meta_extra: "译者：闫超、高磊"
---

> 本文是R中mcmc包的一篇[帮助文档](http://www.stat.umn.edu/geyer/mcmc/library/mcmc/doc/demo.pdf)，作者为Charles J.Geyer。经过[knitr](/2012/06/reproducible-research-with-knitr/)编译后的pdf文档[可见此处](http://cloud.github.com/downloads/cosname/editor/mcmc.pdf)，提供中文译稿的作者：
  
> 闫超，天津财经大学统计系2011级研究生，方向：非寿险准备金评估。
  
> 高磊，天津财经大学统计系2011级研究生，方向：非寿险准备金评估。 

这个案例，我们不关心题目的具体意义，重点放在利用贝叶斯的观点来解决问题时，MCMC在后续的计算中所发挥的巨大作用。我们知道，贝叶斯的结果往往是一个后验分布。这个后验分布往往很复杂，我们难以用经典的方法求解其期望与方差等一系列的数据特征，这时MCMC来了，将这一系列问题通过模拟来解决。从这个意义上说，MCMC是一种计算手段。依频率学派看来，题目利用广义线性模型可以解决，在贝叶斯看来同样以解决，但是遇到了一个问题，就是我们得到的非标准后验分布很复杂。我们正是利用MCMC来解决了这个分布的处理问题。本文的重点也在于此。

在使用MCMC时作者遵循了这样的思路，首先依照贝叶斯解决问题的套路，构建了非标准后验分布函数。然后初步运行MCMC，确定合适的scale。继而，确定适当的模拟批次和每批长度(以克服模拟取样的相关性)。最后，估计参数并利用delta方法估计标准误。
<!--more-->

# 1. 问题的提出

这是一个关于R软件中**mcmc**包的应用案例。问题出自明尼苏达大学统计系博士入学考试试题。这个问题所需要的数据存放在`logit`数据集中。在这个数据集中有五个变量，其中四个自变量`x1、x2、x3、x4`，一个响应变量`y`。

对于这个问题，频率学派的处理方法是利用广义线性模型进行参数估计，下面是相应的R代码以及结果：

```r
library(mcmc)
data(logit)
out <- glm(y ~ x1 + x2 + x3 + x4, data = logit, family = binomial(), x = T)
summary(out)
```

```r   
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
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 137.628  on 99  degrees of freedom
Residual deviance:  87.668  on 95  degrees of freedom
AIC: 97.67

Number of Fisher Scoring iterations: 6
```
    

但是，使用频率学派的分析方法解决这个问题并不是我们想要的，我们希望使用Bayesian分析方法。对于Bayesian分析而言，我们假定数据模型(即广义线性模型)与频率学派一致。同时假定，五个参数(回归系数)相互独立，并服从均值为0、标准差为2的先验正态分布。

定义下面的R函数来计算非标准的对数后验分布概率密度(先验密度与似然函数相乘)。我们为什么要定义成密度函数的对数形式？因为虽然我们是从分布中采样，但是MCMC算法的执行函数`metrop()`需要的一个参数正是这个分布的密度函数的对数形式。

```r
x <- out$x
y <- out$y
lupost <- function(beta, x, y) {
    eta <- as.numeric(x %*% beta)
    logp <- ifelse(eta < 0, eta - log1p(exp(eta)), -log1p(exp(-eta)))
    logq <- ifelse(eta < 0, -log1p(exp(eta)), -eta - log1p(exp(-eta)))
    logl <- sum(logp[y == 1]) + sum(logq[y == 0])
    return(logl - sum(beta^2)/8)
}
```

# 2. 开始MCMC处理

在完成上面数据以及函数的定义(它们都是mcmc算法的输入参数)之后，我们就可以利用**mcmc**包中的`metrop()`来产生随机数据，模拟模型的后验分布。也就是说，我们将要从后验分布中进行取样。
```r
set.seed(42)
beta.init <- as.numeric(coefficients(out))
out <- metrop(lupost, beta.init, 1000, x = x, y = y)
names(out)
```

```r
[1] "accept"       "batch"        "initial"      "final"       
[5] "initial.seed" "final.seed"   "time"         "lud"         
[9] "nbatch"       "blen"         "nspac"        "scale"       
[13] "debug"       
```

此处`metrop()`使用到了如下几种参数：

  * `lupost`一个函数对象，即后验分布概率密度函数的对数。
  * `beta.init`用来设定马氏链的初始状态。这里是上面广义线性模型的参数估计结果。
  * `nbatch = 1000`是采样的样本容量，也就是马氏链的转移次数。
  * `x、y`，是传入`lupost`函数中的一些参数。

`metrop()`函数的结果是一个list(列表)。模拟的数据存放在`out$batch`里。刚才的函数运行结果显示接受概率(accept)很低，所以我们调整一下proposal(建议分布)的重要参数`scale`(即随机游走MH算法的方差)来获得一个更合理的接受概率。什么是接受概率？我们用马氏链的方法对状态空间进行采样，那必然我们有一些值是访问不到的，接受概率就是对这种状况进行衡量的。接受概率大，说明访问越充分，接受概率小，访问就受到了一定的限制，访问不是很细致，但样本的自相关性会减弱。因此，接受概率不是越大越好，也不是越小越好。到底多大的接受概率我们认为才是合理的呢？理论显示，在五个需要估计参数的条件下，接受概率达到20%即可。我们开始尝试不同的`scale`值进行测试：

```r
out <- metrop(out, scale = 0.1, x = x, y = y)
out$accept
## [1] 0.739
out <- metrop(out, scale = 0.3, x = x, y = y)
out$accept
## [1] 0.371
out <- metrop(out, scale = 0.5, x = x, y = y)
out$accept
## [1] 0.148
out <- metrop(out, scale = 0.4, x = x, y = y)
out$accept
## [1] 0.209
out <- metrop(out, nbatch = 10000, x = x, y = y)
out$accept
## [1] 0.2345
``` 

可以看到，每个`metrop()`中第一个参数均为`out`,它的含义是`metrop()`的许多参数与生成`out`的那一次模拟的参数一致，除了这次又修改的部分外，比如`scale`。这里改变的是`scale`，这是`Metropolis`随机游走算法中的一个参数值越大，那么马尔可夫链状态转移就越明显(样本自相关性减弱)，但同时接受概率就越低，所以这是一个需要兼顾两者的选择。从运行结果可以看到`scale=0.4`时满足了我们的要求。


# 3. 诊断，确定批次长度

我们找到了适合接受概率的`scale`值，下面我们按此参数增加模拟次数，然后观察结果。

```r
out <- metrop(out, nbatch = 10000, x = x, y = y)
out$accept
## [1] 0.2332
out$time
## user  system elapsed 
## 2.40    0.00    2.41 
plot(ts(out$batch))
```

![image](https://cloud.githubusercontent.com/assets/7221728/25366713/182a7942-29a4-11e7-880f-404cdc75c3d8.png)


解释一下`metrop()`中的参数`nbatch`，其实与它对应的还有一个参数是`blen`；`nbatch`是要模拟的批数，`blen`是要模拟的每批的长度，`blen`默认为1。假如`nbatch=100`，`blen=100`，那么马氏链共转移100*100=10000次.

```r
acf(out$batch)
```
![image](https://cloud.githubusercontent.com/assets/7221728/25366722/243a72d2-29a4-11e7-8d5d-9c652f5b5587.png)

在这个问题中，我们不研究收敛的问题。从自相关图可以看出，25阶以后的自相关系数可以忽略不计。所以每批次长度25就够了，为了更加保险，我们在下面的模拟中设置每批次长度为100。什么是批次？这是我们为了估计参数而对模拟的结果进行分组时的一个分组长度，之所以要分组，是因为这样才能克服相关性，使批次的均值之间近似独立。这样估计参数才更有效。

# 4. MCMC 的参数估计值与标准误

首先，运行以下程序：

```r
out <- metrop(out, nbatch = 100, blen = 100, outfun = function(z, ...) c(z, 
    z^2), x = x, y = y)
out$accept
## [1] 0.2345
out$time
## user  system elapsed 
## 2.46    0.00    2.54 
```

`outfun`函数的作用是方便构建一些统计量。对于这个问题，我们关心的是后验均值和方差。均值的计算相对简单，只需要对涉及的变量进行平均。但是方差的计算有点棘手。我们需要利用等式
  
`$$var(X)=E(X^2)-E(X)^2$$`

将方差表示为可以通过简单的平均进行估计的两部分的方程。因此，我们只需要得到样本的一阶矩和二阶矩。此处，函数`outfun`可针对参数(状态向量)`z`返回`c(z, z^2)`。`function() c(z, z^2)`的含义是，每次马氏链转移取样时，得到的一个状态`x`,把这个状态带入函数中，得到状态本身值，以及它的平方值。这样我们可以求解样本一阶距及二阶矩。

```r
nrow(out$batch)
```

    [1] 100
    
```r
out$batch[1, ]
```

     [1] 0.6239 0.8217 1.1411 0.4686 0.7494 0.4520 0.7730 1.3696 0.3048 0.6358
    

`out$batch[1, 1]` = `0.6239`是第一批样本的一阶样本矩，`out$batch[1, 6]` = `0.452`是第一批样本的二阶样本矩，注意这里`out$ batch[1, 1]` `$^2$`与`out$batch[1, 6]`并不相等，因为这里的每批长度(`blen`)是100,只有当`blen=1`时，它们才相等。

`outfun()`函数中参数是必要的，因为函数同样需要传递其他参数(如这里的`x`和`y`)到`metrop()`。

## 4.1 简单均值的计算

对每批次的均值再求均值

```r
apply(out$batch, 2, mean)
```
```r
[1] 0.6712 0.7771 1.1814 0.5114 0.7729 0.5465 0.7336 1.5399 0.3878 0.7453
```    

前五个数就是对后验参数均值的蒙特卡洛估计值，紧随其后的五个数是对后验参数二阶矩的估计值。通过下面的程序，得到参数的方差估计.

```r
foo <- apply(out$batch, 2, mean)
mu <- foo[1:5]
sigmasq <- foo[6:10] - mu^2
mu
```
```r
[1] 0.6712 0.7771 1.1814 0.5114 0.7729
```

蒙特卡洛标准误(MCSE)通过批次均值进行计算。这是求均值对简单的方法。
  
(注：方差和标准误是两个不同的概念。方差是一个参数估计，而标准误是对参数估计好坏评价的度量。)

```r
mu.muce <- apply(out$batch[, 1:5], 2, sd)/sqrt(out$nbatch)
mu.muce
```
```r
[1] 0.01367 0.01518 0.01785 0.01585 0.01622
```

额外因素`sqrt(out$nbatch)`的出现是因为批次均值的方差为`$\sigma^{2}/b $`，其中b是批次长度，即`out$blen`；而整体均值的方差为`$\sigma^{2}/n$`，其中n是迭代总数,即`out$blen` * `out$nbatch`。

## 4.2 均值的函数

下面我们使用delta method 得到后验方差的MC标准误。`$ u_{i} $` 代表某个参数单批次的一阶矩的估计值,`$\overline u $`代表某个参数所有批次均值的均值，它们都是针对一阶矩而言。对于二阶矩而言样有`$ v_{i} $`和`$ \overline v $` 。令`$ u=E(\overline u)$`, `$ v=E(\overline v) $` 。采用delta方法将非线性函数线性化：

`$$g(u,v)=v-u^{2}$$`
  
`$$\Delta g(u,v)=\Delta v-2u\Delta u $$`

也就是说，`$ g(\overline u, \overline v)-g(u,v) $` 与 `$ (\overline v – v)- 2u(\overline u – u) $`具有相同的渐进正态分布。而 `$ (\overline v – v)- 2u(\overline u – u) $`的方差是`$ (v_{i} -v)-2u(u_{i} -u) $`方差的1/nbatch倍。这样MCSE可以这样计算：

`$$\frac{1}{n_{batch}} \displaystyle \sum_{i=1}^{n_{batch}}[(v_{i} – \overline v)-2\overline u  
(u_{i} – \overline u)]^2 $$`

我们将以上的计算过程用程序实现:

```r
u <- out$batch[, 1:5]
v <- out$batch[, 6:10]
ubar <- apply(u, 2, mean)
vbar <- apply(v, 2, mean)
deltau <- sweep(u, 2, ubar)
deltav <- sweep(v, 2, vbar)
foo <- sweep(deltau, 2, ubar, "*")
sigmasq.mcse <- sqrt(apply((deltav - 2 * foo)^2, 2, mean)/out$nbatch)
sigmasq.mcse
```
```r
[1] 0.004687 0.008586 0.007195 0.007666 0.007714
```   

这五个值就是后验方差的蒙特卡洛标准误(MCSE)。

## 4.3 均值函数的函数

如果我们对后验标准差也感兴趣的话，也可以通过delta method计算它的标准误，程序如下

```r
sigma <- sqrt(sigmasq)
sigma.mcse <- sigmasq.mcse/(2 * sigma)
sigma.mcse
```

```r
[1] 0.007565 0.011923 0.009470 0.010789 0.010029
```    

# 5. 最后的运行

问题已经解决。现在唯一需要改进的就是提高结果的精确度。(试题要求“你的马尔科夫链采样器必须足够长以保证参数估计的标准误低于0.01”)。取模拟批次为500，每批长度为400，运行如下：

```r
out <- metrop(out, nbatch = 500, blen = 400, x = x, y = y)
out$accept
```
```r
[1] 0.2352
```

```r
out$time
```
```r
user  system elapsed 
50.40    0.01   51.01 
```    

(显然，由于模拟的次数增大，程序运行时间变长，当然不同运算速度的计算机可能显示结果并不一样。下面进行均值和方差的估计。)

```r
foo <- apply(out$batch, 2, mean)
mu <- foo[1:5]
sigmasq <- foo[6:10] - mu^2
mu
```
```r
[1] 0.6636 0.7961 1.1712 0.5075 0.7241
```    

然后计算均值估计的标准误

```r
mu.muce <- apply(out$batch[, 1:5], 2, sd)/sqrt(out$nbatch)
mu.muce
```
```r
[1] 0.002972 0.003611 0.003828 0.003604 0.004242
```    

紧接着计算方差估计的标准误

```r
u <- out$batch[, 1:5]
v <- out$batch[, 6:10]
ubar <- apply(u, 2, mean)
vbar <- apply(v, 2, mean)
deltau <- sweep(u, 2, ubar)
deltav <- sweep(v, 2, vbar)
foo <- sweep(deltau, 2, ubar, "*")
sigmasq.mcse <- sqrt(apply((deltav - 2 * foo)^2, 2, mean)/out$nbatch)
sigmasq.mcse
```
```r
[1] 0.001062 0.001718 0.001538 0.001574 0.002007
```    

给出标准差的估计以及标准误

```r
sigma <- sqrt(sigmasq)
sigma.mcse <- sigmasq.mcse/(2 * sigma)
sigma.mcse
```
```r
[1] 0.001752 0.002355 0.002116 0.002192 0.002509
```

以表格形式展示结果。

  * 后验均值估计：

```r
library(xtable)
data1 <- rbind(mu, mu.muce)
colnames(data1) <- c("constant", "x1", "x2", "x3", "x4")
rownames(data1) <- c("estimate", "MCSE")
data1.table <- xtable(data1, digits = 5)
print(data1.table, type = "html")
```

  * 后验方差估计

```r
data2 <- rbind(sigmasq, sigmasq.mcse)
colnames(data2) <- c("constant", "x1", "x2", "x3", "x4")
rownames(data2) <- c("estimate", "MCSE")
data2.table <- xtable(data2, digits = 5)
print(data2.table, type = "html")
```

  * 后验标准差估计

```r
data3 <- rbind(sigma, sigma.mcse)
colnames(data3) <- c("constant", "x1", "x2", "x3", "x4")
rownames(data3) <- c("estimate", "MCSE")
data3.table <- xtable(data3, digits = 5)
print(data3.table, type = "html")
```

