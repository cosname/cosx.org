---
title: 奇异值分解和图像压缩
date: '2014-02-09T06:40:21+00:00'
author: 邱怡轩
categories:
  - 分析与代数
  - 多元统计
  - 数学方法
  - 数据分析
  - 统计软件
  - 软件应用
tags:
  - SVD
  - 分解
  - 压缩
  - 图像
  - 奇异值分解
  - 矩阵
slug: svd-and-image-compression
forum_id: 419004
---

【2.18更新】：[楠神](https://github.com/road2stat)写了一个非常gelivable的[Shiny应用](https://github.com/road2stat/imgsvd)，用来动态展示图片压缩的效果随k的变化情况。[谢大大](http://yihui.name/)把这个应用放到了[RStudio的服务器](https://yihui.shinyapps.io/imgsvd/)上，大家可以点进去玩玩看了。

<p style="text-align: center;">
  =====================代表正义的分割线=====================
</p>

今天我们来讲讲奇异值分解和它的一些有意思的应用。奇异值分解是一个非常，非常，非常大的话题，它的英文是 Singular Value Decomposition，一般简称为 SVD。下面先给出它大概的意思：

对于任意一个`\(m \times n\)`的矩阵`\(M\)`，不妨假设`\(m > n\)`，它可以被分解为

`$$M = UDV^{T}$$`

其中

  * `\(U\)` 是一个`\(m \times n\)`的矩阵，满足`\(U^{T}U = I_{n}\)`，`\(I_{n}\)` 是`\(n \times n\)`的单位阵
  * `\(V\)` 是一个`\(n \times n\)`的矩阵，满足`\(V^{T}V = I_{n}\)`
  * `\(D\)` 是一个`\(n \times n\)`的对角矩阵，所有的元素都非负

先别急，我看到这个定义的时候和你一样晕，感觉信息量有点大。事实上，上面这短短的三条可以引发出 SVD 许多重要的性质，而我们今天要介绍的也只是其中的一部分而已。

<!--more-->

前面的表达式`\(M = UDV^{T}\)`可以用一种更容易理解的方式表达出来。如果我们把矩阵`\(U\)`用它的列向量表示出来，可以写成

`$$U = (u_1, u_2,\ldots, u_n)$$`

其中每一个`\(u_i\)`被称为`\(M\)`的左奇异向量。类似地，对于`\(V\)`，有

`$$V = (v_1,v_2,\ldots,v_n)$$`

它们被称为右奇异向量。再然后，假设矩阵`\(D\)`的对角线元素为`\(d_i\)`（它们被称为`\(M\)`的奇异值）并按降序排列，那么`\(M\)`就可以表达为

`$$M = d_1u_1v_1^T + d_2u_2v_2^T + \cdots + d_nu_nv_n^T = \sum_{i=1}^n d_iu_iv_i^T = \sum_{i=1}^n A_i$$`

其中`\(A_i = d_iu_iv_i^T\)`是一个`\(m \times n\)`的矩阵。换句话说，我们把原来的矩阵`\(M\)`表达成了`\(n\)`个矩阵的和。

这个式子有什么用呢？注意到，我们假定`\(d_i\)`是按降序排列的，它在某种程度上反映了对应项`\(A_i\)`在`\(M\)`中的“贡献”。`\(d_i\)`越大，说明对应的 `\(A_i\)`在`\(M\)`的分解中占据的比重也越大。所以一个很自然的想法是，我们是不是可以提取出`\(A_i\)`中那些对`\(M\)`贡献最大的项，把它们的和作为对 `\(M\)`的近似？也就是说，如果令

`$$ M_k = \sum_{i=1}^k A_i$$`

那么我们是否可以用`\(M_k\)`来对`\(M_n \equiv M\)`进行近似？

答案是肯定的，不过等一下，这个想法好像似曾相识？对了，多元统计分析中经典的主成分分析就是这样做的。在主成分分析中，我们把数据整体的变异分解成若干个主成分之和，然后保留方差最大的若干个主成分，而舍弃那些方差较小的。事实上，主成分分析就是对数据的协方差矩阵进行了类似的分解（特征值分解），但这种分解只适用于对称的矩阵，而 SVD 则是对任意大小和形状的矩阵都成立。（SVD 和特征值分解有着非常紧密的联系，此为后话）

我们再回顾一下，主成分分析有什么作用？答曰，降维。换言之，就是用几组低维的主成分来记录原始数据的大部分信息，这也可以认为是一种信息的（有损）压缩。在 SVD 中，我们也可以做类似的事情，也就是用更少项的求和`\(M_k\)`来近似完整的`\(n\)`项求和。为什么要这么做呢？我们用一个图像压缩的例子来说明我们的动机。

我们知道，电脑上的图像（特指位图）都是由像素点组成的，所以存储一张 1000×622 大小的图片，实际上就是存储一个 1000×622 的矩阵，共 622000 个元素。这个矩阵用 SVD 可以分解为 622 个矩阵之和，如果我们选取其中的前 100 个之和作为对图像数据的近似，那么只需要存储 100 个奇异值`\(d_i\)`，100 个`\(u_i\)`向量和 100 个`\(v_i\)`向量，共计 100×(1+1000+622)=162300个 元素，大约只有原始的 26% 大小。

【注：本文只是为了用图像压缩来介绍 SVD 的性质，实际使用中常见的图片格式（png，jpeg等）其压缩原理更复杂，且效果往往更好】

为了直观地来看看 SVD 压缩图像的效果，我们拿一幅 1000×622 的图片来做实验（图片来源：<http://www.bjcaca.com/bisai/show.php?pid=33844&bid=40>）

![SVD演示图片，原图](https://uploads.cosx.org/2014/02/pic2.jpg)
![svd_1](https://uploads.cosx.org/2014/02/svd_1.jpg)
![svd_5](https://uploads.cosx.org/2014/02/svd_5.jpg)
![svd_20](https://uploads.cosx.org/2014/02/svd_20.jpg)
![svd_50](https://uploads.cosx.org/2014/02/svd_50.jpg)
![svd_100](https://uploads.cosx.org/2014/02/svd_100.jpg)

可以看出，当取一个成分时，景物完全不可分辨，但还是可以看出原始图片的整体色调。取 5 个成分时，已经依稀可以看出景物的轮廓。而继续增加`\(k\)`的取值，会让图片的细节更加清晰；当增加到 100 时，已经几乎与原图看不出区别。

接下来我们要考虑的问题是，`\(A_k\)` 是否是一个好的近似？对此，我们首先需要定义近似好坏的一个指标。在此我们用`\(B\)`与`\(M\)`之差的 Frobenius 范数 `\(||M – B||_F\)` 来衡量`\(B\)`对`\(M\)` 的近似效果（越小越好），其中矩阵的 Frobenius 范数是矩阵所有元素平方和的开方，当其为 0 时，说明两个矩阵严格相等。

此外，我们还需要限定 `\(A_k\)` 的“维度”（否则 `\(M\)`就是它对自己最好的近似），在这里我们指的是矩阵的[秩](http://zh.wikipedia.org/wiki/%E7%A7%A9_%28%E7%BA%BF%E6%80%A7%E4%BB%A3%E6%95%B0%29)。对于通过 SVD 得到的矩阵`\(M_k\)`，我们有如下的结论：

> 在所有秩为`\(k\)`的矩阵中，`\(M_k\)`能够最小化与`\(M\)`之间的 Frobenius 范数距离。

这意味着，如果我们以 Frobenius 范数作为衡量的准则，那么在给定矩阵秩的情况下，SVD 能够给出最佳的近似效果。万万没想到啊。

在R中，可以使用 `svd()` 函数来对矩阵进行 SVD 分解，但考虑到 SVD 是一项计算量较大的工作，我们使用了 [rARPACK](http://cran.r-project.org/web/packages/rARPACK/index.html) 包中的 `svds()` 函数，它可以只计算前`\(k\)`项的分解结果。完整的 R 代码如下：

```r
library(rARPACK);
library(jpeg);

factorize = function(m, k)
{
    r = svds(m[, , 1], k);
    g = svds(m[, , 2], k);
    b = svds(m[, , 3], k);
    return(list(r = r, g = g, b = b));
}

recoverimg = function(lst, k)
{
    recover0 = function(fac, k)
    {
        dmat = diag(k);
        diag(dmat) = fac$d[1:k];
        m = fac$u[, 1:k] %*% dmat %*% t(fac$v[, 1:k]);
        m[m < 0] = 0;
        m[m > 1] = 1;
        return(m);
    }
    r = recover0(lst$r, k);
    g = recover0(lst$g, k);
    b = recover0(lst$b, k);
    m = array(0, c(nrow(r), ncol(r), 3));
    m[, , 1] = r;
    m[, , 2] = g;
    m[, , 3] = b;
    return(m);
}

rawimg = readJPEG("pic2.jpg");
lst = factorize(rawimg, 100);
neig = c(1, 5, 20, 50, 100);
for(i in neig)
{
    m = recoverimg(lst, i);
    writeJPEG(m, sprintf("svd_%d.jpg", i), 0.95);
}
```

参考文献

  1. [Image Compression with the SVD in R](http://www.johnmyleswhite.com/notebook/2009/12/17/image-compression-with-the-svd-in-r/)
  2. [Foundations of Data Science](http://www.cs.cornell.edu/jeh/book112013.pdf)
  3. [SVD维基页面](http://en.wikipedia.org/wiki/Singular_value_decomposition)
