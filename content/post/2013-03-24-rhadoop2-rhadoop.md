---
title: RHadoop实践系列之二：RHadoop安装与使用
date: '2013-03-24T21:59:56+00:00'
author: 张丹
categories:
  - 软件应用
tags:
  - hadoop
  - MapReduce
  - rhadoop
  - R语言
  - 海量数据
slug: rhadoop2-rhadoop
forum_id: 418924
---

Author：张丹(Conan)
  
Date: 2013-03-07

Weibo: @Conan_Z
  
Email: <bsspirit@gmail.com>
  
Blog: <http://www.fens.me/blog>

APPs:
  
@晒粉丝 <http://www.fens.me>
  
@每日中国天气 <http://apps.weibo.com/chinaweatherapp>

# RHadoop实践系列文章

RHadoop实践系列文章，包含了R语言与Hadoop结合进行海量数据分析。Hadoop主要用来存储海量数据，R语言完成MapReduce 算法，用来替代Java的MapReduce实现。有了RHadoop可以让广大的R语言爱好者，有更强大的工具处理大数据。1G, 10G, 100G, TB,PB 由于大数据所带来的单机性能问题，可能会一去联复返了。

RHadoop实践是一套系列文章，主要包括“Hadoop环境搭建”，“RHadoop安装与使用”，“R实现MapReduce的算法案 例”，“HBase和rhbase的安装与使用”。对于单独的R语言爱好者，Java爱好者，或者Hadoop爱好者来说，同时具备三种语言知识并不容 易。此文虽为入门文章，但R,Java,Hadoop基础知识还是需要大家提前掌握。

<!--more-->

# 第二篇 RHadoop安装与使用部分，分为3个章节。

1. 环境准备
1. RHadoop安装
1. RHadoop程序用例

每一章节，都会分为“文字说明部分”和“代码部分”，保持文字说明与代码的连贯性。

注：Hadoop环境搭建的详细记录，请查看 同系列上一篇文章 “RHadoop实践系列文章之Hadoop环境搭建”。
  
由于两篇文章并非同一时间所写，hadoop版本及操作系统，分步式环境都略有不同。
  
两篇文章相互独立，请大家在理解的基础上动手实验，不要完成依赖两篇文章中的运行命令。

# 环境准备

## 文字说明部分：

首先环境准备，这里我选择了Linux Ubuntu操作系统12.04的64位版本，大家可以根据自己的使用习惯选择顺手的Linux。

但JDK一定要用Oracle SUN官方的版本，请从官网下载，操作系统的自带的OpenJDK会有各种不兼容。JDK请选择1.6.x的版本，JDK1.7版本也会有各种的不兼容情况。
  
<http://www.oracle.com/technetwork/java/javase/downloads/index.html>

Hadoop的环境安装，请参考RHadoop实践系统“Hadoop环境搭建”的一文。

R语言请安装2.15以后的版本，2.14是不能够支持RHadoop的。
  
如果你也使用Linux Ubuntu操作系统12.04，请先更新软件包源，否则只能下载到2.14版本的R。

## 代码部分：

### 1. 操作系统Ubuntu 12.04 x64·

```bash
~ uname -a
Linux domU-00-16-3e-00-00-85 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10 20:39:51 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
```    

### 2. JAVA环境

```bash
~ java -version
java version "1.6.0_29"
Java(TM) SE Runtime Environment (build 1.6.0_29-b11)
Java HotSpot(TM) 64-Bit Server VM (build 20.4-b02, mixed mode)
```    

### 3. HADOOP环境(这里只需要hadoop)

```
hadoop-1.0.3  hbase-0.94.2  hive-0.9.0  pig-0.10.0  sqoop-1.4.2  thrift-0.8.0  zookeeper-3.4.4
```    

### 4. R的环境

```
R version 2.15.3 (2013-03-01) -- "Security Blanket"
Copyright (C) 2013 The R Foundation for Statistical Computing
ISBN 3-900051-07-0
Platform: x86_64-pc-linux-gnu (64-bit)
```    
#### 4.1 如果是Ubuntu 12.04，请更新源再下载R2.15.3版本

