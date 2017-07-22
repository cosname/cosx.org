---
title: '[火光摇曳]神奇的伽玛函数(下)'
date: '2014-07-01T19:52:23+00:00'
author: 靳志辉
categories:
  - 概率论
  - 统计之都
tags:
  - gamma
  - 伽玛函数
slug: gamma-function-2
forum_id: 419024
---

原文链接： <http://www.flickering.cn/?p=203>

# 五、`$ \Gamma(n) = (n-1)!$` 还是 `$ \Gamma(n) = n! $` ? 

伽玛函数找到了，我们来看看第二个问题，为何伽玛函数被定义为满足 `$\Gamma(n)=(n-1)!$`? 这看起来挺别扭的，如果我们稍微修正一下，把伽玛函数定义中的 `$t^{x-1}$` 替换为 `$t^x$`
  
`$$ \Gamma(x) = \int_0^{\infty} t^{x}e^{-t}dt , $$`
  
这不就可以使得 `$\Gamma(n)=n!$`了嘛。估计数学界每年都有学生问这个问题，然而答案却一直有一些争议。

欧拉最早的伽玛函数定义还真是如上所示，选择了`$\Gamma(n)=n!$`，事实上数学王子高斯在研究伽玛函数的时候， 一直使用的是如下定义：
  
`$$ \Pi(x)=\int_{0}^\infty t^x e^{-t}\,dt ,$$`
  
