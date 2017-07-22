---
title: jiebaR中文分词——R的灵活，C的效率
date: '2014-11-15T10:46:46+00:00'
author: 覃文锋
categories:
  - 数据分析
  - 数据挖掘与机器学习
  - 统计软件
  - 软件应用
tags:
  - jiebaR
  - Rcpp
  - 分词
  - 词库
  - 软件包
slug: jiebar-text-segmentation
forum_id: 419040
---


# R是什么？

记得刚接触R的时候，有一种莫名的抵触，A、B、C、D、E那么多种语言了，为什么又多冒出来一个R？为了时间序列的课程，我又要多记忆一大堆乱七八糟的语法。当发现居然有`dd <- 23333` `23333 -> ee` 这样的语法时，更瞬间奠定了R语言在我心中的逗比地位。

因为老师没有专门教授R的相关细节，毕竟课程的主题不是那个，加之R的语法与众不同，这导致我的R语言相关作业的绝大部分时间一般都在百度、谷歌各种R语言的表达、实现方法中度过。<!--more-->

记得有位哲人说过：“人并没有真正喜欢吃的东西，只是吃的次数多了，就‘喜欢’了。”

我对R语言的看法也差不多。随着对R了解的深入，我才发现，丰富的可视化工具、可重复性研究、匿名函数、延迟求值、元编程，还有6000+的CRAN包等等特性，都是R赫赫的闪光点。