``` bash
sh -c "echo deb http://mirror.bjtu.edu.cn/cran/bin/linux/ubuntu precise/ >>/etc/apt/sources.list"
apt-get update
apt-get install r-base
```    

# RHadoop安装

## 文字说明部分：

RHadoop是RevolutionAnalytics的工程的项目，开源实现代码在GitHub社区可以找到。RHadoop包含三个R包 (rmr，rhdfs，rhbase)，分别是对应Hadoop系统架构中的，MapReduce, HDFS, HBase 三个部分。由于这三个库不能在CRAN中找到，所以需要自己下载。
  
<https://github.com/RevolutionAnalytics/RHadoop/wiki>

接下我们需要先安装这三个库的依赖库。
  
首先是rJava，上个章节我们已经配置好了JDK1.6的环境，运行R CMD javareconf命令，R的程序从系统变量中会读取Java配置。然后打开R程序，通过install.packages的方式，安装rJava。

然后，我还要安装其他的几个依赖库，reshape2，Rcpp，iterators，itertools，digest，RJSONIO，functional，通过install.packages都可以直接安装。

接下安装rhdfs库，在环境变量中增加 HADOOP\_CMD 和 HADOOP\_STREAMING 两个变量，可以用export在当前命令窗口中增加。但为下次方便使用，最好把变量增加到系统环境变更/etc/environment文件中。再用 R CMD INSTALL安装rhdfs包，就可以顺利完成了。

安装rmr库，使用R CMD INSTALL也可以顺利完成了。

安装rhbase库，后面“HBase和rhbase的安装与使用”文章中会继续介绍，这里暂时跳过。

最后，我们可以查看一下，RHADOOP都安装了哪些库。
  
由于我的硬盘是外接的，使用mount和软连接(ln -s)挂载了R类库的目录，所以是R的类库在/disk1/system下面
  
/disk1/system/usr/local/lib/R/site-library/
  
一般R的类库目录是/usr/lib/R/site-library或者/usr/local/lib/R/site-library，用户也可以使用whereis R的命令查询，自己电脑上R类库的安装位置

## 代码部分：

### 1. 下载RHadoop相关的3个程序包

<https://github.com/RevolutionAnalytics/RHadoop/wiki/Downloads>

```
rmr-2.1.0
rhdfs-1.0.5
rhbase-1.1
```

### 2. 复制到/root/R目录

```bash
~/R# pwd
/root/R
~/R# ls
rhbase_1.1.tar.gz  rhdfs_1.0.5.tar.gz  rmr2_2.1.0.tar.gz
```    

### 3. 安装依赖库

```bash
命令行执行
~ R CMD javareconf
```
```r
# 启动R程序
install.packages("rJava")
install.packages("reshape2")
install.packages("Rcpp")
install.packages("iterators")
install.packages("itertools")
install.packages("digest")
install.packages("RJSONIO")
install.packages("functional")
```    

### 4. 安装rhdfs库

```bash
~ export HADOOP_CMD=/root/hadoop/hadoop-1.0.3/bin/hadoop
~ export HADOOP_STREAMING=/root/hadoop/hadoop-1.0.3/contrib/streaming/hadoop-streaming-1.0.3.jar (rmr2会用到)
~ R CMD INSTALL /root/R/rhdfs_1.0.5.tar.gz 
```    

#### 4.1 最好把HADOOP_CMD设置到环境变量

```bash
~ vi /etc/environment
HADOOP_CMD=/root/hadoop/hadoop-1.0.3/bin/hadoop
HADOOP_STREAMING=/root/hadoop/hadoop-1.0.3/contrib/streaming/hadoop-streaming-1.0.3.jar
./etc/environment
```    

### 5. 安装rmr库

```bash
~  R CMD INSTALL rmr2_2.1.0.tar.gz 
```    

### 6. 安装rhbase库 (暂时跳过)

### 7. 所有的安装包

