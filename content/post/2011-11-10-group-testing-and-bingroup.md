---
title: 分组检测方法和 binGroup 包
date: '2011-11-10T12:01:08+00:00'
author: COS编辑部
categories:
  - 数据分析
  - 生物与医学统计
  - 统计软件
  - 软件应用
tags:
  - binGroup包
  - R语言
  - 分组检测
  - 样本检测
slug: group-testing-and-bingroup
---

> 本文作者：张博安,University of Nebraska统计系在读博士

$\qquad$今天给大家介绍一下分组检测（group testing）方法和我们写的关于该方法的 R 包 **binGroup**。分组检测（又叫 pooled testing）主要用在样本检测当中，就是把一定数量的单个样本混合在一起，然后对混合样本（称为组；group）检测是否有某种特征。举一个例子，现在要检验 1000 个血液样本是否有艾滋病毒。如果对所有单个样本挨个检测（称为单体检测；individual testing），费时费力并且花费很大。如果我们把每四个单个样本混合，我们只需要对 250 个混合样本进行检测。对检验呈阳性的组，我们可以再对其中每个单个样本进行再检测。当具有所检测的特征样本比例比较小的时候，分组检测可以大幅减少检验的次数，从而节省时间和成本。因而分组检测在传染病监测（Gaydos, 2005），药物研发（Remlinger et al., 2006），基因分型（Chi et al., 2009）等各种有关样本检测的领域中都有成功和广泛的应用。

<h3 style="text-align: center;">
  1.均一总体（HOMOGENEOUS POPULATION）
</h3>

$\qquad$分组检测方法在很长一段时间里都只用在均一（homogeneous）的总体上。在这个总体里，我们假定所有个体都是独立的，并且具有所检测特征的概率均为 $p$。$p$ 称为该特征的总体流行率（overall prevalence）。把 $Y\_{ik}$ 记作在第 $k$ 组中样本 $i$ 的值，（$Y\_{ik}=0$ 表明该样本没有所检测的特征；$Y\_{ik}=1$ 表明该样本具有所检测的特征）。把 $I\_k$ 记做第 $k$ 组中样本个数（称为组大小；group size），则对于 $ i = 1,\dots, I\_k$，$k = 1,\dots, K$，$Y\_{ik}$ 是独立同分布的 Bernoulli(p) 随机变量。类似的，把 $Z\_k$ 记做第 $k$ 组的观测值（$\theta\_{k}=0$ 表明该组检测呈阴性，$\theta\_{k}=1$ 表明该组检测呈阳性），则对于 $k = 1,\dots, K$，$Z\_k$ 是 Bernoulli($\theta\_k$) 随机变量。我们的目的是估计 $p = P(Y\_{ik} = 1)$，但是因为 $Y\_{ik}$ 无法观测到，我们需要找出 $p$ 和 $Z\_k$ 间的关系。 假定所有检测是完美的，我们有 $\theta\_k=0 \Leftrightarrow \sum^{I\_k}\_{i=1}Y\_{ik}=0$ 和 $\theta\_k=1 \Leftrightarrow \sum^{I\_k}\_{i=1}Y\_{ik}>0$。则不难推出 $\theta\_k=P(Z\_k=1)=1-P(Z\_k=0)=1-(1-p)^{I\_k}$。又因为 $Z_k$ 是独立的 Bernoulli 随机变量，我们可以写出如下的似然函数：

<p style="text-align: center;">
  $L(p|z_1,\dots,z_k)=\sum^{K}_{k=1}[1-(1-P)^{I_k}]^{Z_k}(1-p)^{I_k(1-Z_k)}$
</p>

 再由MLE方法求得 $\widehat{p}$，并通过Fisher信息矩阵算出 $\widehat{p}$ 方差。我们写了两个 R 函数计算 $p$ 的置信区间。_bgtCI()_ 用来计算当所有组有相同大小时 $p$ 的置信区间。下面我们用一个例子说明如何使用 _bgtCI()_ 。刘沛等(1997)这篇论文研究了在我国徐州地区丙型肝炎的流行率。实验者把 1875 个献血者的血液样本每五个混合（组大小为 5），再用 ELISA 检验试剂对 375 个组进行检测。结果有 37 个组检验呈阳性。则徐州地区丙型肝炎的总体流行率 $p$ 的 95% 置信区间可以如下计算：

<pre class="brush: r">&gt; bgtCI(n = 375, y = 37, s = 5,
+  conf.level = 0.95,
+  alternative = "two.sided",
+  method = "AC") 

95 percent AC confidence interval:
 [ 0.01487, 0.02821 ]
Point estimate: 0.02056</pre>

