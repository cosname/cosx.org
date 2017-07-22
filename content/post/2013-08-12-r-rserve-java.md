---
title: Rserve与Java的跨平台通信
date: '2013-08-12T23:19:29+00:00'
author: 张丹
categories:
  - 软件应用
tags:
  - java
  - Rserve
  - R语言
slug: r-rserve-java
forum_id: 418951
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
  
[http://blog.fens.me/r-rserve-java/](http://blog.fens.me/r-rserve-java/ "Rserve与Java的跨平台通信")

![rserve-java](http://blog.fens.me/wp-content/uploads/2013/08/rserve-java.png)

**前言**

现在主流的异构跨平台通信组件[Apache Thrift](http://thrift.apache.org/)已经火遍大江南北，支持15种编程语言，但是到目前为止还没有加入R语言。要让R实现跨平台的通信，就只能从R的社区中找方案，像rJava,RCpp,rpy都是2种语言结合的方案，这些方案类似地会把R引擎加载到其他的语言内存环境。优点是高效，缺点是紧耦合，扩展受限，接口程序无法重用。

Rserve给了我们一种新的选择，抽象R语言网络接口，基于TCP/IP协议实现与多语言之间的通信。让我们体验一下Rserve与Java的跨平台通信。

**目录**

1. Rserve介绍
1. Rserve安装
1. Java远程连接Rserve

# 1. Rserve介绍

Rserve是一个基于TCP/IP协议的，允许R语言与其他语言通信的C/S结构的程序，支持C/C++,Java,PHP,Python,Ruby,Nodejs等。 Rserve提供远程连接，认证，文件传输等功能。我们可以设计R做为后台服务，处理统计建模，数据分析，绘图等的任务。

# 2. Rserve安装

**系统环境:**
  
Linux Ubuntu 12.04.2 LTS 64bit server
  
R 3.0.1 64bit

```bash    
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
```    

**Rserve安装**

```    
#建议使用root权限安装
~ sudo R

> install.packages("Rserve")
installing via 'install.libs.R' to /usr/local/lib/R/site-library/Rserve
** R
** inst
** preparing package for lazy loading
** help
*** installing help indices
** building package indices
** testing if installed package can be loaded
* DONE (Rserve)
```   

**启动Rserve**

```    
~ R CMD Rserve

R version 3.0.1 (2013-05-16) -- "Good Sport"
Copyright (C) 2013 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

Rserv started in daemon mode.

#查看进程
~ ps -aux|grep Rserve
conan     7142  0.0  1.2 116296 25240 ?        Ss   09:13   0:00 /usr/lib/R/bin/Rserve

#查看端口
~ netstat -nltp|grep Rserve
tcp        0      0 127.0.0.1:6311          0.0.0.0:*               LISTEN      7142/Rserve
```    

这时Rserve已经启动，端口是6311。接下来，我们来简单地用一下。

# 3. Java远程连接Rserve

* 1、远程连接Rserve
  
    刚刚启动时，使用的本地模式，如果想运程连接需要增加参数 –RS-enable-remote

    ```    
    #杀掉刚才的Rserve守护进程
    ~ kill -9 7142
    
    #打开远程模式重新启动
    ~ R CMD Rserve --RS-enable-remote
    
    #查看端口
    ~ netstat -nltp|grep Rserve
    tcp        0      0 0.0.0.0:6311            0.0.0.0:*               LISTEN      7173/Rserve
    ```   

    0 0.0.0.0:6311，表示不限IP访问了。

* 2、下载Java客户端JAR包
  
    下载Java客户端JAR包：http://www.rforge.net/Rserve/files/

    * REngine.jar
    * RserveEngine.jar

* 3、创建Java工程
  
    在Eclipse中新建Java工程，并加载JAR包环境中。
  
![rserve1](http://blog.fens.me/wp-content/uploads/2013/08/rserve1.png)

* 4、Java编程实现

    ```java    
    package org.conan.r.rserve;

    import org.rosuda.REngine.REXP;
    import org.rosuda.REngine.REXPMismatchException;
    import org.rosuda.REngine.Rserve.RConnection;
    import org.rosuda.REngine.Rserve.RserveException;

    public class Demo1 {

        public static void main(String[] args) throws RserveException, REXPMismatchException {
            Demo1 demo = new Demo1();
            demo.callRserve();
        }

        public void callRserve() throws RserveException, REXPMismatchException {
            RConnection c = new RConnection("192.168.1.201");
            REXP x = c.eval("R.version.string");
            System.out.println(x.asString());//打印变量x

            double[] arr = c.eval("rnorm(10)").asDoubles();
            for (double a : arr) {//循环打印变量arr
                System.out.print(a + ",");
            }
        }
    }
    ```    

* 5、运行结果

    ```r   
    R version 3.0.1 (2013-05-16)
    1.7695224124757984,-0.29753038160770323,0.26596993631142246,1.4027325257239547,-0.30663565983302676,-0.17594309812158912,0.10071253841443684,0.9365455161259986,0.11272119436439701,0.5766373030674361
    ```

通过Rserve非常简单地实现了，Java和R的通信。
  
解决了通信的问题，我们就可以发挥想象，把R更广泛的用起来。

接下来，会讲到如何设计Java和R互相调用的软件架构。敬请关注….

**转载请注明出处：**
  
[http://blog.fens.me/r-rserve-java/](http://blog.fens.me/r-rserve-java/ "Rserve与Java的跨平台通信")
