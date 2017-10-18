---
title: lfda R包的使用方法以及算法的简要说明
date: '2015-08-25T00:25:22+00:00'
author: 唐源
categories:
  - 统计软件
  - 统计模型
tags:
  - lfda包
  - R包
  - 局部Fisher判别分析
  - 核局部Fisher判别分析
  - 算法说明
slug: a-brief-description-of-the-method-and-the-algorithm-of-the-lfda-package
meta_extra: 编辑：王小宁
forum_id: 419092
---

局部Fisher判别分析(Local Fisher Discriminant Analysis)是许多度量学习（Metric Learning）方法中效果最好的其中一种，它是一种线性监督降维方法，它可以自动找到合适的距离转换矩阵(transformation matrix)来抓住数据的不同类(class)的特征，通过加大不同类之间的距离(between-class distance)以及缩小同类里面每个样本的距离(within-class distance)，让不同类之间的界限更明显，从而使可视化效果更清晰。它同时也保持了多模(multimodality)的特征，这在处理一个类有多个的集群的时候有非常大的作用，比如说对于一种有多种可能症状的疾病来说，那些可能的症状都是同一类里面不同的集群，lfda可以把这种病的局部结构和特征(local structure)保持下来从而不会影响到之后的机器学习算法的效果。更细节一点的英文的理论介绍和应用可以
[点击](https://gastrograph.com/resources/whitepapers/local-fisher-discriminant-analysis-on-beer-style-clustering.html)
[这里](https://gastrograph.com/resources/whitepapers/local-fisher-discriminant-analysis-on-beer-style-clustering.html)
和[这里](http://www.ms.k.u-tokyo.ac.jp/software.html#LFDA)。
lfda对特征提取，降维，集群，分类，信息恢复，以及计算机视觉方面起到非常大的作用。
<!--more-->核局部Fisher判别分析(Kernel Local Fisher Discriminant Analysis)是局部Fisher判别分析的非线性化版本，它通过对原来的数据进行核转换技巧（kernel trick）从而能在高维的特征空间里面进行局部Fisher判别分析，它可以使不同类之间的非线性界限更明显，从而使之后的分类，集群等机器学习的方法效果更好。

半监督局部Fisher判别分析(Semi-supervised Local Fisher Discriminant Analysis)是局部Fisher判别分析的延伸版，它是线性的半监督降维方法。它充分的结合了非监督型主成分分析(Principal Component Analysis)和监督型局部Fisher判别分析的优点，使之能够将一部分的类标识（class label）忽略，来表达更多整体上类和类之间的特征，这对缺少标识的数据以及部分标识不正确的数据来说有非常大的作用。

以下是一些lfda包的简单用法，以上的三种分析方法目前都已经实现：
```r 
## 从CRAN上下载和安装最新的发布:
install.packages('lfda')
## 从Github上下载和安装最新的发展版本：
devtools::install_github('terrytangyuan/lfda')
```

局部Fisher判别分析 – Local Fisher Discriminant Analysis(LFDA)
  
假设我们想要将原数据降维到3个维度，我们可以运行以下代码：
```r 
k <- iris[,-5] #　这个矩阵包含了所有将要被转换的自变量(predictors)
y <- iris[,5] # 这是一个代表类标识(class labels)的向量
r <- 3 # 将要降到的维度数
```

运行\`lfda\`模型，注意\`metric\`这个参数可以选择’plain’, ‘weighted’, 和’orthonormalized’来分别代表转换矩阵的类型： 普通，加权，和正交
```r 
model <- lfda(k, y, r, metric = "plain")
plot(model, y) # 对转换之后的数据进行三维可视化
predict(model, iris[,-5]) # predict的方法来用之前得到的lfda模型对新数据进行转换
```
核局部Fisher判别分析 – Kernel Local Fisher Discriminant Analysis(KLFDA)
  
\`klfda\`的主要使用方法和\`lfda\`的使用方法基本一样，只是在使用lfda之前先要用\`kmatrixGauss\`对原数据进行核转换:

```r
k <- kmatrixGauss(iris[,-5])
y <- iris[,5]
r <- 3
model <- klfda(k, y, r, metric = "plain")
```
注意klfda的\`predict\`方法还在实现当中，\`plot\`三维可视化的方法和\`lfda\`的一样已经实现。

半监督局部Fisher判别分析- Semi-supervised Local Fisher Discriminant Analysis(SELF)这个算法要求另外一项参数\`beta\`来代表半监督的程度： 如果beta=0， 即代表完全监督； 如果beta=0， 则完全不监督（不使用任何类标识信息）。假设我们想要忽略\`iris\`数据里10%的类标识：

```r
k <- iris[,-5]
y <- iris[,5]
r <- 3
model <- self(k, y, beta = 0.1, r = 3, metric = "plain")
```
\`predict\`和\`plot\`的使用方法和\`lfda\`的完全一样

欢迎大家使用以及将任何的反馈意见提交到
[这里](https://github.com/terrytangyuan/lfda/issues)
或者发到我的邮箱terrytangyuan[at]gmail.com，
也欢迎大家的[Pull Request](https://github.com/terrytangyuan/lfda/pulls)。
