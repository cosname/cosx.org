---
title: RHadoop实践系列之四 rhbase安装与使用
date: '2013-04-12T12:22:55+00:00'
author: 张丹
categories:
  - 软件应用
tags:
  - hadoop
  - hbase
  - rhaddop
  - rhbase
  - thrift
slug: rhadoop4-rhbase
forum_id: 418930
---

Author：张丹(Conan)
  
Date: 2013-04-07

Weibo: @Conan_Z
  
Email: <bsspirit@gmail.com>
  
Blog: <http://www.fens.me/blog>

APPs:
  
@晒粉丝 [http://www.fens.me](http://www.fens.me/)
  
@每日中国天气 <http://apps.weibo.com/chinaweatherapp>

# RHadoop实践系列文章

RHadoop实践系列文章，包含了R语言与Hadoop结合进行海量数据分析。Hadoop主要用来存储海量数据，R语言完成MapReduce算法，用来替代Java的MapReduce实现。有了RHadoop可以让广大的R语言爱好者，有更强大的工具处理大数据。1G, 10G, 100G, TB,PB 由于大数据所带来的单机性能问题，可能会一去联复返了。

RHadoop实践是一套系列文章，主要包括“Hadoop环境搭建”，“RHadoop安装与使用”，“R实现MapReduce的算法案例”，“HBase和rhbase的安装与使用”。对于单独的R语言爱好者，Java爱好者，或者Hadoop爱好者来说，同时具备三种语言知识并不容易。此文虽为入门文章，但R,Java,Hadoop基础知识还是需要大家提前掌握。

# 第四篇 HBase和rhbase的安装与使用，分为3个章节。
    
1. 环境准备及HBase安装
1. rhbase安装
1. rhbase程序用例    

每一章节，都会分为“文字说明部分”和“代码部分”，保持文字说明与代码的连贯性。

注：Hadoop环境及RHadoop的环境，请查看同系列前二篇文章，此文将不再介绍。

## 1. 环境准备及HBase安装

### 文字说明部分：

首先环境准备，这里我选择了Linux Ubuntu操作系统12.04的64位版本，大家可以根据自己的使用习惯选择顺手的Linux。

但JDK一定要用Oracle SUN官方的版本，请从官网下载，操作系统的自带的OpenJDK会有各种不兼容。JDK请选择1.6.x的版本，JDK1.7版本也会有各种的不兼容情况。
  
<http://www.oracle.com/technetwork/java/javase/downloads/index.html>

Hadoop的环境安装，请参考RHadoop实践系统“Hadoop环境搭建”的一文。

Hadoop和HBase版本：hadoop-1.0.3,hbase-0.94.2

配置HBase的启动命令的环境变量，使用HBase自带的ZooKeeper
  
export HBASE\_MANAGES\_ZK=true

配置hbase-site.xml，设置访问目录，数据副本数，ZooKeeper的访问端口。

复制Hadoop环境的类库，覆盖HBase中的类库。

配置完成，启动HBase服务。

### 代码部分：

hbase安装

1) 下载安装hbase

```bash
~ http://www.fayea.com/apache-mirror/hbase/hbase-0.94.2/hbase-0.94.2.tar.gz
~ tar xvf hbase-0.94.2.tar.gz    
```

2) 修改配置文件

```bash
~ cd hbase-0.94.2/
~ vi conf/hbase-env.sh 
    
    export JAVA_HOME=/root/toolkit/jdk1.6.0_29
    export HBASE_HOME=/root/hbase-0.94.2
    export HADOOP_INSTALL=/root/hadoop-1.0.3
    export HBASE_CLASSPATH=/root/hadoop-1.0.3/conf
    export HBASE_MANAGES_ZK=true
    
~ vi conf/hbase-site.xml
    
    <configuration>
      <property>
        <name>hbase.rootdir</name
        <value>hdfs://master:9000/hbase</value>
      </property>
    
      <property>
         <name>hbase.cluster.distributed</name>
         <value>true</value>
      </property>
    
      <property>
         <name>dfs.replication</name>
         <value>1</value>
      </property>
    
      <property>
        <name>hbase.zookeeper.quorum</name>
        <value>master</value>
      </property>
    
      <property>
          <name>hbase.zookeeper.property.clientPort</name>
          <value>2181</value>
      </property>
    
      <property>
        <name>hbase.zookeeper.property.dataDir</name>
        <value>/root/hadoop/hdata</value>
      </property>
    </configuration>    
```

