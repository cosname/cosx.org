---
title: R利剑NoSQL系列文章 之Cassandra
date: '2013-07-18T18:05:14+00:00'
author: 张丹
categories:
  - 统计软件
tags:
  - Cassandra
  - nosql
  - RCassandra
  - 大数据
slug: r-nosql-cassandra
forum_id: 418945
---

[R利剑NoSQL系列文章](http://blog.fens.me/series-r-nosql/ "R利剑NoSQL系列文章")，主要介绍通过R语言连接使用nosql数据库。涉及的NoSQL产品，包括[Redis](http://blog.fens.me/nosql-r-redis/ "R利剑NoSQL系列文章 之 Redis"), [MongoDB](http://blog.fens.me/nosql-r-mongodb/ "R利剑NoSQL系列文章 之 MongoDB"), [HBase](http://blog.fens.me/nosql-r-hbase "R利剑NoSQL系列文章 之 HBase"), [Hive](http://blog.fens.me/nosql-r-hive/ "R利剑NoSQL系列文章 之 Hive"), [Cassandra](http://blog.fens.me/nosql-r-cassandra/ "R利剑NoSQL系列文章 之 Cassandra"), [Neo4j](http://blog.fens.me/nosql-r-neo4j/ "R利剑NoSQL系列文章 之 Neo4j")。希望通过我的介绍让广大的R语言爱好者，有更多的开发选择，做出更多地激动人心的应用。

关于作者：

  * 张丹(Conan), 程序员Java,R,PHP,Javascript
  * weibo：@Conan_Z
  * blog: http://blog.fens.me
  * email: bsspirit@gmail.com

转载请注明：
  
[/2013/07/r-nosql-cassandra/](/2013/07/r-nosql-cassandra/ "R利剑NoSQL系列文章 之 cassandra")

![rcassandra](https://uploads.cosx.org/2013/07/rcassandra.png)
  

第三篇 R利剑Cassandra，分为7个章节。

  1. Cassandra介绍
  2. Cassandra安装
  3. RCassandra安装
  4. RCassandra函数库
  5. RCassandra基本使用操作
  6. RCassandra使用案例
  7. Cassandra的没落

每一章节，都会分为“文字说明部分”和“代码部分”，保持文字说明与代码的连贯性。

# 1. Cassandra介绍

Apache Cassandra是一套开源分布式NoSQL数据库系统。它最初由Facebook开发，用于储存收件箱等简单格式数据，集Google BigTable的数据模型与Amazon Dynamo的完全分布式的架构于一身。Facebook于2008将 Cassandra 开源，此后，由于Cassandra良好的可扩放性，被Digg、Twitter等知名Web 2.0网站所采纳，成为了一种流行的分布式结构化数据存储方案。

Cassandra 的名称来源于希腊神话，是特洛伊的一位悲剧性的女先知的名字，因此项目的Logo是一只放光的眼睛。

Cassandra的数据会写入多个节点，来保证数据的可靠性，在一致性、可用性和网络分区耐受能力（CAP）的折衷问题上，Cassandra比较灵活，用户在读取时可以指定要求所有副本一致（高一致性）、读到一个副本即可（高可用性）或是通过选举来确认多数副本一致即可（折衷）。这样，Cassandra可以适用于有节点、网络失效，以及多数据中心的场景。

Cassandra介绍摘自：维基百科(http://zh.wikipedia.org/wiki/Cassandra)

# 2. Cassandra安装

## 2.1 文字说明部分：
  
首先环境准备，这里我选择了Linux Ubuntu操作系统12.04的64位服务器版本，大家可以根据自己的使用习惯选择顺手的Linux。

JDK使用SUN官方版本JDK 1.6.0_29，请不要用Linux自带的openjdk。

手动下载并安装Cassandra。

Cassandra配置，需要提前初始化几个目录。

  * data\_file\_directories：为数据文件目录
  * commitlog_directory：为日志文件目录
  * saved\_caches\_directory：为缓存文件目录

下面将介绍单节点的安装，集群安装请参考：[Cassandra单集群实验2个节点](http://blog.fens.me/cassandra-clustor/ "Cassandra单集群实验2个节点")

## 2.2 代码部分：
  
单节点安装：系统环境 Linux Ubuntu 12.04 LTS 64bit server

```bash
~ uname -a
Linux u1 3.5.0-23-generic #35~precise1-Ubuntu SMP Fri Jan 25 17:13:26 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
    
~ cat /etc/issue
Ubuntu 12.04.2 LTS \n \l
```    

JDK环境：SUN官方JDK 1.6.0_29

 ```bash   
 ~ java -version
    
java version "1.6.0_29"
Java(TM) SE Runtime Environment (build 1.6.0_29-b11)
Java HotSpot(TM) 64-Bit Server VM (build 20.4-b02, mixed mode)
```    

下载Cassandra并解压

```bash    
~ wget http://mirrors.tuna.tsinghua.edu.cn/apache/cassandra/1.2.5/apache-cassandra-1.2.5-bin.tar.gz
    
~ tar xvf apache-cassandra-1.2.5-bin.tar.gz
~ mv apache-cassandra-1.2.5-bin cassandra125
~ mv cassandra125 /home/conan/toolkit/
    
~ pwd
/home/conan/toolkit
    
~ ls -l
drwxrwxr-x  9 conan conan 4096 Jun  1 06:10 cassandra125/
drwxr-xr-x 10 conan conan  4096 Apr 23 14:36 jdk16
```    

初始化cassandra

```bash    
~ cd /home/conan/toolkit/cassandra125
    
#配置Cassandra数据文件目录
~ vi conf/cassandra.yaml
    
data_file_directories:
    - /var/lib/cassandra/data
commitlog_directory: /var/lib/cassandra/commitlog
saved_caches_directory: /var/lib/cassandra/saved_caches
```    

目录的介绍：
  
data\_file\_directories：为数据文件目录
  
commitlog_directory：为日志文件目录
  
saved\_caches\_directory：为缓存文件目录

确认操作系统中，这几个目录已被创建。
  
同时确认/var/log/cassandra/目录，对于cassandra是可写的。

```bash   
~ sudo mkdir -p /var/lib/cassandra/data
~ sudo mkdir -p /var/lib/cassandra/saved_caches
~ sudo mkdir -p /var/lib/cassandra/commitlog
~ sudo mkdir -p /var/log/cassandra/
    
~ sudo chown -R conan:conan /var/lib/cassandra
~ sudo chown -R conan:conan /var/log/cassandra/
    
~ ll /var/lib/cassandra
drwxr-xr-x  2 conan conan 4096 Jun  1 06:21 commitlog/
drwxr-xr-x  2 conan conan 4096 Jun  1 06:21 data/
drwxr-xr-x  2 conan conan 4096 Jun  1 06:21 saved_caches/
```    

设置环境变量

```bash    
~ sudo vi /etc/environment
CASSANDRA_HOME=/home/conan/toolkit/cassandra125
    
#让变量生效
~ . /etc/environment
    
#查看环境变量
~ export |grep /home/conan/toolkit/cassandra125
declare -x CASSANDRA_HOME="/home/conan/toolkit/cassandra125"
declare -x OLDPWD="/home/conan/toolkit/cassandra125"
declare -x PWD="/home/conan/toolkit/cassandra125/bin"
```    

启动cassandra

```bash    
~ bin/cassandra -f
#注：-f参数是绑定到console，不加-f则是后台启动。
    
~ jps
19971 CassandraDaemon
20440 Jps
 ```   

打开客户端

```bash    
~ bin/cassandra-cli
    
Connected to: "Test Cluster" on 127.0.0.1/9160
Welcome to Cassandra CLI version 1.2.5
    
Type 'help;' or '?' for help.
Type 'quit;' or 'exit;' to quit.
    
[default@unknown]
 ```   

单节的cassandra，我们已经成功能安装好了。

Cassandra的集群安装请参考：[Cassandra单集群实验2个节点](http://blog.fens.me/cassandra-clustor/ "Cassandra单集群实验2个节点")

# 3. RCassandra安装

## 3.1 文字说明部分：
  
R语言的版本请使用2.15.3，下面介绍如何安装R。

首先，增加一个软件源deb http://mirror.bjtu.edu.cn/cran/bin/linux/ubuntu precise/。
  
更新及指定安装2.15.3-1precise0precise1版本。

启动R程序，安装RCassandra包。

## 3.2 代码部分
  
测试环境R语言的版本是：2.15.3

安装R语言

```bash    
~  sudo vi /etc/apt/sources.list
deb http://mirrors.163.com/ubuntu/ precise main universe restricted multiverse
deb-src http://mirrors.163.com/ubuntu/ precise main universe restricted multiverse
deb http://mirrors.163.com/ubuntu/ precise-security universe main multiverse restricted
deb-src http://mirrors.163.com/ubuntu/ precise-security universe main multiverse restricted
deb http://mirrors.163.com/ubuntu/ precise-updates universe main multiverse restricted
deb http://mirrors.163.com/ubuntu/ precise-proposed universe main multiverse restricted
deb-src http://mirrors.163.com/ubuntu/ precise-proposed universe main multiverse restricted
deb http://mirrors.163.com/ubuntu/ precise-backports universe main multiverse restricted
deb-src http://mirrors.163.com/ubuntu/ precise-backports universe main multiverse restricted
deb-src http://mirrors.163.com/ubuntu/ precise-updates universe main multiverse restricted
deb http://mirror.bjtu.edu.cn/cran/bin/linux/ubuntu precise/
```    

更新apt-get源

```bash    
~ sudo apt-get update
    
#声明安装2.15.3的版本
~ sudo apt-get install r-base-core=2.15.3-1precise0precise1
    
#启动R
~ R
R version 2.15.3 (2013-03-01) -- "Security Blanket"
Copyright (C) 2013 The R Foundation for Statistical Computing
ISBN 3-900051-07-0
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
```    

安装RCassandra

```r    
install.packages('RCassandra')
library(RCassandra)
```    

# 4. RCassandra函数库

## 4.1 文字说明部分 
  
列出有的RCassandra支持的函数，只有17个。记得rredis有100个函数，rmongodb有153个函数。相比之下RCassandra太轻量了。

但是这17个函数，并没有覆盖Cassandra的所有操作，就连一些的基本的操作都没有函数支持，要在命令行处理。不知道是什么原因？！希望RCassandra能继续发展，完善没有实现的功能函数。

不支持的常用操作：
  
创建keyspaces,删除keyspaces
  
创建列族，删除列族
  
删除一行
  
删除一行的某列数据

下面列出了这17个函数，并与Cassandra的命令做了对比说明。

## 4.2 代码部分
  
共有17个函数

    
    RC.close               RC.insert
    RC.cluster.name        RC.login
    RC.connect             RC.mget.range
    RC.consistency         RC.mutate
    RC.describe.keyspace   RC.read.table
    RC.describe.keyspaces  RC.use
    RC.get                 RC.version
    RC.get.range           RC.write.table
    RC.get.range.slices
    

Cassandra和RCassandra的基本操作对比：

```Cassandra/r
#连接到集群
Cassandra: connect 192.168.1.200/9160;
RCassandra: conn<-RC.connect(host="192.168.1.200",port=9160)

#查看当前集群名字
Cassandra: show cluster name;
RCassandra: RC.cluster.name(conn)

#列出当前集群所有keyspaces
Cassandra: show keyspaces;
RCassandra: RC.describe.keyspaces(conn)

#查看DEMO的keyspace
Cassandra: show schema DEMO;
RCassandra: RC.describe.keyspace(conn,'DEMO')

#选择DEMO的keyspace
Cassandra: use DEMO;
RCassandra: RC.use(conn,'DEMO')

#设置一致性级别
Cassandra: consistencylevel as ONE;
RCassandra: RC.consistency(conn,level="one")

#插入数据
Cassandra：set Users[1][name] = scott;
RCassandra：RC.insert(conn,'Users','1', 'name', 'scott')

#插入数据框
Cassandra：NA
RCassandra：RC.write.table(conn, "Users", df)

#读取列族所有数据
Cassandra: list Users;
RCassandra： RC.read.table(conn,"Users")

#读取数据
Cassandra: get Users[1]['name'];
RCassandra：RC.get(conn,'Users','1', c('name'))

#退出连接
Cassandra: exit; quit;
RCassandra: RC.close(conn)
```
    



# 5. RCassandra基本使用操作

## 5.1 文字说明部分
  
介绍RCassandra的基本函数操作，以iris的数据集为例，介绍了如何利用RCassandra操作Cassandra数据库。

## 5.2 代码部分

```r 
#安装RCassandra
install.packages('RCassandra')

#加载RCassandra类库
library(RCassandra)

#建立服务器连接
conn<-RC.connect(host="192.168.1.200")

#当前集群的名字(2个节点集群的名字)
RC.cluster.name(conn)
[1] "case1"

#当前协议的版本
RC.version(conn)
[1] "19.36.0"

#列出所有keyspaces配置信息
RC.describe.keyspaces(conn)

#列出叫的DEMO的keyspaces配置信息
RC.describe.keyspace(conn, "DEMO")

#RCassandra是不能创建的列族的，提前通过Cassandra命令创建一个列族
#[default@DEMO] create column family iris;

#插入iris数据
head(iris)
  Sepal.Length Sepal.Width Petal.Length Petal.Width Species
1          5.1         3.5          1.4         0.2  setosa
2          4.9         3.0          1.4         0.2  setosa
3          4.7         3.2          1.3         0.2  setosa
4          4.6         3.1          1.5         0.2  setosa
5          5.0         3.6          1.4         0.2  setosa
6          5.4         3.9          1.7         0.4  setosa

#iris是一个data.frame
RC.write.table(conn, "iris", iris)

attr(,"class")
[1] "CassandraConnection"

#查看第1行，Sepal.Length列和Species的值
RC.get(conn, "iris", "1", c("Sepal.Length", "Species"))
           key  value           ts
1 Sepal.Length    5.1 1.372881e+15
2      Species setosa 1.372881e+15
#注：ts是时间戳

#查看第1行
RC.get.range(conn, "iris", "1")
           key  value           ts
1 Petal.Length    1.4 1.372881e+15
2  Petal.Width    0.2 1.372881e+15
3 Sepal.Length    5.1 1.372881e+15
4  Sepal.Width    3.5 1.372881e+15
5      Species setosa 1.372881e+15

#查看
r <- RC.get.range.slices(conn, "iris")
class(r)
[1] "list"

r[[1]]
           key  value           ts
1 Petal.Length    1.7 1.372881e+15
2  Petal.Width    0.4 1.372881e+15
3 Sepal.Length    5.4 1.372881e+15
4  Sepal.Width    3.9 1.372881e+15
5      Species setosa 1.372881e+15

rk <- RC.get.range.slices(conn, "iris", limit=0)
y <- RC.read.table(conn, "iris")
y <- y[order(as.integer(row.names(y))),]

head(y)
  Petal.Length Petal.Width Sepal.Length Sepal.Width Species
1          1.4         0.2          5.1         3.5  setosa
2          1.4         0.2          4.9         3.0  setosa
3          1.3         0.2          4.7         3.2  setosa
4          1.5         0.2          4.6         3.1  setosa
5          1.4         0.2          5.0         3.6  setosa
6              
```   

    

不支持的常用操作

  * 创建keyspaces,删除keyspaces
  * 创建列族，删除列族
  * 删除一行
  * 删除一行的某列数据

# 6. RCassandra使用案例

## 6.1 文字说明部分
  
通过一个业务需求的例子，加深我们对RCassandra的认识。下面是一个非常简单的业务场景。

业务需求：
  
1. 创建一个Users列族，包含name,password两列
  
2. 在已经数据的情况下，有动态增加一个新列age

## 6.2 代码部分
  
在Cassandra命令行，创建列族Users

```Cassandra    
[default@DEMO] create column family Users
...     with key_validation_class = 'UTF8Type'
...     and comparator = 'UTF8Type'
...     and default_validation_class = 'UTF8Type';
    
89a2fb75-f7d0-399e-b017-30a974b19f4a
```    

RCassandra插入数据，包含name,password两列

```r
> df<-data.frame(name=c('a1','a2'),password=c('a1','a2')) 
> print(df)
  name password
1   a1       a1
2   a2       a2

#插入数据
> RC.write.table(conn, "Users", df)
attr(,"class")
[1] "CassandraConnection"

#查看数据
> RC.read.table(conn,"Users")
     name password
2    a2       a2
1    a1       a1

#新插入: 一行KEY=1234，并增加age列
> RC.insert(conn,'Users','1234', 'name', 'scott')
> RC.insert(conn,'Users','1234', 'password', 'tiger')
> RC.insert(conn,'Users','1234', 'age', '20')

#查看数据
> RC.read.table(conn,"Users")
     age  name password
1234  20 scott    tiger
2     NA    a2       a2
1     NA    a1       a1

#修改: KEY=1的行中，name=a11, age=12
> RC.insert(conn,'Users','1', 'name', 'a11')
> RC.insert(conn,'Users','1', 'age', '12')

#查看数据
> RC.read.table(conn,"Users")
     age  name password
1234  20 scott    tiger
2     NA    a2       a2
1     12   a11       a1
```

    

# 7. Cassandra的没落

越来越多的基于cassandra构建的应用，开始向hbase迁移。 

Cassandra的没落，在技术上可能存在的一些原因：

1. 读的性能太慢

    无中心的设计，造成读数据时通过逆熵做计算，性能损耗很大，甚至会严重影响服务器运作。

2. 数据同步太慢（最终一致性延迟可能非常大）

    由于无中心设计，要靠各节点传递信息。相互发通知告知状态，如果副本集有多份，其中又出现节点有宕机的情况，那么做到数据的一致性，延迟可能非常大，效率也很低的。

3. 用插入和更新代替查询，缺乏灵活性，所有查询都要求提前定义好。

    与大多数数据库为读优化不同，Cassandra的写性能理论上是高于读性能的，因此非常适合流式的数据存储，尤其是写负载高于读负载的。与HBase比起来，它的随机访问性能要高很多，但不是很擅长区间扫描，因此可以作为HBase的即时查询缓存，由HBase进行批量的大数据处理，由Cassandra提供随机查询的接口

4. 不支持直接接入hadoop，不能实现MapReduce。

    现在大数据的代名词就是hadoop，做为海量数据的框架不支持hadoop及MapReduce，就将被取代。除非Cassandra能够给出其他的定位，或者海量数据解决方案。DataStax公司，正在用Cassandra重够HDFS的文件系统，不知道是否可以成功。

让我期待Cassandra未来的发展吧！

**转载请注明：**
  
[/2013/07/r-nosql-cassandra/](/2013/07/r-nosql-cassandra/ "R利剑NoSQL系列文章 之 cassandra")
