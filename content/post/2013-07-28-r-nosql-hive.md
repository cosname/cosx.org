---
title: R利剑NoSQL系列文章 之 Hive
date: '2013-07-28T12:00:32+00:00'
author: 张丹
categories:
  - 统计软件
tags:
  - hive
  - nosql
  - rhive
  - R语言
slug: r-nosql-hive
forum_id: 418947
---

[R利剑NoSQL系列文章](http://blog.fens.me/series-r-nosql/ "R利剑NoSQL系列文章")，主要介绍通过R语言连接使用nosql数据库。涉及的NoSQL产品，包括[Redis](http://blog.fens.me/nosql-r-redis/ "R利剑NoSQL系列文章 之 Redis"),[MongoDB](http://blog.fens.me/nosql-r-mongodb/ "R利剑NoSQL系列文章 之 MongoDB"), [HBase](http://blog.fens.me/nosql-r-hbase "R利剑NoSQL系列文章 之 HBase"), [Hive](http://blog.fens.me/nosql-r-hive/ "R利剑NoSQL系列文章 之 Hive"), [Cassandra](http://blog.fens.me/nosql-r-cassandra/ "R利剑NoSQL系列文章 之 Cassandra"), [Neo4j](http://blog.fens.me/nosql-r-neo4j/ "R利剑NoSQL系列文章 之 Neo4j")。希望通过我的介绍让广大的R语言爱好者，有更多的开发选择，做出更多地激动人心的应用。

**关于作者：**

* 张丹(Conan), 程序员Java,R,PHP,Javascript
* weibo：@Conan_Z
* blog: http://blog.fens.me
* email: bsspirit@gmail.com

**转载请注明：**
  
[/2013/07/r-nosql-hive/](/2013/07/r-nosql-hive/ "R利剑NoSQL系列文章之hive")

![rhive](https://uploads.cosx.org/2013/07/rhive.png)

**第四篇 R利剑Hive，分为5个章节**

1. Hive介绍
1. Hive安装
1. RHive安装
1. RHive函数库
1. RHive基本使用操作

# 1. Hive介绍

Hive是建立在Hadoop上的数据仓库基础构架。它提供了一系列的工具，可以用来进行数据提取转化加载（ETL），这是一种可以存储、查询和分析存储在 Hadoop 中的大规模数据的机制。Hive 定义了简单的类 SQL 查询语言，称为 HQL，它允许熟悉 SQL 的用户查询数据。同时，这个语言也允许熟悉 MapReduce 开发者的开发自定义的 mapper 和 reducer 来处理内建的 mapper 和 reducer 无法完成的复杂的分析工作。<!--more-->

Hive 没有专门的数据格式。 Hive 可以很好的工作在Thrift之上，控制分隔符，也允许用户指定数据格式

上面内容摘自 百度百科(http://baike.baidu.com/view/699292.htm)

hive与关系数据库的区别：

* 数据存储不同：hive基于hadoop的HDFS，关系数据库则基于本地文件系统
* 计算模型不同：hive基于hadoop的mapreduce，关系数据库则基于索引的内存计算模型
* 应用场景不同：hive是OLAP数据仓库系统提供海量数据查询的，实时性很差;关系数据库是OLTP事务系统，为实时查询业务服务
* 扩展性不同：hive基于hadoop很容易通过分布式增加存储能力和计算能力，关系数据库水平扩展很难，要不断增加单机的性能

# 2. Hive安装

Hive是基于Hadoop开发的数据仓库产品，所以首先我们要先有Hadoop的环境。

![rhive](https://uploads.cosx.org/2013/07/rhive.jpg)

**Hadoop安装**，请参考：[Hadoop环境搭建](http://blog.fens.me/rhadoop-hadoop/ "RHadoop实践系列之一:Hadoop环境搭建"), [创建Hadoop母体虚拟机](http://blog.fens.me/hadoop-base-kvm/ "让Hadoop跑在云端系列文章 之 创建Hadoop母体虚拟机")

**Hive的安装**，请参考：[Hive安装及使用攻略](http://blog.fens.me/hadoop-hive-intro/ "Hive安装及使用攻略")

Hadoop-1.0.3的下载地址
  
http://archive.apache.org/dist/hadoop/core/hadoop-1.0.3/

Hive-0.9.0的下载地址
  
http://archive.apache.org/dist/hive/hive-0.9.0/

**Hive安装好后**
  
启动hiveserver的服务

```bash
~ nohup hive --service hiveserver  &
Starting Hive Thrift Server
```

打开hive shell

```bash
~ hive shell
Logging initialized using configuration in file:/home/conan/hadoop/hive-0.9.0/conf/hive-log4j.proper             ties
Hive history file=/tmp/conan/hive_job_log_conan_201306261459_153868095.txt

#查看hive的表
hive> show tables;
hive_algo_t_account
o_account
r_t_account
Time taken: 2.12 seconds

#查看o_account表的数据
hive> select * from o_account;
1       abc@163.com     2013-04-22 12:21:39
2       dedac@163.com   2013-04-22 12:21:39
3       qq8fed@163.com  2013-04-22 12:21:39
4       qw1@163.com     2013-04-22 12:21:39
5       af3d@163.com    2013-04-22 12:21:39
6       ab34@163.com    2013-04-22 12:21:39
7       q8d1@gmail.com  2013-04-23 09:21:24
8       conan@gmail.com 2013-04-23 09:21:24
9       adeg@sohu.com   2013-04-23 09:21:24
10      ade121@sohu.com 2013-04-23 09:21:24
11      addde@sohu.com  2013-04-23 09:21:24
Time taken: 0.469 seconds
```    

# 3. RHive安装

请提前配置好JAVA的环境：

```bash
~ java -version
java version "1.6.0_29"
Java(TM) SE Runtime Environment (build 1.6.0_29-b11)
Java HotSpot(TM) 64-Bit Server VM (build 20.4-b02, mixed mode)
```    

安装R：Ubuntu 12.04，请更新源再下载R2.15.3版本

```bash
~ sudo sh -c "echo deb http://mirror.bjtu.edu.cn/cran/bin/linux/ubuntu precise/ >>/etc/apt/sources.list"
~ sudo apt-get update
~ sudo apt-get install r-base-core=2.15.3-1precise0precise1
```    

安装R依赖库：rjava

```
#配置rJava
~ sudo R CMD javareconf

#启动R程序
~ sudo R
install.packages("rJava")
```    

安装RHive

```r
install.packages("RHive")

library(RHive)
Loading required package: rJava
Loading required package: Rserve
This is RHive 0.0-7. For overview type ‘?RHive’.
HIVE_HOME=/home/conan/hadoop/hive-0.9.0
call rhive.init() because HIVE_HOME is set.
```    

# 4. RHive函数库

rhive.aggregate        rhive.connect          rhive.hdfs.exists      rhive.mapapply
rhive.assign           rhive.desc.table       rhive.hdfs.get         rhive.mrapply
rhive.basic.by         rhive.drop.table       rhive.hdfs.info        rhive.napply
rhive.basic.cut        rhive.env              rhive.hdfs.ls          rhive.query
rhive.basic.cut2       rhive.exist.table      rhive.hdfs.mkdirs      rhive.reduceapply
rhive.basic.merge      rhive.export           rhive.hdfs.put         rhive.rm
rhive.basic.mode       rhive.exportAll        rhive.hdfs.rename      rhive.sapply
rhive.basic.range      rhive.hdfs.cat         rhive.hdfs.rm          rhive.save
rhive.basic.scale      rhive.hdfs.chgrp       rhive.hdfs.tail        rhive.script.export
rhive.basic.t.test     rhive.hdfs.chmod       rhive.init             rhive.script.unexport
rhive.basic.xtabs      rhive.hdfs.chown       rhive.list.tables      
rhive.size.table
rhive.big.query        rhive.hdfs.close       rhive.load             rhive.write.table
rhive.block.sample     rhive.hdfs.connect     rhive.load.table
rhive.close            rhive.hdfs.du          rhive.load.table2


**Hive和RHive的基本操作对比：**

 ```r   
#连接到hive
Hive:  hive shell
RHive: rhive.connect("192.168.1.210")

#列出所有hive的表
Hive:  show tables;
RHive: rhive.list.tables()

#查看表结构
Hive:  desc o_account;
RHive: rhive.desc.table('o_account'), rhive.desc.table('o_account',TRUE)

#执行HQL查询
Hive:  select * from o_account;
RHive: rhive.query('select * from o_account')

#查看hdfs目录
Hive:  dfs -ls /;
RHive: rhive.hdfs.ls()

#查看hdfs文件内容
Hive:  dfs -cat /user/hive/warehouse/o_account/part-m-00000;
RHive: rhive.hdfs.cat('/user/hive/warehouse/o_account/part-m-00000')

#断开连接
Hive:  quit;
RHive: rhive.close()
```    

# 5. RHive基本使用操作

```r
#初始化
rhive.init()

#连接hive
rhive.connect("192.168.1.210")

#查看所有表
rhive.list.tables()
             tab_name
1 hive_algo_t_account
2           o_account
3         r_t_account

#查看表结构
rhive.desc.table('o_account');
     col_name data_type comment
1          id       int
2       email    string
3 create_date    string

#执行HQL查询
rhive.query("select * from o_account");
   id           email         create_date
1   1     abc@163.com 2013-04-22 12:21:39
2   2   dedac@163.com 2013-04-22 12:21:39
3   3  qq8fed@163.com 2013-04-22 12:21:39
4   4     qw1@163.com 2013-04-22 12:21:39
5   5    af3d@163.com 2013-04-22 12:21:39
6   6    ab34@163.com 2013-04-22 12:21:39
7   7  q8d1@gmail.com 2013-04-23 09:21:24
8   8 conan@gmail.com 2013-04-23 09:21:24
9   9   adeg@sohu.com 2013-04-23 09:21:24
10 10 ade121@sohu.com 2013-04-23 09:21:24
11 11  addde@sohu.com 2013-04-23 09:21:24

#关闭连接
rhive.close()
[1] TRUE
```

创建临时表

```r
rhive.block.sample('o_account', subset="id<5")
[1] "rhive_sblk_1372238856"

rhive.query("select * from rhive_sblk_1372238856");
  id          email         create_date
1  1    abc@163.com 2013-04-22 12:21:39
2  2  dedac@163.com 2013-04-22 12:21:39
3  3 qq8fed@163.com 2013-04-22 12:21:39
4  4    qw1@163.com 2013-04-22 12:21:39

#查看hdfs的文件
rhive.hdfs.ls('/user/hive/warehouse/rhive_sblk_1372238856/')
  permission owner      group length      modify-time
1  rw-r--r-- conan supergroup    141 2013-06-26 17:28
                                                 file
1 /user/hive/warehouse/rhive_sblk_1372238856/000000_0

rhive.hdfs.cat('/user/hive/warehouse/rhive_sblk_1372238856/000000_0')
1abc@163.com2013-04-22 12:21:39
2dedac@163.com2013-04-22 12:21:39
3qq8fed@163.com2013-04-22 12:21:39
4qw1@163.com2013-04-22 12:21:39
```    

按范围分割字段数据

```r   
rhive.basic.cut('o_account','id',breaks='0:100:3')
[1] "rhive_result_20130626173626"
attr(,"result:size")
[1] 443

rhive.query("select * from rhive_result_20130626173626");
             email         create_date     id
1      abc@163.com 2013-04-22 12:21:39  (0,3]
2    dedac@163.com 2013-04-22 12:21:39  (0,3]
3   qq8fed@163.com 2013-04-22 12:21:39  (0,3]
4      qw1@163.com 2013-04-22 12:21:39  (3,6]
5     af3d@163.com 2013-04-22 12:21:39  (3,6]
6     ab34@163.com 2013-04-22 12:21:39  (3,6]
7   q8d1@gmail.com 2013-04-23 09:21:24  (6,9]
8  conan@gmail.com 2013-04-23 09:21:24  (6,9]
9    adeg@sohu.com 2013-04-23 09:21:24  (6,9]
10 ade121@sohu.com 2013-04-23 09:21:24 (9,12]
11  addde@sohu.com 2013-04-23 09:21:24 (9,12]
```    

Hive操作HDFS

```r
#查看hdfs文件目录
rhive.hdfs.ls()
  permission owner      group length      modify-time   file
1  rwxr-xr-x conan supergroup      0 2013-04-24 01:52 /hbase
2  rwxr-xr-x conan supergroup      0 2013-06-23 10:59  /home
3  rwxr-xr-x conan supergroup      0 2013-06-26 11:18 /rhive
4  rwxr-xr-x conan supergroup      0 2013-06-23 13:27   /tmp
5  rwxr-xr-x conan supergroup      0 2013-04-24 19:28  /user

#查看hdfs文件内容
rhive.hdfs.cat('/user/hive/warehouse/o_account/part-m-00000')
1abc@163.com2013-04-22 12:21:39
2dedac@163.com2013-04-22 12:21:39
3qq8fed@163.com2013-04-22 12:21:39
```    

**转载请注明：**
  
[/2013/07/r-nosql-hive/](/2013/07/r-nosql-hive/ "R利剑NoSQL系列文章 之 hive")
