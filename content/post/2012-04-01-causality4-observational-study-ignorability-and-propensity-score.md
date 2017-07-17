---
title: 因果推断简介之四：观察性研究，可忽略性和倾向得分
date: '2012-04-01T14:41:38+00:00'
author: 丁鹏
categories:
  - 经典理论
  - 统计推断
tags:
  - Donald Rubin
  - ignorability
  - J. Neyman
  - propensity score
  - 倾向得分
  - 匹配
  - 可忽略性
  - 回归分析
  - 因果推断
  - 混杂因素
  - 观察性研究
  - 随机化试验
slug: causality4-observational-study-ignorability-and-propensity-score
forum_id: 418867
---

这节采用和前面相同的记号。`$Z$` 表示处理变量（`$1$` 是处理，`$0$`是对照），`$Y$` 表示结果，`$X$` 表示处理前的协变量。在完全随机化试验中，可忽略性 `$Z \bot \{Y(1), Y(0)\} $` 成立，这保证了平均因果作用 `$ACE(Z\rightarrow Y) = E\{Y(1) – Y(0)\} = E\{Y\mid Z=1\} – E\{Y\mid Z=0\}$` 可以表示成观测数据的函数，因此可以识别。在某些试验中，我们“先验的”知道某些变量与结果强相关，因此要在试验中控制他们，以减少试验的方差。在一般的有区组（blocking）的随机化试验中，更一般的可忽略性 `$Z \bot \{Y(1), Y(0)\} | X$` 成立，因为只有在给定协变量 `$ X $` 后，处理的分配机制才是完全随机化的。比如，男性和女性中，接受处理的比例不同，但是这个比例是事先给定的。

在传统的农业和工业试验中，由于随机化，可忽略性一般是能够得到保证的；因此在这些领域谈论因果推断是没有太大问题的。Jerzy Neyman 最早的博士论文，就研究的是农业试验。但是，这篇写于 1923 年的重要统计学文章，迟迟没有得到统计学界的重视，也没有人将相关方法用到社会科学的研究中。1970 年代，Donald Rubin 访问 UC Berkeley 统计系，已退休的 Jerzy Neyman 曾问起：为什么没有人将潜在结果的记号用到试验设计之外？正如 Jerzy Neyman 本人所说 “without randomization an experiment has little value irrespective of the subsequent treatment（没有随机化的试验价值很小）”，人们对于观察性研究中的因果推断总是抱着强烈的怀疑态度。我们经常听到这样的声音：统计就不是用来研究因果关系的！

