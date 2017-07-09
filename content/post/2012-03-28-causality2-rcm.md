---
title: 因果推断简介之二：Rubin Causal Model (RCM)和随机化试验
date: '2012-03-28T11:48:23+00:00'
author: 丁鹏
categories:
  - 经典理论
  - 统计推断
tags:
  - Donald Rubin
  - RCM
  - 可识别性
  - 因果推断
  - 因果识别
  - 平均因果作用
  - 随机化试验
slug: causality2-rcm
forum_id: 418865
---

![Donald Rubin](https://uploads.cosx.org/2012/03/Donald-Rubin.jpg)

因果推断用的最多的模型是 Rubin Causal Model (RCM; Rubin 1978) 和 Causal Diagram (Pearl 1995)。Pearl (2000) 中介绍了这两个模型的等价性，但是就应用来看，RCM 更加精确，而 Causal Diagram 更加直观，后者深受计算机专家们的推崇。这部分主要讲 RCM。

设  `$Z\_i$` 表示个体 `$i$` 接受处理与否，处理取 `$1$`，对照取`$0$` (这部分的处理变量都讨论二值的，多值的可以做相应的推广)；`$Y\_i$` 表示个体 `$i$` 的结果变量。另外记 `$\{  Y\_i(1),Y\_i(0)\}$` 表示个体 `$i$` 接受处理或者对照的潜在结果 (potential outcome)，那么 `$Y\_i(1) -Y\_i(0)$`  表示个体 `$i$`  接受治疗的个体因果作用。不幸的是，每个个体要么接受处理，要么接受对照 `$\{Y\_i(1),Y\_i(0)\}$` 中必然缺失一半，个体的因果作用是不可识别的。观测的结果是 `$Y\_i = Z\_i Y\_i(1) + (1 – Z\_i) Y_i(0)$`。 但是，在 `$Z$` 做随机化的前提下，我们可以识别总体的平均因果作用 (Average Causal Effect; ACE):

`$$ACE(Z\rightarrow Y) = E\{Y\_i(1) – Y\_i(0)\}$$`

这是因为
  
`$$\begin{eqnarray*}
ACE(Z \rightarrow Y) & = & E\{Y\_i(1)\} -E\{Y\_i(0)\} \\
& = & E\{Y\_i(1) \mid Z\_i =1\}  -E\{Y\_i(0)\mid Z\_i=0\} \\
& = & E\{Y\_i \mid Z\_i =1\} – E\{Y\_i \mid Z\_i=0\}
\end{eqnarray*}$$`
  
最后一个等式表明 `$ACE$` 可以由观测的数据估计出来。其中第一个等式用到了期望算子的线性性(非线性的算子导出的因果度量很难被识别！)；第二个式子用到了随机化，即 `$$Z\bot\{Y(1),Y(0)\} $$` 其中， `$\bot$` 表示独立性。由此可见，随机化试验对于平均因果作用的识别起着至关重要的作用。

当 `$ Y $` 是二值的时候，平均因果作用是流行病学中常用的“风险差”（risk difference; RD）：
  
`$$  
\begin{eqnarray*}
CRD(Z\rightarrow Y)  & = & P(Y(1) = 1)  –  P(Y(0)=1) \\
& = & P(Y=1\mid Z=1) – P(Y=1\mid Z=0)
\end{eqnarray*}
$$`

当然，流行病学还常用“风险比”（risk ratio; RR）：
  
`$$\begin{eqnarray*}
CRR(Z \rightarrow Y) & = & \frac{P(Y(1) = 1)}{P(Y(0)=1)}\\
& = & \frac{P(Y=1\mid Z=1)}{P(Y=1\mid Z=0)}
\end{eqnarray*}
$$`

和“优势比”（odds ratio; OR）：
  
`$$\begin{eqnarray*}
COR(Z \rightarrow Y) & = & \frac{P(Y(1) = 1)P(Y(0)=0) }{P(Y(0)=1)P(Y(1)=0) } \\ 
& = & \frac{P(Y=1\mid Z=1)P(Y=0\mid Z=0)}{P(Y=1\mid Z=0) P(Y=0\mid Z=1)}  
\end{eqnarray*} $$`

上面的记号都带着“C”，是为了强调“causal”。细心的读者会发现，定义 CRR 和 COR 的出发点和 ACE 不太一样。ACE 是通过对个体因果作用求期望得到的，但是 CRR 和 COR 是直接在总体上定义的。这点微妙的区别还引起了不少人的研究兴趣。比如，经济学中的某些问题，受到经济理论的启示，处理的作用可能是非常数的，仅仅研究平均因果作用不能满足实际问题的需要。这时候，计量经济学家提出了“分位数处理作用”（quantile treatment effect: QTE）：
  
`$$QTE(\tau) = F^{-1}\_{Y(1)}(\tau) – F^{-1}\_{Y(0)}(\tau)$$`

在随机化下，这个量也是可以识别的。但是，其实这个量并不能回答处理作用异质性（heterogenous treatment effects）的问题，因为处理作用非常数，最好用如下的量刻画：
  
`$$\Delta(\delta) = P(Y(1) – Y(0) \leq \delta )$$`

这个量刻画的是处理作用的分布。不幸的是，估计 `$\Delta(\delta)$` 需要非常强的假定，通常不具有可行性。

作为结束，留下如下的问题：

  1. “可识别性”（identifiability）在统计中是怎么定义的？
  2. 医学研究者通常认为，随机对照试验（randomized controlled experiment）是研究处理有效性的黄金标准，原因是什么呢？随机化试验为什么能够消除 Yule-Simpson 悖论？
  3. `$QTE(\tau)$` 在随机化下是可识别的。另外一个和它“对偶”的量是 Ju and Geng (2010) 提出的分布因果作用（distributional causal effect: DCE）：`$DCE(y) = P(Y(1) \geq y) – P(Y(0) \geq y)$` ，在随机化下也可以识别。
  4. 即使完全随机化，`$\Delta(\delta)$` 也不可识别。也就是说，经济学家提出的具有“经济学意义”的量，很难用观测数据来估计。这种现象在实际中常常发生：关心实际问题的人向统计学家索取的太多，而他们提供的数据又很有限。

关于 RCM 的版权，需要做一些说明。目前可以看到的文献，最早的是 Jerzy Neyman 于 1923 年用波兰语写的博士论文，第一个在试验设计中提出了“潜在结果”（potential outcome）的概念。后来 Donald Rubin 在观察性研究中重新（独立地）提出了这个概念，并进行了广泛的研究。Donald Rubin 早期的文章并没有引用 Jerzy Neyman 的文章，Jerzy Neyman 的文章也不为人所知。一直到 1990 年，D. M. Dabrowska 和 T. P. Speed 将 Jerzy Neyman 的文章翻译成英文发表在 Statistical Science 上，大家才知道 Jerzy Neyman 早期的重要贡献。今天的文献中，有人称 Neyman-Rubin Model，其实就是潜在结果模型。计量经济学家，如 James Heckman 称，经济学中的 Roy Model 是潜在结果模型的更早提出者。在 Donald Rubin 2004 年的 Fisher Lecture 中，他非常不满地批评计量经济学家，因为 Roy 最早的论文中，全文没有一个数学符号，确实没有明确的提出这个模型。详情请见，Donald Rubin 的 Fisher Lecture，发表在 2005 年的 Journal of the American Statistical Association 上。研究 Causal Diagram 的学者，大多比较认可 Donald Rubin 的贡献。但是 Donald Rubin 却是 Causal Diagram 的坚定反对者，他认为 Causal Diagram 具有误导性，且没有他的模型清楚。他与James Heckman （诺贝尔经济学奖）， Judea Pearl （图灵奖） 和 James Robins 之间的激烈争论，成为了广为流传的趣闻。

参考文献：

  1. Neyman, J. (1923) On the application of probability theory to agricultural experiments. Essay on principles. Section 9. reprint in Statistical Science. 5, 465-472.
  2. Pearl, J. (1995) Causal diagrams for empirical research. Biometrika, 82, 669-688.
  3. Pearl, J. (2000) Causality: models, reasoning, and inference. Cambridge University Press。
  4. Rubin, D.B. (1978) Bayesian inference for causal effects: The role of randomization. The Annals of Statistics, 6, 34-58.