```bash
~ ls /disk1/system/usr/local/lib/R/site-library/
digest  functional  iterators  itertools  plyr  Rcpp  reshape2  rhdfs  rJava  RJSONIO  rmr2  stringr
```    

# RHadoop程序用例

## 文字说明部分：

安装好rhdfs和rmr两个包后，我们就可以使用R尝试一些hadoop的操作了。

首先，是基本的hdfs的文件操作。

查看hdfs文件目录
  
hadoop的命令：hadoop fs -ls /user
  
R语言函数：hdfs.ls(”/user/“)

查看hadoop数据文件
  
hadoop的命令：hadoop fs -cat /user/hdfs/o\_same\_school/part-m-00000
  
R语言函数：hdfs.cat(”/user/hdfs/o\_same\_school/part-m-00000″)

接下来，我们执行一个rmr算法的任务

普通的R语言程序：

```r
small.ints = 1:10
sapply(small.ints, function(x) x^2)
```    

MapReduce的R语言程序：

```r
small.ints = to.dfs(1:10)
mapreduce(input = small.ints, map = function(k, v) cbind(v, v^2))
from.dfs("/tmp/RtmpWnzxl4/file5deb791fcbd5")
```    

因为MapReduce只能访问HDFS文件系统，先要用to.dfs把数据存储到HDFS文件系统里。MapReduce的运算结果再用from.dfs函数从HDFS文件系统中取出。

第二个，rmr的例子是wordcount，对文件中的单词计数

```r
input<- '/user/hdfs/o_same_school/part-m-00000'
wordcount = function(input, output = NULL, pattern = " ") {
    wc.map = function(., lines) {
                keyval(unlist( strsplit( x = lines,split = pattern)),1)
        }
        wc.reduce =function(word, counts ) {
                keyval(word, sum(counts))
        } 
        mapreduce(input = input ,output = output, input.format = "text",
            map = wc.map, reduce = wc.reduce,combine = T)
    }
wordcount(input)
from.dfs("/tmp/RtmpfZUFEa/file6cac626aa4a7")
```    

我在HDFS上提前放置了数据文件/user/hdfs/o\_same\_school/part-m-00000。写wordcount的MapReduce函数，执行wordcount函数，最后用from.dfs从HDFS中取得结果。

## 代码部分：

### 1. rhdfs包的使用

```r
# 启动R程序
library(rhdfs)
# Loading required package: rJava
# HADOOP_CMD=/root/hadoop/hadoop-1.0.3/bin/hadoop
# Be sure to run hdfs.init()
hdfs.init()
```    

#### 1.1 命令查看hadoop目录

```bash
~ hadoop fs -ls /user
Found 4 items
drwxr-xr-x   - root supergroup          0 2013-02-01 12:15 /user/conan
drwxr-xr-x   - root supergroup          0 2013-03-06 17:24 /user/hdfs
drwxr-xr-x   - root supergroup          0 2013-02-26 16:51 /user/hive
drwxr-xr-x   - root supergroup          0 2013-03-06 17:21 /user/root
```    

#### 1.2 rhdfs查看hadoop目录

```r
hdfs.ls("/user/")
    
 permission    owner  group    size     modtime        file
1 drwxr-xr-x  root supergroup    0 2013-02-01 12:15 /user/conan
2 drwxr-xr-x  root supergroup    0 2013-03-06 17:24  /user/hdfs
3 drwxr-xr-x  root supergroup    0 2013-02-26 16:51  /user/hive
4 drwxr-xr-x  root supergroup    0 2013-03-06 17:21  /user/root
```    

#### 1.3 命令查看hadoop数据文件