这里我们使用了 Agresti-Coull 置信区间，因为它通常有很好的覆盖概率。还有一些其它的置信区间可供选择，譬如 Clopper-Pearson，Wilson 和 Wald 区间（覆盖概率最差）等。如果大家学过属性数据分析，相信对这些二项分布参数的置信区间 不陌生。在组大小相等的情况下，我们有 [latex\theta=P(Z_k=1)=1-(1-p)^l]$。我们先算出关于 $\theta$ 的置信区间，再通过以上变换求得 $p$ 的置信区间。关于这些区间在分组检测情况下的比较，请参看 Tebbs and Bilder (2004)。当各组组大小不等的时候，置信区间的计算就变得复杂许多。我们提供了 _bgtvs()_ 函数计算这种情形下的精确置信区间，这里就不详细介绍了。

$\qquad$分组检测实验中很重要的一个步骤就是选择合适的组大小。如果组太小，很少的混合样本会检测呈阳性，我们就浪费了检测试剂；如果组太大，那么大部分的混合样本会检测呈阳性，对 $p$ 的估计就会很差。一个凭经验的方法是选一个组大小使得差不多一半的组检测呈阳性。更精确的方法是，当我们对 $p$ 有一个初步估计，选一个组大小使得 MSE（均方误差）最小化（Swallow, 1985）。在这个例子中，假定我们初步估计 $p$ 为 0.025，并设定组大小的上界为 100，则 _estDesign()_ 函数可以计算出最佳的组大小是 61。

<pre class="brush: r">&gt; estDesign(n = 375, smax = 100, p.tr = 0.025)
group size s with minimal mse(p) = 61
$varp [1] 2.554086e-06 

$mse
[1] 2.560173e-06 

$bias
[1] 7.80204e-05 

$exp
[1] 0.02507802</pre>

当然，在实践中我们通常无法混合如此多个单个样本（阳性样本在被过度稀释后会检测呈阴性，称为稀释效应）。但是这个函数可以给我们选取组大小提供参考。对均一总体,我们的包中还包括以下函数：

  * _bgtTest()_: 计算对 p 假设检验的 p 值
  * _bgtPower()_: 计算对 p 假设检验的功效
  * _nDeisgn()_, _sDesign()_, _plot.bgtDesign()_: 当 n 或 s 变化时，计算假设检验的功效并作图。

这些函数可以帮助使用者设计自己的分组检测实验，这里我们就不一一介绍。

<h3 style="text-align: center;">
  2.非均一总体（HETEROGENEOUS POPULATION）
</h3>

$\qquad$在现实中均一总体的假设总显得不切实际。拿之前那个的例子来说，酗酒者，饮食卫生条件较差或卫生习惯不良者会比其他人得肝炎的几率较大，所以认为所有人有同样感染肝炎的风险是不合常理的。如果能搜集到每一个献血者个人信息的数据，我们希望建立一个关于肝炎的流行率的回归模型，使我们能通过各种相关的因素预测个人感染肝炎的概率。当然，这不是一个简单的 logistic 模型，因为在分组检测中我们无法收集到个人是否患病的数据。我们需要新的估计参数的方法。

$\qquad$我们仍然把 $Y\_{ik}$ 记做在第 $k$ 组中样本 $i$ 的值，则 $p\_{ik}=P(Y\_{ik}=1)$ 是该样本具有所检测的特征的概率。把可能影响此概率的 $p-1$ 个变量记做 $x\_{ik1}, x\_{ik2},\dots, x\_{ik,p-1}$，我们的回归模型是

<p style="text-align: center;">
  $f(p_{ik})=\beta_{0}+\beta_{1}x_{1ik}+\dots+\beta_{p-1}x_{p-1,ik}$
</p>

 其中 $f$ 是链接函数。对于 $i = 1, \dots, I\_k$， $k = 1,\dots, K$，$Y\_{ik}$ 是独立的 Bernoulli($p_{ik}$) 随机变量。目前主要有两种方法估计 。第一种方法是由 Vansteelandt et al. (2000)提出的。假定所有检测都是完美的，则不难推出

<p style="text-align: center;">
  $\theta_{k}=1-\sum^{I_k}_{i=1}(1-p_{ik})$
</p>

又因为 $Z_k$ 是独立的 Bernoulli 随机变量，我们可以写出如下的似然函数：

$L(\beta\_0,\dots,\beta\_{p-1}|Z\_1,\dots,Z\_k)$

$=\prod^{K}\_{k=1}(1-\prod^{I\_k}\_{i=1}(1-p\_{ik}))^{z\_K}(\prod^{I\_k}\_{i=1}(1-p\_{ik}))^{1-z_K}$

$=\prod^{K}\_{k=1}[1-\prod^{I\_k}\_{i=1}(1-f^{-1}(\beta\_0+\beta\_1x\_{1ik}+\dots+\beta\_{p-1}x\_{p-1,ik}))]^{Z_k}$

