---
title: '支持向量机系列二: Support Vector'
date: '2014-01-25T10:38:32+00:00'
author: 张驰原
categories:
  - 推荐文章
  - 数据挖掘与机器学习
tags:
  - 优化
  - 支持向量机
  - 机器学习
  - 监督学习
slug: svm-series-2-support-vector
forum_id: 419001
---

原文链接请点击[这里](http://blog.pluskid.org/?p=682)

[上一次](/2014/01/svm-series-maximum-margin-classifier/)介绍支持向量机，结果说到 Maximum Margin Classifier ，到最后都没有说“支持向量”到底是什么东西。不妨回忆一下上次最后一张图：

![Optimal-Hyper-Plane](https://uploads.cosx.org/2014/01/Optimal-Hyper-Plane.png)

可以看到两个支撑着中间的 gap 的超平面，它们到中间的 separating hyper plane 的距离相等（想想看：为什么一定是相等的？），即我们所能得到的最大的 geometrical margin `\(\tilde{\gamma}\)` 。而“支撑”这两个超平面的必定会有一些点，试想，如果某超平面没有碰到任意一个点的话，那么我就可以进一步地扩充中间的 gap ，于是这个就不是最大的 margin 了。由于在 `\(n\)` 维向量空间里一个点实际上是和以原点为起点，该点为终点的一个向量是等价的，所以这些“支撑”的点便叫做支持向量。

很显然，由于这些 supporting vector 刚好在边界上，所以它们是满足 `\(y(w^{T}x + b) = 1\)`（还记得我们把 functional margin 定为1了吗？），而对于所有不是支持向量的点，也就是在“阵地后方”的点，则显然有`\(y(w^{T}x + b) > 1\)`。事实上，当最优的超平面确定下来之后，这些后方的点就完全成了路人甲了，它们可以在自己的边界后方随便飘来飘去都不会对超平面产生任何影响。这样的特性在实际中有一个最直接的好处就在于存储和计算上的优越性，例如，如果使用 100 万个点求出一个最优的超平面，其中是 supporting vector 的有 100 个，那么我只需要记住这 100 个点的信息即可，对于后续分类也只需要利用这 100 个点而不是全部 100 万个点来做计算。（当然，通常除了 K-Nearest Neighbor 之类的 [Memory-based Learning](http://en.wikipedia.org/wiki/Instance-based_learning) 算法，通常算法也都不会直接把所有的点记忆下来，并全部用来做后续 inference 中的计算。不过，如果算法使用了 Kernel 方法进行非线性化推广的话，就会遇到这个问题了。Kernel 方法在下一次会介绍。）

当然，除了从几何直观上之外，支持向量的概念也会从其优化过程的推导中得到。其实上一次还偷偷卖了另一个关子就是虽然给出了目标函数，却没有讲怎么来求解。现在就让我们来处理这个问题。回忆一下之前得到的目标函数：
  
`$$\max \frac{1}{\|w\|} \quad s.t., y_{i}(w^{T}x_{i} + b) \geq 1, i=1,\dots,n$$`

这个问题等价于（为了方便求解，我在这里加上了平方，还有一个系数，显然这两个问题是等价的，因为我们关心的并不是最优情况下目标函数的具体数值）：
  
`$$\min \frac{1}{2}\|w\|^{2} \quad s.t., y_{i}(w^{T}x_{i} + b) \geq 1, i=1, \dots, n$$`

到这个形式以后，就可以很明显地看出来，它是一个凸优化问题，或者更具体地说，它是一个二次优化问题——目标函数是二次的，约束条件是线性的。这个问题可以用任何现成的 [QP (Quadratic Programming)](http://en.wikipedia.org/wiki/Quadratic_programming) 的优化包进行求解。所以，我们的问题到此为止就算全部解决了，于是我睡午觉去了~ :smile:

啊？呃，有人说我偷懒不负责任了？好吧，嗯，其实呢，虽然这个问题确实是一个标准的 QP 问题，但是它也有它的特殊结构，通过 [Lagrange Duality](http://en.wikipedia.org/wiki/Lagrange_duality#The_strong_Lagrangian_principle:_Lagrange_duality) 变换到对偶变量 (dual variable) 的优化问题之后，可以找到一种更加有效的方法来进行求解——这也是 SVM 盛行的一大原因，通常情况下这种方法比直接使用通用的 QP 优化包进行优化要高效得多。此外，在推导过程中，许多有趣的特征也会被揭露出来，包括刚才提到的 supporting vector 的问题。

关于 Lagrange duality 我没有办法在这里细讲了，可以参考 Wikipedia 。简单地来说，通过给每一个约束条件加上一个 Lagrange multiplier，我们可以将它们融和到目标函数里去
  
`$$\mathcal{L}(w,b,\alpha) = \frac{1}{2}\|w\|^2 - \sum_{i=1}^{n} \alpha_{i} (y_{i}(w^{T}x_{i} + b) - 1)$$`

然后我们令

`$$\theta(w) = \max_{\alpha_{i} \geq 0} \mathcal{L}(w,b,\alpha)$$`

容易验证，当某个约束条件不满足时，例如`\(y_{i}(w^{T}x_{i} + b) < 1\)`，那么我们显然有`\(\theta(w) = \infty\)` （只要令`\(\alpha_{i} = \infty\)` 即可）。而当所有约束条件都满足时，则有`\(\theta(w) = \frac{1}{2}\|w\|^{2}\)`，亦即我们最初要最小化的量。因此，在要求约束条件得到满足的情况下最小化`\(\frac{1}{2}\|w\|^{2}\)`实际上等价于直接最小化`\(\theta(w)\)`（当然，这里也有约束条件，就是`\(\alpha_{i} \geq 0, \quad i=1,\dots,n\)`），因为如果约束条件没有得到满足，`\(\theta(w)\)`会等于无穷大，自然不会是我们所要求的最小值。具体写出来，我们现在的目标函数变成了：
  
`$$\[ \min_{w,b} \] \; \theta(w) = \[ \min_{w,b} \] \; \[ \max_{\alpha_{i} \geq 0} \] \; \mathcal{L}(w,b,\alpha) = p^{*}$$`

这里用`p^{*}`表示这个问题的最优值，这个问题和我们最初的问题是等价的。不过，现在我们来把最小和最大的位置交换一下：
  
`$$\[ \max_{\alpha_{i} \geq 0} \] \; \[ \min_{w,b} \] \; \mathcal{L}(w,b,\alpha) = d^{*}$$`

当然，交换以后的问题不再等价于原问题，这个新问题的最优值用 `\(d^{*}\)` 来表示。并，我们有`\(d^{*} \leq p^{*}\)`，这在直观上也不难理解，最大值中最小的一个总也比最小值中最大的一个要大吧！ :slight_smile: 总之，第二个问题的最优值`\(d^{*}\)`在这里提供了一个第一个问题的最优值`\(p^{*}\)`的一个下界，在满足某些条件的情况下，这两者相等，这个时候我们就可以通过求解第二个问题来间接地求解第一个问题。具体来说，就是要满足 [KKT 条件](http://en.wikipedia.org/wiki/Karush%E2%80%93Kuhn%E2%80%93Tucker_conditions)，这里暂且先略过不说，直接给结论：我们这里的问题是满足 KKT 条件的，因此现在我们便转化为求解第二个问题。

首先要让`\(\mathcal{L}\)`关于`\(w\)`和`\(b\)`最小化，我们分别令`\(\partial \mathcal{L} / \partial w\)`和`\(\partial \mathcal{L} / \partial b\)`等于零：

`$$
\begin{align}
\frac{\partial \mathcal{L}}{\partial w} = 0 &\Rightarrow w=\sum_{i=1}^{n} \alpha_{i} y_{i} x_{i} \\
\frac{\partial \mathcal{L}}{\partial b} = 0 &\Rightarrow \sum_{i=1}^{n} \alpha_{i} y_{i} = 0
\end{align}
$$`

带回 `\(\mathcal{L}\)`得到：

`$$
\begin{align}
\mathcal{L}(w,b,\alpha) &= \frac{1}{2}\sum_{i,j=1}^{n} \alpha_{i}\alpha_{j}y_{i}y_{j}x_{i}^{T}x_{j}-\sum_{i,j=1}^{n}\alpha_{i}\alpha_{j}y_{i}y_{j}x_{i}^{T}x_{j} – b\sum_{i=1}^{n}\alpha_{i}y_{i} + \sum_{i=1}^{n}\alpha_{i} \\ 
&= \sum\{i=1}^{n}\alpha_{i} – \frac{1}{2}\sum_{i,j=1}^{n}\alpha_{i}\alpha_{j}y_{i}y_{j}x_{i}^{T}x_{j}
\end{align}
$$`

此时我们得到关于 dual variable`\(\alpha\)`的优化问题：

`$$
\begin{align}
\[\max_{\alpha}\] &\sum_{i=1}^{n} \alpha_{i} – \frac{1}{2}\sum_{i,j=1}^{n} \alpha_{i} \alpha_{j} y_{i}y_{j}x_{i}^{T}x_{j} \\
s.t., &\alpha_{i} \geq 0, i=1,\dots,n \\
&\sum_{i=1}^{n}\alpha_{i}y_{i} = 0
\end{align}
$$`

如前面所说，这个问题有更加高效的优化算法，不过具体方法在这里先不介绍，让我们先来看看推导过程中得到的一些有趣的形式。首先就是关于我们的 hyper plane ，对于一个数据点 `\(x\)` 进行分类，实际上是通过把`\(x\)`带入到`\(f(x) = w^{T}x+b\)`算出结果然后根据其正负号来进行类别划分的。而前面的推导中我们得到`\(w = \sum_{i=1}^{n} \alpha_{i} y_{i} x_{i}\)`，因此

`$$
\begin{align}  
f(x) &= \left(\sum_{i=1}^{n} \alpha_{i} y_{i} x_{i} \right)^{T}x+b \\  
&= \sum_{i=1}^{n} \alpha_{i} y_{i} \langle x_{i}, x \rangle + b 
\end{align}
$$`

这里的形式的有趣之处在于，对于新点`\(x\)`的预测，只需要计算它与训练数据点的内积即可（这里`\(\langle \cdot, \cdot\rangle\)`表示向量内积），这一点至关重要，是之后使用 Kernel 进行非线性推广的基本前提。此外，所谓 Supporting Vector 也在这里显示出来——事实上，所有非 Supporting Vector 所对应的系数`\(\alpha\)`都是等于零的，因此对于新点的内积计算实际上只要针对少量的“支持向量”而不是所有的训练数据即可。

为什么非支持向量对应的`\(\alpha\)`等于零呢？直观上来理解的话，就是这些“后方”的点——正如我们之前分析过的一样，对超平面是没有影响的，由于分类完全有超平面决定，所以这些无关的点并不会参与分类问题的计算，因而也就不会产生任何影响了。这个结论也可由刚才的推导中得出，回忆一下我们刚才通过 Lagrange multiplier 得到的目标函数：

`$$
\[ \max_{\alpha_{i} \geq 0} \] \; \mathcal{L}(w,b,\alpha) = \[ \max_{\alpha_{i} \geq 0} \] \; \frac{1}{2}\|w\|^2-\sum_{i=1}^{n} \alpha_{i} \color{red}{\left(y_{i}(w^{T}x_{i}+b)-1\right)}
$$`

注意到如果`\(x_{i}\)`是支持向量的话，上式中红颜色的部分是等于 0 的（因为支持向量的 functional margin 等于 1 ），而对于非支持向量来说，functional margin 会大于 1 ，因此红颜色部分是大于零的，而`\(\alpha_{i}\)`又是非负的，为了满足最大化，`\(\alpha_{i}\)`必须等于 0 。这也就是这些非 Supporting Vector 的点的悲惨命运了。 :p

嗯，于是呢，把所有的这些东西整合起来，得到的一个 maximum margin hyper plane classifier 就是支持向量机（Support Vector Machine），经过直观的感觉和数学上的推导，为什么叫“支持向量”，应该也就明了了吧？当然，到目前为止，我们的 SVM 还比较弱，只能处理线性的情况，不过，在得到了 dual 形式之后，通过 Kernel 推广到非线性的情况就变成了一件非常容易的事情了。不过，具体细节，还要留到下一次再细说了。 :simle:
