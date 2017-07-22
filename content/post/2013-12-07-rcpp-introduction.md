---
title: Rcpp简明入门
date: '2013-12-07T12:25:21+00:00'
author: 张晔
categories:
  - 统计软件
tags:
  - C/C++
  - cppFunction
  - Rcpp
  - R包开发
  - sourceCpp
slug: rcpp-introduction
forum_id: 418991
---

Rcpp牛到什么程度，我想不用我多说。光是看Author五人组的名字就足够唬人了（简直是R包开发男子天团了）。最近正在为实验室开发R包（平生第一次），愉快地用起了Rcpp。有过这些天之后觉得感觉真的很好，于是也就厚颜无耻地写篇小文介绍一下。以下的内容都是在Linux下完成了，Windows的朋友们需要安装Rtools才能用上Rcpp。

# 1. cppFunction和sourceCpp

首先我们来看看第一个例子。

```cpp
cppFunction(
    'int fib_cpp_0(int n){
         if(n==1||n==2) return 1;
         return(fib_cpp_0(n-1)+fib_cpp_0(n-2));
    }'
)
```

这个例子是老掉牙的计算第n个Fibonacci数的函数，不过既然Dirk老爷子也用这个例子，我们也就将就一下把。运行这段代码之后，你可以在R的Workplace中看到一个名为fib\_cpp\_0的函数。我们来看看跟R版本的Fib_r的对比。

```r
fib_r <- function(n){
    if(n==1||n==2) return(1)
    return(fib_r(n-1)+fib_r(n-2))
}
```


  
这两个函数运行的时间对比如下：

```r
> system.time(fib_r(30))
   user  system elapsed
  3.080   0.000   3.083
> system.time(fib_cpp_0(30))
   user  system elapsed
  0.004   0.000   0.004
```

在这个对比中，我们可以发现，`fib_cpp_0`比`fib_r`快得多了。虽然如此，我觉得这个比较没有什么意思，原因在于这个对比中没有体现R向量化运算的优势。不过考虑到相当多的人在写R的代码时根本不考虑向量化（我忏悔，我就是其中之一），Rcpp还真的能解决很多效率问题。