3) 复制hadoop环境的配置文件和类库

```bash
~ cp ~/hadoop-1.0.3/conf/hdfs-site.xml ~/hbase-0.94.2/conf
~ cp ~/hadoop-1.0.3/hadoop-core-1.0.3.jar ~/hbase-0.94.2/lib
~ cp ~/hadoop-1.0.3/lib/commons-configuration-1.6.jar ~/hbase-0.94.2/lib
~ cp ~/hadoop-1.0.3/lib/commons-collections-3.2.1.jar ~/hbase-0.94.2/lib    
```

4) 启动hadoop和hbase

```bash
~/hadoop-1.0.3/bin/start-all.sh
~/hbase-0.94.2/bin/start-hbase.sh 
```

5) 查看hbase进行

```bash
~ jps
    
    12041 HMaster
    12209 HRegionServer
    31734 TaskTracker
    31343 DataNode
    31499 SecondaryNameNode
    13328 Jps
    31596 JobTracker
    11916 HQuorumPeer
    31216 NameNode    
```

6) 打开hbase命令行客户端

```bash
~/hbase-0.94.2/bin/hbase shell
    
HBase Shell; enter 'help<RETURN>' for list of supported commands.
Type "exit<RETURN>" to leave the HBase Shell
Version 0.94.2, r1395367, Sun Oct  7 19:11:01 UTC 2012
    
hbase(main):001:0> list
    
    TABLE
    0 row(s) in 0.0150 seconds   
```

HBase安装完成。

## 2. rhbase安装

### 文字说明部分：

安装完成HBase后，我们还需要安装Thrift，因为rhbase是通过Thrift调用HBase的。

Thrift是需要本地编译的，官方没有提供二进制安装包，首先下载thrift-0.8.0。

在thrift解压目录输入./configure，会列Thrift在当前机器所支持的语言环境，如果只是为了rhbase默认配置就可以了。
  
在我的配置中除了希望支持rhbase访问，还支持PHP,Python,C++。因此需要在系统中，装一些额外的类库。大家可以根据自己的要求，设置Thrift的编译参数。

编译并安装Thrift，然后启动HBase的ThriftServer服务。

最后，安装rhbase。

### **代码部分：**

   
1. 下载thrift
    
    ```
    ~ wget http://archive.apache.org/dist/thrift/0.8.0/thrift-0.8.0.tar.gz
    ~ tar xvf thrift-0.8.0.tar.gz
    ~ cd thrift-0.8.0/
    ```

1. 下载PHP支持类库(可选)
    ```
    ~ sudo apt-get install php-cli
    ```
    
1. 下载C++支持类库(可选)

    ```
    ~ sudo apt-get install libboost-dev libboost-test-dev libboost-program-options-dev libevent-dev automake libtool flex bison pkg-config g++ libssl-dev
    ```

1. 生成编译的配置参数

    ```
    ~ ./configure

      thrift 0.8.0

      Building code generators ..... :

      Building C++ Library ......... : yes
      Building C (GLib) Library .... : no
      Building Java Library ........ : no
      Building C# Library .......... : no
      Building Python Library ...... : yes
      Building Ruby Library ........ : no
      Building Haskell Library ..... : no
      Building Perl Library ........ : no
      Building PHP Library ......... : yes
      Building Erlang Library ...... : no
      Building Go Library .......... : no

      Building TZlibTransport ...... : yes
      Building TNonblockingServer .. : yes

      Using Python ................. : /usr/bin/python

      Using php-config ............. : /usr/bin/php-config
    ```

1. 编译和安装

    ```
    ~ make
    ~ make install
    ```
   
1. 查看thrift版本

    ```
    ~ thrift -version
      Thrift version 0.8.0
    ```
 
1. 启动HBase的Thrift Server
  
    ```  
    ~ /hbase-0.94.2/bin/hbase-daemon.sh start thrift

    ~ jps 

      12041 HMaster
      12209 HRegionServer
      13222 ThriftServer
      31734 TaskTracker
      31343 DataNode
      31499 SecondaryNameNode
      13328 Jps
      31596 JobTracker
      11916 HQuorumPeer
      31216 NameNode
    ```