```bash
    ~ hadoop fs -cat /user/hdfs/o_same_school/part-m-00000
    
    10,3,tsinghua university,2004-05-26 15:21:00.0
    23,4007,北京第一七一中学,2004-05-31 06:51:53.0
    51,4016,大连理工大学,2004-05-27 09:38:31.0
    89,4017,Amherst College,2004-06-01 16:18:56.0
    92,4017,斯坦福大学,2012-11-28 10:33:25.0
    99,4017,Stanford University Graduate School of Business,2013-02-19 12:17:15.0
    113,4017,Stanford University,2013-02-19 12:17:15.0
    123,4019,St Paul's Co-educational College - Hong Kong,2004-05-27 18:04:17.0
    138,4019,香港苏浙小学,2004-05-27 18:59:58.0
    172,4020,University,2004-05-27 19:14:34.0
    182,4026,ff,2004-05-28 04:42:37.0
    183,4026,ff,2004-05-28 04:42:37.0
    189,4033,tsinghua,2011-09-14 12:00:38.0
    195,4035,ba,2004-05-31 07:10:24.0
    196,4035,ma,2004-05-31 07:10:24.0
    197,4035,southampton university,2013-01-07 15:35:18.0
    246,4067,美国史丹佛大学,2004-06-12 10:42:10.0
    254,4067,美国史丹佛大学,2004-06-12 10:42:10.0
    255,4067,美国休士顿大学,2004-06-12 10:42:10.0
    257,4068,清华大学,2004-06-12 10:42:10.0
    258,4068,北京八中,2004-06-12 17:34:02.0
    262,4068,香港中文大学,2004-06-12 17:34:02.0
    310,4070,首都师范大学初等教育学院,2004-06-14 15:35:52.0
    312,4070,北京师范大学经济学院,2004-06-14 15:35:52.0
```    

#### 1.4 rhdfs查看hadoop数据文件

```r
hdfs.cat("/user/hdfs/o_same_school/part-m-00000")
    
     [1] "10,3,tsinghua university,2004-05-26 15:21:00.0"
     [2] "23,4007,北京第一七一中学,2004-05-31 06:51:53.0"
     [3] "51,4016,大连理工大学,2004-05-27 09:38:31.0"
     [4] "89,4017,Amherst College,2004-06-01 16:18:56.0"
     [5] "92,4017,斯坦福大学,2012-11-28 10:33:25.0"
     [6] "99,4017,Stanford University Graduate School of Business,2013-02-19 12:17:15.0"
     [7] "113,4017,Stanford University,2013-02-19 12:17:15.0"
     [8] "123,4019,St Paul's Co-educational College - Hong Kong,2004-05-27 18:04:17.0"
     [9] "138,4019,香港苏浙小学,2004-05-27 18:59:58.0"
    [10] "172,4020,University,2004-05-27 19:14:34.0"
    [11] "182,4026,ff,2004-05-28 04:42:37.0"
    [12] "183,4026,ff,2004-05-28 04:42:37.0"
    [13] "189,4033,tsinghua,2011-09-14 12:00:38.0"
    [14] "195,4035,ba,2004-05-31 07:10:24.0"
    [15] "196,4035,ma,2004-05-31 07:10:24.0"
    [16] "197,4035,southampton university,2013-01-07 15:35:18.0"
    [17] "246,4067,美国史丹佛大学,2004-06-12 10:42:10.0"
    [18] "254,4067,美国史丹佛大学,2004-06-12 10:42:10.0"
    [19] "255,4067,美国休士顿大学,2004-06-12 10:42:10.0"
    [20] "257,4068,清华大学,2004-06-12 10:42:10.0"
    [21] "258,4068,北京八中,2004-06-12 17:34:02.0"
    [22] "262,4068,香港中文大学,2004-06-12 17:34:02.0"
    [23] "310,4070,首都师范大学初等教育学院,2004-06-14 15:35:52.0"
    [24] "312,4070,北京师范大学经济学院,2004-06-14 15:35:52.0"
```    

### 2. rmr2包的使用

```r
    # 启动R程序
    library(rmr2)
    
    Loading required package: Rcpp
    Loading required package: RJSONIO
    Loading required package: digest
    Loading required package: functional
    Loading required package: stringr
    Loading required package: plyr
    Loading required package: reshape2
```    

#### 2.1 执行r任务

```r
small.ints = 1:10
sapply(small.ints, function(x) x^2)
    
[1]   1   4   9  16  25  36  49  64  81 100
```    

#### 2.2 执行rmr2任务

