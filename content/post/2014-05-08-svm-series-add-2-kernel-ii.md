---
title: '“支持向量机系列”的番外篇二: Kernel II'
date: '2014-05-08T17:42:55+00:00'
author: 张驰原
categories:
  - 推荐文章
  - 数据挖掘与机器学习
tags:
  - kernel
  - 支持向量机
  - 机器学习
slug: svm-series-add-2-kernel-ii
forum_id: 419018
---

原文链接请点击[这里](http://blog.pluskid.org/?p=723)

在之前我们介绍了如何[用 Kernel 方法来将线性 SVM 进行推广以使其能够处理非线性的情况](/2014/02/svm-series-3-kernel/)，那里用到的方法就是通过一个非线性映射 `$\phi(\cdot)$`将原始数据进行映射，使得原来的非线性问题在映射之后的空间中变成线性的问题。然后我们利用核函数来简化计算，使得这样的方法在实际中变得可行。不过，从线性到非线性的推广我们并没有把 SVM 的式子从头推导一遍，而只是直接把最终得到的分类函数

`$$
f(x) = \sum_{i=1}^n\alpha_i y_i \langle x_i, x\rangle + b
$$`

![infinity](https://uploads.cosx.org/2014/05/infinity.png) 

中的内积换成了映射后的空间中的内积，并进一步带入了核函数进行计算。如果映射过后的空间是有限维的，那么这样的做法是可行的，因为之前的推导过程会一模一样，只是特征空间的维度变化了而已，相当于做了一些预处理。但是如果映射后的空间是无限维的，还能不能这么做呢？答案当然是能，因为我们已经在这么做了嘛！但是理由却并不是理所当然的，从有限到无限的推广许多地方都可以“直观地”类比，但是这样的直观性仍然需要严格的数学背景来支持，否则就会在一些微妙的地方出现一些奇怪的“悖论”（例如比较经典的芝诺的那些悖论）。当然这是一个很大的坑，没法填，所以这次我们只是来浮光掠影地看一看核方法背后的故事。<!--more-->

回忆一下原来我们做的非线性映射`$\phi$`，它将原始特征空间中的数据点映射到另一个高维空间中，之前我们没有提过，其实这个高维空间在这里有一个华丽的名字——“再生核希尔伯特空间 (Reproducing Kernel Hilbert Space, RKHS)”。“再生核”就是指的我们用于计算内积的核函数，再说“再生”之前，我们先来简单地介绍一下 [Hilbert Space](http://en.wikipedia.org/wiki/Hilbert_space) ，它其实是欧氏空间的一个推广。首先从基本的向量空间开始，空间中的点具有加法和数乘的操作，在这个向量空间上定义一个内积操作，于是空间将升级为[内积空间](http://en.wikipedia.org/wiki/Inner_product_space)。根据内积可以定义一个范数：

`$$
\|x\|^2=\langle x, x\rangle
$$`

从而成为一个[赋范向量空间](http://en.wikipedia.org/wiki/Normed_space)。范数可以用于定义一个度量

`$$
d(x_1,x_2) = \|x_1-x_2\|
$$`

从而成为一个[度量空间](http://en.wikipedia.org/wiki/Metric_space)。如果这样的空间在这个度量下是[完备的](http://en.wikipedia.org/wiki/Complete_metric_space)，那么这个空间叫做 Hilbert Space 。简单地来说，Hilbert Space 就是完备的内积空间。最简单的例子就是欧氏空间`$\mathbb{R}^m$`，这是一个`$m$`维的 Hilbert Space ，无穷维的例子比如是区间`$[a,b]$`上的连续函数所组成的空间，并使用如下的内积定义

`$$
\langle f_1,f_2\rangle = \int_a^bf_1(t)f_2(t)dt
$$`

我们这里的 RKHS 就是一个函数空间。实际上，在这里我们有一个很有用的性质，就是维度相同的 Hilbert Space 是互相同构的——也就是说空间的各种结构（包括内积、范数、度量和向量运算等）都可以在不同的空间之间转换的时候得到保持。有了这样的性质，就可以让我们不用去关心 RKHS 中的点到底是什么。

将映射记为`$\phi:\mathcal{X}\rightarrow \mathcal{H}$`，这里`$\mathcal{H}$`表示 RKHS，用`$f$`表示里面的元素 ；而`$\mathcal{X}$`是原始特征空间，这里我们甚至不需要要求原始空间必须要是一个欧氏空间或者向量空间（这也是核方法的优点之一），用`$x$`表示里面的点。由于刚才说了`$\mathcal{H}$`中点的本质是什么对于我们的计算不会产生影响，所以我们可以人为地认为这些点“是什么”——更确切地说，我们认为（或者说定义）`$\mathcal{H}$`中的点是定义在 `$\mathcal{X}$`上的函数，在一定的条件下（详见 N. Aronszajn, Theory of Reproducing Kernels），我们可以找到对应于这个 Hilbert Space 的一个（唯一的）再生核函数（Reproducing Kernel）`$K: \mathcal{X}\times\mathcal{X}\rightarrow \mathbb{R}$`（这里只考虑实函数），满足如下两条性质：

  1. 对于任意固定的 `$x_0\in\mathcal{X}$`，`$K(x,x_0)$`作为`$x$`的函数属于我们的函数空间`$\mathcal{H}$`。
  1. 对于任意`$x\in\mathcal{X}$`和`$f(\cdot)\in\mathcal{H}$`，我们有`$f(x) = \langle f(\cdot),K(\cdot,x)\rangle$`。

其中第二条性质就叫做 reproducing property ，也是“再生核”名字的来源。至于字面上为什么这么叫，我也不清楚。也许是说元素`$x$`经过 kernel 映射之后，由内积一乘，又给冒出来了。有了这个 kernel 之后，我们可以很自然地把映射`$\phi$`定义为：

`$$
\phi(x) = K(\cdot,x)
$$`

由核的再生性质，我们之前的用于计算`$\mathcal{H}$`中内积的 kernel trick 也自然成立了：

`$$
\langle \phi(x_1),\phi(x_2)\rangle = \langle K(\cdot,x_1),K(\cdot,x_2)\rangle = K(x_1,x_2)
$$`

再生核有很多很好的性质，比如正定性（在线性代数里这样的性质通常称为“半正定”），也就是说对任意`$x_1,\ldots,x_n\in\mathcal{X}$`和 `$\xi_1,\ldots,\xi_n\in\mathbb{R}$`，都有

`$$
\sum_{i,j=1}^nK(x_i,x_j)\xi_i\xi_j \geq 0
$$`

这是很好证明的，按照核函数的再生性质写成刚才的内积形式，然后把系数拿到内积里面去，上面那个式子就等于`$\|\sum_{i=1}^n\xi_iK(\cdot,x_i)\|^2$`，根据范数的性质，也就非负了。

到这里，铺垫已经够多了，于是让我们回到 SVM ，这次我们不是直接偷工减料在最终得到的分类函数上做手脚，而是回到线性 SVM 的最初推导。当然，第一步我们要用刚才定义的映射`$\phi$`将数据从原始空间`$\mathcal{X}$`映射到 RKHS`$\mathcal{H}$`中，简单起见，我们用`$f_i(\cdot)$`来表示`$K(\cdot,x_i)$`。

和以前一样，我们使用一个线性超平面来分隔两类不同的点，并且我们假设经过非线性映射到`$\mathcal{H}$`中之后数据已经是线性可分的了。这个线性超平面由一个线性函数来表示。这里需要再明确一下线性函数的概念，简单的说，如果`$x_1$`、`$x_2$`是向量，`$\alpha_1$`、`$\alpha_2$`是标量，那么线性函数应该满足

`$$
\mathcal{F}(\alpha_1 x_1+\alpha_2 x_2) = \alpha_1 \mathcal{F}(x_1) + \alpha_2 \mathcal{F}(x_2)
$$`

在这里，由于我们讨论的空间`$\mathcal{H}$`中的元素本身就是函数，因此我们把`$\mathcal{H}$`上的函数改称“泛函 (functional)”。根据 [Riesz Representation 定理](http://en.wikipedia.org/wiki/Riesz_representation_theorem)，Hilbert Space 中的任意一个线性泛函`$\mathcal{F}$` ，都有一个`$f_\mathcal{F}\in\mathcal{H}$`，使得

`$$
\mathcal{F}(f) = \langle f,f_\mathcal{F}\rangle,\quad \forall f\in\mathcal{H}
$$`

换句话说，线性函数可以由向量内积表示，这和我们熟知的有限维欧氏空间中是一样的。只是要表示超平面还得再加上一个截距`$b$`

`$$
\mathcal{F}(f) = \langle f,g\rangle + b
$$`

这个样子的函数（泛函）严格来说称作[仿射函数](http://en.wikipedia.org/wiki/Affine_transformation)（泛函）。同我们在[第一篇](/2014/01/svm-series-maximum-margin-classifier/)中类似，我们可以定义 margin ，得到 geometrical margin 为

`$$
\gamma = \frac{y(\langle f,g\rangle +b)}{\|g\|}
$$`

类似于原来的推导，我们最终会得到一个如下的目标函数

`$$
\min \frac{1}{2}\|g\|^2\quad s.t., y_i(\langle f_i,g\rangle+b)\geq 1, i=1,\ldots,n
$$`

形式上和以前一样，只是把`$x_i$`换成了`$f_i$`，`$w$`换成了`$g$`，但是现在我们要求的参数`$g$`是在 Hilbert Space 中，特别当`$\mathcal{H}$`是无穷维的时候，是没有办法直接使用数值方法来求解的。即使可以转到 [dual 优化推导](/2014/01/svm-series-2-support-vector/)，但是里面涉及到对无穷维向量的求导之类的问题，我还不知道是不是能直接推广。不过幸运的是，我们在这里可以再把问题转化到有限维空间中。

这需要借助一个叫做 Representer Theorem 的定理，该定理说明，上面这个目标函数（还包括很大一类其他的目标函数）的最优解`$g^*$`可以写成如下的形式：

`$$
g^*=\sum_{i=1}^n a_i f_i
$$`

换句话说，可以由这`$n$`个训练数据（有限集）张成。定理的证明是很简单的，记`$\mathcal{H}_0$ 为 $\{f_1,\ldots,f_n\}$`张成的子空间，其正交补记为 `$\mathcal{H}_0^\bot$`，则任意的`$f\in\mathcal{H}$`都可以唯一地表示成`$f=f_0+f_0^\bot$`，其中`$f_0\in\mathcal{H}_0$`、`$f_0^\bot \in\mathcal{H}_0^\bot$` ，因此

`$$
g^* = g^*_0 + g^{*\bot}_0
$$`

由于`$g^{*\bot}_0$`垂直于`$f_1,\ldots,f_n$`，因此

`$$
\langle f_i,g^*\rangle = \langle f_i,g_0^* + g_0^{*\bot}\rangle = \langle f_i,g_0^*\rangle + 0
$$`

因此，`$g_0^{*\bot}$`部分的取值对于目标函数中的约束条件并不产生影响，可以任意定。另一方面，考虑目标函数本身，我们有

`$$
\|g^*\|^2 = \|g_0^* + g_0^{*\bot}\|^2 = \|g_0^*\|^2 + \|g_0^{*\bot}\|^2
$$`

最后一个等式是由于两者相互垂直而得到的（也就是勾股定理的推广啦），得到这个形式之后，再注意到我们是希望最小化`$\|g^*\|^2$`，其中`$g_0^{*\bot}$`是可以任意取值的，而范数`$\|g_0^{*\bot}\|^2$`又是非负的，所以在最小值的时候我们必定有`$\|g_0^{*\bot}\|^2=0$`，从而`$g_0^{*\bot}=0$`，也就证明了 `$g^*\in\mathcal{H}_0$`。

这样一来，问题就从在一个无穷维的 Hilbert Space 中找一个最优的`$g^*$`转化为了在一个`$n$`维的欧氏空间中找一个最优的系数`$\mathbf{a}^*$`，又回到了我们熟悉的问题，目标函数也变成了下面的样子：

`$$
\begin{aligned}
\frac{1}{2}\|g\|^2 &= \frac{1}{2}\left\|\sum_{i=1}^na_{i}f_{i}\right\|^2 \\
&= \frac{1}{2}\sum_{i,j=1}^na_{i}a_{j}K(x_i,x_j) \\
&= \frac{1}{2}\mathbf{a}^TK\mathbf{a}
\end{aligned}
$$`

这里矩阵`$(K)_{ij}=K(x_i,x_j)$`就是 Kernel Gram Matrix 。而约束条件也可以相应地写成

`$$
\begin{aligned}
1 &\leq y_i(\langle f_i,g\rangle + b) \\
&= y_i(\langle f_i,\sum_{j=1}^na_jf_j\rangle +b) \\
&= y_i(\mathbf{a}^TK_i + b)
\end{aligned}
$$`

这里`$i=1,\ldots,n$`，而`$K_i$`表示矩阵`$K$`的第`$i$`列。所以回到了最初的线性 SVM 的 Quadratic Programming 问题。当然，形式上有一些差别，另外，原来的线性 SVM 的问题的维度是原始数据空间`$\mathcal{X}$`的维度，而这里的问题维度是等于数据点的个数`$n$`，这是 RKHS`$\mathcal{H}$`的一个子空间`$\mathcal{H}_0$`。此外，原来的线性 SVM 不能处理`$\mathcal{X}$`中的非线性问题，但是现在经过非线性映射之后，（理想情况下）数据应该变得线性可分了。当然，即使不能完全线性可分，我们也可以使用之前说过的 [slack variable](/2014/02/svm-series-4-support-vector/) 的方法来放松约束。而问题的数值求解，也和以前类似，一方面可以直接使用二次优化的包求解，另一方面则可以通过 [dual 优化](/2014/01/svm-series-2-support-vector/)的方式来完成——得到的结果应该跟我们之前偷懒直接在最终结果上把内积进行替换所得的结果是一样的。

最后稍微补充一下：在刚才的介绍中我们看起来好像是先确定了 RKHS 之后再找出对应的再生核的，但是在实际中，通常是先设计出一个核函数（或者说通常都是直接使用几个常见的核函数），然后对应的 RKHS 就自然地确定下来了。关于 RKHS 还有许多的内容，但是没有办法全部讲了。在传统的 Kernel 方法应用中，通常只要注意到是否可以全部表示为内积运算就可以尝试使用 kernel 方法了，许多常见的算法（例如 Least-Square Regression 、PCA 等）都是可以用核方法来扩展的，在这里 Representer Theorem 将会是重要的一环。

除此之外，进来还有不少在 RKHS 里衡量统计独立性的工作，又不是只是像传统的 kernel trick 那么简单了，说明 RKHS 还是包含了不少有趣的话题的。