R是一门统计学用的语言，这是这门语言给我的第一印象。看了 [John Chambers](http://datascience.la/john-chambers-user-2014-keynote/) 在 USER!2014 的视频，以及他对R的定义“a software interface into the best algorithms.” 的时候，我感受到了R的“最初的价值”。

`magrittr`让我们更欢乐地操纵各种命令，`knitr`让统计报告和编程文学化，`dplyr`更方便地处理数据，R还有`shiny`让你轻松地构建动态内容。我很难想象没有R，让我用其他语言来完成完成这些事情需要多少的工作量。

# 灵活而高效的接口

有人说R慢，只能说这些人应该不够“本质”，效率和灵活性总是需要平衡的。用C和FORTRAN来实现算法，用R（S）来解决问题，这是S诞生的初衷之一。英语渣渣的理解，不对请轻轻地喷。R的底层C接口对初学者有些复杂，Rcpp的出现很大程度上降低了写出高效率R包和代码的成本。

之前因为对文本挖掘比较感兴趣，所以打算用R来做一些分析，但是发现在R上，文本挖掘最基本的中文分词的模块还没有较好的实现。R是开源的，开源的意义不只是`Free`使用，还有贡献社区这一层，于是jiebaR诞生了。

jiebaR是[“结巴”中文分词](https://github.com/fxsjy/jieba)（Python）的R语言版本，支持最大概率法（Maximum Probability），隐式马尔科夫模型（Hidden Markov Model），索引模型（QuerySegment），混合模型（MixSegment）共四种分词模式，同时有词性标注，关键词提取，文本Simhash相似度比较等功能。项目使用了Rcpp和[CppJieba](https://github.com/aszxqw/cppjieba)进行开发。目前托管在[GitHub](https://github.com/qinwf/jiebaR)上。安装很简单，你可以下载Windows的[二进制包](https://github.com/qinwf/jiebaR/releases)或者：

```r
library(devtools)
install_github("qinwf/jiebaR"）
```

是的，然后你就可以开始分词了，再也没有rJava那头痛的Path设置。

jiebaR使用了Rcpp，用Rcpp可以很容易地把C++的逻辑整合到R里。比如，在R里，你很难实现构建一棵Trie树，写出有向无环图等数据结构，同时进行动态规划算法，这些是最大概率法（MPSegment）—— jiebaR分词的核心算法之一。就算实现了，在R里有`for`遍历的速度，你猜猜就知道是多么的压力山大。

Rcpp是一个很神奇的包，特别是当你试过使用Rcpp Modules以后，jiebaR使用Rcpp Modules实现了worker的概念，把静态的C++面向对象的模型带到R中动态实现。

常用的分词包有两种加载词库的方法，就是加载包时读取默认的词典和数据模型，或者在分词前加载词典和模型数据。在早期的版本中，jiebaR也使用过这两种方式进行加载。第一种方式，就像一个铁笼子，加载包时一次性加载了词库，封装在一起。第二种方式灵活，可以动态地加载词库和模型数据，适时进行修改，但是每次分词前，加载词库都十分耗费时间，对于小的任务不合适。

有了Rcpp Modules，jiebaR可以把C++中的分词类映射到R语言中的RC类，把这样原本C++中静态的类的操作，带到了R里面，可以动态地运行。在jiebaR里，你可以动态地生成分词器，使用不同的分词器，对不同类型的文本进行操作，分词就像切菜时选不同的菜刀一样。

`library(jiebaR)`加载包时，没有启动任何分词引擎，启动引擎很简单，就是一句赋值语句就可以了。

```r
cutter = worker()
```

软件默认设定非常重要，jiebaR默认参数为绝大多数任务调整到了最好的状态（哈哈，我的自我感觉）。初始化分词简单，分词就更简单了。为了让大家少一些待在电脑前的时间，多一些陪家人和朋友的时间，少敲一些键盘，jiebaR重载了`<=`这个不太常用的符号。分词就是一个类似赋值的过程，足够简单粗暴：

```r
cutter <= "江州市长江大桥，参加了长江大桥的通车仪式。" 

# [1] "江州"     "市长"     "江大桥"   "参加"     "了"       "长江大桥" "的"       "通车"     "仪式"  

# 或者Pipe一个文件路径

cutter <= "weibo.txt"
```

当然，如果你喜欢打字，也可以使用`segment()`函数。正如之前说的，可以同时初始化和使用多个分词器。可以添加一些参数来初始化，可用参数列表很长很长，但是一般你不会全用到它们，具体可以参考帮助文档`?worker()`:

```r
cutter2 = worker( user = 某个用户词库路径) ### 初始化第二个引擎

ShowDictPath()  ### 可以显示默认词典路径
```

这时R的环境里同时有两个加载了不同词库的分词引擎。如果需要了解这两个不同的引擎的区别只需要`print`一下就可以了。

```r
cutter

# Worker Type:  Mix Segment
# 
# Detect Encoding :  TRUE
# Default Encoding:  UTF-8
# Keep Symbols    :  FALSE
# Output Path     :  
# Write File      :  TRUE
# Max Read Lines  :  1e+05
# 
# Fixed Model Components:  
# 
# $dict
# [1] "C:/Users/user/R/win-library/3.1/jiebaR/dict/jieba.dict.utf8"
# 
# $hmm
# [1] "C:/Users/user/R/win-library/3.1/jiebaR/dict/hmm_model.utf8"
# 
# $user
# [1] "C:/Users/user/R/win-library/3.1/jiebaR/dict/user.dict.utf8"
# 
# $detect $encoding $symbol $output $write $lines can be reset.
```

哈哈，暴露了我是一个Windows党，每个worker都有一些参数设置，如`cutter`中的`$detect`参数决定了引擎是否自动判断输入文件的编码，在引擎加载时可以通过`worker(detect = F )`进行参数设置，也可以在加载后通过`cutter$detect = F`进行设置。其实 `worker()`函数返回的是一个环境（environment），里面封装了真正的分词引擎，你可以通过`cutter$worker`来查看真正的“引擎”。

```r
cutter$worker

# C++ object <0000000014C98780> of class 'mixseg' <0000000014CA4680>
```

`cutter$worker`和`cutter`都是环境，在传递时是传址，而不是传值，效率是比较高的。jiebaR的分词速度是其他R语言分词包的5-20倍。

jiebaR除了分词，还提供了词性标注、关键词提取、文本相似度比较等功能，具体的内容可以参考GitHub里的项目介绍。这些功能的用法都差不多。

分词结束后，对于不需要的引擎只需要用`rm()`进行删除，R有自动的垃圾回收机制，为你解决内存管理的后顾之忧。

分词已经分好，统计分析才是最重要的任务。剃刀已经磨砺，接下来就可以用R来处理中文字符了。

目前该包还有很多需要完善的地方，大家感兴趣的可以参与jiebaR或者CppJieba的开发中，一个pull request，来一发开源的精神。

JOHN CHAMBERS：<http://datascience.la/john-chambers-user-2014-keynote/>
  
GitHub：<https://github.com/qinwf/jiebaR>
  
二进制包：<https://github.com/qinwf/jiebaR/releases>
  
Cppjieba：<https://github.com/aszxqw/cppjieba>
  
“结巴”中文分词：<https://github.com/fxsjy/jieba>
