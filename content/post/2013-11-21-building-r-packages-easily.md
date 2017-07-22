---
title: 极简 R 包建立方法
date: '2013-11-21T11:07:48+00:00'
author: 黄俊文
categories:
  - 统计之都
  - 统计软件
  - 软件应用
tags:
  - R包
  - R文档
  - R语言
  - 创建R包
slug: building-r-packages-easily
forum_id: 418988
---

# 前言 

最近想试一下捣腾一个 R 包出来，故参考了一些教程。现在看到的最好的就是谢益辉大大之前写过的[开发R程序包之忍者篇](/2011/05/write-r-packages-like-a-ninja/)，以及 Hadley 大神（ggplot2 devtools 等一系列包的作者）的 [教程](http://adv-r.had.co.nz/#package-development)。但是前者有一些过时，后者是全英文的，所以我这里记录一下比较简单的过程，给读者们一个参考思路。如果你有一些 R 程序，想塞到去一个自创的 R 包中，那么这篇文章就可能是你想要的。为了方便说明，这里用我的包来进行示例。


# 准备工作

1. 安装好 R。
2. 可能需要 RStudio，没有的话也没有影响。
3. 如果你是 Windows 下，请安装 rtools，去官网下载 exe 安装；如果你是 Linux 下，请安装对应的 R 开发包，Debian/Ubuntu 下就是运行命令 `sudo apt-get install r-base-dev`；如果你是 OS X 下，要装好 command-line-tools，如果你没有装过的话，Terminal 运行 `git` 或者 `xcode-select` 应该会弹出安装提示，按提示安装即可。
4. 打开 R 环境，运行 `install.packages('devtools',dependencies=T)` 。
5. 有一个编辑代码的程序，比如说 Sublime Text，notepad++，请不要用记事本编辑代码！另外要记得把文件保存成 UTF-8 (without BOM) 编码！
6. 你要有一堆已经正确运行成功的 R function(s)，你想把它们塞到你的 R 包中。

前面那些（除了第 6 点）是你想要写 R 程序包的先决条件（开发链），接下来就是开始写包的节奏了。注意这里不是所谓官方的写法，也不是最完美的写法，写出来也不能够保证能够放到 CRAN 上面啦。但是生成的东西应该是能够被别人安装并且运行的（要求真低 =_=///）。

# 编写 

## 骨架 

```r
library('devtools') # 开发 R 包黑魔法工具
create('~/somebm') # 建立 R 包的目录， somebm 就是你想要的包的名称
setwd('~/somebm') # 把工作目录放到 R 包中的目录，开发 R 包过程中始终推荐这样做。
dir() # 列出当前工作目录的文件和文件夹
```

以上的过程，就是建立一个最基本的 R 包的目录骨架，并且把骨架文件夹作为当前工作空间。看一下生成的文件夹有什么东西：一个叫 `R` 的文件夹，一个叫 `man` 的空文件夹，一个叫 `DESCRIPTION` 的文件。

## 添加 DESCRIPTION 

实际上，我们最简单（但能用）的 R 包，只需要操作 `R` 文件夹中的文件，和 `DESCRIPTION` 文件即可！

简单一点，先看看 `DESCRIPTION` 文件内容（用代码编辑器或者 `file.edit('DESCRIPTION')`）

```r
Package: somebm
Title: 
Description: 
Version: 0.1
Authors@R: # getOptions('devtools.desc.author')
Depends: R (>= 3.0.2)
License: # getOptions('devtools.desc.license')
LazyData: true
```

一一填写就可以。比如说我开发包，是关于布朗运动的，想要 MIT 协议发行我的代码，我就把这个文件的内容改成这样：

```r
Package: somebm
Title: some Brownian motions simulation functions
Description: some Brownian motions simulation functions
Version: 0.1
Author: Laowu Wang <wanglaowu@mail.example.com>
Depends:
    R (>= 3.0.2)
License: MIT
LazyData: true
```

保存就可以了！如无意外，这个文件不需要再多的改动了！

## 添加 `*.R` 文件 

接下来我们的关注点就是包文件夹中 `R` 文件夹中的文件了。

这个文件夹下，应该放着所有的自创的 R 代码。至于怎样放，放到哪个文件中，几乎无所谓，只要（你觉得）有美感，不凌乱，即可。

需要说明的是，在此目录下一个 `somebm-package.r` （`<packagename>-package.r`）的文件已经被创建了，这个文件应该被保留下作为这个包的描述文件，最好不要放自创函数进去这里。

Talk is cheap。我这里给一个例子。

在此目录中，建立一个叫 bm.R 的文件。由于我这个包是用于模拟布朗运动的，这里把已经写好的模拟布朗运动的函数塞进去，在 bm.R 中写入：

```r
fbm <- function(hurst=0.7, n=100){
  delta <- 1/n
  r <- numeric(n+1)
  r[1] <- 1
  for(k in 1:n)
    r[k+1] <- 0.5 * ((k+1)^(2*hurst) - 2*k^(2*hurst) + (k-1)^(2*hurst))
  r <- c(r, r[seq(length(r)-1, 2)])
  lambda <- Re((fft(r)) / (2*n))
  W <- fft(sqrt(lambda) * (rnorm(2*n) + rnorm(2*n)*1i))
  W <- n^(-hurst) * cumsum(Re(W[1:(n+1)]))
  X <- ts(W, start=0, deltat=delta)
  return(X)
}
```

保存。在 R 或 RStudio 中运行

```r
#setwd('~/somebm') # 如果之前的 R 环境没有关闭的话，这一步是不需要的。
load_all() # 把包骨架文件夹中的 R 文件夹中的所有 .R 文件读进来
fbm() # 测试自己写的程序
fbm(hurst=0.2, n=1000) # 再测试自己写的程序
```

`load_all()` 函数很神奇地把包骨架文件夹中的 R 文件夹中的所有 .R 文件读进来了；每一次你改进你的 `*.R` 文件，只要运行一次 `load_all()` 就会把最新的自创函数们拉进来，在 R 环境中就可以测试最新的代码是否正常。

慢着…… 你可能忘记了一些东西……

## 文档和注释 

> 代码不写注释是万恶之源
  
> — 阿不思*邓布利多

别的可以省略，文档和注释是绝对不可以省略的。

实际上，R 包规定了每一个（对外）的函数和变量和数据结构，都要有对应的解释等；在 man 文件夹中会有对应的 `*.Rd` 文件，里面是由奇奇怪怪的东西（R+LaTeX）写成的。我们可以用比较简洁的方式来写函数注释，然后用一些方法来生成对应的 `*.Rd` 文件。

具体地说，先修改 bm.R 文件：

```r
#' Generate a time series of fractional Brownian motion.
#'
#' This function generatea a time series of one dimension fractional Brownian motion.
#' adapted from http://www.mathworks.com.au/matlabcentral/fileexchange/38935-fractional-brownian-motion-generator .
#'
#' @param hurst the hurst index, with the default value 0.71
#' @param n the number of points between 0 and 1 that will be generated, with the default value 100
#' @export
#' @examples
#' fbm()
#' plot(fbm())
#' d <- fbm(hurst=0.2, n=1000)
#' plot(d)
fbm <- function(hurst=0.7, n=100){
  delta <- 1/n
  r <- numeric(n+1)
  r[1] <- 1
  for(k in 1:n)
    r[k+1] <- 0.5 * ((k+1)^(2*hurst) - 2*k^(2*hurst) + (k-1)^(2*hurst))
  r <- c(r, r[seq(length(r)-1, 2)])
  lambda <- Re((fft(r)) / (2*n))
  W <- fft(sqrt(lambda) * (rnorm(2*n) + rnorm(2*n)*1i))
  W <- n^(-hurst) * cumsum(Re(W[1:(n+1)]))
  X <- ts(W, start=0, deltat=delta)
  return(X)
}
```

函数头顶上的一连串注释就是了。注意这种注释是 `#'` 开头的，会由 `devtools` 里面的辅助函数来进行处理。先是函数简短说明，再是具体说明，然后是由 `#' @param` 开头的行就是对每个参数的说明。接下来，对用户使用的函数都要顶上一个 `#' @export` 行。最后，`#' @examples` 接下来的行就是示例用法啦。

只要运行
```r
document()
```

就会生成对应的 `*.Rd` 文件在 `man` 文件夹中。

## 打包 

一个命令

```r
build()
```

就会在与包文件夹平行的文件夹中生成 `somebm_0.1.tar.gz` 类似的打包文件。可以在 R 环境中使用 `install.packages('~/somebm_0.1.tar.gz', type='source')` 来安装！

恭喜！你基本完成了一个包了！

# 提交到 CRAN！ 

什么！想提交到 CRAN 上面？

首先你要在包的工作空间里面运行

```r
check()
```

尽量排除所有的 errors notes。

如果不放心的话，还可以在 terminal 环境，对前面 `build()` 生成的包用 R 自带的命令检查：

```r
R CMD check --as-cran ~/somebm_0.1.tar.gz
```
尽量排除所有的 errors notes。

以上两个命令应该没啥大区别，当然检查多几次是好的。

接着阅读 [CRAN Repository Policy](http://cran.r-project.org/web/packages/policies.html)，确保没有违反什么 policy 啦。

最后在 <http://cran.r-project.org/submit.html> 提交即可。按照提示上传 tar 包，填写资料等。有问题的话过不久管理员会发信息到电子邮件，按照电子邮件修改之后再上传。

# 忽然间就完结了…… 吗？ 

经过刚才的步骤，可以说已经建造好一个包了。成就感满满的！

当然，官方文档那些详尽（又臭又长）的说明文是有着更加细致和更加多功能的介绍的。比如说 demo 啊，dataset 啊，test 啊，还有关于 S3 S4 的函数啊什么的。各位有兴趣的还可以继续深入考察！

最后的最后，本文示例的所有代码在[这里](https://github.com/fyears/somebm), `man` 文件夹和 `NAMESPACE` 文件都是自动生成的。
