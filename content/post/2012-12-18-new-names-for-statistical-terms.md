---
title: '[译作]一些统计名词的新名字'
date: '2012-12-18T16:31:43+00:00'
author: Larry Wasserman
categories:
  - 统计之都
slug: new-names-for-statistical-terms
forum_id: 418892
meta_extra: "译者：陈丽云"
---

原文载于卡耐基梅隆大学统计系教授Larry Wasserman的博客：[Normal Deviate](http://normaldeviate.wordpress.com/2012/12/16/new-names-for-statistical-methods/)

有没有觉得很多统计学家实在是想象力有限——是时候把那些迂腐无趣的名字踢出历史了！看看这些如何？

**贝叶斯推断**：虽然贝叶斯当年确实用他那个著名的定理来做了一些计算…但明明是拉普拉斯搞出来的系统推断好不好！
  
新名字：**拉普拉斯推断**

**贝叶斯网络**：一个有向无环图加上了一些概率分布就可以跟贝叶斯推断扯上亲戚了？或者应该叫拉普拉斯推断？维基百科明明告诉你，这只是Judea Pearl无聊时候臆想出来的名字… <!--more-->
  
新名字：**珀尔图**

**贝叶斯分类规则**：给定{(X,Y)}，其中Y是0-1变量，最佳的分类器就当P(Y=1|X=x)>1/2的时候猜Y=1，或者P(Y=1|X=x)< 1/2的时候猜Y=0。这个和贝叶斯规则听起来经常会混淆是不是？其实这个规则有点黄金标准的味道，不如改叫：
  
新名字：**黄金律**

**无偏估计量**：总是听起来很厉害的感觉…
  
新名字：**均值中心化的估计量**

**可信集**：只是一个拥有特定后验概率的集合——比如这是一个95%可信集。或许一个更奇妙的名字是：
  
新名字：**不可思议集**（原文为Incredible Set，大家自行体悟英文意思吧）

**置信区间**：本来想说“均一频率覆盖集”，不过听起来有点拗口…那么短一点，就叫：
  
新名字：**覆盖集**

**自助法(Bootstrap)**:如果我没记错的话，当时John Tukey给Brad Efron建议的是“猎枪(shotgun)”。Brad,你就不能听Tukey一回嘛!
  
新名字:**猎枪**

**因果推断**:有没有曾几何时causal和casual傻傻分不清楚？有些人说这东西还是叫做“实验效果分析”，但是听起来一点也不让人兴奋。依我说，这东西就应该叫：
  
新名字：**正式推断（Formal Inference）**
    
**中心极限定理**：多无趣的名字呀！联想到它的历史，我觉得还是叫：
  
新名字：**棣莫弗定理**

**大数定律**：又是一个超级无爱的名字！还是，为了表示对历史的尊敬，这东西应该叫：
  
新名字：**白努力定理（伯努利定理）**

**最小方差无偏估计量**：我们还是把它踢出去吧！

**Lasso**：Rob你起的名字不错呀！不过人们根本看不出来它是干啥的。看看这个怎么样？
  
新名字： **泰瑟枪（Taser，Tibshirani’s Awesome Sparse Estimator for regression）**

**斯蒂格勒的得名由来定律（Stigler’s law of eponymy）**：如果你觉得不知所云…还是[去维基百科查查吧](http://en.wikipedia.org/wiki/Stigler%27s_law_of_eponymy)。它会告诉你，其实这东西应该叫：
  
新名字：**斯蒂格勒的得名由来定律**（小编表示看完wiki后已无力吐槽-_-||）

**神经网络**：还是名副其实一点吧…
  
新名字：**非线性回归**

**p值**：有没有觉得这名字挺烂的？我能想到的最好名字大概是：
  
新名字：**费歇尔统计量（Fisher Statistic）**

**支持向量机**：可以提名为“史上最差命名”了！有没有觉得像什么工厂里面冷冰冰的机器？我想还是叫：
  
新名字：**瓦普尼克分类器（Vapnik Classifier）**

**U-统计量**：显然它就是：
  
新名字：**i统计量**（小编表示基本不解…）

**核**：统计学中，这东西指的是局部平滑的方法，比如核密度估计和Nadaraya-Watson核回归。有些人也用“Parzen Window”——你家在重新装修么？机器学习中，它指的是Mercer核（再生核希尔伯特空间中的一部分）。我们还是稍稍区分一下吧：
  
新名字：**分别叫做平滑核、Mercer核**

**再生核希尔伯特空间（Reproducing Kernel Hilbert Space）**：念完了瞬间觉得喘不上气来了…而缩写为RKHS也不怎么优雅。叫它Aronszajn-Bergman空间吧也不怎么顺口。这个怎么样？
  
新名字：**Mercer空间**

没有比0更常用的常量了…鉴于这东西还没有人命名过，我决定把自己载入史册：
  
新名字：**Wasserman 常量.**

原文附下：

> Bayesian Inference. Bayes did use his famous theorem to do a calculation. But it was really Laplace who systematically used Bayes’ theorem for inference.
>  
> New Name: Laplacian Inference.
> 
> 
> Bayesian Nets. A Bayes nets is just a directed acyclic graph endowed with probability distribution. This has nothing to do with Bayesian — oops, I mean Laplacian — inference. According to Wikipedia, it was Judea Pearl who came up with the name.
> 
> New Name: Pearl Graph.
> 
> 
> The Bayes Classification Rule. Give {(X,Y)}, with {Yin {0,1}}, the optimal classifier is to guess that {Y=1} when {P(Y=1|X=x)geq 1/2} and to guess that {Y=0} when {P(Y=1|X=x)< 1/2}. This is often called the Bayes rule. This is confusing for many reasons. Since this rule is a sort of gold standard how about:
> 
> New Name: The Golden Rule.
> 
> 
> Unbiased Estimator. Talk about a name that promises more than it delivers.
  
> New Name: Mean Centered Estimator.
> 
> 
> Credible Set. This is a set with a specified posterior probability content such as: here is a 95 percent credible set. Might as well make it sound more exciting.
> 
> New Name: Incredible Set.
> 
> 
> Confidence Interval. I am tempted to suggest “Uniform Frequency Coverage Set” but that’s clumsy. However it does yield a good acronym if you permute the letter a bit.
>  
> New Name: Coverage Set.
> 
> 
> The Bootstrap. If I remember correctly, Brad Efron considered several names and John Tukey suggested “the shotgun.” Brad, you should have listened to Tukey.
>  
> New Name: The Shotgun.
> 
> 
> Causal Inference. For some reason, whenever I try to type “causal” I end up typing “casual.” Anyway, the mere mention of causation upsets some people. Some people call causal inference “the analysis of treatment effects” but that’s boring. I suggest we go with the opposite of casual:
>  
> New Name: Formal Inference.
> 
> 
> The Central Limit Theorem. Boring! For historical reasons I suggest:
>  
> de Moivre’s Theorem.
> 
> The Law of Large Numbers. Another boring name. Again, to respect history I suggest:
>  
> New Name: Bernoulli’s Theorem.
> 
> 
> Minimum Variance Unbiased Estimator. Let’s just eliminate this one.
> 
> The lasso. Nice try Rob, but most people don’t even know what it stands for. How about this:
>  
> New Name: the Taser. (Tibshirani’s Awesome Sparse Estimator for regression).
> 
> 
> Stigler’s law of eponymy. If you don’t know what this is, check it out on Wikipedia. The you’ll understand why it name should be:
> 
> New Name: Stigler’s law of eponymy.
> 
> 
> Neural nets. Let’s call them what they are.
>  
> (Not so) New name: Nonlinear regression.
> 
> p-values. I hope you’ll agree that this is a less than inspiring name. The best I can come up with is:
>
> New Name: Fisher Statistic.
> 
> 
> Support Vector Machines. This might get the award for the worst name ever. Sounds like some industrial device in a factory. >Since we already like the acronym VC, I suggest: 
> New Name: Vapnik Classifier.
> 
> 
> U-statistic. I think this one is obvious. 
>
> New Name: iStatistic.
> 
> 
> Kernels. In statistics, this refers to a type of local smoothing, such as kernel density estimation and Nadaraya-Watson kernel regression. Some people use “Parzen Window” which sounds like something you buy when remodeling your house. But in Machine Learning it is used to refer to Mercer kernels with play a part in Reproducing Kernel Hilbert Spaces. We don’t really need new names we just need to clarify how we use the terms:
>  
> New Usage: Smoothing Kernels for density estimators etc. Mercer kernels for kernels that generate a RKHS.
> 
> 
> Reproducing Kernel Hilbert Space. Saying this phrase is exhausting. The acronym RKHS is not much better. If we used history as a guide we’d say Aronszajn-Bergman space but that’s just as clumsy. How about:
>  
> New Name: Mercer Space.
> 
> 
> No constant is used more than 0. Since no one else has ever names it, this is my chance for a place in history.
>  
> New Name: Wasserman’s Constant.