然而这个定义在历史上并没有流传开来。

  ![勒让德肖像水彩画](https://uploads.cosx.org/2014/07/legendre.jpg)

欧拉在伽玛函数的推导中实际上引入了两类积分形式
  
`$$ \int_0^1 t^{x}(1-t)^{y}dt, \quad \quad \int_0^{\infty} t^{x}e^{-t}dt $$`
  
现在我们分别称为欧拉一类积分和欧拉二类积分。勒让德追随欧拉的脚步，发表了多篇论文对欧拉积分进行了深入的研究和推广，不过在勒让德的研究中，对积分中的参数做了 `$-1$`的移位修改，主要定义为
  
`$$ B(x, y) = \int_0^1 t^{x-1}(1-t)^{y-1}dt $$`
  
和
  
`$$ \Gamma(x) = \int_0^{\infty} t^{x-1}e^{-t}dt .$$`
  
`$B(x,y)$` 现在称为贝塔积分或者贝塔函数。其中`$\Gamma(x)$` 的这个定义选择导致了 `$ \Gamma(n) = (n-1)!$`。实际上伽马函数中的`$\Gamma$`符号历史上就是勒让德首次引入的，而勒让德给出的这个伽玛函数的定义在历史上起了决定作用，该定义被法国的数学家广泛采纳并在世界范围推广，最终使得这个定义在现代数学中成为了既成事实。

<!--more-->

什么原因驱使勒让德偏向选择`$\Gamma(n) = (n-1)!$` 的定义呢？ 这成为了一个谜，没有明确的解释。 不过有数学史研究者们对欧拉的研究表明，在`$1730\sim1768$`年之间欧拉自己在研究一类积分的时候，实际上就已经对积分中的参数做了$-1$的移位修改，从而明确的引入了贝塔积分，而这个修改显然被勒让德注意到了。 是什么原因使得欧拉和勒让德在研究他们的积分形式的时候都考虑引入$-1$ 移位修改呢？ 有数学家猜测一个可能的原因是这两位数学家注意到，如果按照现代伽玛函数的定义，那么有
  
`\begin{equation}  
\label{beta-gamma-decompose}
B(x,y) = \frac{\Gamma(x)\Gamma(y)}{\Gamma(x+y)} ,
\end{equation}`
  
`$B(x,y)$` 具有非常漂亮的对称形式。可是如果选取高斯给出的 `$\Pi(n)=n!$` 的定义，令
  
`$$ E(x, y) = \int_0^1 t^{x}(1-t)^{y}dt $$`
  
则有
  
`$$ E(x,y) = \frac{\Pi(x)\Pi(y)}{\Pi(x+y+1)} ,$$`
  
这个形式显然不如 `$B(x,y)$` 具有对称美，而数学家总是很在乎数学公式的美感的。

还有一个类似的解释是从抽象代数的角度提出的，考虑伽玛分布的概率密度函数
  
`$$ f_\alpha(x)= \left\{
\begin{aligned}
\frac{x^{\alpha-1} e^{-x}}{\Gamma(\alpha)} & \text{for }x>0
\\ 0 \quad \quad & \text{for }x < 0
\end{aligned}
\right.
$$`
  
形成的集合 `$\{f_\alpha : \alpha > 0\}$`,那么该集合在卷积运算 `$*$`之下构成一个抽象代数中的半环，即满足
  
`$$ f_\alpha * f_\beta = f_{\alpha+\beta} .$$`
  
而用`$\Pi(x)$` 的定义则无法得到类似的结果。

另外一个更具启发性的解释是也是从抽象代数角度描述的。 对伽玛函数
  
`$$ \Gamma(x) = \int_0^{\infty} e^{-t}t^{x-1}dt $$`
  
做一个线性变换 `$h: t \rightarrow ct$`，可以得到如下函数
  
`\begin{equation}
\label{generalized-gamma} 
\frac{\Gamma(x)}{c^x} = \int_0^{\infty} e^{-ct} t^x \frac{dt}{t}  
\end{equation}`
  
由此 `$dt/t = d \log t$` 可以被看成是乘法群 `$(0, \infty)$` 上的一个不变测度，在尺度伸缩变换下满足不变性：
  
`$$ \frac{d(ct)}{ct} = \frac{dt}{t} .$$`
  
而 `$e^{-ct}$` 对应于群上的一个加法特征(additive character) $f$， 满足
  
`$$f(t+s) =f(t) \cdot f(s) ,$$`
  
`$t^x$`对应于群上的一个乘法特征(mulpicative character) $g$， 满足
  
`$$g(t \cdot s) = g(t) \cdot g(s) .$$`
  
由于积分表示的是求和， 所以\eqref{generalized-gamma} 式 被看成是乘法群 `$(0, \infty)$` 上加法特征和乘法特征混合乘积的累积求和。有了这个分解，只要在抽象代数的有限域上定义了$f$ 和$g$ 这两个映射， 实数域上定义的`$\frac{\Gamma(x)}{c^x}$` 函数就可以被推广到有限域上进行定义，只是无限求和的积分号变成了有限求和符号`$\Sigma$` 。 进一步，借用贝塔函数和伽玛函数满足的关系式\eqref{beta-gamma-decompose}, `$Beta(x,y)$`也可以完全类似的在有限域中定义出来， 而这种推广也将变得具有简洁的对称美。当然，这个理由和欧拉、勒让德的选择无关，而是现代数学家们给出的一个额外的解释。

# 六、伽玛函数欣赏

伽玛函数从它诞生开始就被许多数学家追逐研究，包括高斯、勒让德、威尔斯特拉斯、柳维尔等等，数学家们发现了这个函数大量的奇特性质，在解决许多数学问题的时候是一把利器。伽玛函数作为阶乘的推广，首先它也满足如下的斯特林公式
  
`$$ \Gamma(x) \approx \sqrt{2\pi}e^{-x}x^{x-\frac{1}{2}} .$$`
  
另外， 伽玛函数不仅可以定义在实数集上，基于复变函数的理论还可以延拓到整个复平面上。所以我们不仅可以计算`$ (\frac{1}{2})!, (-7.5)!$`，我们甚至可以计算 `$(\frac{1}{2} + \frac{1}{3}i)!$`，阶乘的概念居然可以推广到虚数，这真是太神奇了！

欧拉把$n!$ 推广之后得到了伽玛函数，很自然的一个问题是：伽玛函数是$n!$的唯一的插值推广函数吗？ 当然不是，丹尼尔·贝努利最早的无穷乘积推广就已经说明了存在多种推广延拓的方式。譬如`$f(x) = \Gamma(x) \cos (2n\pi)$` 这个函数显然也满足把 $n!$ 延拓到实数集。 那伽玛函数在延拓 $n!$ 的时候有什么特殊的地方呢？ 从伽玛函数的图像我们可以看到它是一个凸函数，所以我们很自然地会问伽玛函数是否是唯一的满足凸性的阶乘函数，可是答案还是否定的。 那伽马函数为什么鹤立鸡群呢？数学家们发现不仅 `$\Gamma(x)$` 是一个凸函数， `$\log\Gamma(x)$`也是一个凸函数，数学上可以证明如下定理:

**[Bohr-Mullerup 定理]** 如果 `$f:(0,\infty)\rightarrow (0,\infty)$`,且满足

  1. `$f(1) = 1$`
  2. `$f(x+1) = xf(x)$`
  3. `$\log f(x)$` 是凸函数

那么 `$f(x) = \Gamma(x)$`, 也就是`$\Gamma(x)$`是唯一满足以上条件的函数。`$log \Gamma(x)$` 是一个凸函数

  ![digamma-func](https://uploads.cosx.org/2014/07/digamma-func.png) 

伽玛函数有不少等价的表示形式和神奇的结果。高斯给出的伽玛函数的形式是
  
`$$ \Gamma(x) = \lim_{n\rightarrow\infty} \frac{n^x n!}{x(x+1)(x+2)\cdots(x+n)} .$$`
  
欧拉证明了如下一个漂亮的反射公式
  
`$$ \Gamma(x) \Gamma(1-x) = \frac{\pi}{\sin (\pi x)} .$$`
  
维尔斯特拉斯把高斯的伽玛函数形式做一下变换，就得到如下表达为无穷乘积的结果
  
`$$ {\Gamma(x)} = \frac{1}{xe^{\gamma x}} \prod_{k=1}^\infty
\frac{e^{\frac{x}{k}}} {1+\frac{x}{k}} .$$`
  
此处 `$\gamma = 0.5772156649\cdots$` 为欧拉常数。这个结果在复平面上也成立。由于伽玛函数的这个分解形式的启发，导致维尔斯特拉斯发现复平面上任意整函数`$f(z)$` 都以分解为无穷乘积形式。基于维尔斯特拉斯的这个无穷乘积形式和欧拉的反射公式，分别整理简化一下 `$\Gamma(1+x)\Gamma(1-x)$`，就可以轻松地得到介绍沃利斯公式的时候中提到的 `$\sin x$` 的无穷乘积展开式。

伽玛函数还有很多妙用，它能扩展一些重要的数学概念，譬如导数。我们可以定义一阶、二阶等整数阶导数，而数学家们却追问一个奇怪的问题：我们能定义分数阶的导数吗？ 这个问题早年莱布尼茨研究微积分的时候他就提出来过，然而没有获得实质性进展。而欧拉给出了伽玛函数之后，也研究过分数阶导数的问题。我们观察一下函数`$f(x) = x^n$` 的各阶导数

![derivatives](https://uploads.cosx.org/2014/07/derivatives.png)

由于k阶导数可以用阶乘表达，于是我们用伽玛函数表达为
  
`$$ f(x)^{(k)} = \frac{\Gamma{(n+1)}}{\Gamma{(n-k+1)}} x^{n-k} $$`
  
基于上式，可以把导数的阶从整数延拓到实数集。例如，取`$n=1, k=\frac{1}{2}$` 我们可以计算 $x$ 的 `$\frac{1}{2}$`阶导数为
  
`$$ f(x)^{(\frac{1}{2})} = \frac{\Gamma{(1+1)}}{\Gamma{(1-1/2+1)}} x^{1-1/2}
= \frac{2\sqrt{x}}{\sqrt{\pi}} .$$`
  
很容易想到对于一般的函数 `$f(x)$`通过泰勒级数展开可以表达为幂级数，于是借用 `$x^n$`的分数阶导数，我们可以尝试定义出任意函数的分数阶导数。不过有点遗憾的是这种简单的基于泰勒级数的定义方法不是良定义的，并非对所有函数都适用，但是这个思想却给后来的数学家提供了重要的线索，并由此发展了数学分析中的一个研究课题： Fractional Calculus。 在这种微积分中，分数阶的导数是具有良定义的，而积分作为导数的逆运算，也可以有分数阶。 这听起来真是很神奇，而这一切都要归功于伽玛函数。

  ![n 维球的体积](https://uploads.cosx.org/2014/07/n-dim-ball.jpg)

伽马函数还有一个奇妙的运用是求高维空间中球的体积。我们知道 二维球是圆；其面积为 `$\pi r^2$`，三维球的体积为 `$\frac{4}{3} \pi r^3$`，那$n$维空间中半径为$r$的球的体积如何计算呢？ 数学上这个体积应该是如下多重积分
  
`$$ \displaystyle V_n(r) = \idotsint\limits_{ \tiny \{(x_1, \cdots, x_n) | \sum x_i^2 < r^2 \} } 1 \quad dx_1dx_2 \cdots dx_n $$`
  
可以证明
  
`$$ V_n(r) = \frac{\pi^{\frac{n}{2}} r^n}{\Gamma(\frac{n}{2} + 1)} .$$`

下面我们来说一说伽玛函数和数论的关系。 伽玛函数和欧拉常数`$\gamma$` 有密切关系，可以发现
  
`$$ \gamma = -\frac{d\Gamma(x)}{dx}|_{x=1} =
\lim_{n\rightarrow \infty}(1+\frac{1}{2} + \frac{1}{3}+\cdots+\frac{1}{n} – \log n) $$`
  
欧拉常数`$\gamma$` 是一个神奇的常数，数学家们至今也没搞清楚它是一个有理数还是一个无理数。进一步还可以发现伽玛函数和黎曼`$\zeta(s)$`函数
  
`$$ \zeta(s) = 1+\frac{1}{2^s} + \frac{1}{3^s} + \cdots $$`
  
有密切联系，黎曼发现了如下式子
  
`$$ \zeta(x) \Gamma(x) = \int_0^\infty \frac{u^{x-1}}{e^u – 1} du ,$$`
  
`$$ \zeta(x) = \zeta(1-x) \Gamma(1-x) 2^s \pi^{s-1} \sin\left(\frac{\pi x}{2}\right) .$$`
  
`$\zeta$` 函数在解析数论中可是有着举足轻重的地位，因为它涉及了数学中著名的素数分布定理和黎曼猜想，而以上两个式子在分析黎曼猜想过程中有重要作用。数学家蒙哥马利有一句名言：“假如你是一个魔鬼，引诱数学家用自己的灵魂来换取一个定理的证明。多数数学家会想要换取的会是什么定理呢，我想会是黎曼猜想。” 而希尔伯特曾说过，如果他在沉睡1000年后醒来, 他将问的第一个问题便是：黎曼猜想得到证明了吗？

前面提到了 `$\log\Gamma(x)$` 是一个凸函数。对这个函数求导得到的函数
  
`$$ \Psi(x) = \frac{d\log\Gamma(x)}{dx} $$`
  
被称为 Digamma 函数，可以证明
  
`$$\Psi(x) = -\gamma + (x-1) – \frac{(x-1)(x-2)}{2\cdot 2!}
 \frac{(x-1)(x-2)(x-3)}{3\cdot 3!} \cdots $$`
  
这也是一个很重要的函数，具有如下一个漂亮的性质
  
`$$ \Psi(x+1) = \Psi(x) + \frac{1}{x} .$$`
  
函数`$\Psi(x)$`和欧拉常数`$\gamma$` 以及 `$\zeta$` 函数都有密切关系，令
  
`$$ \Psi_n(x) = \frac{d^{n+1}\log\Gamma(x)}{dx^{n+1}} ,$$`
  
可以证明
  
`$$\Psi_1(x) = \frac{d^{2}\log\Gamma(x)}{dx^{2}}  
= \frac{1}{x^2} + \frac{1}{(x+1)^2} + \frac{1}{(x+2)^2} + \cdots .$$`
  
对于几个具体的数值，有如下漂亮的结果
  
`$$\Psi(1) = -\gamma, \quad \quad \Psi(2) = 1-\gamma $$` 

`$$\Psi_1(1) = \zeta(2) = 1 + \frac{1}{2^2} + \frac{1}{3^2} + \frac{1}{4^2} + \cdots
= \frac{\pi^2}{6} $$`

# 七、随机数学中的伽马函数

伽玛函数在概率统计中频繁现身，众多的统计分布，包括常见的统计学三大分布(`$t$` 分布，`$\chi^2$` 分布，`$F$` 分布)、贝塔分布、狄利克雷分布的密度公式中都有伽玛函数的身影。当然发生最直接联系的概率分布是直接由伽玛函数变换得到的伽玛分布。对伽玛函数的定义做一个变形，就可以得到如下式子
  
`$$ \int_0^{\infty} \frac{x^{\alpha-1}e^{-x}}{\Gamma(\alpha)}dx = 1 .$$`
  
于是，取积分中的函数作为概率密度，就得到一个形式最简单的伽玛分布的密度函数
  
`$$Gamma(x|\alpha) = \frac{x^{\alpha-1}e^{-x}}{\Gamma(\alpha)} .$$`
  
如果做一个变换 `$x=\beta t$`, 就得到伽玛分布的更一般的形式
  
`$$Gamma(t|\alpha, \beta) = \frac{\beta^\alpha t^{\alpha-1}e^{-\beta t}}{\Gamma(\alpha)} .$$`

  ![gamma-distribution](https://uploads.cosx.org/2014/07/gamma-distribution.png)

伽玛分布在概率统计领域也是一个万人迷，众多统计分布和它有密切关系。指数分布和 $\chi^2$ 分布都是特殊的伽玛分布。另外伽玛分布是一个很强大的先验分布，在贝叶斯统计分析中被广泛的用作其它分布的先验。如果把统计分布中的共轭关系类比为人类生活中的情侣关系的话，那指数分布、泊松分布、正态分布、对数正态分布都可以是伽玛分布的情人。

接下来的内容中我们主要关注`$\beta = 1$`的简单形式的伽玛分布。伽玛分布首先和泊松分布发生密切的联系。我们容易发现伽玛分布的概率密度和泊松分布在数学形式上具有高度的一致性。参数为`$\lambda$`的泊松分布，概率写为
  
`$$Poisson(X=k|\lambda) = \frac{\lambda^k e^{-\lambda}}{k!} $$`
  
在伽玛分布的密度中取 `$\alpha = k+1$` 得到
  
`$$ Gamma(\lambda|\alpha=k+1)  
= \frac{\lambda^ke^{-\lambda}}{\Gamma(k+1)}= \frac{\lambda^k e^{-\lambda}}{k!} $$`
  
所以这两个分布的数学形式具有高度的一致性，只是泊松分布是离散的，伽玛分布是连续的。这种数学上的一致性是偶然的吗？ 事实上，从泊松分布出发，可以利用一个简单的概率物理模型对伽玛分布的密度函数给出清晰的解释。

泊松分布可以用于描述一段时间内事件发生次数的统计性质，譬如接到的电话的次数。假设我们关心的不是一段有限的时间，而是 `$(0, \infty)$` 整个时间轴上接到电话的统计性质，应该如何来描述呢？我们可以假设接到的电话满足如下性质

  1. 概率在时间轴是独立均匀分布的，即每个等长的时间区间上是否接到电话是独立的，并且概率分布一样；每一个长度为h的充分小的时间片上接到一个电话的概率正比于时间片的长度；
  2. 每一个充分小时间片上最多只能接到一个电话。
  3. 平均而言，假设每个长度为1的单位时间片上接到电话个数是1；

如果我们考察 `$[0, \lambda]$` 这个时间区间，那么平均而言，这个长度为 `$\lambda$` 的时间片上应该接到 `$\lambda$` 个电话，把这个时间区间分成 $n$ 个独立的小片，那么每个时间片上接到一个电话的概率恰好是 `$p = \lambda/n$`。当$n$ 足够大的时候，每个时间片上只能是接到一个电话或者没有接到电话，恰好对应于成功概率为$p$ 的一个贝努利实验，于是$n$ 个时间片对应于$n$ 个独立的贝努利实验，所以 `$[0, \lambda]$`这个时间区间上接到的电话总数$X$ 应该符合二项分布
  
`$$p(X=k) = \binom{n}{k} p^k(1-p)^{n-k} .$$`
  
由于 `$np= \lambda$`, 于是 $n$ 趋向于无穷的时候，粒子个数$X$将满足参数为`$\lambda$` 的泊松分布
  
`$$p(X=k) = \frac{\lambda^k e^{-\lambda}}{k!} .$$`

熟悉随机过程理论的读者马上会发现以上模型实际上是参数为1 的泊松过程。 我们关心的问题是：什么时候会接到第`${k+1}$ `个电话？或者说接到第$k+1$ 个电话的时间点 `$Y_{k+1}$` 会是什么概率分布？ 形式化的描述就是如何计算如下的概率？
  
`$$ P(\lambda < Y_{k+1} \le \lambda + d\lambda) = ? $$`
  
上式表明第$k+1$ 个电话落在长度为 `$d\lambda$` 的区间 `$(\lambda, \lambda + d\lambda] $`内，这个概率事件可以分解为两个独立事件

  1. 区间 `$(\lambda, \lambda + d\lambda] $` 内接到一个电话，这个概率是 `$d \lambda$`
  2. 区间 `$[0, \lambda]$` 内接到了前$k$ 个电话，这个概率是 
  
  `$$ p(X=k) = \frac{\lambda^k e^{-\lambda}}{k!} .$$`

于是所求的概率是以上两个事件概率相乘，即
  
`$$ P(\lambda < Y_{k+1} \le \lambda + d\lambda) = p(X=k) \cdot d \lambda .$$`
  
由于第$k+1$ 个电话必然出现在时间轴上某处，所以把时间轴所有无穷小区间上的概率累加起来，正好对应于必然事件的概率1，所以有
  
`$$ \int_0^\infty p(X=k) \cdot d \lambda = 1 $$`

把`$P(X=k)$ `带入上式即可得到
  
`$$ \int_0^\infty \frac{\lambda^k e^{-\lambda}}{k!} d \lambda = 1 $$`
  
`$$ k! = \int_0^\infty \lambda^k e^{-\lambda} d \lambda $$`
  
上述两式整好就对应于伽玛分布和伽玛函数。所以`$Y_{k+1}$` 恰好符合伽玛分布。 我们其实从泊松分布出发，完全基于概率物理模型，推导出了伽玛函数，而推导的过程也同时给伽玛分布的密度函数提供了物理解释。

如果我们把伽玛函数和`$e^\lambda$`的泰勒展开式对照写成如下形式
  
`\begin{align} 
e^\lambda = \sum_{k=0}^{\infty} {\lambda^k \over k!} \\
k! = \int_0^{\infty} {\lambda^k \over e^\lambda}\ d\lambda.
\end{align}`
  
我们发现这两个式子形式上具有对偶关系。由于`$\sum$` 和`$\int$` 都表示求和， 几乎可以认为从第一个式子只是把 `$e^\lambda$` 和 `$k!$` 交换一下就得到了第二个式子。 这两个式子之间有更多的内在联系吗？事实上有如下一个奇妙的等式成立 

`\begin{equation} 
\label{gamma-e-taylor} \frac{1}{k!} \int_0^\lambda \frac{\lambda^k}{e^\lambda} d\lambda + \frac{1}{e^\lambda} \sum_{n=0}^k \frac{\lambda^n}{n!} = 1 
\end{equation}`
  
用上面描述的泊松过程的物理模型，可以很容易的证明这个等式。我们把数轴分成 `$(0, \lambda]$` 和 `$(\lambda, \infty)$` 这两个区间，考察第$k+1$ 个电话接到时间 `$Y_{k+1}$` 分别落在这两个区间的概率，当然有 `$$ P(Y_{k+1} \le \lambda) + P(Y_{k+1} > \lambda) = 1 $$`
  
按照上述的物理模型，显然第$k+1$ 个电话的时间落入`$(0, \lambda]$` 的概率为
  
`$$ P(Y_{k+1} \le \lambda) = \int_0^\lambda \frac{\lambda^k e^{-\lambda}}{k!} d \lambda $$`
  
如果第$k+1$ 个电话的时间点落入 `$(\lambda, \infty)$`，这个事件等价地可以理解为 `$(0, \lambda]$` 上的电话个数不能超过 $k$ 个，由于`$(0, \lambda]$` 这个有限时间区间上的电话次数符合参数为`$\lambda$` 的泊松分布， 所以这个概率为
  
`$$ P(Y_{k+1} > \lambda) = \sum_{n=0}^k \frac{\lambda^n e^{-\lambda} }{n!} $$`
  
所以我们得到
  
`\begin{equation}  
\label{poisson-gamma-dual}  
\int_0^\lambda \frac{\lambda^k e^{-\lambda}}{k!}d\lambda+\sum_{n=0}^k \frac{\lambda^n e^{-\lambda}}{n!} = 1  
\end{equation}`
  
这个式子俗称泊松-伽玛对偶，简单整理一下就是 \eqref{gamma-e-taylor} 式。

由于泊松分布可以看做是二项分布的极限分布，所以我们也可以从二项分布的角度对伽马分布进行解释。由于
  
`$$ e^{-\lambda} = \lim_{n\rightarrow \infty} (1- \frac{\lambda}{n}) ^n $$`
  
所以伽马分布的概率密度可以重写为
  
`\begin{align*}  
\frac{\lambda^k e^{-\lambda}}{k!}  
& = \lim_{n\rightarrow \infty} \frac{\lambda^k (1-\frac{\lambda}{n}) ^n}{k!} \\  
& = \lim_{n\rightarrow \infty} \frac{ n! n^k (\frac{\lambda}{n})^k (1-\frac{\lambda}{n}) ^n}{k! \cdot n!} \\ 
& = \lim_{n\rightarrow \infty} \frac{(n+k)!}{k!\cdot n!} (\frac{\lambda}{n})^k (1-\frac{\lambda}{n}) ^n \\  
& = \lim_{n\rightarrow \infty} \binom{n+k}{k} (\frac{\lambda}{n})^k (1-\frac{\lambda}{n}) ^n  
\end{align*}`
  
显然上式具有明确的二项分布的物理含义。事实上，二项分布和贝塔分布之间也存在完全类似\eqref{poisson-gamma-dual} 的一个等式：
  
`\begin{equation}
\label{binomial-beta-dual}
\frac{n!}{k!(n-k-1)!} \int_0^p t^k(1-t)^{n-k-1} dt + \sum_{v=0}^k \binom{n}{v} p^v(1-p)^{n-v} = 1  
\end{equation}`
  
如果我们知道`$n\rightarrow\infty$`时上式中二项分布的极限是泊松分布，而贝塔分布的极限是伽玛分布，那么就很容易理解 \eqref{poisson-gamma-dual} 其实可以看做是 \eqref{binomial-beta-dual} 的极限形式。

# 八、结语

作家海明威说：“冰山运动之雄伟壮观，是因为它只有八分之一在水面上。阶乘，这么一个简单的基于整数的数学概念，俨然是一座冰山，我们日常看到的只是它浮在水面上的一角。而数学家们眼光犀利，看出这座山并非只有整数的一角，他们逐步地深入挖掘探索，挖出了神奇的伽马函数，把深藏在冰山下的实数域、复数域、甚至有限域都给挖了出来。而挖掘出来的伽玛函数真是一个魔术师，它跨越了人们的直觉想象，使得许多数学概念能够神奇地从整数延拓到分数；而伽玛函数同时又在现代数学的各个分支中表演着自己的神奇技艺。有许多人认为数学的概念是静态的：这些数学概念产生于历史上某一个时刻，某一位数学大家之手，之后就几乎一成不变了。对于大多数非数学专业的人而言，这种感觉貌似很自然，毕竟普通读者所接触的几何、代数、微积分这些数学知识都已经体系成熟，存在了几百甚至上千年。 然而数学的发展其实是先有探索的阶段，然后才有逻辑与体系，只是我们的数学课本历来偏重后者而忽视前者。而如果我们对数学知识的探索过程有所了解的话，会发现这些探索也犹如冰山掩藏在水面之下的部分，甚至比露出的尖角还更具魅力。

台湾的数学教授蔡聪明先生在数学的科普传播方面写过大量的文章，他在《数学的发现趣谈》一书中对于数学的创造、发现与发展有一段精彩的论述：“如果你不知道一个定理（或公式）是怎样发现的，那么你对它并没有真正的了解，因为真正的了解必须从逻辑因果掌握到创造的心理因果。一个定理的诞生，基本上跟一粒种子在适当的土壤、风雨、阳光、气候 … 之下，发芽成一颗树，再开花结果，并没有两样。”本文尝试尽可能的呈现伽玛函数这颗数学之树的生长历程，可以说伽玛函数的种子最早是沃利斯播下的，欧拉给予了最好的施肥、灌溉使得种子发芽，而后来众多数学家们的努力使得这颗嫩芽茁壮成长，最终几乎成长为一颗参天大树。

伽玛函数这颗大树在现代数学中如此繁茂，笔者知识有限仅能描绘它很有限的一部分。这个函数在数学上魅力独特，不仅能够被一个理科本科生很好的理解，它本身又足够的深刻，具有很多漂亮的数学性质，历史上吸引了众多一流的数学家对它进行探索研究。美国数学家 Philip J.Davis 在1959年在《美国数学月刊》上发表了一篇很有名的介绍伽玛函数的文章，文中对伽玛函数一些特性发现的历史进行了详细的描述，这篇文章获得了 Chauvenet Prize (美国数学会颁发的数学科普奖)。 他在文中最后总结道：

> Each generation has found something of interest to say about the gamma function. Perhaps the next generation will also. (每一代人都发现了一些伽马函数的有趣性质，也许下一代人也会有所发现。)    
     

# 九、推荐阅读
  
如果希望了解更多阶乘研究以及伽玛函数相关的历史，推荐阅读如下文献：

  * 蔡聰明, 瓦里斯尋`$\pi$` 的發現理路,科学月刊, 27(4) 1996
  * 蔡聰明, 瓦里斯公式及其相關的結果,科学月刊, 27(5), 1996
  * 蔡聰明, 談 Stirling 公式, 数学传播 , 17(2), 1993
  * Philip J. Davis, Leonhard Euler’s Integral: A Historical Profile of the Gamma Function, The American Mathematical Monthly, vol. 66, pp. 849-869, 1959
  * Jacques Dutka, The Early History of the Factorial Function, Archive for History of Exact Sciences, 43 (3), pp. 225-249, 1991
  * Detlef Gronnau, Why is the gamma function so as it is?, Teaching Mathematics and Computer Science, 2003
  * Emil Artin, The Gamma function(English Traslation), Holt, Rinehart and Winston, Inc., 1964
  * George E. Andrews et al., Special Functions, Cambridge University Press, 2001
  * Ian Tweddle, James Stirling’s Methodus Differentialis: An Annotated Translation of Stirling’s Text, Springer, 2003

![flickering-logo](https://uploads.cosx.org/2014/07/flickering-logo.png)