1. 安装rhbase
  
    ```
     ~ R CMD INSTALL rhbase_1.1.1.tar.gz
    ```

很顺利的安装完成。

## 3. rhbase程序用例

### 文字说明部分：

### rhbase的相关函数：

```
  hb.compact.table      hb.describe.table     hb.insert             hb.regions.table  
  hb.defaults           hb.get                hb.insert.data.frame  hb.scan
  hb.delete             hb.get.data.frame     hb.list.tables        hb.scan.ex
  hb.delete.table       hb.init               hb.new.table          hb.set.table.mode    
```

### hbase和rhbase的基本操作对比：

```
建表
HBASE:     create 'student_shell','info'
RHBASE:    hb.new.table("student_rhbase","info")
   
列出所有表
HBASE:     list
RHBASE:    hb.list.tables()
    
显示表结构
HBASE:     describe 'student_shell'
RHBASE:    hb.describe.table("student_rhbase")
  
插入一条数据
HBASE:     put 'student_shell','mary','info:age','19'
RHBASE:    hb.insert("student_rhbase",list(list("mary","info:age", "24")))
         
读取数据
HBASE:     get 'student_shell','mary'
RHBASE:    hb.get('student_rhbase','mary')
    
删除表(HBASE需要两条命令，rhbase仅是一个操作)
HBASE:     disable 'student_shell'
HBASE:     drop 'student_shell'
RHBASE:    hb.delete.table('student_rhbase')    
```

### 代码部分：

Hbase Shell

```bash
> create 'student_shell','info'
> list
    
     TABLE
     student_shell
    
> describe 'student_shell'
    
   DESCRIPTION                                                          ENABLED
   {NAME => 'student_shell', FAMILIES => [{NAME => 'info', DATA_BLOCK_ true
   ENCODING => 'NONE', BLOOMFILTER => 'NONE', REPLICATION_SCOPE => '0'
   , VERSIONS => '3', COMPRESSION => 'NONE', MIN_VERSIONS => '0', TTL
   => '2147483647', KEEP_DELETED_CELLS => 'false', BLOCKSIZE => '65536
   ', IN_MEMORY => 'false', ENCODE_ON_DISK => 'true', BLOCKCACHE => 't
   rue'}]}
    
>  put 'student_shell','mary','info:age','19'
>  get 'student_shell','mary'
    
  COLUMN                      CELL
  info:age                   timestamp=1365414964962, value=19
    
> disable 'student_shell'
> drop 'student_shell'    
```

rhbase script

```r
~ R
> library(rhbase)
> hb.init()
    
    <pointer: 0x16494a0>
    attr(,"class")
    [1] "hb.client.connection"
    
>hb.new.table("student_rhbase","info",opts=list(maxversions=5,x=list(maxversions=1L,compression='GZ',inmemory=TRUE)))
    
   [1] TRUE
    
> hb.list.tables()
    
    $student_rhbase
      maxversions compression inmemory bloomfiltertype bloomfiltervecsize
    info:           5        NONE    FALSE            NONE                  0
              bloomfilternbhashes blockcache timetolive
    info:                   0      FALSE         -1
    
 > hb.describe.table("student_rhbase")
    
          maxversions compression inmemory bloomfiltertype bloomfiltervecsize
    info:           5        NONE    FALSE            NONE                  0
          bloomfilternbhashes blockcache timetolive
    info:                   0      FALSE         -1
    
> hb.insert("student_rhbase",list(list("mary","info:age", "24")))
    
    [1] TRUE
    
> hb.get('student_rhbase','mary')
    
    [[1]]
    [[1]][[1]]
    [1] "mary"
    
    [[1]][[2]]
    [1] "info:age"
    
    [[1]][[3]]
    [[1]][[3]][[1]]
    [1] "24"
    
> hb.delete.table('student_rhbase')
    
    [1] TRUE    
```

RHadoop实践系列文章的第四篇完成！希望这个四篇文章对大家有所帮助。
  
稍后我可能还会写一些，关于rmr算法实践，rhadoop架构方面和hive的使用的相关文章。
  
欢迎大家多提问题，多交流。
