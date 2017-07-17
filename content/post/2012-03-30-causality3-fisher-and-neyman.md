---
title: 因果推断简介之三：R. A. Fisher 和 J. Neyman 的分歧
date: '2012-03-30T13:10:09+00:00'
author: 丁鹏
categories:
  - 经典理论
  - 统计推断
tags:
  - Fisher randomization test
  - Neyman repeated sampling procedure
  - sharp null
  - 因果推断
  - 有限样本
  - 统计量
  - 置信区间
  - 随机化检验
  - 零假设
slug: causality3-fisher-and-neyman
forum_id: 418866
---

![R.A. Fisher](https://uploads.cosx.org/2012/03/R.A.-Fisher.jpg)
  
这部分谈到的问题非常微妙：完全随机化试验下的 Fisher randomization test 和 Neyman repeated sampling procedure。简单地说，前者是随机化检验，或者如很多教科书讲的Fisher 精确检验 （Fisher exact test）；后者是 Neyman 提出的置信区间 （confidence interval）理论。

我初学因果推断的时候，并没有细致的追求这些微妙的区别，觉得了解到简介之二的层次就够了。不过在 Guido Imbens 和 Donald Rubin 所写的因果推断教科书（还未出版）中，这两点内容放在了全书的开端，作为因果推断的引子。在其他的教科书中，是看不到这样的讲法的。平日里常常听到 Donald Rubin 老爷子对 Fisher randomization test 的推崇，我渐渐地也被他洗脑了。

Fisher 的随机化检验，针对的是如下的零假设，又被称为 sharp null：  `$$H_0 : Y_i(1) = Y_i(0), \forall i = 1,\cdots,n.$$` 坦白地说，这个零假设是我见过的最奇怪的零假设，没有之一。现行的统计教科书中，讲到假设检验，零假设都是针对某些参数的，而 Fisher 的 sharp null 看起来却像是针对随机变量的。这里需要讲明白的是，当我们关心**有限样本 （finite sample）**的因果作用时，每个个体的潜在结果 `$ \{Y_i(1), Y_i(0)\} $` 都是固定的，观测变量 `$Y_i = Z_i Y_i(1) + (1 – Z_i)Y_i(0) $` 的随机性仅仅由于“随机化” `$Z_i $` 本身导致的。理解清楚这点，才能理解 Fisher randomization test 和后面的 Neyman repeated sampling procedure。如果读者对于这种有限样本的思考方式不习惯，可以先阅读一下经典的抽样调查教科书，那里几乎全是有限样本的理论，所有的随机性都来自于随机采样的过程。

如果认为潜在结果是固定的数，那么 Fisher sharp null 就和现行的假设检验理论不相悖。这个 null 之所以“sharp”的原因是，在这个零假设下，所有个体的潜在结果都固定了，个体的因果作用为零，唯一的随机性来自于随机化的“物理”特性。定义处理分配机制的向量为 `$$ \overrightarrow{Z} = (Z_1, \cdots, Z_n).$$` 结果向量为 `$$\overrightarrow{Y} = (Y_1, \cdots, Y_n).$$`

此时有限样本下的**随机化分配机制**如下定义：

`$$P(  \overrightarrow{Z} |   \overrightarrow{Y}  ) = \binom{n}{m}^{-1}, \forall  \overrightarrow{Y} ,$$`

其中， `$m = \sum\limits_{i=1}^n Z_i $` 为处理组中的总数。这里的“条件期望”并不是说  `$ \overrightarrow{Y} $` 是随机变量，而是强调处理的分配机制不依赖于潜在结果。比如，我们选择统计量 `$$T = T(\overrightarrow{Z}, \overrightarrow{Y}) = \frac{1}{m} \sum\limits_{i=1}^n Z_i Y_i –  \frac{1}{n-m }\sum\limits_{i=1}^n (1 – Z_i) Y_i $$`
  
![J. Neyman](https://uploads.cosx.org/2012/03/J.-Neyman.jpg) 来检验零假设，问题在于这个统计量的分布不易求出。但是，我们又知道，这个统计量的分布完全来自随机化。因此，我们可以用如下的“随机化”方法 （Monte Carlo 方法模拟统计量的分布）：将处理分配机制的向量 `$ \overrightarrow{Z}  $` 进行随机置换得到`$ \overrightarrow{Z}^1 = (Z_1^1, \cdots, Z_n^1) $`，计算此时的检验统计量 `$ T^1 = T(\overrightarrow{Z}^1, \overrightarrow{Y}) $`；如此重复多次（`$n$` 不大时，可以穷尽所有的置换），便可以模拟出统计量在零假设下的分布，计算出 p 值。

有人说，Fisher randomization test 已经蕴含了 bootstrap 的思想，似乎也有一定的道理。不过，这里随机化的方法是针对一个特例提出来的。

下面要介绍的 Neyman 的方法，其实早于 Fisher 的方法。这种方法在 Neyman 1923 年的博士论文中，正式提出了。这种方法假定 `$n$` 个个体中有 `$m$`个随机的接受处理，目的是估计（有限）总体的平均因果作用：`$$ \tau = \frac{1}{n} \sum\limits_{i=1}^n \{ Y_i(1) – Y_i(0) \} .$$` 一个显然的无偏估计量是  `$$\hat{\tau}  = \bar{y}_1 – \bar{y}_0 =  \frac{1}{m} \sum\limits_{i=1}^n Z_i Y_i –  \frac{1}{n-m} \sum\limits_{i=1}^n (1 – Z_i) Y_i .$$` 但是，通常的方差估计量，

`$\hat{\text{Var}}(\hat{\tau})  =  \sum\limits_{Z_i=1} (Y_i – \bar{y}_1)^2 /(m-1)m+  \sum\limits_{Z_i=0} (Y_i – \bar{y}_0)^2/(n-m-1)(n-m) $`

高估了方差，构造出来的置信区间在 Neyman – Pearson 意义下太“保守”。可以证明，在个体处理作用是常数的假定下，上面的方差估计是无偏的。

通常的教科书讲假设检验，都是从正态均值的检验开始。Neyman 的方法给出了 `$ \tau $` 的点估计和区间估计，也可以用来检验如下的零假设：`$$H_0:  \tau = 0.$$`

实际中，到底是 Fisher 和零假设合理还是 Neyman 的零假设合理，取决于具体的问题。比如，我们想研究某项政策对于中国三十多个省的影响，这是一个有限样本的问题，因为我们很难想象中国的省是来自某个“超总体”。但是社会科学中的很多问题，我们不光需要回答处理或者政策对于观测到的有限样本的作用，我们更关心这种处理或者政策对于一个更大总体的影响。前者，Fisher 的零假设更合适，后者 Neyman 的零假设更合适。

关于这两种角度的争论，可以上述到 Fisher 和 Neyman 两人。1935 年，Neyman 向英国皇家统计学会提交了一篇论文“Statistical problems in agricultural experimentation”，Fisher 和 Neyman 在讨论文章时发生了激烈的争执。不过，从今天的统计教育来看，Neyman 似乎占了上风。

用下面的问题结束：

  1. 在 sharp null下，Neyman 方法下构造的 T 统计量，是否和 Fisher randomization test 构造的统计量相同？分布是否相同？
  2. Fisher randomization test 中的统计量可以有其他选择，比如 Wilcoxon 秩和统计量等，推断的方法类似。
  3. 当 `$ Y $` 是二值变量时，上面 Fisher 的方法就是教科书中的 Fisher exact test。在没有学习 potential outcome 这套语言之前，理解 Fisher exact test 是有些困难的。
  4. 证明 `$ E \{  \hat{\text{Var}}(\hat{\tau})  \}  \geq \text{Var}(\hat{\tau}) $`。
  5. 假定 `$n$` 个个体是一个超总体（super-population）的随机样本，超总体的平均因果作用定义为 `$$ \tau_{SP} = E\{ Y(1) – Y(0) \}.$$` 那么 Neyman 的方法得到估计量是超总体平均因果作用的无偏估计，且方差的表达式是精确的；而 sharp null 在超总体的情形下不太适合。

原始的参考文献是：

- Neyman, J. (1923) On the application of probability theory to agricultural experiments. Essay on principles. Section 9. reprint in Statistical Science. 5, 465-472. with discussion by Donald Rubin.

最近的理论讨论是：
  
- [On Arxiv.](http://arxiv.org/abs/1402.0142)