$\times [\prod^{I\_k}\_{i=1}(1-f^{-1}(\beta\_0+\beta\_1x\_{1ik}+\dots+\beta\_{p-1}x\_{p-1,ik}))]^{1-Z\_k}$

再由 MLE 估计 $\beta$。在包中我们是用 _optim_ 函数实现 MLE 估计的。这个方法浅显易懂，但是缺点是不够灵活。当我们对阳性组中单个样本再检测的时候，这些再检验的结果无法被包括在参数估计中。另外一种更灵活的方法是由 Xie (2001)提出的。假设我们有每个单个样本的值，则似然函数具有简单的二项分布的形式：

<p style="text-align: center;">
  $L(\beta_0,\dots,\beta_{p-1}|y_{11},\dots,y_{I_kK})=\prod^{K}_{k=1}\prod^{I_k}_{i=1}p^{y_{ik}}_{ik}(1-p_{ik})^{1-y_{ik}}$
</p>

&nbsp;

因为单个样本无法观测到，我们将上式中的每一个 $y\_{ik}$ 替换为 $E(Y\_{ik}|Z\_1=z\_1,\dots,Z\_k= z\_k)$，再利用 EM 算法估计 $\beta$。EM 算法是在参数估计中非常重要的方法，在处理缺失数据和隐性变量模型等领域应用广泛。有关 EM 算法的简介，可以参看 Casella and Berger (2001, p. 326 – 329)。对我们的问题，EM 算法由下面给出：

1. E-step：计算$\widehat{w}\_{ik}=E(Y\_{ik}|Z\_1=z\_1,\dots,Z\_k=z\_k)$
  
2. M-Step：找出β使得以下似然函数的条件期望最大化（其中 $p\_{ik}$ 是 $\beta$ 的函数）$E[log(L(\beta|y\_{11},\dots,y\_{I\_kK}))|Z\_1=z\_1,\dots,Z\_k=z\_k]=\sum^{K}\_{k=1}\sum^{I\_k}\_{i=1}\widehat{w}\_{ik}log(p\_{ik})+(1-\widehat{w}\_{ik})log(1-p_{ik})$
  
3. 重复步骤1和2直到 $|(\widehat{\beta}^{(r)}\_d-\widehat{\beta}^{(r-1)}\_d)/\widehat{\beta}^{(r-1)}_d|<\epsilon$。其中$\widehat{\beta}^{(r)}$是$\beta$的第r次估计，$\epsilon > 0$

$\beta$ 的方差可以由 Louis’formula 得到。该方法的优点是非常灵活，可容纳对单个样本再检验，以及应用在如阵列分组(matrix or array-based pooling, Phatarfod and Sudbury, 1994; Kim et al., 2007)等更复杂的分组检测的场合。在我们的包中，gtreg 函数用来拟合分组检测回归模型。在使用时，我们可以指定检验的敏感性(sensitivity)和特异性(specificity)（在以上的介绍中，为简单起见，我们没有讨论检测有误差的情形），分组编号，参数估计的方法（Vansteelandt 或 Xie）等。如果我们要包含对单个样本再检验结果，则只能使用 Xie 方法；除此以外，两种方法应给出非常相似的结果。

$\qquad$我们用 Vansteelandt et al. (2000)中的一个例子来说明如何使用 _gtreg_ 函数。数据来自一项对肯尼亚偏远地区怀孕妇女 HIV 感染率监测的研究，研究者收集了所有怀孕妇女的个人信息，这里我们选取年龄和教育水平两项变量预测每位妇女感染 HIV 的概率。数据的最后几行如下：

<pre class="brush: r">&gt; data(hivsurv)
&gt; tail(hivsurv[,c(3,5,6:8)], n = 7)
    AGE EDUC. HIV gnum groupres
422  29     3   1   85        1
423  17     2   0   85        1
424  18     2   0   85        1
425  18     2   0   85        1
426  22     3   0   86        0
427  30     2   0   86        0
428  34     3   0   86        0</pre>

可以看到每一组中单个样本都有同样的分组编号（gnum)和）值（groupres）.例如第 422 个样本是 HIV 阳性，所以在第 85 组中的所有样本都有 “1” 的组值。这组数据中也包括单体检测的数据（HIV），因为实验者希望证实分组检测在节约大量的成本的同时可以得到和单体检测几乎一样好的估计。现在我们就用 _gtreg_ 函数拟合数据，并用包中的 _summary_ 函数给出总结性的输出。

<pre class="brush: r">&gt; fit1  summary(fit1)

Call:
gtreg(formula = groupres ~ AGE + EDUC., data = hivsurv, groupn = gnum,
    sens = 0.99, spec = 0.95, linkf = "logit", method = "Vansteelandt") 

