---
title: rlist：基于list在R中处理非关系型数据
date: '2014-07-03T09:51:55+00:00'
author: COS编辑部
categories:
  - 统计软件
  - 软件应用
tags:
  - rlist
  - 非关系型数据
slug: rlist-package
---

> 本文作者：[任坤](http://renkun.me/)，厦门大学王亚南经济研究院金融硕士生，研究兴趣为计算统计和金融量化交易，pipeR，learnR，rlist等[项目](https://github.com/renkun-ken)的作者。

近年来，非关系型数据逐渐获得了更广泛的关注和使用。下面分别列举了一个典型的关系型数据表和一个典型的非关系型数据集。

关系型数据：一组学生的基本数据，包括姓名（Name）、性别（Gender）、年龄（Age）以及专业（Major）。

<table class="table table-condensed">
  <tr class="header">
    <th align="left">
      Name
    </th>
    
    <th align="left">
      Gender
    </th>
    
    <th align="left">
      Age
    </th>
    
    <th align="left">
      Major
    </th>
  </tr>
  
  <tr class="odd">
    <td align="left">
      Ken
    </td>
    
    <td align="left">
      Male
    </td>
    
    <td align="left">
      24
    </td>
    
    <td align="left">
      Finance
    </td>
  </tr>
  
  <tr class="even">
    <td align="left">
      Ashley
    </td>
    
    <td align="left">
      Female
    </td>
    
    <td align="left">
      25
    </td>
    
    <td align="left">
      Statistics
    </td>
  </tr>
  
  <tr class="odd">
    <td align="left">
      Jennifer
    </td>
    
    <td align="left">
      Female
    </td>
    
    <td align="left">
      23
    </td>
    
    <td align="left">
      Computer Science
    </td>
  </tr>
</table>

非关系型数据：一组程序开发者的基本信息，包括姓名（Name）、年龄（Age）、兴趣爱好（Interest）、编程语言以及使用年数（Language）。<!--more-->

<table class="table table-condensed">
  <tr class="header">
    <th align="left">
      Name
    </th>
    
    <th align="left">
      Age
    </th>
    
    <th align="left">
      Interest
    </th>
    
    <th align="left">
      Language
    </th>
  </tr>
  
  <tr class="odd">
    <td align="left">
      Ken
    </td>
    
    <td align="left">
      24
    </td>
    
    <td align="left">
      reading, music,movies
    </td>
    
    <td align="left">
      R:2, C#:4, Python:3
    </td>
  </tr>
  
  <tr class="even">
    <td align="left">
      James
    </td>
    
    <td align="left">
      25
    </td>
    
    <td align="left">
      sports, music
    </td>
    
    <td align="left">
      R:3, Java:2, C++:5
    </td>
  </tr>
  
  <tr class="odd">
    <td align="left">
      Penny
    </td>
    
    <td align="left">
      24
    </td>
    
    <td align="left">
      movies, reading
    </td>
    
    <td align="left">
      R:1, C++:4, Python:2
    </td>
  </tr>
</table>

可以发现，第一个表中的关系型数据可以简单地放入矩形的数据表，而第二个表中的非关系型数据中`Interest`和`Language`本身并不是单一值的字段，因而如果在关系型数据库中表示，可能需要建立多个表和关系来存储。

对于这种数据的处理，MongoDB是较为成熟的解决方案之一。在R中，`data.frame`可以用来很好地描述关系型数据表，也有`data.table`, `dplyr`等扩展包可以方便地处理这类数据。而list对象可以很好地表征结构灵活的非关系型数据，但是却缺乏可以灵活地处理list对象中存储非关系型数据的扩展包。

这就是 [rlist](http://renkun.me/rlist) 扩展包诞生的原因：让人们可以使用全部R的函数和功能，方便地访问list对象中存储的非关系型数据，从而轻松地、直观地进行非关系型数据映射 （mapping）、筛选（filtering）、分组（grouping）、排序（sorting）、更新（updating）等等。

可以用`devtools`扩展包直接从[GitHub](https://github.com/renkun-ken/rlist)安装rlist最新的开发版本：

    devtools::install_github("rlist","renkun-ken")

下面将通过一些例子来分别介绍这个扩展包的主要功能。下面的例子基本都在以下数据中进行。

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

上面的代码是直接在R中建立一个名为`devs`的list对象，里面包含的正是前面提到的非关系型数据。由于直接输出数据占用篇幅较长，在后面的例子中可能采用`str`函数来显示数据。

<div id="mapping" class="section level2">
  <h2>
    映射（mapping）
  </h2>
  
  <p>
    <code>list.map</code>函数提供了list中元素的映射功能。
  </p>
  
  <p>
    将每个元素映射到年龄（age）：
  </p>
  
  <pre><code>list.map(devs, age)</code></pre>
  
  <pre><code>$p1
[1] 24

$p2
[1] 25

$p3
[1] 24</code></pre>
  
  <p>
    将每个元素映射到使用编程语言的平均年数：
  </p>
  
  <pre><code>list.map(devs, mean(as.numeric(lang)))</code></pre>
  
  <pre><code>$p1
[1] 3

$p2
[1] 3.333

$p3
[1] 2.333</code></pre>
  
  <p>
    将每个元素映射到使用的编程语言名称：
  </p>
  
  <pre><code>list.map(devs, names(lang))</code></pre>
  
  <pre><code>$p1
[1] "r"      "csharp" "python"

$p2
[1] "r"    "java" "cpp" 

$p3
[1] "r"      "cpp"    "python"</code></pre>
</div>

<div id="filtering" class="section level2">
  <h2>
    筛选（filtering）
  </h2>
  
  <p>
    筛选出年龄不低于25岁的个体：
  </p>
  
  <pre><code>str(list.filter(devs, age&gt;=25))</code></pre>
  
  <pre><code>List of 1
 $ p2:List of 4
  ..$ name    : chr "James"
  ..$ age     : num 25
  ..$ interest: chr [1:2] "sports" "music"
  ..$ lang    :List of 3
  .. ..$ r   : num 3
  .. ..$ java: num 2
  .. ..$ cpp : num 5</code></pre>
  
  <p>
    筛选出使用R语言的个体：
  </p>
  
  <pre><code>str(list.filter(devs, "r" %in% names(lang)))</code></pre>
  
  <pre><code>List of 3
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
  .. ..$ python: num 2</code></pre>
  
  <p>
    筛选出使用Python年限不低于3年的个体：
  </p>
  
  <pre><code>str(list.filter(devs, lang$python &gt;= 3))</code></pre>
  
  <pre><code>List of 1
 $ p1:List of 4
  ..$ name    : chr "Ken"
  ..$ age     : num 24
  ..$ interest: chr [1:3] "reading" "music" "movies"
  ..$ lang    :List of 3
  .. ..$ r     : num 2
  .. ..$ csharp: num 4
  .. ..$ python: num 3</code></pre>
</div>

<div id="grouping" class="section level2">
  <h2>
    分组（grouping）
  </h2>
  
  <p>
    按照年龄做互斥分组：
  </p>
  
  <pre><code>str(list.group(devs, age))</code></pre>
  
  <pre><code>List of 2
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
  .. .. ..$ cpp : num 5</code></pre>
  
  <p>
    按照兴趣做非互斥分组：
  </p>
  
  <pre><code>str(list.class(devs, interest))</code></pre>
  
  <pre><code>List of 4
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
  .. .. ..$ cpp : num 5</code></pre>
</div>

<div id="sorting" class="section level2">
  <h2>
    排序（sorting）
  </h2>
  
  <p>
    按照年龄升序排列：
  </p>
  
  <pre><code>str(list.sort(devs, age))</code></pre>
  
  <pre><code>List of 3
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
  .. ..$ cpp : num 5</code></pre>
  
  <p>
    按照使用兴趣数量降序排列，然后按照R语言使用年数降序排列：
  </p>
  
  <pre><code>str(list.sort(devs, desc(length(interest)), desc(lang$r)))</code></pre>
  
  <pre><code>List of 3
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
  .. ..$ python: num 2</code></pre>
</div>

<div id="updating" class="section level2">
  <h2>
    更新（updating）
  </h2>
  
  <p>
    去除<code>interest</code>和<code>lang</code>两个字段，加入<code>nlang</code>表示掌握语言数目，以及<code>expert</code>使用时间最长的语言名称：
  </p>
  
  <pre><code>str(list.update(devs, interest=NULL, lang=NULL, nlang=length(lang),
  expert={
    longest &lt;- sort(unlist(lang))[1]
    names(longest)
  }))</code></pre>
  
  <pre><code>List of 3
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
</div>

<div id="lambda" class="section level2">
  <h2>
    Lambda表达式
  </h2>
  
  <p>
    rlist中所有支持表达式计算的函数都支持 Lambda 表达式，允许用户访问列表元素的元数据（metadata），即元素本身、元素索引编号（index）、元素名称（name）。
  </p>
  
  <pre><code>x &lt;- list(a=c(1,2,3),b=c(3,4,5))
list.map(x, sum(.))</code></pre>
  
  <pre><code>$a
[1] 6

$b
[1] 12</code></pre>
  
  <p>
    在上面的代码中，<code>.</code>表示每个元素本身。此例中由于列表中每个元素都是一个数值向量，因此可以分别通过<code>sum</code>函数求和。如果不使用<code>.</code>来表示元素本身，可以通过形如 <code>x -&gt; f(x)</code> 或者 <code>x ~ f(x)</code> 的 Lambda 表达式自定义符号。
  </p>
  
  <pre><code>list.map(x, x -&gt; sum(x))</code></pre>
  
  <pre><code>$a
[1] 6

$b
[1] 12</code></pre>
  
  <p>
    默认情况下，<code>.i</code>表示当前元素的索引，<code>.name</code>表示当前元素的名称。下面用<code>list.iter</code>函数遍历<code>x</code>中的各个元素，对于每个元素显示自定义字符串。
  </p>
  
  <pre><code>list.iter(x, cat(.name,":",.i,"\n"))</code></pre>
  
  <pre><code>a : 1 
b : 2 </code></pre>
  
  <p>
    通过 Lambda 表达式自定义这些符号时，可以采用 <code>f(x,i,name) -&gt; expression</code> 的形式，例如：
  </p>
  
  <pre><code>list.map(x, f(x,i) -&gt; x*i)</code></pre>
  
  <pre><code>$a
[1] 1 2 3

$b
[1]  6  8 10</code></pre>
</div>

<div class="section level2">
  <h2>
    管道操作
  </h2>
  
  <p>
    由于rlist中函数结构设计具有很强的一致性，推荐和<a href="http://renkun.me/pipeR">pipeR</a>扩展包中定义的管道操作符一同使用，使得R中的非关系型数据操作易读、可维护。
  </p>
  
  <p>
    下面的代码通过结合管道操作选择出喜欢音乐并且使用R的开发者的名字和年龄，结果组合成一个<code>data.frame</code>：
  </p>
  
  <pre><code>library(pipeR)
devs %&gt;&gt;% 
  list.filter("music" %in% interest & "r" %in% names(lang)) %&gt;&gt;%
  list.select(name,age) %&gt;&gt;%
  list.rbind %&gt;&gt;%
  data.frame</code></pre>
  
  <pre><code>    name age
p1   Ken  24
p2 James  25</code></pre>
</div>

<div class="section level2">
  <h2>
    包含结构化对象的列表
  </h2>
  
  <p>
    下面是一个更为复杂的例子，其中涉及到生成一列 <code>data.frame</code>、处理一列线性模型等等：
  </p>
  
  <pre><code>set.seed(1)
1:10 %&gt;&gt;%
  list.map(i -&gt; {
    x &lt;- rnorm(1000)
    y &lt;- i * x + rnorm(1000)
    data.frame(x=x,y=y)
  }) %&gt;&gt;%
  list.map(df -&gt; lm(y~x)) %&gt;&gt;%
  list.update(summary = m -&gt; summary(m)) %&gt;&gt;%
  list.sort(m -&gt; desc(summary$r.squared)) %&gt;&gt;%
  list.map(c(rsq=summary$r.squared, coefficients)) %&gt;&gt;%
  list.rbind %&gt;&gt;%
  data.frame</code></pre>
  
  <pre><code>      rsq X.Intercept.     x
1  0.9896    -0.032250 9.986
2  0.9871     0.031999 8.970
3  0.9832    -0.001191 7.993
4  0.9802     0.004400 6.958
5  0.9684    -0.034238 6.008
6  0.9626     0.007260 4.941
7  0.9450    -0.004309 3.995
8  0.8997    -0.012472 2.962
9  0.7994     0.016558 2.011
10 0.5008    -0.016187 1.006</code></pre>
</div>

<div class="section level2">
  <h2>
    其他功能
  </h2>
  
  <p>
    除了上述函数之外，rlist扩展包还提供了许多其他函数，这里只做简单介绍：
  </p>
  
  <ul>
    <li>
      <code>list.join</code>：根表达式合并两个list
    </li>
    <li>
      <code>list.parse</code>：将其他类型的对象转换为结构相同的list
    </li>
    <li>
      <code>list.load</code>, <code>list.save</code>：读写JSON, YAML, RData格式的list
    </li>
    <li>
      <code>list.if</code>, <code>list.which</code>, <code>list.any</code>, <code>list.all</code>：list元素的逻辑判断
    </li>
    <li>
      <code>list.find</code>, <code>list.findi</code>：在list中按照表达式寻找指定数量的元素
    </li>
    <li>
      …
    </li>
  </ul>
  
  <p>
    详细介绍请参见帮助文档：
  </p>
  
  <pre><code>help(package = rlist)</code></pre>
  
  <p>
    以及应用手册：
  </p>
  
  <pre><code>vignette("introduction", package = "rlist")</code></pre>
</div>

&nbsp;
