---
title: 聊聊R和GPU
date: '2013-10-07T10:30:11+00:00'
author: 寇强
categories:
  - 统计软件
  - 软件应用
tags:
  - CUDA
  - GPGPU
  - GPU
  - gputools
  - HiPLARM
  - rpud
  - R语言
  - 大数据
  - 高性能计算
slug: gossip-r-gpu
forum_id: 418974
---

> 注：本文来自寇强的博客，[原文请点击此处](http://thirdwing.github.io/2013/09/27/rgpu/)。
  
> 寇强：现为Indiana University PhD in Informatics。
  
> 微博：[@没故事的生科男](http://weibo.com/thirdwing?topnav=1&wvr=5&topsug=1)。

这是一直想写几句的一个话题，既然今天有时间就聊一聊。

GPGPU算是近几年兴起的一个领域，以CUDA为代表，在高性能计算方面成果相当多。作为一种相对廉价的高性能解决方案，越来越多的程序员开始加入GPGPU阵营。Andrew Ng（就是那个Machine Learning公开课的Andrew）去年在Google用造价大约一百万美的集群完成了猫脸识别，而这个月他刚刚宣布他的团队用造价两万美元的GPU集群，达到了同样的效果（[论文在这儿](http://stanford.edu/~acoates/papers/CoatesHuvalWangWuNgCatanzaro_icml2013.pdf)）。从这里我们也可以大致看出GPU在Machine Learning方面的潜力。

在这个所谓的“大数据时代”，大规模机器学习似乎是个必须要解决的问题，而个人观点觉得Hadoop这种MapReduce平台不适合相对密集型的机器学习。从报道上看，UCBerkely开发的Spark平台在这个方面要远远优于Hadoop，但Spark没玩过，今天还是聊聊以前玩过的GPU。

GPGPU的解决方案有不止一个，但由于英伟达集团的大力推广，CUDA可能是支持最好，也是使用最多的，后面提到的GPU也都默认是他家的，所以真正的题目应该是“R和CUDA”。我的测试和开发环境是ubuntu，后面提到的测试和配置也都是ubuntu下面的。


# 一、GPU的优势 {#gpu}

我们不说latency之类的术语，只举个简单的例子。现在全班要去春游，你有一辆保时捷和一辆大巴：保时捷只有四个座位，但半个小时就到了；大巴有50个座位，但要一个多小时。为了让全班尽早过去，大巴一定是首选。从计算的角度看，各位的CPU就是保时捷，GPU就是大巴。GPU每个核心都很弱，但众多的核心还是让GPU在并行计算上拥有了相当的优势。另外一点，GPU有相当的价格优势。单纯从浮点数计算能力来看，300块左右的GT430（91.564G）已经接近于2000块左右的i7（107.6G）。

# 二、GPU的弱势 {#gpu}

简单地讲，不是所有运算都可以并行化，其实这也是并行计算的弱势。但几乎所有矩阵运算都有并行化的可能，所以Machine Learning的很多方法移植到GPU还是相当有搞头的。

# 三、用GPU的几个R package {#gpur_package}

估计多数人都没有精力自己写CUDA的代码，我们先来看看和GPU有关的几个package，今天只聊我用过的三个，也就是前三个。

  * gputools
  * HiPLARM
  * rpud
  * magma
  * gcbd
  * OpenCL
  * WideLM
  * cudaBayesreg
  * permGPU

# 四、安装和环境配置 {#id1}

现在CUDA的安装配置应该已经简单很多了，以ubuntu为例，基本只要下载对应的deb文件，用apt-get就可以完成了，具体请参考[CUDA zone](https://developer.nvidia.com/cuda-downloads)网站。

安装之后就是配置工作，主要是`$PATH（/usr/local/cuda-5.5/bin）`、`$CUDA_HOME（/usr/local/cuda-5.5）`和`$LD_LIBRARY_PATH（/usr/local/cuda-5.5/lib64）`这几个环境变量的配置。我这里给出的都是默认位置，大家搞清楚自己的CUDA安装在哪里就OK了。

## 1. gputools的安装和示例 {#gputools}

[gputools](http://cran.r-project.org/web/packages/gputools/index.html)基本上是最具通用性的package，由[Michigan大学开发](http://brainarray.mbni.med.umich.edu/brainarray/rgpgpu/)。

这个package已经在CRAN上了，但直接install.package还是可能出错，其实还是环境变量的问题。如果CUDA_HOME没有问题的话，检查一下src文件夹下的config.mk，看下面三个变量是不是和自己的一致。如果不一致，应该会报告找不到R.h之类的错误。检查过之后就可以R CMD INSTALL gputools了。

```bash
R_HOME := $(shell R RHOME)
R_INC := $(R_HOME)/include
R_LIB := $(R_HOME)/lib 
```

这里拿一个矩阵相乘做例子，测试函数如下：

```r
library(gputools)
gpu.matmult <- function(n) {
    A <- matrix(runif(n * n), n ,n)
    B <- matrix(runif(n * n), n ,n)
    tic <- Sys.time()
    C <- A %*% B
    toc <- Sys.time()
    comp.time <- toc - tic
    cat("CPU: ", comp.time, "\n")
    tic <- Sys.time()
    C <- gpuMatMult(A, B)
    toc <- Sys.time()
    comp.time <- toc - tic
    cat("GPU: ", comp.time, "\n")
}
```

可以明显地看到，在维度比较低的时候，GPU没有任何优势。

```r
gpu.matmult(5)
```

```
## CPU:  0.0001199245 
## GPU:  0.2105169 
```

```r
gpu.matmult(50)
```

```
## CPU:  0.000446558 
## GPU:  0.003529072 
```

```r
gpu.matmult(500)
```

```
## CPU:  0.07863498 
## GPU:  0.02003336 
```

开始有优势了！

```r
gpu.matmult(1000)
```

```
## CPU:  0.7417495 
## GPU:  0.09884238 
```

```r
gpu.matmult(2000)
```

```
## CPU:  5.727753 
## GPU:  0.7211812 
```

## 2. rpud的安装和示例 {#rpud}

rpud是著名的R Tutorial网站开发的，[下载界面](http://www.r-tutor.com/content/download)提供了三个package，RPUD、RPUDPLUS和RPUSVM。其中只有rpud是开源的，后两个只提供了编译好的文件。

rpud的安装就容易多了，添加一个R\_LIBS\_USER环境变量，之后直接安装即可。

拿Matrix Distance举个例子：

```r
test.data <- function(dim, num, seed = 17) {
    set.seed(seed)
    matrix(rnorm(dim * num), nrow = num)
}
m <- test.data(120, 4500)
system.time(dist(m))
```

```
##    user  system elapsed 
##  13.944   0.016  13.977
```

```r
library(rpud)
```

```
## Rpud 0.3.4
## http://www.r-tutor.com
## Copyright (C) 2010-2013 Chi Yau. All Rights Reserved.
## Rpud is licensed under GNU GPL v3. There is absolutely NO warranty.
```

```r
system.time(rpuDist(m))
```

```
##    user  system elapsed 
##   0.452   0.248   0.702
```

加速效果还不错，但不开源就着实让人不爽了。

## 3. HiPLAR的安装和示例 {#hiplar}

HiPLAR是High Performance Linear Algebra in R的缩写，这个package的配置略复杂，因为调用的library略多。不过好在提供了installer，一般也不会出错。这里直接拿官方例子说话吧。

```r
library(Matrix);
n <- 8192;
X <- Hilbert(n);
A <- nearPD(X);
system.time(B <- chol(A$mat));
```

```
## user  system elapsed  
## 97.990   0.356  98.591
```

```r
library(HiPLARM)
system.time(B <- chol(A$mat));
```

```
## user  system elapsed 
## 1.012   0.316   1.337
```

# 五、调用CUDA {#rcuda}

用了各种package，但很多时候还是要自己写CUDA代码，这个也是我正在做的。

这里用的是Matloff老爷子的[Programming on Parallel Machines](http://heather.cs.ucdavis.edu/~matloff/158/PLN/ParProcBook.pdf)里的例子。具体的CUDA语法这里就不聊了，我入门是[Udacity](https://www.udacity.com/course/cs344)上的视频，这里也推荐给大家。

CUDA是基于C的，所以调用CUDA和调用C没有多少不同。调用C的时候，是把C文件用R CMD SHLIB编译成so，之后用R调用。稍微注意一下R CMD SHLIB的输出，其实就什么都明白了。

```bash
$ R CMD SHLIB sd.c
gcc -std=gnu99 -I/usr/share/R/include -DNDEBUG -fpic  -O3 -pipe  -g  -c sd.c -o sd.o
gcc -std=gnu99 -shared -o sd.so sd.o -L/usr/lib/R/lib -lR
```

R CMD SHLIB只是自动调用了下面那两行，对于CUDA，我们手动写就行了。

CUDA代码如下：

```cpp
#include<cuda.h>;
#include<stdio.h>;

extern "C" void meanout(int *hm, int *nrc, double *meanmut);

__device__ void findpair(int tn, int n, int *pair)
{
    int sum = 0, oldsum = 0, i;
    for(i = 0; ; i++){
        sum += n - i - 1;
        if(tn <= sum - 1){
	pair[0] = i;
	pair[1] = tn - oldsum + i + 1;
	return;
	}

        oldsum = sum;
    }

}

__global__ void proc1pair(int *m, int *tot, int n)
{
    int pair[2];
    findpair(threadIdx.x, n, pair);
    int sum = 0;
    int startrowa = pair[0], startrowb = pair[1];
    for (int k = 0 ; k < n ; k++)
        sum += m[startrowa + n*k]*m[startrowb + n*k];
    atomicAdd(tot, sum);
}

void meanout(int *hm, int *nrc, double *meanmut)
{
    int n = *nrc, msize = n*n*sizeof(int);
    int *dm, htot, *dtot;
    cudaMalloc((void **)&dm, msize);
    cudaMemcpy(dm, hm, msize, cudaMemcpyHostToDevice);
    htot = 0;
    cudaMalloc((void **)&dtot, sizeof(int));
    cudaMemcpy(dtot, &htot, sizeof(int), cudaMemcpyHostToDevice);

    dim3 dimGrid(1, 1);
    int npairs = n*(n - 1)/2;
    dim3 dimBlock(npairs, 1, 1);
    proc1pair&lt;&lt;&lt;dimGrid, dimBlock&gt;&gt;&gt;(dm, dtot, n);
    cudaThreadSynchronize();
    cudaMemcpy(&htot, dtot, sizeof(int), cudaMemcpyDeviceToHost);
    *meanmut = htot/double(npairs);
    cudaFree(dm);
    cudaFree(dtot);
}
```

编译选项如下：

```bash
$ nvcc -g -G -I/usr/local/cuda/include -Xcompiler "-I/usr/share/R/include -fpic" -c mutlinksforr.cu -o mutlink.o -arch=sm_11
$ nvcc -shared -Xlinker "-L/usr/lib/R/lib -lR" -L/usr/local/cuda/lib mutlink.o -o meanlinks.so
```

R里的调用和输出

```r
dyn.load("meanlinks.so")
m <- rbind(c(0, 1, 1, 1), c(1, 0, 0, 1), c(1, 0, 0, 1), c(1, 1, 1, 0))
ma <- rbind(c(0, 1, 0), c(1, 0, 0), c(1, 0, 0))
.C("meanout", as.integer(m), as.integer(4), mo = double(1))
```

```
## [[1]]
##  [1] 0 1 1 1 1 0 0 1 1 0 0 1 1 1 1 0
## 
## [[2]]
## [1] 4
## 
## $mo
## [1] 1.333
```

# 六、最后 {#id2}

今晚有时间，所以就大致聊了聊R和GPU，准确地说是R和CUDA。利用GPU做machine learning是我现在除去实验室项目之外，最大的兴趣所在。现在先从Back-Propagation开始，也许明年会有一个基于GPU的machine learning的package出来，但不保证开发进度呀。（如果真的发布0.1版本，不知道中国R语言大会能不能混个演讲。）

特别提一点，这是我笔记本上的测试结果，显卡是GT 720M，这个并不是专业的计算卡，如果动用Tesla，效果应该明显得多。刚刚拿到学校的GPU集群的帐号，哪天可以试一试。
