---
title: COS论坛精华帖系列——strsplit 的反函数
date: '2013-08-13T12:30:53+00:00'
author: 统计之都
categories:
  - 统计软件
  - 软件应用
tags:
  - strplit
  - 字符串
  - 精华帖
  - 论坛
slug: cos-series-inverse-function-of-strsplit
forum_id: 418952
---

我们知道，R 中的 `strsplit` 函数可以将字符串按照分隔符来进行分割。正如下面所示：

```r
str_poor <- "the quick brown fox jumps over a lazy dog"
str_poor
# [1] "the quick brown fox jumps over a lazy dog"

str_splited <- unlist(strsplit(str_poor, " "))
str_splited
# [1] "the"   "quick" "brown" "fox"   "jumps" "over"  "a"     "lazy"  "dog"
```

那么，有没有对应的“反函数”，就是说把以上的 `splited_str` 还原成为原来的 `poor_str` 呢？当然是有的，而且不止一种方法。  <!--more-->

# 官方版本：`paste`

在 R 的 `base` 包之中，就有一个有用的函数，`paste`，它可以轻松地完成这个任务！

```r
str_new <- paste(str_splited, collapse=" ")
str_new
# [1] "the quick brown fox jumps over a lazy dog"
```

# 如果不用 `collapse` 参数… 

很多人知道 `paste` 函数，但是很多人没有留意到其中有 `collapse` 这个参数。如果不用这个参数的话，有没有办法？当然是有的。这里就实现了一个简单的函数来做这件事。

```r
p = function(x){
    retval = x[1]
    if(length(x) >= 2){
        for(i in 2:length(x)){
            retval = paste(retval,as.character(x[i]),sep=" ")
        }
    }
    return(retval)
}

str_new_2 <- p(str_splited)
str_new_2
# [1] "the quick brown fox jumps over a lazy dog"
```

# 如果不用 `paste` 函数… 

如果有人有着一股折(dan4)腾(teng2)的心态，也许会问，不要 `paste` 函数怎么办？可以，还有不只一个方法。

比如说，输出到文件再读回来。

```r
cat(str_splited, file="temp.txt")
str_new_3 <- readLines("temp.txt")[1]
# Warning in readLines("temp.txt") :
#   incomplete final line found on 'temp.txt'
file.remove("temp.txt")
# [1] TRUE
str_new_3
# [1] "the quick brown fox jumps over a lazy dog"
```

又比如说，`charToRaw` 和 `rawToChar` 一起使用？

```r
temp1 <- cbind(" ", str_splited)
# cbind() 把矩阵横行地合并成一个大矩阵（列方式）
temp1
#           str_splited
#  [1,] " " "the"      
#  [2,] " " "quick"    
#  [3,] " " "brown"    
#  [4,] " " "fox"      
#  [5,] " " "jumps"    
#  [6,] " " "over"     
#  [7,] " " "a"        
#  [8,] " " "lazy"     
#  [9,] " " "dog"
```

然后利用`sapply`函数，结合`charToraw`函数与其反函数`rawTochar`函数，即可达到预期效果。

```
temp2 <- unlist( sapply(t(temp1), charToRaw) )[-1]

# sapply() 就是把各个 t(temp1) 中的向量元素套进 chraToRaw 来运行，并且返回结果组成向量
# unlist() 将list数据变成字符串向量或者数字向量的形式
# charToRaw() 将字母转换成 ascii 码
# [-1] 是用来去除边界多了一个的空格

temp2
#   the1   the2   the3        quick1 quick2 quick3 quick4 quick5        brown1 
# 74 68 65 20 71 75 69 63 6b 20 62 
# brown2 brown3 brown4 brown5          fox1   fox2   fox3        jumps1 jumps2 
# 72 6f 77 6e 20 66 6f 78 20 6a 75 
# jumps3 jumps4 jumps5         over1  over2  over3  over4             a        
# 6d 70 73 20 6f 76 65 72 20 61 20 
#  lazy1  lazy2  lazy3  lazy4          dog1   dog2   dog3 
# 6c 61 7a 79 20 64 6f 67 
str_new_4 <- rawToChar(temp2)
# rawToChar() 显然就是 charToRaw() 的反函数啦
str_new_4
# [1] "the quick brown fox jumps over a lazy dog"
```

以上代码一句话即：

```r
str_new_4 <- rawToChar(unlist(sapply(t(cbind(" ", str_splited)), charToRaw))[-1])
```

如果还嫌玩得不够大的话，使用最时髦的 Map Reduce 和 functional programming 思想来解决问题就好了！

```r
combstr = function(s1,s2) sprintf("%s %s",s1,s2)
str_new_5 <- Reduce(combstr, str_splited)
# Reduce() 就是神奇的 Map Reduce 中的 Reduce 啦，对 str_splited 中一个个地套上 combstr()！
str_new_5
# [1] "the quick brown fox jumps over a lazy dog"
```

如你所见，R 有着无与伦比的灵活性，希望各位客官看完这篇文章能够感受到 R 的强大和好玩！