我并不喜欢`cppFunction`这种C++代码和R代码混合在一起的风格。Rcpp提供了另外一种方法让我们简单调用C++代码: `sourceCpp`(有没有想起R里面的source？）

```cpp
#include <Rcpp.h>
using namespace Rcpp;

//[[Rcpp::export]]
int fib_cpp_1(int n)
{
    if(n==1||n==2) return 1;
    return fib_cpp_1(n-1)+fib_cpp_1(n-2);
}
```

在R中只要调用

```r
sourceCpp("fib_cpp_1.cpp")
```

于是我们又得到了一个`fib_cpp_1`函数。它跟`fib_cpp_0`的对比如下：

```cpp
> system.time(fib_cpp_0(50))
用户    系统    流逝 
194.077   0.153 195.575 
> system.time(fib_cpp_1(50))
用户    系统    流逝 
152.336   0.221 157.190
```

在上面可以看出用`sourceCpp`生成的函数`fib_cpp_1`在计算速度上比用`cppFunction`生成的`fib_cpp_0`更快。至于原因是什么，我还没有发现，一旦发现，我很乐意再次写出来跟大家分享。

其实，`cppFunction`和`sourceCpp`的本质是什么？

我们来回忆一下在没有Rcpp之前我们是如何调用C/C++的。在那个年代，我们会先写出C/C++的代码，然后用`R CMD SHLIB`生成一个动态链接库，然后再用`dyn.load`载入这个动态链接库。最后用`.Call`(或者.C，当然这个太老了），调用库中的函数。

然后我们直接输入`fib_cpp_1`看看它们的庐山真面目：

```cpp
function (n)
.Primitive(".Call")(, n)
```

从上面我们可以看到，其实通过`cppFunction`和`sourceCpp`得到的这个函数，本质上还是用`.Call`调用动态链接库中编译好的C++函数。只不过Rcpp帮你把一些麻烦的步骤省略下来了。

# 2. 编译动态链接库

Rcpp自带了一个函数`SHLIB`这个函数可以帮你将使用了Rcpp.h的cpp文件编译成动态链接库。这个函数源代码在Rcpp包中SHLIB.R下面。你可以在R的控制台中调用

```r
Rcpp:::SHLIB("test.cpp")
```

来编译你的动态链接库。之所以要加前面这一串，是因为这个函数没有在Rcpp包的namespace中export。当然你在shell下面可以用

```shell
Rscript -e "Rcpp:::SHLIB('test.cpp')"
```

来编译（这个技巧来自([http://thirdwing.github.io/2013/10/25/rcpp/](http://thirdwing.github.io/2013/10/25/rcpp/ "Rcpp的前世今生") ).

如果我们进去看看这个函数的源代码，我们会发现，其实它做的事情就是为编译器指明库的位置（通过添加环境变量）。

如果要用这种方法调用cpp程序的话，cpp的写法会有一些规定，当然这跟平时我们直接用R API调用C语言的写法很相似。所以如果大家只是想用C/C++来解决性能瓶颈的话，我建议大家还是使用`sourceCpp`或者`cppFunction`好了。

# 3. 用Rcpp开发R package

一如R自家踢狗的`package.skeletion`一样，Rcpp提供了一个函数`Rcpp.package.skeletion`，运行这个函数：

```r
Rcpp.package.skeletion("RcppDemo")
```

然后你就可以在当前工作目录下找到一个名为RcppDemo的目录，目录的结构如下：

```r
Demo
|-- DESCRIPTION
|-- man
|   |-- Demo-package.Rd
|   `-- rcpp_hello_world.Rd
|-- NAMESPACE
|-- R
|   `-- RcppExports.R
|-- Read-and-delete-me
`-- src
    |-- Makevars
    |-- Makevars.win
    |-- RcppExports.cpp
    `-- rcpp_hello_world.cpp
```

不过说回来，每个R package都差不多的啦。这个几乎是空的package里面已经有一个写好的Hello world函数。当然我们这里就不拿这个经典函数来作例子了。

```r
#include <Rcpp.h>
using namespace Rcpp;

RcppExport SEXP dftest(SEXP df, SEXP vname)
{
    DataFrame DF = as<DataFrame>(df);
    std::string var = as<std::string>(vname);
    NumericVector v = DF[var];
    return(wrap(v));
}
```

在R文件夹下面，我们再定义如下函数：

```r
DFtest <- function(dframe, varname){
    vcol <- .Call("dftest", dframe, varname)
    return(vcol)
}
```

这个函数的作用是返回一个data.frame中的一列，这一列的名字由用户提供。假设你把这个Demo打包了，然后安装载入，你就可以调用`DFtest`。假设你调用`DFtest(cars, "speed")`，那么你会得到`cars$speed`。

这个例子其实也没有太多的技术含量。不过还是有一点意思的。我们可以先看看其中的源代码。

第一行指明需要用到Rcpp.h。第二行指明命名空间是Rcpp。

第三行中的RcppExport的作用是，当你把这个cpp文件编译成动态链接库之后，RcppExport后面的函数可以被.Call调用。而实际上这个RcppExport是一个宏。根据["[Rcpp-devel] What are RcppExport, BEGIN_RCPP and END_RCPP?"](http://lists.r-forge.r-project.org/pipermail/rcpp-devel/2011-October/003043.html) 的说法：

```r
#define RcppExport extern "C"
```

第三行中，我们传入了两个`SEXP`作为参数。这两个参数在第四行和第五行中用函数`Rcpp::as`分别转换为`DataFrame`和`std::string`。第六行中我们取出这个数据框中名为var的那一列，赋值给一个`NumericVector`.

在最后一行`Rcpp::wrap`将这个`NumericVector`重新转换成一个`SEXP`，然后传回R中。

# 4. 总的来说

因为Rcpp，我们可以在C++中操作一些我们熟悉的R对象，而且更妙的是，分配内存这种粗重功夫不用我们自己撸袖子上了，实在可喜可贺。当然现在还有一些问题，比方说，现在我们在C++中操作DataFrame的时候，还不能像在R中随意切割那么潇洒，再比如，虽然Rcpp中的sugar可以让我们直接将一个`NumericVector`与一个数值比较，然后得到一个`LogicalVector`，但我们无法用类似R中`A[B>0]`这样的语句去操作C++中的`NumericVector`或者DataFrame（或者已经有了而我不知道）。

虽然如此，但是Rcpp的前景还是一片光明的，利用Rcpp来开发R package是一件愉快的事情。我们莫忘了Rcpp开发出来的目的，不在其速度，而在于它让我们能更好地进行R的开发。
