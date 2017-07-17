---
title: 在Batch Mode下完成无人值守的R项目测试
date: '2009-03-21T12:28:31+00:00'
author: 齐韬
categories:
  - 统计软件
tags:
  - R语言
  - simulation
  - 批处理
  - 测试
slug: running-r-in-batch-mode
forum_id: 418782
---

今天我来谈一点用R编程的经验吧。好像R的很多方面许多牛人都谈过了，比如R的打包啊，R的图形啊，下面我来谈谈R的测试。如果希望真正学到什么的话，还是要自己花时间实践的。

在很多情况下，你自己或和你的团队在一起开发一个R的项目，而伴随着开发的深入，测试就成了家常便饭。但是往往很多统计算法涉及到比较大的计算，比方说missing data的模型，比方说具有多层次结构的模型。测试这些R程序需要花费大量的时间。当然了如果你的程序规模很小，计算量也不大的情况下，大可不必杀鸡用牛刀，但是一般情况下，再小的一段统计算法，如果需要做一系列的simulation或是case study的话，测试都会花很多的时间。比如，如果你有几个实现了推广的ROC模型的R函数，或者是一个包含这些函数的R包，没有人能说这个程序真正管用，你要测试，那你就需要做simulation和case study。simulation简单的就是模拟出一系列预先设定模型参数的数据，让目标模型去fit，然后比较结果。case study则可以做各式各样的比较研究，特定数据的实例分析等等。好了，废话不多说，总之这篇文章就是告诉你怎么样方便地测试，随时随地想测就测。
<!--more-->

其实核心就是调用Rterm，包含的主要文件如下:

（1）创建文件：Rbatch.bat
```bash
cd test
date /T >> logout.txt
time /T >> logout.txt
cd ..
C:\Progra~1\R\R-2.8.0\bin\Rterm.exe --vanilla <config.R> testout.txt
```

（2）创建文件：`config.R`

如果你已经打好了R包，一下的代码可以减少，只要load你的包就好了。

下面的版本是你还没有打包，但是调用了C++动态链接库，测试数据，和函数源代码需要source

```r
# PATH
#---------------------------------------------------------
Path.autorun <- "C:\\autorun\\"
Path.rdll <- "C:\\WORK\\Project\\src\\C++\\bin\\"
Path.data <- "C:\\WORK\\Project\\Datasets\\Data\\R\\"
Path.funs <- "C:\\WORK\\Project\\src\\R\\"
Path.dump <- "C:\\autorun\\results\\"
#---------------------------------------------------------
dyn.load(paste(Path.rdll,"RDLL.dll",sep=""))

source(paste(Path.autorun,"source.data.R",sep=""))
source(paste(Path.autorun,"source.funs.R",sep=""))
source(paste(Path.autorun,"source.test.R",sep=""))
source(paste(Path.autorun,"testProjectR.R",sep=""))

source.data(Path.data)
source.funs(Path.funs)
testProjectR(paste(Path.autorun,"test\\",sep=""),TEST=0)
```

（3）在testProjectR.R 文件中创建测试框架函数testProjectR：

```r
testProjectR <- function(loc=getenv("STEST"), TEST=c(0,1,2)) {
## loc: the directory of the Project testing suite
## TEST: (0: the default loop test, 1: test buglist only, 2: loop test and test buglist
if (loc!="") dirOfRTestSuite <- loc
else stop("Specify the directory of testing suite to loc.")
print(dirOfRTestSuite)
TESTBUG <- TEST[1]
tests <- character(0)
if (TESTBUG != 1) tests <- scan(paste(dirOfRTestSuite,"testlist",sep=""),what=character(0))
if (TESTBUG != 0) tests <- c(tests, scan(paste(dirOfRTestSuite,"buglist",sep=""),what=character(0)))
print(tests)
for ( i in 1: length(tests) )
{
print(paste(dirOfRTestSuite,tests[i],sep=""))
source(paste(dirOfRTestSuite,tests[i],sep=""))
}
invisible()
}
```

（4）在`\test`目录下创建`testlist`文件,里面写你要测试的文件名

运行`Rbatch.bat`，开始测试。

在测试函数中通过用`try`命令，实现对异常的收集，而不直接跳出测试。

![batch mode](https://uploads.cosx.org/2009/03/batch.jpg)
