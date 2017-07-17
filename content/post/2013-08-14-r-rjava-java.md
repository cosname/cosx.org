---
title: 解惑rJava R与Java的高速通道
date: '2013-08-14T22:30:14+00:00'
author: 张丹
categories:
  - 软件应用
tags:
  - java
  - jcall
  - jinit
  - JRI
  - rjava
  - R语言
slug: r-rjava-java
forum_id: 418953
---

[R的极客理想系列文章](http://blog.fens.me/series-r/ "R的极客理想系列文章")，涵盖了R的思想，使用，工具，创新等的一系列要点，以我个人的学习和体验去诠释R的强大。

R语言作为统计学一门语言，一直在小众领域闪耀着光芒。直到大数据的爆发，R语言变成了一门炙手可热的数据分析的利器。随着越来越多的工程背景的人的加入，R语言的社区在迅速扩大成长。现在已不仅仅是统计领域，教育，银行，电商，互联网….都在使用R语言。

要成为有理想的极客，我们不能停留在语法上，要掌握牢固的数学，概率，统计知识，同时还要有创新精神，把R语言发挥到各个领域。让我们一起动起来吧，开始R的极客理想。<!--more-->
  
**关于作者：**

* 张丹(Conan), 程序员Java,R,PHP,Javascript
* weibo：@Conan_Z
* blog: [http://blog.fens.me](http://blog.fens.me/ "粉丝日志|跨界的IT博客")
* email: bsspirit@gmail.com

**转载请注明出处：**
  
[http://blog.fens.me/r-rjava-java](http://blog.fens.me/r-rjava-java "解惑rJava R与Java的高速通道")
  
![rjava](http://blog.fens.me/wp-content/uploads/2013/08/rjava1.png)

**前言**
  
Java语言在工业界长期处于霸主地位，Java语法、JVM、JDK、Java开源库，在近10年得到了爆发式的发展，几乎覆盖了应用开发的所有领域。伴随着Java的全领域发展，问题也随之而来了。语法越来越复杂，近似的项目越来越多，学好Java变得很难。对于没有IT背景的统计人员，学用Java更是难于上青天。

R一直是统计圈内处于佼佼者的语言，语法简单，学习曲线不太长也不太陡。如果能结合Java的通用性和R的专业性，碰撞出的火花，将会缤纷绚烂。

本文将介绍R与Java连接的高速通道，rJava通信方案。另外一篇文章介绍的Rserve通信方案，请参考： [Rserve与Java的跨平台通信](http://blog.fens.me/r-rserve-java/ "Rserve与Java的跨平台通信")

**目录**

1. rJava介绍
1. rJava安装
1. rJava实现R调用Java
1. rJava(JRI)实现Java调用R (win7)
1. rJava(JRI)实现Java调用R (Ubuntu)

# 1. rJava介绍

rJava是一个R语言和Java语言的通信接口，通过底层JNI实现调用，允许在R中直接调用Java的对象和方法。

rJava还提供了Java调用R的功能，是通过JRI(Java/R Interface)实现的。JRI现在已经被嵌入到rJava的包中，我们也可以单独试用这个功能。现在rJava包，已经成为很多基于Java开发R包的基础功能组件。

正式由于rJava是底层接口，并使用JNI作为接口调用，所以效率非常高。在JRI的方案中，JVM直接通过内存直接加载RVM，调用过程性能几乎无损耗，因此是非常高效连接通道，是R和Java通信的首选开发包。

# 2. rJava安装

**系统环境：**

```
* Linux Ubuntu 12.04.2 LTS 64bit server
* R version 3.0.1 64bit
* Java (Oracle SUN) 1.6.0_29 64bit Server VM


~ uname -a
Linux conan 3.5.0-23-generic #35~precise1-Ubuntu SMP Fri Jan 25 17:13:26 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux

~ cat /etc/issue
Ubuntu 12.04.2 LTS \n \l

~ R --version
R version 3.0.1 (2013-05-16) -- "Good Sport"
Copyright (C) 2013 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under the terms of the
GNU General Public License versions 2 or 3.
For more information about these matters see
http://www.gnu.org/licenses/.

~ java -version
java version "1.6.0_29"
Java(TM) SE Runtime Environment (build 1.6.0_29-b11)
Java HotSpot(TM) 64-Bit Server VM (build 20.4-b02, mixed mode)
```    

**rJava安装**

```    
#配置rJava环境
~ sudo R CMD javareconf

#启动R
~ sudo R
> install.packages("rJava")
installing via 'install.libs.R' to /usr/local/lib/R/site-library/rJava
** R
** inst
** preparing package for lazy loading
** help
*** installing help indices
** building package indices
** testing if installed package can be loaded
* DONE (rJava)

The downloaded source packages are in
        ‘/tmp/RtmpiZyCE7/downloaded_packages’
```    

# 3. rJava实现R调用Java

在R环境中，使用rJava包编程

```r    
#加载rJava包
> library(rJava)
> search()
 [1] ".GlobalEnv"        "package:rJava"     "package:stats"
 [4] "package:graphics"  "package:grDevices" "package:utils"
 [7] "package:datasets"  "package:methods"   "Autoloads"
[10] "package:base"

#启动JVM
> .jinit()

#声明并赋值到字符串
> s  s
[1] "Java-Object{Hello World!}"

#查看字符串长度
> .jcall(s,"I","length")
[1] 12

#索引World的位置
> .jcall(s,"I","indexOf","World")
[1] 6

#查看concat的方法声明
> .jmethods(s,"concat")
[1] "public java.lang.String java.lang.String.concat(java.lang.String)"

#使用concat方法连接字符串
> .jcall(s,"Ljava/lang/String;","concat",s)
[1] "Hello World!Hello World!"

#打印字符串对象
> print(s)
[1] "Java-Object{Hello World!}"

#打印字符串值
> .jstrVal(s)
[1] "Hello World!"
 ```   

**rJava优化过的方法调用，用$来调用方法**

```r
#同.jcall(s,"I","length")
> s$length()
[1] 12

#同.jcall(s,"I","indexOf","World")
> s$indexOf("World")
[1] 6
```    

# 4. rJava(JRI)实现Java调用R (win7)

在win7中安装rJava

**系统环境：**

* win7 64bit 旗舰版
* R 3.0.1
* Java 1.6.0_45

**设置环境变量**

```bash
PATH: C:\Program Files\R\R-3.0.1\bin\x64;D:\toolkit\java\jdk6\bin;;D:\toolkit\java\jdk6\jre\bin\server
JAVA_HOME: D:\toolkit\java\jdk6
CLASSPATH: C:\Program Files\R\R-3.0.1\library\rJava\jri
```    

**在R中安装rJava**

```r    
> install.packages("rJava")

#加载rJava
> library(rJava)
> .jinit()

#R调用Java变量测试
> s  s
[1] "Java-Object{Hello World!}"
```    

**启动Eclipse编写程序**

![rjava2](http://blog.fens.me/wp-content/uploads/2013/08/rjava2.png)

```java
package org.conan.r.rjava;

import org.rosuda.JRI.Rengine;

public class DemoRJava {

    public static void main(String[] args) {
        DemoRJava demo = new DemoRJava();
        demo.callRJava();
    }

    public void callRJava() {
        Rengine re = new Rengine(new String[] { "--vanilla" }, false, null);
        if (!re.waitForR()) {
            System.out.println("Cannot load R");
            return;
        }

        //打印变量
        String version = re.eval("R.version.string").asString();
        System.out.println(version);

        //循环打印数组
        double[] arr = re.eval("rnorm(10)").asDoubleArray();
        for (double a : arr) {
            System.out.print(a + ",");
        }
        re.end();
    }
}
```    

**在Eclipse启动设置VM参数：**

```
-Djava.library.path="C:\Program Files\R\R-3.0.1\library\rJava\jri\x64"
```

![rjava](http://blog.fens.me/wp-content/uploads/2013/08/rjava.png)

**运行结果：**

```   
R version 3.0.1 (2013-05-16)
0.04051018703700011,-0.3321596519938258,0.45642459001166913,-1.1907153494936031,1.5872266854172385,1.3639721994863943,-0.6309712627586983,-1.5226698569087498,-1.0416402147174952,0.4864034017637044
```    

**打包DemoRJava.jar**
  
在Eclipse中完成打包，上传到linux环境，继续测试。

# 5. rJava(JRI)实现Java调用R (Ubuntu)

新建目录DemoRJava，上传DemoRJava.jar到DemoRJava

```bash
~ mkdir /home/conan/R/DemoRJava
~ cd /home/conan/R/DemoRJava
~ ls -l
-rw-r--r-- 1 conan conan 1328 Aug  8  2013 DemoRJava.jar
```    

**运行Jar包**

```bash
~ export R_HOME=/usr/lib/R
~ java -Djava.library.path=/usr/local/lib/R/site-library/rJava/jri -cp /usr/local/lib/R/site-library/rJava/jri/JRI.jar:/home/conan/R/DemoRJava/DemoRJava.jar org.conan.r.rjava.DemoRJava
```    

**运行结果**

```   
R version 3.0.1 (2013-05-16)
0.6374494596732511,1.3413824702002808,0.04573045670001342,-0.6885617932810327,0.14970067632722675,-0.3989493870007832,-0.6148250252955993,0.40132038323714453,-0.5385260423222166,0.3459850956295771
```

我们完成了，R和Java的互调。包括了R通过rJava调用Java，Java通过JRI调用R。并演示了win和linux中的使用方法。

**转载请注明出处：**
  
[http://blog.fens.me/r-rjava-java](http://blog.fens.me/r-rjava-java "解惑rJava R与Java的高速通道")
