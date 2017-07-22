---
title: 从统计学角度来看深度学习（3）：记忆和核方法
date: '2015-06-25T12:49:15+00:00'
author: Shakir Mohamed
categories:
  - 推荐文章
  - 统计之都
tags:
  - Fisher
  - 机器学习
  - 神经网络
slug: a-statistical-view-of-deep-learning-iii-memory-and-kernels
forum_id: 419087
meta_extra: "译者：丁维悦；审校：朱雪宁、何通、施涛；编辑：王小宁"
---

原文链接：<http://blog.shakirm.com/2015/04/a-statistical-view-of-deep-learning-iii-memory-and-kernels/>

作者：[Shakir Mohamed](http://www.shakirm.com/)

![methodTriangle1-300x300](https://uploads.cosx.org/2015/06/methodTriangle1-300x300.png)

<p style="text-align:center">连接机器学习的回归方法</p>

人们通过对以往的经验或者数据的回忆来推断未来的事物，这样的过程可以用一个经常出现在最近文献中的词语——记忆来概括。机器学习模型都是由这样的‘记忆’组成的，如何理解这些‘记忆’对于如何使用模型是极为重要的。根据机器学习模型的种类，可以分为两种主要的记忆机制，即参数型与非参数型（还包括了介于两者之间的模型）。深度网络作为参数记忆型模型的代表，它将统计特性从所观察到的数据中以模型参数或者权重的方式提炼出来。而非参数模型中的典范则是核机器（以及最近邻），它们的记忆机制是存储所有数据。我们可以自然地认为，深度网络与核机器是两种原理不同的由数据推导结论的方法，但是实际上，我们研究出这些方法的过程却表明它们之间有着更加深远的联系以及更基本的相似性。

深度网络、核机器以及高斯过程三者形成了解决相同问题的一套连贯的方法。它们的最终形式很不相同，但是它们本质上却是相互联系的。了解这一点对于更深入的研究十分有用，而这种联系正是这篇文章将要探讨的。
<!--more-->

# 基函数与神经网络

在这篇文章里主要讨论回归问题，即学习判别模型或者输入输出的映射关系。这些方法扩展了看似简单的线性模型。一个线性模型假设在输入数据X或其变换`$\varphi(x)$`之上做的线性组合能够解释目标值`$y$`。这里的变换`$\varphi(x)$`是一个基函数，它将数据转换为更有解释性的特征集合，例如在过去十分流行的对于图像的尺度不变特征变换（[SIFT](https://en.wikipedia.org/wiki/Scale-invariant_feature_transform)）以及音频的美尔倒频谱系数（[MFCC](https://en.wikipedia.org/wiki/Mel-frequency_cepstrum)）。在这些例子中，基函数是固定的，因此我们仍旧采用的是线性回归。而神经网络让我们能够使用自适应的基函数，我们可以通过对数据的学习找出更好的特征，而不必进行人为地设计。不仅如此，神经网络还可以构建非线性回归模型。

从概率的角度而言，回归模型往往被分为两部分：系统性部分以及随机性部分。其中系统性部分是我们希望学习到的函数f，而观测值则是这个函数在噪声干扰下的所得值。为了将神经网络与线性模型更好的联系在一起，我们在此将神经网络最后的线性层与之前的其他层分开。于是对于一个L层的深度神经网络，我们用一个含有参数`$\theta$`的映射`$\varphi(x;\theta)$`代表前L-1层的映射结果，同时赋予最后一层权重`$w$`，此模型的参数空间为`$q=\{\theta,w\}$`。

`$$\textrm{系统性部分: } \quad f = \mathbf{w}^\top \phi(\mathbf{x}; \theta) \qquad \mathbf{q}\sim \mathcal{N}(0,\sigma_q^2 \mathbf{I}),$$`

`$$\textrm{随机性部分: } \quad y = f(\mathbf{x}) + \epsilon \qquad \epsilon \sim \mathcal{N}(0, \sigma_y^2)$$`

有了明确的概率模型，就意味着我们有了一个可以进行参数优化的目标函数，而这个目标函数是通过对该模型的联合概率分布函数取负对数而得到的。我们现在可以在神经网络中采用最大后验估计，并通过反向传播算法获得所有的模型参数。“记忆”会通过这个模型的参数建模框架而被保留下来。因此我们并不存储数据，而是简洁的用模型的参数去概括它。这种形式有着很好的性质：我们可以将数据的特性都嵌入到函数f中，例如对2D图像采用卷积运算进行特征的提取，同时我们也可以利用其可扩展性做一个随机近似，不仅如此，我们在采用梯度下降算法时还可以只选取一小批数据而不是所有数据。可以看出，损失函数可以让我们将神经网络很好的扩展到其他类型的回归中，因此它对于输出权重的准确度而言是举足轻重的。

`$$J(\mathbf{w}) = \frac{1}{2} \sum_{n=1}^{N} (y_n – \mathbf{w}^\top \phi(\mathbf{x}_n; \theta))^2 + \frac{\lambda}{2 }\mathbf{w}^\top\mathbf{w}.$$`

# 核方法

如果我们多瞄一眼最后的那个目标函数，尤其是代表最后线性层的式子，就会很快的写出它的对偶函数。就让我们通过令该目标函数对w求导后的式子为0并求解的方式来找到其对偶形式吧。

`$$\nabla J(\mathbf{w}) = 0 \implies \mathbf{w} = \frac{1}{\lambda} \sum_n (y_n – \mathbf{w}^\top \phi(\mathbf{x}_n))\phi(\mathbf{x}_n)$$`

`$$\mathbf{w} =\sum_n \alpha_n\phi(\mathbf{x}_n) = \boldsymbol{\Phi}^\top \boldsymbol{\alpha} \qquad \alpha_n = -\frac{1}{\lambda}(\mathbf{w}^\top \phi(\mathbf{x}_n) – y_n)$$`

我们将所有的关于观测值的基函数（特征）整合到了矩阵`$\Phi(x)$`中。将最后一层参数的解代入到损失函数中，我们就得到了由新参数`$\alpha$`构成的对偶损失函数，以及涉及矩阵相乘的格拉姆矩阵（Gram Matrix）`$K=\Phi\Phi^{\top}$`。我们可以重复之前求导的过程并解得使对偶损失函数最小的优化参数`$\alpha$`如下:

`$$\nabla J(\mathbf{\boldsymbol{\alpha}}) = 0 \implies \boldsymbol{\alpha} = (\mathbf{K} + \lambda \mathbf{I}_N)^{-1} \mathbf{y}$$`
  
以上正是核机器（Kernel Machines）与神经网络分道扬镳的地方。由于我们仅仅需要考虑特征`$\varphi(x)$`的内积K，而不是采用深度网络的非线性映射进行参数化地概括，所以我们可采用核替代（kernel substitution）的方法，即选择一个合适的核函数`$k(x,x^{\top})$`来进行计算。这说明了深度网络与核机器之间具有很深刻的联系：它们不仅仅是相关的，它们是互为对偶的。

这时的记忆机制已经完全转换为非参数型的了，也就是说通过核矩阵K我们现在显示地刻画了所有样本点。核方法的优势就在于我们能更容易的获得具有我们期望性质的函数，例如具有p阶可微的函数或者周期函数，而这些性质是不太可能通过随机逼近得到的。测试数据`$x^{\star}$`的预测值也可以用一些不一样的方式写出：

`$$f =\mathbf{w}_{MAP}^\top \phi(\mathbf{x}^*) = \boldsymbol{\alpha}^\top \boldsymbol{\Phi}(\mathbf{x}) \phi(\mathbf{x}^*) = \sum_n \alpha_n k(\mathbf{x^*, x}_n) = k(\mathbf{X, x}^*)^\top (\mathbf{K} + \lambda\mathbf{I})^{-1} \mathbf{y}$$`
  
最后一个等式是由表示定理（[Representer theorem](http://en.wikipedia.org/wiki/Representer_theorem)）得出的解。这让我们从另一个视角定义这个问题，即直接对我们想要估计的函数加惩罚项，并限定该函数属于希尔伯特空间中（一个直接的非参数视角）：

`$$J(f) =\frac{1}{2} \sum_{n=1}^{N} (y_n – f(\mathbf{x}_n))^2 + \frac{\lambda}{2 }\| f\|^2_{\mathcal{H}}.$$`
  
# 高斯过程

我们可以更进一步，不仅考虑函数f的最大后验估计，也考虑它的方差。为此我们必须定义一个与目标函数有着相同损失函数的概率模型。这是可行的，因为我们知道如何选取合适的先验分布，并且这个概率模型正是与高斯过程回归：

`$$p(f) = \mathcal{N}(\mathbf{0}, \mathbf{K}) \qquad p(y | f) = \mathcal{N}(y | f, \lambda)$$`
  
我们现在我们可以采用一些在条件高斯分布下常用的做法来得到任意预测样本x的均值与方差：

`$$p(f^* | \mathbf{X, y, x^*}) = \mathcal{N}(\mathbb{E}[f^*] ,\mathbb{V}[f^*])$$`

`$$\mathbb{E}[f^*] = k(\mathbf{X, x}^*)^\top (\mathbf{K} + \lambda \mathbf{I})^{-1} \mathbf{y}$$`

`$$\mathbb{V}[f^*] =k(\mathbf{x^*, x^*}) -k(\mathbf{X, x}^*)^\top (\mathbf{K} + \lambda \mathbf{I})^{-1}k(\mathbf{X, x}^*)$$`
  
# 总结

无论是核方法还是高斯方法都能让我们很便利地得到一致的预测样本均值。我们现在也可以求出目标函数的方差，这对很多问题而言都是很有用的，比如主动学习(active learning)与优化探索(optimistic exploration)。由于刻画问题的机制与核机器一样，所以高斯过程中的记忆也是非参数类型的。高斯过程将核方法与神经网络之间很好地连接了起来：我们可以通过对核机器采用贝叶斯推断，或是将一个单层神经网络的隐藏层结点数设为无穷的方式而导出高斯过程。

对如何尽可能的得到一个好的回归方程这一问题，深度神经网络、核方法以及高斯过程是三种不同的方法。它们之间有着深刻的联系：我们可以从任意一个模型出发推导出另外两个，并且让我们将这些表面上对立的方法进行统一。我认为这样的联系是十分有意义的，对于后续建立更加强大且有说服力的分类以及回归模型也是十分重要的。

# 参考文献

[1] Christopher M Bishop, Pattern recognition and machine learning, 2006

[2] Carl Edward Rasmussen, Gaussian processes for machine learning, 2006

[3] Radford M Neal, Bayesian Learning for Neural Networks, 1994