![](https://uploads.cosx.org/2012/04/hume-kant-popper1.png)

在第一讲 Yule-Simpson 悖论的评论中，有人提到了哲学（史）上的休谟问题（我的转述）：人类是否能从有限的经验中得到因果律？这的确是一个问题，这个问题最后促使德国哲学家康德为调和英国经验派（休谟）和大陆理性派（莱布尼兹-沃尔夫）而写了巨著《纯粹理性批判》。其实，如果一个人是绝对的怀疑论者（如休谟），他可能怀疑一切，甚至包括因果律，所以，康德的理论也不能完全“解决”休谟问题。怀疑论者是无法反驳的，他们的问题也是无法回答的。他们存在的价值是为现行一切理论起到警示作用。一般来说，统计学家不会从过度哲学的角度谈论问题。从前面的说明中可以看出，统计中所谓的“因果”是**“某种”意义的“因果”**，即统计学只讨论**“原因的结果”**，而不讨论**“结果的原因”**。前者是可以用数据证明或者证伪的；后者是属于科学研究所探索的。用科学哲学家卡尔·波普的话来说，科学知识的积累是“猜想与反驳”的过程：“猜想”结果的原因，再“证伪”原因的结果；如此循环即科学。

<!--more-->

下面谈到的是，**在什么样的条件下**，观察性研究也可以推断因果。 这是一切社会科学所关心的问题。答案是：可忽略性，即 `$ Z\bot \{ Y(1), Y(0) \} | X $`。在可忽略性下，`$ACE$` 可以识别，因为

`$$\begin{eqnarray*}  
ACE&=& E(Y(1)) – E(Y(0))\nonumber\\&=& E[E(Y(1) \mid X)] – E[E(Y(0)\mid X)]\nonumber\\&=& E[E(Y(1)\mid X, Z=1)] – E[E(Y(0)\mid X, Z=0)]\nonumber\\&=& E[E(Y\mid X,Z=1)] – E[E(Y\mid X,Z=0)].  
\end{eqnarray*}$$`

从上面的公式来看，似乎我们的任务是估计两个条件矩 `$ E\{ Y\mid X, Z=z\} (z=0,1).$` 这就是一个回归问题。不错，这也是为什么通常的回归模型被赋予“因果”含义的原因。如果我们假定可忽略性和线性模型 `$E\{Y\mid X, Z\} = \beta_0 + \beta_x X + \beta_z Z$` 成立，那么`$ \beta_z $` 就表示平均因果作用。线性模型比较容易实现，实际中人们比较倾向这种方法。但是他的问题是：（1）假定个体因果作用是常数；（2）对于处理和对照组之间的不平衡（unbalance）没有很好的检测，常常在对观测数据外推（extrapolation）。

上面的第二条，是线性回归最主要的缺陷。在 Donald Rubin 早期因果推断的文献中，推崇的方法是“匹配”（matching）。一般来说，我们有一些个体接受处理，另外更多的个体接受对照；简单的想法就是从对照组中找到和处理组中比较“接近”的个体进行匹配，这样得出的作用，可以近似平均因果作用。“接近”的标准是基于观测协变量的，比如，如果某项研究，性别是唯一重要的混杂因素，我们就将处理组中的男性和对照组中的男性进行匹配。但是，如果观测协变量的维数较高，匹配就很难实现了。现有的渐近理论表明，匹配方法的收敛速度随着协变量维数的增高而线性的衰减。

后来 Paul Rosenbaum 到 Harvard 统计系读 Ph.D.，在 Donald Rubin 的课上问到了这个问题。这就促使两人合作写了一篇非常有名的文章，于 1983 年发表在 Biometrika 上：“The central role of the propensity score in observational studies for causal effects”。倾向得分定义为 `$ e(X) = P(Z=1\mid X),$` 容易验证，在可忽略性下，它满足性质 `$ Z\bot X|e(X) $` （在数据降维的文献中，称之为“充分降维”，sufficient dimension reduction） 和 `$Z\bot \{Y(1), Y(0)\}|e(X)$`（给定倾向得分下的可忽略性）。根据前面的推导，显然有 `$ ACE =E[E(Y\mid e(X),Z=1)] – E[E(Y\mid e(X),Z=0)]$`。此时，倾向得分是一维的，我们可以根据它分层 （Rosenbaum 和 Rubin 建议分成 5 层），得到平均因果作用的估计。连续版本的分层，就是下面的加权估计： `$$ACE = E\{Y(1) \}- E\{ Y(0) \} = E\left\{  \frac{ZY}{e(X)} \right\} – E\left\{  \frac{(1-Z)Y}{ 1 – e(X)} \right\}.$$` 不过，不管是分层还是加权，第一步我们都需要对倾向得分进行估计，通常的建议是 Logistic 回归。甚至有文献证明的下面的“离奇”结论：使用估计的倾向得分得到平均因果作用的估计量的渐近方差比使用真实的倾向得分得到的小。

熟悉传统回归分析的人会感到奇怪，直接将 `$ Y $` 对 `$ Z $` 和 `$ X $` 做回归的方法简单直接，为何要推荐倾向得分的方法呢？确实，读过 Rosenbaum 和 Rubin 原始论文的人，一般会觉得，这篇文章很有意思，但是又觉得线性回归（或者 logistic 回归）足矣，何必这么复杂？在因果推断中，我们应该更加关心处理机制，也就是倾向得分。按照 Don Rubin 的说法，我们应该根据倾向得分来“设计”观察性研究；按照倾向得分将人群进行匹配，形成一个近似的“随机化试验”。而这个设计的过程，不能依赖于结果变量；甚至在设计的阶段，我们要假装没有观察到结果变量。否则，将会出现如下的怪现象：社会科学的研究者不断地尝试加入或者剔除某些回归变量，直到回归的结果符合自己的“故事”为止。这种现象在社会科学中实在太普遍了！结果的回归模型固然重要，但是如果在 `$ Y $` 模型上做文章，很多具有“欺骗性”的有偏结果就会出现在文献中。这导致大多数的研究中，因果性并不可靠。

讲到这里，我们有必要回到最开始的 Yule-Simpson’s Paradox。用 `$Z$` 表示处理（`$1$` 表示处理，`$ 0 $` 表示对照），`$ Y $` 表示存活与否（`$ 1 $` 是表示存活，`$ 0 $` 表示死亡），`$ X $` 表示性别（`$ 1 $` 表示男性，`$ 0 $` 表示女性）。目前我们有处理“因果作用”的两个估计量：一个不用性别进行加权调整

`$$\begin{eqnarray*}  
\widehat{ACE}_{unadj} &=& \widehat{P} (Y = 1\mid Z=1) – \widehat{P}(Y=1\mid Z=0) \\  
&=& 0.50 – 0.40 = 0.10 > 0 .
\end{eqnarray*}$$`

另一个用性别进行加权调整（由于此时协变量是一维的，倾向得分和协变量本身存在一一对应，用倾向得分调整结果相同，见下面问题 1）

`$$\begin{eqnarray*}  
&&\widehat{ACE}_{adj} \\  
&=& \{ \widehat{P}(Y = 1\mid Z=1, X=1 ) – \widehat{P}(Y = 1\mid Z=0, X=1 ) \} \widehat{P}(X=1) \\  
&& + \{ \widehat{P}(Y = 1\mid Z=1, X=0 ) –\widehat{P}(Y = 1\mid Z=0, X=0 ) \} \widehat{P}(X=0) \\
&=& (0.60 – 0.70)\times 0.5 + (0.20 – 0.30)\times 0.5\\
&=& -0.10<0.
\end{eqnarray*}$$`

其中，`$ \widehat{\cdot} $` 表示相应的矩估计。 是否根据性别进行调整，对结果有本质的影响。当 `$ Z \bot \{Y(1), Y(0)\} $` 时， 第一个估计量是因果作用的相合估计；当`$ Z \bot \{Y(1), Y(0)\}|X $` 时，第二个估计量是因果作用的相合估计。根据实际问题的背景，我们应该选择哪个估计量呢？到此为止，回答这个问题有些似是而非（选择调整的估计量？），更进一步的回答，请听下回分解：因果图（causal diagram）。

作为结束，留下如下的问题：

  1. 如果 `$X$` 是二值的变量（如性别），那么匹配或者倾向的分都导致如下的估计量：`$ACE = \sum\limits_{x=0,1} \left[ E\{Y\mid Z=1, X=x\} – E\{ Y\mid Z=0, X=x\} \right] P(X=x) .$` 这个公式在流行病学中非常基本，即根据混杂变量进行分层调整。在后面的介绍中将讲到，这个公式被 Judea Pearl 称为“后门准则”（backdoor criterion）。
  2. 倾向得分的加权形式， `$ACE = E\{Y(1) \}- E\{ Y(0) \} = E\left\{  \frac{ZY}{e(X)} \right\} – E\left\{  \frac{(1-Z)Y}{ 1 – e(X)} \right\},$` 本质上是抽样调查中的 Horvitz-Thompson 估计。在流行病学的文献中，这样的估计量常被称为“逆概加权估计量”（inverse probability weighting estimator; IPWE）。
  3. 直观上，为什么估计的倾向得分会更好？想想偏差和方差的权衡（bias-variance tradeoff）。

关于“可忽略性”（ignorability），需要做一些说明。在中文翻译的计量经济学教科书中，这个术语翻译存在错误，比如 Wooldridge 的 Econometric Analysis of Cross Section and Panel Data 的中译本中，“可忽略性”被翻译成“不可知”。子曰：“名不正，则言不顺；言不顺，则事不成。”在 Rubin (1978) 中，“可忽略性”这个概念是在贝叶斯推断的框架下提出来的：当处理的分配机制满足这样的条件时，在后验的推断中，可将分配机制“忽略”掉。在传统的贝叶斯看来，所有的推断都是条件在观测数据上的，那么为什么处理的分配机制会影响贝叶斯后验推断呢？Donald Rubin 说，当时连 Leonard Jimmie Savage 和 Dennis Victor Lindley 都在此困惑不解，他 1978 年的文章，原意就是为了解释为什么随机化会影响贝叶斯推断。

“可忽略性” 这个名字最早是在缺失数据的文献中提出来的。当缺失机制是随机缺失（missing at random：MAR）且模型的参数与缺失机制的参数不同时，缺失机制“可忽略”（ignorable）。“可忽略”是指，缺失机制不进入基于观测数据的似然或者贝叶斯后验分布。

参考文献：

  1. Rosenbaum, P. R. and Rubin, D. B. (1983) The central role of the propensity score in observational studies for causal effects. Biometrika, 70, 41-55.
  2. Rubin, D. B. (1976) Inference and missing data (with discussion). Biometrika, 63, 581-592.
  3. Rubin, D. B. (1978) Bayesian inference for causal effects: The role of randomization. The Annals of Statistics, 6, 34-58.
  4. Wooldridge, J. M. (2002) Econometric analysis of cross section and panel data. The MIT press.
