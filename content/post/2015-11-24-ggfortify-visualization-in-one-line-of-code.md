---
title: 一行R代码来实现繁琐的可视化
date: '2015-11-24T10:41:34+00:00'
author: COS编辑部
categories:
  - 统计图形
  - 软件应用
tags:
  - ggfortify
  - ggplot2
  - 可视化
  - 模型
slug: ggfortify-visualization-in-one-line-of-code
---

本文作者： 唐源，目前就职于芝加哥一家创业公司，曾参与和创作过多个被广泛使用的 R 和 Python 开源项目，是 ggfortify，lfda，metric-learn 等包的作者，也是 xgboost，caret，pandas 等包的贡献者。（喜欢爬山和烧烤 <img class="alignnone" src="http://img.t.sinajs.cn/t4/appstyle/expression/ext/normal/0b/tootha_thumb.gif" alt="" width="22" height="22" />）

[ggfortify](https://github.com/sinhrks/ggfortify) 是一个简单易用的R软件包，它可以仅仅使用**一行代码**来对许多受欢迎的R软件包结果进行二维可视化，这让统计学家以及数据科学家省去了许多繁琐和重复的过程，不用对结果进行任何处理就能以 `ggplot` 的风格画出好看的图，大大地提高了工作的效率。

ggfortify 已经可以在 [CRAN](https://cran.fhcrc.org/web/packages/ggfortify/index.html) 上下载得到，但是由于最近很多的功能都还在快速增加，因此还是推荐大家从 [Github](https://github.com/sinhrks/ggfortify) 上下载和安装。

<pre><code class="r">library(devtools)
install_github('sinhrks/ggfortify')
library(ggfortify)</code></pre>

接下来我将简单介绍一下怎么用 `ggplot2` 和 `ggfortify` 来很快地对PCA、聚类以及LFDA的结果进行可视化，然后将简单介绍用 `ggfortify` 来对时间序列进行快速可视化的方法。

## PCA (主成分分析)

`ggfortify` 使 `ggplot2` 知道怎么诠释PCA对象。加载好 `ggfortify` 包之后, 你可以对`stats::prcomp` 和 `stats::princomp` 对象使用 `ggplot2::autoplot`。

<pre><code class="r">library(ggfortify)
df &lt;- iris[c(1, 2, 3, 4)]
autoplot(prcomp(df))</code></pre>

[<img class="aligncenter size-large wp-image-11596" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-1-1-500x250.png" alt="ggfortify-unnamed-chunk-1-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-1-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-1-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-1-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-1-1.png)你还可以选择数据中的一列来给画出的点按类别自动分颜色。输入`help(autoplot.prcomp)` 可以了解到更多的其他选择。

<pre><code class="r">autoplot(prcomp(df), data = iris, colour = 'Species')</code></pre>

[<img class="aligncenter size-large wp-image-11597" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-2-1-500x250.png" alt="ggfortify-unnamed-chunk-2-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-2-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-2-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-2-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-2-1.png)比如说给定`label = TRUE` 可以给每个点加上标识（以`rownames`为标准），也可以调整标识的大小。

<pre><code class="r">autoplot(prcomp(df), data = iris, colour = 'Species', label = TRUE,
         label.size = 3)</code></pre>

[<img class="aligncenter size-large wp-image-11598" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-3-1-500x250.png" alt="ggfortify-unnamed-chunk-3-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-3-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-3-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-3-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-3-1.png)给定 `shape = FALSE` 可以让所有的点消失，只留下标识，这样可以让图更清晰，辨识度更大。

<pre><code class="r">autoplot(prcomp(df), data = iris, colour = 'Species', shape = FALSE,
         label.size = 3)</code></pre>

[<img class="aligncenter size-large wp-image-11599" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-4-1-500x250.png" alt="ggfortify-unnamed-chunk-4-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-4-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-4-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-4-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-4-1.png)

<!--more-->给定 

`loadings = TRUE` 可以很快地画出特征向量。

<pre><code class="r">autoplot(prcomp(df), data = iris, colour = 'Species', loadings = TRUE)</code></pre>

[<img class="aligncenter size-large wp-image-11600" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-5-1-500x250.png" alt="ggfortify-unnamed-chunk-5-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-5-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-5-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-5-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-5-1.png)同样的，你也可以显示特征向量的标识以及调整他们的大小，更多选择请参考帮助文件。

<pre><code class="r">autoplot(prcomp(df), data = iris, colour = 'Species',
         loadings = TRUE, loadings.colour = 'blue',
         loadings.label = TRUE, loadings.label.size = 3)</code></pre>

[<img class="aligncenter size-large wp-image-11601" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-6-1-500x250.png" alt="ggfortify-unnamed-chunk-6-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-6-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-6-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-6-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-6-1.png)

## 因子分析

和PCA类似，`ggfortify` 也支持 `stats::factanal` 对象。可调的选择也很广泛。以下给出了简单的例子：

**注意** 当你使用 `factanal` 来计算分数的话，你必须给定 `scores` 的值。

<pre><code class="r">d.factanal &lt;- factanal(state.x77, factors = 3, scores = 'regression')
autoplot(d.factanal, data = state.x77, colour = 'Income')</code></pre>

[<img class="aligncenter size-large wp-image-11603" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-7-1-500x250.png" alt="ggfortify-unnamed-chunk-7-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-7-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-7-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-7-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-7-1.png)

<pre><code class="r">autoplot(d.factanal, label = TRUE, label.size = 3,
         loadings = TRUE, loadings.label = TRUE, loadings.label.size  = 3)</code></pre>

[<img class="aligncenter size-large wp-image-11604" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-7-2-500x250.png" alt="ggfortify-unnamed-chunk-7-2" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-7-2-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-7-2-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-7-2.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-7-2.png)

## K-均值聚类

<pre><code class="r">autoplot(kmeans(USArrests, 3), data = USArrests)</code></pre>

[<img class="aligncenter size-large wp-image-11606" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-8-1-500x250.png" alt="ggfortify-unnamed-chunk-8-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-8-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-8-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-8-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-8-1.png)

<pre><code class="r">autoplot(kmeans(USArrests, 3), data = USArrests, label = TRUE, 
         label.size = 3)</code></pre>

[<img class="aligncenter size-large wp-image-11607" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-8-2-500x250.png" alt="ggfortify-unnamed-chunk-8-2" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-8-2-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-8-2-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-8-2.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-8-2.png)

## 其他聚类

`ggfortify` 也支持 `cluster::clara`, `cluster::fanny`, `cluster::pam`。

<pre><code class="r">library(cluster)
autoplot(clara(iris[-5], 3))</code></pre>

[<img class="aligncenter size-large wp-image-11608" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-9-1-500x250.png" alt="ggfortify-unnamed-chunk-9-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-9-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-9-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-9-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-9-1.png)给定 `frame = TRUE`，可以把 `stats::kmeans` 和 `cluster::*` 中的每个类圈出来。

<pre><code class="r">autoplot(fanny(iris[-5], 3), frame = TRUE)</code></pre>

[<img class="aligncenter size-large wp-image-11609" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-10-1-500x250.png" alt="ggfortify-unnamed-chunk-10-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-10-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-10-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-10-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-10-1.png)你也可以通过 `frame.type` 来选择圈的类型。更多选择请参照 [`ggplot2::stat_ellipse`](http://docs.ggplot2.org/dev/stat_ellipse.html) 里面的 `frame.type` 的 `type` 关键词。

<pre><code class="r">autoplot(pam(iris[-5], 3), frame = TRUE, frame.type = 'norm')</code></pre>

[<img class="aligncenter size-large wp-image-11610" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-11-1-500x250.png" alt="ggfortify-unnamed-chunk-11-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-11-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-11-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-11-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-11-1.png)更多关于聚类方面的可视化请参考 Github 上的 [Vignette](https://github.com/sinhrks/ggfortify/tree/master/vignettes) 或者 [Rpubs](http://rpubs.com/sinhrks/plot_pca) 上的例子。

## lfda（Fisher局部判别分析）

[`lfda`](https://cran.r-project.org/web/packages/lfda/index.html) 包支持一系列的 Fisher 局部判别分析方法，包括半监督 lfda，非线性 lfda。你也可以使用 `ggfortify` 来对他们的结果进行可视化。

<pre><code class="r">library(lfda)
# Fisher局部判别分析 (LFDA)
model &lt;- lfda(iris[-5], iris[, 5], 4, metric="plain")
autoplot(model, data = iris, frame = TRUE, frame.colour = 'Species')</code></pre>

[<img class="aligncenter size-large wp-image-11612" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-12-1-500x250.png" alt="ggfortify-unnamed-chunk-12-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-12-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-12-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-12-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-12-1.png)

<pre><code class="r"># 非线性核Fisher局部判别分析 (KLFDA)
model &lt;- klfda(kmatrixGauss(iris[-5]), iris[, 5], 4, metric="plain")
autoplot(model, data = iris, frame = TRUE, frame.colour = 'Species')</code></pre>

[<img class="aligncenter size-large wp-image-11613" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-12-2-500x250.png" alt="ggfortify-unnamed-chunk-12-2" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-12-2-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-12-2-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-12-2.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-12-2.png)**注意** 对 `iris` 数据来说，不同的类之间的关系很显然不是简单的线性，这种情况下非线性的klfda 影响可能太强大而影响了可视化的效果，在使用前请充分理解每个算法的意义以及效果。

<pre><code class="r"># 半监督Fisher局部判别分析 (SELF)
model &lt;- self(iris[-5], iris[, 5], beta = 0.1, r = 3, metric="plain")
autoplot(model, data = iris, frame = TRUE, frame.colour = 'Species')</code></pre>

[<img class="aligncenter size-large wp-image-11614" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-13-1-500x250.png" alt="ggfortify-unnamed-chunk-13-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-13-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-13-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-13-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-13-1.png)

## 时间序列的可视化

用 `ggfortify` 可以使时间序列的可视化变得极其简单。接下来我将给出一些简单的例子。

### ts对象

<pre><code class="r">library(ggfortify)
autoplot(AirPassengers)</code></pre>

[<img class="aligncenter size-large wp-image-11616" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-14-1-500x250.png" alt="ggfortify-unnamed-chunk-14-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-14-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-14-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-14-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-14-1.png)可以使用 `ts.colour` 和 `ts.linetype` 来改变线的颜色和形状。更多的选择请参考 `help(autoplot.ts)`。

<pre><code class="r">autoplot(AirPassengers, ts.colour = 'red', ts.linetype = 'dashed')</code></pre>

[<img class="aligncenter size-large wp-image-11617" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-15-1-500x250.png" alt="ggfortify-unnamed-chunk-15-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-15-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-15-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-15-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-15-1.png)

## 多变量时间序列

<pre><code class="r">library(vars)
data(Canada)
autoplot(Canada)</code></pre>

[<img class="aligncenter size-large wp-image-11618" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-16-1-500x250.png" alt="ggfortify-unnamed-chunk-16-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-16-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-16-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-16-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-16-1.png)使用 `facets = FALSE` 可以把所有变量画在一条轴上。

<pre><code class="r">autoplot(Canada, facets = FALSE)</code></pre>

[<img class="aligncenter size-large wp-image-11619" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-17-1-500x250.png" alt="ggfortify-unnamed-chunk-17-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-17-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-17-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-17-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-17-1.png)

`autoplot` 也可以理解其他的时间序列类别。可支持的R包有：

  * `zoo::zooreg`
  * `xts::xts`
  * `timeSeries::timSeries`
  * `tseries::irts`

一些例子：

<pre><code class="r">library(xts)
autoplot(as.xts(AirPassengers), ts.colour = 'green')</code></pre>

[<img class="aligncenter size-large wp-image-11620" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-18-1-500x250.png" alt="ggfortify-unnamed-chunk-18-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-18-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-18-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-18-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-18-1.png)

<pre><code class="r">library(timeSeries)
autoplot(as.timeSeries(AirPassengers), ts.colour = ('dodgerblue3'))</code></pre>

[<img class="aligncenter size-large wp-image-11621" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-18-2-500x250.png" alt="ggfortify-unnamed-chunk-18-2" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-18-2-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-18-2-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-18-2.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-18-2.png)你也可以通过 `ts.geom` 来改变几何形状，目前支持的有 `line`， `bar` 和 `point。`

<pre><code class="r">autoplot(AirPassengers, ts.geom = 'bar', fill = 'blue')</code></pre>

[<img class="aligncenter size-large wp-image-11622" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-19-1-500x250.png" alt="ggfortify-unnamed-chunk-19-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-19-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-19-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-19-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-19-1.png)

<pre><code class="r">autoplot(AirPassengers, ts.geom = 'point', shape = 3)</code></pre>

[<img class="aligncenter size-large wp-image-11623" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-20-1-500x250.png" alt="ggfortify-unnamed-chunk-20-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-20-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-20-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-20-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-20-1.png)

## forecast包

<pre><code class="r">library(forecast)
d.arima &lt;- auto.arima(AirPassengers)
d.forecast &lt;- forecast(d.arima, level = c(95), h = 50)
autoplot(d.forecast)</code></pre>

[<img class="aligncenter size-large wp-image-11624" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-21-1-500x250.png" alt="ggfortify-unnamed-chunk-21-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-21-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-21-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-21-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-21-1.png)有很多设置可供调整：

<pre><code class="r">autoplot(d.forecast, ts.colour = 'firebrick1', predict.colour = 'red',
         predict.linetype = 'dashed', conf.int = FALSE)</code></pre>

[<img class="aligncenter size-large wp-image-11625" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-22-1-500x250.png" alt="ggfortify-unnamed-chunk-22-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-22-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-22-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-22-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-22-1.png)

## vars包

<pre><code class="r">library(vars)
data(Canada)
d.vselect &lt;- VARselect(Canada, lag.max = 5, type = 'const')$selection[1]
d.var &lt;- VAR(Canada, p = d.vselect, type = 'const')
autoplot(predict(d.var, n.ahead = 50), ts.colour = 'dodgerblue4',
         predict.colour = 'blue', predict.linetype = 'dashed')</code></pre>

[<img class="aligncenter size-large wp-image-11626" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-24-1-500x250.png" alt="ggfortify-unnamed-chunk-24-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-24-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-24-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-24-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-24-1.png)

## changepoint包

<pre><code class="r">library(changepoint)
autoplot(cpt.meanvar(AirPassengers))</code></pre>

[<img class="aligncenter size-large wp-image-11627" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-25-1-500x250.png" alt="ggfortify-unnamed-chunk-25-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-25-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-25-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-25-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-25-1.png)

<pre><code class="r">autoplot(cpt.meanvar(AirPassengers), cpt.colour = 'blue', cpt.linetype = 'solid')</code></pre>

[<img class="aligncenter size-large wp-image-11628" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-26-1-500x250.png" alt="ggfortify-unnamed-chunk-26-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-26-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-26-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-26-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-26-1.png)

## strucchange包

<pre><code class="r">library(strucchange)
autoplot(breakpoints(Nile ~ 1), ts.colour = 'blue', ts.linetype = 'dashed',
         cpt.colour = 'dodgerblue3', cpt.linetype = 'solid')</code></pre>

[<img class="aligncenter size-large wp-image-11629" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-27-1-500x250.png" alt="ggfortify-unnamed-chunk-27-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-27-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-27-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-27-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-27-1.png)

## dlm包

<pre><code class="r">library(dlm)
form &lt;- function(theta){
  dlmModPoly(order = 1, dV = exp(theta[1]), dW = exp(theta[2]))
}

model &lt;- form(dlmMLE(Nile, parm = c(1, 1), form)$par)
filtered &lt;- dlmFilter(Nile, model)

autoplot(filtered)</code></pre>

[<img class="aligncenter size-large wp-image-11630" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-28-1-500x250.png" alt="ggfortify-unnamed-chunk-28-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-28-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-28-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-28-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-28-1.png)

<pre><code class="r">autoplot(filtered, ts.linetype = 'dashed', fitted.colour = 'blue')</code></pre>

[<img class="aligncenter size-large wp-image-11633" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-29-1-500x250.png" alt="ggfortify-unnamed-chunk-29-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-29-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-29-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-29-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-29-1.png)

<pre><code class="r">smoothed &lt;- dlmSmooth(filtered)
autoplot(smoothed)</code></pre>

[<img class="aligncenter size-large wp-image-11634" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-30-1-500x250.png" alt="ggfortify-unnamed-chunk-30-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-30-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-30-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-30-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-30-1.png)

<pre><code class="r">p &lt;- autoplot(filtered)
autoplot(smoothed, ts.colour = 'blue', p = p)</code></pre>

## [<img class="aligncenter size-large wp-image-11635" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-31-1-500x250.png" alt="ggfortify-unnamed-chunk-31-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-31-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-31-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-31-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-31-1.png)KFAS包

<pre><code class="r">library(KFAS)
model &lt;- SSModel(
  Nile ~ SSMtrend(degree=1, Q=matrix(NA)), H=matrix(NA)
)
 
fit &lt;- fitSSM(model=model, inits=c(log(var(Nile)),log(var(Nile))), 
              method="BFGS")
smoothed &lt;- KFS(fit$model)
autoplot(smoothed)</code></pre>

[<img class="aligncenter size-large wp-image-11636" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-32-1-500x250.png" alt="ggfortify-unnamed-chunk-32-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-32-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-32-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-32-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-32-1.png)使用 `smoothing='none'` 可以画出过滤后的结果。

<pre><code class="r">filtered &lt;- KFS(fit$model, filtering="mean", smoothing='none')
autoplot(filtered)</code></pre>

[<img class="aligncenter size-large wp-image-11637" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-33-1-500x250.png" alt="ggfortify-unnamed-chunk-33-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-33-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-33-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-33-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-33-1.png)

<pre><code class="r">trend &lt;- signal(smoothed, states="trend")
p &lt;- autoplot(filtered)
autoplot(trend, ts.colour = 'blue', p = p)</code></pre>

&nbsp;

[<img class="aligncenter size-large wp-image-11638" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-35-1-500x250.png" alt="ggfortify-unnamed-chunk-35-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-35-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-35-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-35-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-35-1.png)

# stats包

可支持的stats包里的对象有：

  * `stl`, `decomposed.ts`
  * `acf`, `pacf`, `ccf`
  * `spec.ar`, `spec.pgram`
  * `cpgram`

<pre><code class="r">autoplot(stl(AirPassengers, s.window = 'periodic'), ts.colour = 'blue')
</code></pre>

[<img class="aligncenter size-large wp-image-11639" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-36-1-500x250.png" alt="ggfortify-unnamed-chunk-36-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-36-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-36-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-36-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-36-1.png)

<pre><code class="r">autoplot(acf(AirPassengers, plot = FALSE))
</code></pre>

&nbsp;

[<img class="aligncenter size-large wp-image-11640" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-37-1-500x250.png" alt="ggfortify-unnamed-chunk-37-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-37-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-37-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-37-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-37-1.png)

<pre><code class="r">autoplot(acf(AirPassengers, plot = FALSE), conf.int.fill = '#0000FF', 
         conf.int.value = 0.8, conf.int.type = 'ma')</code></pre>

&nbsp;

[<img class="aligncenter size-large wp-image-11641" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-38-1-500x250.png" alt="ggfortify-unnamed-chunk-38-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-38-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-38-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-38-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-38-1.png)

<pre><code class="r">autoplot(spec.ar(AirPassengers, plot = FALSE))</code></pre>

&nbsp;

[<img class="aligncenter size-large wp-image-11642" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-39-1-500x250.png" alt="ggfortify-unnamed-chunk-39-1" width="500" height="250" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-39-1-500x250.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-39-1-300x150.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-39-1.png 1152w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-39-1.png)

<pre><code class="r">ggcpgram(arima.sim(list(ar = c(0.7, -0.5)), n = 50))</code></pre>

[<img class="aligncenter size-large wp-image-11643" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-40-1-500x500.png" alt="ggfortify-unnamed-chunk-40-1" width="500" height="500" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-40-1-500x500.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-40-1-150x150.png 150w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-40-1-300x300.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-40-1.png 576w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-40-1.png)

<pre><code class="r">library(forecast)
ggtsdiag(auto.arima(AirPassengers))</code></pre>

[<img class="aligncenter size-large wp-image-11644" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-41-1-500x500.png" alt="ggfortify-unnamed-chunk-41-1" width="500" height="500" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-41-1-500x500.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-41-1-150x150.png 150w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-41-1-300x300.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-41-1.png 960w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-41-1.png)

<pre><code class="r">gglagplot(AirPassengers, lags = 4)</code></pre>

&nbsp;

[<img class="aligncenter size-large wp-image-11645" src="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-42-1-500x500.png" alt="ggfortify-unnamed-chunk-42-1" width="500" height="500" srcset="https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-42-1-500x500.png 500w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-42-1-150x150.png 150w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-42-1-300x300.png 300w, https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-42-1.png 768w" sizes="(max-width: 500px) 100vw, 500px" />](https://cos.name/wp-content/uploads/2015/11/ggfortify-unnamed-chunk-42-1.png)

更多关于时间序列的例子，请参考 [Rpubs](http://rpubs.com/sinhrks/plot_ts) 上的介绍。

最近又多了许多额外的非常好用的功能，比如说现在已经支持 `multiplot` 同时画多个不同对象，强烈推荐参考 [Rpubs](http://rpubs.com/sinhrks/ggfortify_subplots) 以及关注我们 [Github](https://github.com/sinhrks/ggfortify) 上的更新。

祝大家使用愉快！有问题请及时在Github上 [报告](https://github.com/sinhrks/ggfortify/issues)。(可以使用中文)
