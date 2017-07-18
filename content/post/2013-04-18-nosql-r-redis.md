---
title: R利剑NoSQL系列文章 之 Redis
date: '2013-04-18T12:00:50+00:00'
author: 张丹
categories:
  - 软件应用
tags:
  - nosql
  - redis
  - rredis
  - R语言
slug: nosql-r-redis
forum_id: 418933
---

Author: 张丹(Conan)
  
Email: <bsspirit@gmail.com>
  
Blog: [http://www.fens.me](http://www.fens.me/)
  
Weibo: @Conan_Z
  
Date: 2013-4-14

# R利剑NoSQL系列文章

R利剑NoSQL系列文章，主要介绍通过R语言连接使用nosql数据库。涉及的NoSQL产品，包括Redis, MongoDB, HBase, Hive, Cassandra, Neo4j。希望通过我的介绍让广大的R语言爱好者，有更多的开发选择，做出更多地激动人心的应用。

由于文章篇幅有限，均跳过NoSQL的安装过程，请自行参考文档安装。

# 第二篇 R利剑Redis，分为4个章节。

Redis环境准备
rredis函数库
rredis基本使用操作
rredis使用案例
    

每一章节，都会分为“文字说明部分”和“代码部分”，保持文字说明与代码的连贯性。

# 第一章 Redis环境准备

## 文字说明部分：

首先环境准备，这里我选择了Linux Ubuntu操作系统12.04的64位服务器版本，大家可以根据自己的使用习惯选择顺手的Linux。

  
Redis安装过程跳过。sudo apt-get install redis-server

查看Redis服务器环境
  
使用/etc/init.d/redis-server命令，启动redis-server， 默认端口：port=6379

在服务器端，用telnet连接redis-server

用telnet插入数据，读取数据

R语言环境2.15.0，WinXP通过远程连接，访问Redis server。

## 代码部分：

- 查看操作系统

```bash
~ uname -a

    Linux AY121111030241cda8003 3.2.0-29-generic #46-Ubuntu SMP Fri Jul 27 17:03:23 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

~ cat /etc/issue

    Ubuntu 12.04.1 LTS \n \l
```    

- 启动redis

```bash
~ /etc/init.d/redis-server start

    Starting redis-server: redis-server.
```

- 查看系统进程

```bash
~ ps -aux|grep redis

    redis    20128  0.0  0.0  10676  1428 ?        Ss   16:39   0:00 /usr/bin/redis-server /etc/redis/redis.conf
```

- 查看启日志

```bash
~ cat  /var/log/redis/redis-server.log

    [20128] 14 Apr 16:39:43 * Server started, Redis version 2.2.12
    [20128] 14 Apr 16:39:43 # WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
    [20128] 14 Apr 16:39:43 * The server is now ready to accept connections on port 6379
```

- telnet连接redis-server

```bash
~ telnet localhost 6379

    Trying 127.0.0.1...
    Connected to localhost.
    Escape character is '^]'.
```

- 插入数据

```
rpush data 1
:1

rpush data 2
:2
```    

- 查询数据

```bash
lrange data 0 -1
*2
$1
1
$1
2
```    

- R语言开发环境2.15.0，WinXP

```bash
~ R
R version 2.15.0 (2012-03-30)
Copyright (C) 2012 The R Foundation for Statistical Computing
ISBN 3-900051-07-0
Platform: i386-pc-mingw32/i386 (32-bit)
```

# 第二章 rredis函数库

rredis提供了100函数，对应用redis的操作。虽然函数也不少，但是用法都是比较简单的，对R语言支持足够灵活，代码也比较简洁。

下面列出了所有rredis函数库，我只挑选一些常用的介绍。

## 文字说明部分：

- 建立连接，关闭连接

```bash
redisConnect() , redisClose()
```

- 清空当前/所有数据库数据

```bash
redisFlushDB() , redisFlushAll()
```

- 列出所有KEY值，KEY的数量

```bash
redisKeys(), redisDBSize()
```

- 选择切换数据库:0是默认数据库

```bash
redisSelect(0)    
```

- 插入string对象，批量插入

```bash
redisSet('x',runif(5)), redisMSet(list(x=pi,y=runif(5),z=sqrt(2)))
```

- 读取string对象，批量读取

```bash
redisGet('x'), redisMGet(c('x','y','z'))
```

- 删除对象

```bash
redisDelete('x')
```

- 左边插入数组对象,右边插入数组对象

```bash
redisLPush('a',1), redisRPush('a','A')
```

- 左边弹出一个数组对象， 右边弹出一个数组对象，

```bash
redisLPop('a'), redisRPop('a')
```

- 从左边显示数组对象列表

```bash
redisLRange('a',0,-1)
```

- 插入set类型对象

```bash
redisSAdd('A',runif(2))
```

- 显示set对象有几个元素，列表显示set对象元素

```bash
redisSCard('A'), redisSMembers('A')
```

- 显示两个set对象的差集，交集，并集

```bash
redisSDiff(c('A','B')),redisSInter(c('A','B')),redisSUnion(c('A','B'))
```

## 代码部分：

共有100个函数

```bash
redisAuth
redisBgRewriteAOF
redisBgSave
redisBLPop
redisBRPop
redisBRPopLPush
redisClose
redisCmd
redisConnect
redisDBSize
redisDecr
redisDecrBy
redisDelete
redisDiscard
redisEval
redisExec
redisExists
redisExpire
redisExpireAt
redisFlushAll
redisFlushDB
redisGet
redisGetContext
redisGetResponse
redisGetSet
redisHDel
redisHExists
redisHFields
redisHGet
redisHGetAll
redisHIncrBy
redisHKeys
redisHLen
redisHMGet
redisHMSet
redisHSet
redisHVals
redisIncr
redisIncrBy
redisInfo
redisKeys
redisLIndex
redisLLen
redisLPop
redisLPush
redisLRange
redisLRem
redisLSet
redisLTrim
redisMGet
redisMonitorChannels
redisMove
redisMSet
redisMulti
redisPublish
redisRandomKey
redisRename
redisRPop
redisRPopLPush
redisRPush
redisSAdd
redisSave
redisSCard
redisSDiff
redisSDiffStore
redisSelect
redisSet
redisSetBlocking
redisSetContext
redisShutdown
redisSInter
redisSInterStore
redisSIsMember
redisSlaveOf
redisSMembers
redisSMove
redisSort
redisSPop
redisSRandMember
redisSRem
redisSubscribe
redisSUnion
redisSUnionStore
redisTTL
redisType
redisUnsubscribe
redisUnwatch
redisWatch
redisZAdd
redisZCard
redisZIncrBy
redisZInterStore
redisZRange
redisZRangeByScore
redisZRank
redisZRem
redisZRemRangeByRank
redisZRemRangeByScore
redisZScore
redisZUnionStore   
```

# 第三章 rredis基本使用操作

## 文字说明部分：

首先，要安装rredis类库，加载类库。

redisConnect(host=“192.168.1.101”,port=6379)

然后，通过redisConnect()函数，建立与Redis Server的连接。如果是本地连接redisConnect()不要参数，下面例子使用远程连接，增加host参数配置IP地址。redisConnect(host=“192.168.1.101”,port=6379)

redis的基本操作：建议链接，切换数据库，列表显示所有KEY值，清空当前数据库数据，清空所有数据库数据，关闭链接，

string类型操作：插入，读取，删除，插入并设置过期时间，批量操作

list类型操作：插入，读取，弹出

set类型操作：插入，读取，交集，差集，并集

rredis与redis-cli的交互操作

## 代码部分：

## rredis的基本操作：

```r
#安装rredis
install.packages("rredis")

#加载rredis类库
library(rredis)

#远程连接redis server
redisConnect(host="192.168.1.101",port=6379)

#列出所有的keys
redisKeys()
    [1] "x"    "data"

#显示有多少个key
redisDBSize()
    [1] 2

#切换数据库1
redisSelect(1)
    [1] "OK"
redisKeys()
    NULL

#切换数据库0
redisSelect(0)
    [1] "OK"
redisKeys()
    [1] "x"    "data"

#清空当前数据库数据
redisFlushDB()
    [1] "OK"

#清空所有数据库数据
redisFlushAll()
    [1] "OK"

#关闭链接
redisClose()    
```

## string类型操作:

```r
#插入对象
redisSet('x',runif(5))
    1] "OK"

#读取对象
redisGet('x')
    [1] 0.67616159 0.06358643 0.07478021 0.32129140 0.16264615

#设置数据过期时间
redisExpire('x',1)
Sys.sleep(1)
redisGet('x')
    NULL

#批量插入
redisMSet(list(x=pi,y=runif(5),z=sqrt(2)))
    [1] TRUE

#批量读取
redisMGet(c('x','y','z'))
    $x
    [1] 3.141593
    $y
    [1] 0.9249501 0.3444994 0.6477250 0.1681421 0.2646853
    $z
    [1] 1.414214

#删除数据    
redisDelete('x')
    [1] 1
redisGet('x')
    NULL
```

## list类型操作

```r
#从数组左边插入数据
redisLPush('a',1)
redisLPush('a',2)
redisLPush('a',3)

#显示从数组左边0-2的数据
redisLRange('a',0,2)
    [[1]]
    [1] 3
    [[2]]
    [1] 2
    [[3]]
    [1] 1

#从数据左边弹出一个数据
redisLPop('a')
    [1] 3

#显示从数组左边0-(-1)的数据   
redisLRange('a',0,-1)
    [[1]]
    [1] 2

    [[2]]
    [1] 1

#从数组右边插入数据
redisRPush('a','A')
redisRPush('a','B')

#显示从数组左边0-(-1)的数据
redisLRange('a',0,-1)
    [[1]]
    [1] 2
    [[2]]
    [1] 1
    [[3]]
    [1] "A"
    [[4]]
    [1] "B"

#从数据右边弹出一个数据
redisRPop('a')
```

## set类型操作

```r
redisSAdd('A',runif(2))
redisSAdd('A',55)

#显示对象有几个元素
redisSCard('A')
    [1] 2

#列表显示set对象元素
redisSMembers('A')
    [[1]]
    [1] 55

    [[2]]
    [1] 0.6494041 0.3181108

redisSAdd('B',55)
redisSAdd('B',rnorm(3))

#显示对象有几个元素
redisSCard('B')
    [1] 2

#列表显示set对象元素    
redisSMembers('B')
    [[1]]
    [1] 55

    [[2]]
    [1] 0.1074787 1.3111006 0.8223434

#差集
redisSDiff(c('A','B'))
    [[1]]
    [1] 0.6494041 0.3181108

#交集
redisSInter(c('A','B'))
    [[1]]
    [1] 55

#并集
redisSUnion(c('A','B'))
    [[1]]
    [1] 55

    [[2]]
    [1] 0.1074787 1.3111006 0.8223434

    [[3]]
    [1] 0.6494041 0.3181108
```

## rredis与redis-cli交互

- redis客户端插入数据，rredis读取数据

```bash
#打开redis客户端
~ redis-cli
redis 127.0.0.1:6379> set shell "Greetings, R client!"
    OK

redisGet('shell')
    [1] "Greetings, R client!"
```

- rredis插入数据，redis客户端读取数据

```r
#插入数据
redisSet('R', 'Greetings, shell client!')
    [1] "OK"

#读取数据(有乱码)
redis 127.0.0.1:6379> get R
    "X\\x00\x00\x00\x02\x00\x02\x0f\x00\x00\x02\x03\x00\x00\x00\x00\x10\x00\x00\x00\x01\x00\x04\x00\\x00\x00\x00\x18Greetings, shell client!"
```

- 转型以数组方式存储(charToRaw)

```r
redisSet('R', charToRaw('Greetings, shell client!'))
    [1] TRUE

#正常读取数据
redis 127.0.0.1:6379> get R
    "Greetings, shell client!"
```

# 第四章 rredis测试案例

测试案例的需求：
  
读入一个数据文件，从左到右分别是用户id，口令，邮箱，在redis里建立合适的数据模型，并将这些数据导入到redis。

### 文字说明部分：

首先，定义数据模型：

KEY:
  
users:用户id

VALUE:
  
id:用户id
  
pw:口令
  
email:邮箱

R语言读入数据文件。

然后，建立redis连接，以循环方式插入数据。

以users:wolys为KEY，输出对应用的VALVE值。

## 代码部分

```r
#读入数据
data<-scan(file="data5.txt",what=character(),sep=" ")
data<-data[which(data!='#')]

> data

     [1] "wolys"                   "wolysopen111"            "wolys@21cn.com"         
     [4] "coralshanshan"           "601601601"               "zss1984@126.com"        
     [7] "pengfeihuchao"           "woaidami"                "294522652@qq.com"       
    [10] "simulategirl"            "@#$9608125"              "simulateboy@163.com"    
    [13] "daisypp"                 "12345678"                "zhoushigang_123@163.com"
    [16] "sirenxing424"            "tfiloveyou"              "sirenxing424@126.com"   
    [19] "raininglxy"              "1901061139"              "lixinyu23@qq.com"       
    [22] "leochenlei"              "leichenlei"              "chenlei1201@gmail.com"  
    [25] "z370433835"              "lkp145566"               "370433835@qq.com"       
    [28] "cxx0409"                 "12345678"                "cxx0409@126.com"        
    [31] "xldq_l"                  "061222ll"                "viv093@sina.com"  

#连接redis连接
redisConnect(host="192.168.1.101",port=6379)
redisFlushAll()
redisKeys()

#循环插入数据
id<-NULL
for(i in 1:length(data)){
  if(i %% 3 == 1) {
    id<-data[i]
    redisSAdd(paste("users:",id,sep=""),paste("id:",id,sep=""))
  } else if(i %% 3 == 2) {
    redisSAdd(paste("users:",id,sep=""),paste("pw:",data[i],sep=""))
  } else {
    redisSAdd(paste("users:",id,sep=""),paste("email:",data[i],sep=""))
  }
}

#列出所有的KEY
redisKeys()

     [1] "users:cxx0409"       "users:sirenxing424"  "users:simulategirl"  "users:xldq_l"       
     [5] "users:coralshanshan" "users:raininglxy"    "users:pengfeihuchao" "users:leochenlei"   
     [9] "users:daisypp"       "users:wolys"         "users:z370433835"   

#通过KEY查询VALUE
redisSMembers("users:wolys")

    [[1]]
    [1] "pw:wolysopen111"

    [[2]]
    [1] "email:wolys@21cn.com"

    [[3]]
    [1] "id:wolys"

#关闭redis连接
redisClose()
```

完成测试案例。

## 数据文件：data5.txt

```txt
wolys # wolysopen111 # wolys@21cn.com
coralshanshan # 601601601 # zss1984@126.com
pengfeihuchao # woaidami # 294522652@qq.com
simulategirl # @#$9608125 # simulateboy@163.com
daisypp # 12345678 # zhoushigang_123@163.com
sirenxing424 # tfiloveyou # sirenxing424@126.com
raininglxy # 1901061139 # lixinyu23@qq.com
leochenlei # leichenlei # chenlei1201@gmail.com
z370433835 # lkp145566 # 370433835@qq.com
cxx0409 # 12345678 # cxx0409@126.com
xldq_l # 061222ll # viv093@sina.com
```