```r
    small.ints = to.dfs(1:10)
    
    13/03/07 12:12:55 INFO util.NativeCodeLoader: Loaded the native-hadoop library
    13/03/07 12:12:55 INFO zlib.ZlibFactory: Successfully loaded & initialized native-zlib library
    13/03/07 12:12:55 INFO compress.CodecPool: Got brand-new compressor
    
    mapreduce(input = small.ints, map = function(k, v) cbind(v, v^2))
    
    packageJobJar: [/tmp/RtmpWnzxl4/rmr-local-env5deb2b300d03, /tmp/RtmpWnzxl4/rmr-global-env5deb398a522b, /tmp/RtmpWnzxl4/rmr-streaming-map5deb1552172d, /root/hadoop/tmp/hadoop-unjar7838617732558795635/] [] /tmp/streamjob4380275136001813619.jar tmpDir=null
    13/03/07 12:12:59 INFO mapred.FileInputFormat: Total input paths to process : 1
    13/03/07 12:12:59 INFO streaming.StreamJob: getLocalDirs(): [/root/hadoop/tmp/mapred/local]
    13/03/07 12:12:59 INFO streaming.StreamJob: Running job: job_201302261738_0293
    13/03/07 12:12:59 INFO streaming.StreamJob: To kill this job, run:
    13/03/07 12:12:59 INFO streaming.StreamJob: /disk1/hadoop/hadoop-1.0.3/libexec/../bin/hadoop job  -Dmapred.job.tracker=hdfs://r.qa.tianji.com:9001 -kill job_201302261738_0293
    13/03/07 12:12:59 INFO streaming.StreamJob: Tracking URL: http://192.168.1.243:50030/jobdetails.jsp?jobid=job_201302261738_0293
    13/03/07 12:13:00 INFO streaming.StreamJob:  map 0%  reduce 0%
    13/03/07 12:13:15 INFO streaming.StreamJob:  map 100%  reduce 0%
    13/03/07 12:13:21 INFO streaming.StreamJob:  map 100%  reduce 100%
    13/03/07 12:13:21 INFO streaming.StreamJob: Job complete: job_201302261738_0293
    13/03/07 12:13:21 INFO streaming.StreamJob: Output: /tmp/RtmpWnzxl4/file5deb791fcbd5
    
    from.dfs("/tmp/RtmpWnzxl4/file5deb791fcbd5")
    
    $key
    NULL
    
    $val
           v
     [1,]  1   1
     [2,]  2   4
     [3,]  3   9
     [4,]  4  16
     [5,]  5  25
     [6,]  6  36
     [7,]  7  49
     [8,]  8  64
     [9,]  9  81
    [10,] 10 100
```    

#### 2.3 wordcount执行rmr2任务