Deviance Residuals:
    Min       1Q   Median       3Q      Max
-1.1813  -0.9385  -0.8221   1.3297   1.6694   

Coefficients:
            Estimate Std. Error z value Pr(&gt;|z|)
(Intercept) -2.99039    1.59911  -1.870   0.0615 .
AGE         -0.05163    0.06748  -0.765   0.4443
EDUC.        0.73621    0.43885   1.678   0.0934 .
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

    Null deviance: 191.4  on 85  degrees of freedom
Residual deviance: 109.4  on 83  degrees of freedom
AIC: 115.4 

Number of iterations in optim(): 138</pre>

拟合的结果存放在 fit1 中，我们定义它为“gt” class。得到的模型可以写成

<p style="text-align: center;">
  $logit(\widehat{p}_{ik})=-2.99-0.0516Age_{ik}+0.7362Educ_{ik}$
</p>

其中 $\widehat{p}_{ik}$ 是第 $k$ 组中第 $i$ 个样本 HIV 阳性的概率的估计。

$\qquad$在 **binGroup** 包中还包括一些其他函数。如 _sim.gt_ 产生分组检测数据，_predict.gt_ 根据参数的估计值预测 $p_{ik}$ 等。_gtreg.mp_ 函数适用于在基因分型领域有非常重要应用的阵列分组。在这类实验中，所有单个样本被放在一个或多个阵列的方格中（例如 $n^2$ 个样本就分配到 $n \times n$ 个方格里）， 然后将每一行的样本作为一组,每一列的样本作为一组检测。如果某一行和某一列检测呈阳性，则在它们交叉的位置的单个样本很可能具有所检测的特征。这种分组方式特别之处在于每个单个样本同时出现在所在行和所在列的组中，所以 Vansteelandt 方法无法应对这种分组方式。而对 Xie 方法，我们只需把所有行的观测值，列的观测值作为已知信息包含在 E-step 中的条件期望，就可通过 EM 算法求得参数估计。

$\qquad$值得一提的是，在很多分组检测的的场合（如对单个样本再检验，阵列分组等），E-step 中的条件期望很难求出，或者没有解析表达，这种情况下我们可以使用 Gibbs sampling 方法估计条件期望。Gibbs sampling（可以参看 Carlin and Louis, 2008, Section 3.4.1）方法是 Metropolis-Hastings 算法的一个特例。简单来说，当多个变量的联合概率分布不明确，而各个变量的条件分布已知的时候，Gibbs sampling 根据其他变量的当前值，依次对分布的每个变量生成一个样本，最后建立一个马尔可夫链，其平衡分布就是这多个变量的联合分布。为叙述方便，我们把所有单个样本的值重新标记为 $Y\_1,\dots, Y\_N$，把所有可观测到的变量（所有组值，再检验结果等）记作 $T$。因为 $Y\_1,\dots, Y\_N|T=t$ 的分布很难求出，而对每一个 $i$，条件分布 $Y\_i|Y\_s=y\_s,s \ne i,T=t$ 则容易求得，所以我们可以生成 Gibbs 样本 $y^{\*}\_i \sim f(Y\_i|Y\_s=y\_s,s \ne i,T=t)$。在 $N$ 个单个样本中循环 $K$ 次($K$ 通常很大)后，我们得到一个 Monte Carlo Markov Chain 并且 $(y^{\*}\_1,\dots,y^{\*}\_N)$ 的联合分布收敛到 $Y\_1,\dots, Y\_N|T=t$。现在我们可以用 $\sum y^{\*}\_i/K$ 估计 $\widehat{w}\_i=E(Y\_i|T=t)$ ，其中 $\sum$ 是对所有 $K$ 个 Gibbs 样本求和。这时的 EM 算法称作 Monte Carlo Expected Maximization(MCEM)算法。当然，因为在每个 E-step 中我们要产生大量的 Gibbs 样本，这种方法通常较慢。

$\qquad$以上向大家简单介绍了分组检测的一些方法及其在 R 中的实现。我们这里只讨论了分组检测中参数估计的问题。还有很多方法(参看 Bilder, Tebbs, and Chen, 2010)专注于如何通过再检验最快找出所有 $Y\_{ik}=1$ 的样本，这些方法反过来也依赖于我们估计的 $\widehat{p}\_{ik}$（在阳性组中优先再检验 $\widehat{p}_{ik}$ 大的样本）。如果你的工作中能用到这些方法，欢迎你使用我们的 **binGroup** 包以及向我咨询；如果和你的工作没有直接的联系，我们的模型和 R 程序也涉及了统计学中一些热门的方法，希望能对大家有所帮助和启发。

下载本文PDF文档： [分组检测方法和binGroup包](https://cos.name/wp-content/uploads/2011/11/分组检测方法和binGroup包.pdf)
