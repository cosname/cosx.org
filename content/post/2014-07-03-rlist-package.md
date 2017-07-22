---
title: rlist：基于list在R中处理非关系型数据
date: '2014-07-03T09:51:55+00:00'
author: 任坤
categories:
  - 统计软件
  - 软件应用
tags:
  - rlist
  - 非关系型数据
slug: rlist-package
forum_id: 419025
---

本文作者：[任坤](http://renkun.me/)，厦门大学王亚南经济研究院金融硕士生，研究兴趣为计算统计和金融量化交易，pipeR，learnR，rlist等[项目](https://github.com/renkun-ken)的作者。

近年来，非关系型数据逐渐获得了更广泛的关注和使用。下面分别列举了一个典型的关系型数据表和一个典型的非关系型数据集。

关系型数据：一组学生的基本数据，包括姓名（Name）、性别（Gender）、年龄（Age）以及专业（Major）。

|Name      |Gender  |Age  |Major             |
|:--------:|:------:|:---:|:----------------:|
|Ken       |Male    |24   |Finance           |
|Ashley    |Female  |25   |Statistics        |
|Jennifer  |Female  |23   |Computer Science  |

非关系型数据：一组程序开发者的基本信息，包括姓名（Name）、年龄（Age）、兴趣爱好（Interest）、编程语言以及使用年数（Language）。

|Name   |Age  |Interest               |Language              |
|:-----:|:---:|:---------------------:|:--------------------:|
|Ken    |24   |reading, music,movies  |R:2, C#:4, Python:3   |
|James  |25   |sports, music          |R:3, Java:2, C++:5    |
|Penny  |24   |movies, reading        |R:1, C++:4, Python:2  |

可以发现，第一个表中的关系型数据可以简单地放入矩形的数据表，而第二个表中的非关系型数据中`Interest`和`Language`本身并不是单一值的字段，因而如果在关系型数据库中表示，可能需要建立多个表和关系来存储。

对于这种数据的处理，MongoDB是较为成熟的解决方案之一。在R中，`data.frame`可以用来很好地描述关系型数据表，也有`data.table`, `dplyr`等扩展包可以方便地处理这类数据。而list对象可以很好地表征结构灵活的非关系型数据，但是却缺乏可以灵活地处理list对象中存储非关系型数据的扩展包。

这就是 [rlist](http://renkun.me/rlist) 扩展包诞生的原因：让人们可以使用全部R的函数和功能，方便地访问list对象中存储的非关系型数据，从而轻松地、直观地进行非关系型数据映射 （mapping）、筛选（filtering）、分组（grouping）、排序（sorting）、更新（updating）等等。

可以用`devtools`扩展包直接从[GitHub](https://github.com/renkun-ken/rlist)安装rlist最新的开发版本：

```r
devtools::install_github("rlist","renkun-ken")
```

下面将通过一些例子来分别介绍这个扩展包的主要功能。下面的例子基本都在以下数据中进行。

```r
    library(rlist)
    devs <- 
      list(
        p1=list(name="Ken",age=24,
          interest=c("reading","music","movies"),
          lang=list(r=2,csharp=4,python=3)),
        p2=list(name="James",age=25,
          interest=c("sports","music"),
          lang=list(r=3,java=2,cpp=5)),
        p3=list(name="Penny",age=24,
          interest=c("movies","reading"),
          lang=list(r=1,cpp=4,python=2)))
    str(devs)

    List of 3
     $ p1:List of 4
      ..$ name    : chr "Ken"
      ..$ age     : num 24
      ..$ interest: chr [1:3] "reading" "music" "movies"
      ..$ lang    :List of 3
      .. ..$ r     : num 2
      .. ..$ csharp: num 4
      .. ..$ python: num 3
     $ p2:List of 4
      ..$ name    : chr "James"
      ..$ age     : num 25
      ..$ interest: chr [1:2] "sports" "music"
      ..$ lang    :List of 3
      .. ..$ r   : num 3
      .. ..$ java: num 2
      .. ..$ cpp : num 5
     $ p3:List of 4
      ..$ name    : chr "Penny"
      ..$ age     : num 24
      ..$ interest: chr [1:2] "movies" "reading"
      ..$ lang    :List of 3
      .. ..$ r     : num 1
      .. ..$ cpp   : num 4
      .. ..$ python: num 2
```

上面的代码是直接在R中建立一个名为`devs`的list对象，里面包含的正是前面提到的非关系型数据。由于直接输出数据占用篇幅较长，在后面的例子中可能采用`str`函数来显示数据。

# 映射（mapping）

`list.map` 函数提供了list中元素的映射功能。

 将每个元素映射到年龄（age）
 
 ```r
list.map(devs, age)
$p1
[1] 24

$p2
[1] 25

$p3
[1] 24
 ```
 
将每个元素映射到使用编程语言的平均年数：

```r
list.map(devs, mean(as.numeric(lang)))
$p1
[1] 3

$p2
[1] 3.333

$p3
[1] 2.333
```
将每个元素映射到使用的编程语言名称：

```r 
list.map(devs, names(lang))
$p1
[1] "r"      "csharp" "python"

$p2
[1] "r"    "java" "cpp" 

$p3
[1] "r"      "cpp"    "python"
```

# 筛选（filtering）

筛选出年龄不低于25岁的个体：

```r
str(list.filter(devs, age>=25))

List of 1
 $ p2:List of 4
  ..$ name    : chr "James"
  ..$ age     : num 25
  ..$ interest: chr [1:2] "sports" "music"
  ..$ lang    :List of 3
  .. ..$ r   : num 3
  .. ..$ java: num 2
  .. ..$ cpp : num 5
 ```
 
筛选出使用R语言的个体：

```r
str(list.filter(devs, "r" %in% names(lang)))
List of 3
 $ p1:List of 4
  ..$ name    : chr "Ken"
  ..$ age     : num 24
  ..$ interest: chr [1:3] "reading" "music" "movies"
  ..$ lang    :List of 3
  .. ..$ r     : num 2
  .. ..$ csharp: num 4
  .. ..$ python: num 3
 $ p2:List of 4
  ..$ name    : chr "James"
  ..$ age     : num 25
  ..$ interest: chr [1:2] "sports" "music"
  ..$ lang    :List of 3
  .. ..$ r   : num 3
  .. ..$ java: num 2
  .. ..$ cpp : num 5
 $ p3:List of 4
  ..$ name    : chr "Penny"
  ..$ age     : num 24
  ..$ interest: chr [1:2] "movies" "reading"
  ..$ lang    :List of 3
  .. ..$ r     : num 1
  .. ..$ cpp   : num 4
  .. ..$ python: num 2
```

筛选出使用Python年限不低于3年的个体

```r
str(list.filter(devs, lang$python >= 3))
List of 1
 $ p1:List of 4
  ..$ name    : chr "Ken"
  ..$ age     : num 24
  ..$ interest: chr [1:3] "reading" "music" "movies"
  ..$ lang    :List of 3
  .. ..$ r     : num 2
  .. ..$ csharp: num 4
  .. ..$ python: num 3
```

# 分组（grouping）

按照年龄做互斥分组：

```r
str(list.group(devs, age))
List of 2
 $ 24:List of 2
  ..$ p1:List of 4
  .. ..$ name    : chr "Ken"
  .. ..$ age     : num 24
  .. ..$ interest: chr [1:3] "reading" "music" "movies"
  .. ..$ lang    :List of 3
  .. .. ..$ r     : num 2
  .. .. ..$ csharp: num 4
  .. .. ..$ python: num 3
  ..$ p3:List of 4
  .. ..$ name    : chr "Penny"
  .. ..$ age     : num 24
  .. ..$ interest: chr [1:2] "movies" "reading"
  .. ..$ lang    :List of 3
  .. .. ..$ r     : num 1
  .. .. ..$ cpp   : num 4
  .. .. ..$ python: num 2
 $ 25:List of 1
  ..$ p2:List of 4
  .. ..$ name    : chr "James"
  .. ..$ age     : num 25
  .. ..$ interest: chr [1:2] "sports" "music"
  .. ..$ lang    :List of 3
  .. .. ..$ r   : num 3
  .. .. ..$ java: num 2
  .. .. ..$ cpp : num 5
```

按照兴趣做非互斥分组
 
```r
str(list.class(devs, interest))
List of 4
 $ movies :List of 2
  ..$ p1:List of 4
  .. ..$ name    : chr "Ken"
  .. ..$ age     : num 24
  .. ..$ interest: chr [1:3] "reading" "music" "movies"
  .. ..$ lang    :List of 3
  .. .. ..$ r     : num 2
  .. .. ..$ csharp: num 4
  .. .. ..$ python: num 3
  ..$ p3:List of 4
  .. ..$ name    : chr "Penny"
  .. ..$ age     : num 24
  .. ..$ interest: chr [1:2] "movies" "reading"
  .. ..$ lang    :List of 3
  .. .. ..$ r     : num 1
  .. .. ..$ cpp   : num 4
  .. .. ..$ python: num 2
 $ music  :List of 2
  ..$ p1:List of 4
  .. ..$ name    : chr "Ken"
  .. ..$ age     : num 24
  .. ..$ interest: chr [1:3] "reading" "music" "movies"
  .. ..$ lang    :List of 3
  .. .. ..$ r     : num 2
  .. .. ..$ csharp: num 4
  .. .. ..$ python: num 3
  ..$ p2:List of 4
  .. ..$ name    : chr "James"
  .. ..$ age     : num 25
  .. ..$ interest: chr [1:2] "sports" "music"
  .. ..$ lang    :List of 3
  .. .. ..$ r   : num 3
  .. .. ..$ java: num 2
  .. .. ..$ cpp : num 5
 $ reading:List of 2
  ..$ p1:List of 4
  .. ..$ name    : chr "Ken"
  .. ..$ age     : num 24
  .. ..$ interest: chr [1:3] "reading" "music" "movies"
  .. ..$ lang    :List of 3
  .. .. ..$ r     : num 2
  .. .. ..$ csharp: num 4
  .. .. ..$ python: num 3
  ..$ p3:List of 4
  .. ..$ name    : chr "Penny"
  .. ..$ age     : num 24
  .. ..$ interest: chr [1:2] "movies" "reading"
  .. ..$ lang    :List of 3
  .. .. ..$ r     : num 1
  .. .. ..$ cpp   : num 4
  .. .. ..$ python: num 2
 $ sports :List of 1
  ..$ p2:List of 4
  .. ..$ name    : chr "James"
  .. ..$ age     : num 25
  .. ..$ interest: chr [1:2] "sports" "music"
  .. ..$ lang    :List of 3
  .. .. ..$ r   : num 3
  .. .. ..$ java: num 2
  .. .. ..$ cpp : num 5
```

# 排序（sorting）

按照年龄升序排列：

```r
str(list.sort(devs, age))
List of 3
 $ p1:List of 4
  ..$ name    : chr "Ken"
  ..$ age     : num 24
  ..$ interest: chr [1:3] "reading" "music" "movies"
  ..$ lang    :List of 3
  .. ..$ r     : num 2
  .. ..$ csharp: num 4
  .. ..$ python: num 3
 $ p3:List of 4
  ..$ name    : chr "Penny"
  ..$ age     : num 24
  ..$ interest: chr [1:2] "movies" "reading"
  ..$ lang    :List of 3
  .. ..$ r     : num 1
  .. ..$ cpp   : num 4
  .. ..$ python: num 2
 $ p2:List of 4
  ..$ name    : chr "James"
  ..$ age     : num 25
  ..$ interest: chr [1:2] "sports" "music"
  ..$ lang    :List of 3
  .. ..$ r   : num 3
  .. ..$ java: num 2
  .. ..$ cpp : num 5
```
  
按照使用兴趣数量降序排列，然后按照R语言使用年数降序排列：

```r
str(list.sort(devs, desc(length(interest)), desc(lang$r)))
List of 3
 $ p1:List of 4
  ..$ name    : chr "Ken"
  ..$ age     : num 24
  ..$ interest: chr [1:3] "reading" "music" "movies"
  ..$ lang    :List of 3
  .. ..$ r     : num 2
  .. ..$ csharp: num 4
  .. ..$ python: num 3
 $ p2:List of 4
  ..$ name    : chr "James"
  ..$ age     : num 25
  ..$ interest: chr [1:2] "sports" "music"
  ..$ lang    :List of 3
  .. ..$ r   : num 3
  .. ..$ java: num 2
  .. ..$ cpp : num 5
 $ p3:List of 4
  ..$ name    : chr "Penny"
  ..$ age     : num 24
  ..$ interest: chr [1:2] "movies" "reading"
  ..$ lang    :List of 3
  .. ..$ r     : num 1
  .. ..$ cpp   : num 4
  .. ..$ python: num 2
```

# 更新（updating）

去除 interest 和 lang 两个字段，加入 nlang 表示掌握语言数目，以及 expert 使用时间最长的语言名称：

```r
str(list.update(devs, interest=NULL, lang=NULL, nlang=length(lang),
  expert={
    longest &lt;- sort(unlist(lang))[1]
    names(longest)
  }))

List of 3
 $ p1:List of 4
  ..$ name  : chr "Ken"
  ..$ age   : num 24
  ..$ nlang : int 3
  ..$ expert: chr "r"
 $ p2:List of 4
  ..$ name  : chr "James"
  ..$ age   : num 25
  ..$ nlang : int 3
  ..$ expert: chr "java"
 $ p3:List of 4
  ..$ name  : chr "Penny"
  ..$ age   : num 24
  ..$ nlang : int 3
  ..$ expert: chr "r"</code></pre>
```

# Lambda表达式

rlist中所有支持表达式计算的函数都支持 Lambda 表达式，允许用户访问列表元素的元数据（metadata），即元素本身、元素索引编号（index）、元素名称（name）。

```r
x <- list(a=c(1,2,3),b=c(3,4,5))
list.map(x, sum(.))

$a
[1] 6

$b
[1] 12

```

在上面的代码中，. 表示每个元素本身。此例中由于列表中每个元素都是一个数值向量，因此可以分别通过 sum 函数求和。如果不使用 . 来表示元素本身，可以通过形如  x -> f(x) 或者 x ~ f(x)  的 Lambda 表达式自定义符号。

```r
list.map(x, x -> sum(x))

$a
[1] 6

$b
[1] 12
```

默认情况下， .i 表示当前元素的索引，.name 表示当前元素的名称。下面用 list.iter 函数遍历 x 中的各个元素，对于每个元素显示自定义字符串。

```r
list.iter(x, cat(.name,":",.i,"\n"))
a : 1 
b : 2 
```
通过 Lambda 表达式自定义这些符号时，可以采用 f(x,i,name) -> expression 的形式，例如：

```r
list.map(x, f(x,i) -> x*i)
$a
[1] 1 2 3

$b
[1]  6  8 10
```

# 管道操作

由于rlist中函数结构设计具有很强的一致性，推荐和[pipeR](http://renkun.me/pipeR)扩展包中定义的管道操作符一同使用，使得R中的非关系型数据操作易读、可维护。

下面的代码通过结合管道操作选择出喜欢音乐并且使用R的开发者的名字和年龄，结果组合成一个 data.frame ：

```r
library(pipeR)
devs % >> % 
  list.filter("music" %in% interest & "r" %in% names(lang)) %>>%
  list.select(name,age) %>>%
  list.rbind % >> %
  data.frame
      
    name age
p1   Ken  24
p2 James  25
```

# 包含结构化对象的列表  

下面是一个更为复杂的例子，其中涉及到生成一列 `data.frame`、处理一列线性模型等等：
```r  
set.seed(1)
1:10 %>>%
  list.map(i -> {
    x <- rnorm(1000)
    y <- i * x + rnorm(1000)
    data.frame(x=x,y=y)
  }) %>>%
  list.map(df -> lm(y~x)) %>>%
  list.update(summary = m -> summary(m)) %>>%
  list.sort(m -> desc(summary$r.squared)) %>>%
  list.map(c(rsq=summary$r.squared, coefficients)) %>>%
  list.rbind %>>%
  data.frame
```
  
```r       
 rsq        X.Intercept.  x
1  0.9896    -0.032250 9.986
2  0.9871     0.031999 8.970
3  0.9832    -0.001191 7.993
4  0.9802     0.004400 6.958
5  0.9684    -0.034238 6.008
6  0.9626     0.007260 4.941
7  0.9450    -0.004309 3.995
8  0.8997    -0.012472 2.962
9  0.7994     0.016558 2.011
10 0.5008    -0.016187 1.006
```

# 其他功能

除了上述函数之外，rlist扩展包还提供了许多其他函数，这里只做简单介绍：

`list.join`：根表达式合并两个list

- `list.parse`：将其他类型的对象转换为结构相同的list

- `list.load`, `list.save`：读写JSON, YAML, RData格式的list

- `list.if`, `list.which`, `list.any`, `list.all`：list元素的逻辑判断

- `list.find`, `list.findi`：在list中按照表达式寻找指定数量的元素

详细介绍请参见帮助文档：

```r   
help(package = “rlist”)
```  

以及应用手册：

```r   
vignette("introduction", package = "rlist")
```