```r
    input<- '/user/hdfs/o_same_school/part-m-00000'
    wordcount = function(input, output = NULL, pattern = " "){
    
        wc.map = function(., lines) {
                keyval(unlist( strsplit( x = lines,split = pattern)),1)
        }
    
        wc.reduce =function(word, counts ) {
                keyval(word, sum(counts))
        }         
    
        mapreduce(input = input ,output = output, input.format = "text",
            map = wc.map, reduce = wc.reduce,combine = T)
    }
    
    wordcount(input)
    
    packageJobJar: [/tmp/RtmpfZUFEa/rmr-local-env6cac64020a8f, /tmp/RtmpfZUFEa/rmr-global-env6cac73016df3, /tmp/RtmpfZUFEa/rmr-streaming-map6cac7f145e02, /tmp/RtmpfZUFEa/rmr-streaming-reduce6cac238dbcf, /tmp/RtmpfZUFEa/rmr-streaming-combine6cac2b9098d4, /root/hadoop/tmp/hadoop-unjar6584585621285839347/] [] /tmp/streamjob9195921761644130661.jar tmpDir=null
    13/03/07 12:34:41 INFO util.NativeCodeLoader: Loaded the native-hadoop library
    13/03/07 12:34:41 WARN snappy.LoadSnappy: Snappy native library not loaded
    13/03/07 12:34:41 INFO mapred.FileInputFormat: Total input paths to process : 1
    13/03/07 12:34:41 INFO streaming.StreamJob: getLocalDirs(): [/root/hadoop/tmp/mapred/local]
    13/03/07 12:34:41 INFO streaming.StreamJob: Running job: job_201302261738_0296
    13/03/07 12:34:41 INFO streaming.StreamJob: To kill this job, run:
    13/03/07 12:34:41 INFO streaming.StreamJob: /disk1/hadoop/hadoop-1.0.3/libexec/../bin/hadoop job  -Dmapred.job.tracker=hdfs://r.qa.tianji.com:9001 -kill job_201302261738_0296
    13/03/07 12:34:41 INFO streaming.StreamJob: Tracking URL: http://192.168.1.243:50030/jobdetails.jsp?jobid=job_201302261738_0296
    13/03/07 12:34:42 INFO streaming.StreamJob:  map 0%  reduce 0%
    13/03/07 12:34:59 INFO streaming.StreamJob:  map 100%  reduce 0%
    13/03/07 12:35:08 INFO streaming.StreamJob:  map 100%  reduce 17%
    13/03/07 12:35:14 INFO streaming.StreamJob:  map 100%  reduce 100%
    13/03/07 12:35:20 INFO streaming.StreamJob: Job complete: job_201302261738_0296
    13/03/07 12:35:20 INFO streaming.StreamJob: Output: /tmp/RtmpfZUFEa/file6cac626aa4a7
    
    from.dfs("/tmp/RtmpfZUFEa/file6cac626aa4a7")
    
    $key
     [1] "-"
     [2] "04:42:37.0"
     [3] "06:51:53.0"
     [4] "07:10:24.0"
     [5] "09:38:31.0"
     [6] "10:33:25.0"
     [7] "10,3,tsinghua"
     [8] "10:42:10.0"
     [9] "113,4017,Stanford"
    [10] "12:00:38.0"
    [11] "12:17:15.0"
    [12] "123,4019,St"
    [13] "138,4019,香港苏浙小学,2004-05-27"
    [14] "15:21:00.0"
    [15] "15:35:18.0"
    [16] "15:35:52.0"
    [17] "16:18:56.0"
    [18] "172,4020,University,2004-05-27"
    [19] "17:34:02.0"
    [20] "18:04:17.0"
    [21] "182,4026,ff,2004-05-28"
    [22] "183,4026,ff,2004-05-28"
    [23] "18:59:58.0"
    [24] "189,4033,tsinghua,2011-09-14"
    [25] "19:14:34.0"
    [26] "195,4035,ba,2004-05-31"
    [27] "196,4035,ma,2004-05-31"
    [28] "197,4035,southampton"
    [29] "23,4007,北京第一七一中学,2004-05-31"
    [30] "246,4067,美国史丹佛大学,2004-06-12"
    [31] "254,4067,美国史丹佛大学,2004-06-12"
    [32] "255,4067,美国休士顿大学,2004-06-12"
    [33] "257,4068,清华大学,2004-06-12"
    [34] "258,4068,北京八中,2004-06-12"
    [35] "262,4068,香港中文大学,2004-06-12"
    [36] "312,4070,北京师范大学经济学院,2004-06-14"
    [37] "51,4016,大连理工大学,2004-05-27"
    [38] "89,4017,Amherst"
    [39] "92,4017,斯坦福大学,2012-11-28"
    [40] "99,4017,Stanford"
    [41] "Business,2013-02-19"
    [42] "Co-educational"
    [43] "College"
    [44] "College,2004-06-01"
    [45] "Graduate"
    [46] "Hong"
    [47] "Kong,2004-05-27"
    [48] "of"
    [49] "Paul's"
    [50] "School"
    [51] "University"
    [52] "university,2004-05-26"
    [53] "university,2013-01-07"
    [54] "University,2013-02-19"
    [55] "310,4070,首都师范大学初等教育学院,2004-06-14"
    
    $val
     [1] 1 2 1 2 1 1 1 4 1 1 2 1 1 1 1 2 1 1 2 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
    [39] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
```
