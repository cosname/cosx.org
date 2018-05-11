---
title: '深入对比数据科学工具箱: SparkR vs Sparklyr'
date: '2018-05-11'
author: 朱俊辉 
slug: sparkr-vs-sparklyr
categories:
  - 统计软件
tags:
  - spark
  - 软件包
  - 并行计算
meta_extra: "审稿：郎大为、黄俊文、朱雪宁"
forum_id: 419983
---

![](https://sfault-image.b0.upaiyun.com/340/584/3405848728-5ab3c7fb13cac_articlex)

# 背景介绍

SparkR 和 Sparklyr 是两个基于Spark的R语言接口，通过简单的语法深度集成到R语言生态中。SparkR 由 Spark 社区维护，通过源码级别更新SparkR的最新功能，最初从2016年夏天的1.5版本开始支持，从使用上非常像`Spark Native`。Sparklyr 由 RStudio 社区维护，通过深度集成 RStudio 的方式，提供更易于扩展和使用的方法，更强调统计特性与机器学习，实现本地与分布式代码的一致性，通常会比SparkR延迟1-2个版本，从使用上看接近于`dplyr`。

# 整体对比

特性|	SparkR|	Sparklyr
---|---|---
文档|	+ + |	+ + +
安装便利性|	+	|+ + +
数据IO|	+ + +|	+ + +
数据清洗| + + +| + + +
SQL|+ +|+ + +
机器学习|	+ +|	+ + +
深度学习|-|+ +
流式计算|	+ + +|	-
图计算| -|+ +
分发R代码|+ + +	|+ + +

>>由于 SparkR 与 Sparklyr 都是 Spark API的封装，故二者在计算性能上没有显著差异。

# 深度对比

## 文档

两者文档相对来说 Sparklyr 更加丰富一些，其中包含了业界/学界大量案例，但以中文版较少。SparkR 由第三方提供了中文版文档。

SparkR 文档：http://spark.apachecn.org/docs/cn/2.3.0/structured-streaming-programming-guide.html

Sparklyr 文档：https://spark.rstudio.com

## 安装便利性

SparkR: 从官网下载。

Sparklyr: `sparklyr::spark_install(version = "2.3.0", hadoop_version = "2.7")`，不依赖于Spark版本，spark 2.X 完美兼容1.X。

Spark环境配置需要注意的问题：

1. 下载和Hadoop对应版本号的发行版，具体可以通过  `sparklyr::spark_available_versions()` 查询可用的spark版本
2. `JAVA_HOME/SPARK_HOME/HADOOP_HOME` 是必须要指定的环境变量，建议使用 `JDK8/spark2.x/hadoop2.7`
3. yarn-client/yarn-cluster 模式需要设置环境变量 `Sys.setenv("HADOOP_CONF_DIR"="/etc/hadoop/conf")`
4. 连接 Hive 需要提供 Hive 链接配置, 在spark-connection 初始化时指定对应 `hive-site.xml` 文件

由于不同发行版本的Hadoop/Yarn集群略有差异，环境Setup问题可以留言讨论。

## Spark初始化

SparkR:

```{r}
Sys.setenv("SPARKR_SUBMIT_ARGS"="--master yarn-client sparkr-shell")

sc <- SparkR::sparkR.session(enableHiveSupport = T,
                             sparkHome = "/data/FinanceR/Spark")
```

Sparklyr:

```{r}
sc <- sparklyr::spark_connect(master = "yarn-client",
                             spark_home = "/data/FinanceR/Spark",
                             version = "2.2.0",
                             config = sparklyr::spark_config())
```

## 数据IO

以写Parquet文件为例,同理你可以用 `SparkR::write.*()`/`sparklyr::spark_write_*()` 等写入其他格式文件到HDFS上,比如 csv/text。

> 什么是 Parquet 文件？
> Parquet 是一种高性能列式存储文件格式，比CSV文件强在内建索引，可以快速查询数据，目前普遍应用在模型训练过程。

SparkR:

```{r}
df <- SparkR::as.DataFrame(faithful) 

SparkR::write.parquet(df,path= "/user/FinanceR",mode="overwrite",partition_by = "dt")
```

Sparklyr:

```{r}
df <- sparklyr::copy_to(sc,faithful,"df")

sparklyr::spark_write_parquet(df,path="/user/FinanceR",mode="overwrite",partition_by = "dt")
```

## 数据清洗

dplyr 集成 spark/mysql 需要用到远程处理模式。它要求先定义数据源表，再通过一系列dplyr操作惰性求值，直到执行 `head()` 或者 `collect()` 等触发函数，才会执行计算过程，并将数据返回。如此设计是因为大数据集如果立即处理是无法优化数据处理流程的，通过惰性求值的方式，系统会在远程机器上自动优化数据处理流程。

以统计计数为例：

从 db.financer_tbl 表中给 b 列 +2 后赋值为 a，过滤出 a > 2 条件下，每个 key 对应出现的次数并按照升序排序，最后去除统计缺失值。

SparkR:

```{r}
library(SparkR)
library(magrittr)

remote_df = SparkR::sql("select * from db.financer_tbl limit 10") # 定义数据源表

remote_df %>%
    mutate(a = df$b + 2) %>%
    filter("a > 2")%>%
    group_by("key")%>%
    count()%>%
    withColumn("count","cnt")%>%
    orderBy("cnt",decrease = F)%>%
    dropna() ->
    pipeline

pipeline %>% persist("MEM_AND_DISK") # 大数据集 缓存在集群上
pipeline %>% head() # 小数据 加载到本地
```

Sparklyr:

```{r}
library(sparklyr)
library(dplyr)

# 在 mutate 中支持 Hive UDF

remote_df = dplyr::tbl(sc,from = "db.financer_tbl") # 定义数据源表 
# 或者 remote_df = dplyr::tbl(sc,from = dplyr::sql("select * from db.financer_tbl limit 10")) #

remote_df %>%
    mutate(a = b+2) %>%   # 在 mutate 中支持 Hive UDF
    filter(a > 2)%>%
    group_by(key)%>%
    summarize(count = n())%>%
    select(cnt = count)%>% 
    order_by(cnt)%>%
    arrange(desc(cnt))%>%
    na.omit() ->
    pipeline

pipeline %>% sdf_persist() # 大数据集 缓存在集群上
pipeline %>% head() %>% collect() # 小数据 加载到本地
```

## SQL

SparkR:

```{r}
df <- SparkR::sql('SELECT * FROM financer_tbl WHERE dt = "20180318"')
```

Sparklyr:

由于Sparklyr通过dplyr接口操作，所以，所有数据操作几乎和MySQL完全一样，学习成本≈0。

```{r}
df <- sc %>% 
      dplyr::tbl(dplyr::sql('SELECT * FROM financer_tbl WHERE dt = "20180318"'))

sc %>% DBI::dbGetQuery('SELECT * FROM financer_tbl WHERE dt = "20180318" limit 10') # 直接将数据 collect 到本地, 与操作MySQL完全一样
      
df %>% dbplyr::sql_render() # 将 pipeline 自动翻译为 SQL
# SELECT * FROM financer_tbl WHERE dt = "20180318"
```

## 分发R代码

分发机制：

系统会将本地依赖文件压缩打包上传到HDFS路径上，通过 Spark 动态分发到执行任务的机器上解压缩。
执行任务的机器本地独立的线程、内存中执行代码，最后汇总计算结果到主要节点机器上实现R代码的分发。

SparkR:

```{r}
#SparkR::dapply/SparkR::gapply/SparkR::lapply

func <- function(x){x + runif(1) } # 原生R代码

SparkR::gapplyCollect(x = df, func = func,group = "key")
```

Sparklyr:

```{r}
func <- function(x){x + runif(1) } # 原生 R代码

sparklyr::spark_apply(x = df,packages=T,name = c("key","value"),func =func,group = "key")
```

SparkR 手动通过 `spark.addFile` 加载本地依赖，而 Sparklyr 打包本地 R 包只需通过 package = TRUE 参数即可，最大化减少学习成本。


## 流式计算

>什么是流式计算?
>流式计算是介于实时与离线计算之间的一种计算方式，以亚秒级准实时的方式小批量计算数据，广泛应用在互联网广告、推荐等场景。

SparkR:

```{r}
stream <- SparkR::read.stream(
            source = "kafka",
            "kafka.bootstrap.servers" = "a1.financer.com:9092,
                                         a2.financer.com:9092",
            "subscribe" =  "binlog.financer.financer")

stream %>%
  SparkR::selectExpr( "CAST(key AS STRING)", "CAST(value AS STRING)") %>%
  SparkR::selectExpr("get_json_object(value,'$.data') as data") %>% 
  SparkR::selectExpr("get_json_object(data,'$.ORDERID') as orderid"
             ,"get_json_object(data,'$.USERID') as userid"
             ,"get_json_object(data,'$.TS') as ts"
             ) %>% 
  SparkR::withWatermark("ts", "5 minutes") %>% 
  SparkR::createOrReplaceTempView("financer")

"
 select userid,window.start as ts,count(1) as cnt
 from financer 
 group by userid, window(ts, '5 seconds')
" %>% 
SparkR::sql() %>% 
  SparkR::write.stream("console",outputMode = "complete") ->
  query 

```

Sparklyr: 暂时不支持流式计算，功能开发中。

## 图计算

>什么是图计算?
>图计算是以“图论”为基础的对现实世界的一种“图”结构的抽象表达，以及在这种数据结构上的计算模式。
>通常，在图计算中，基本的数据结构表达就是： G = （V，E，D） V = vertex （顶点或者节点） E = edge （边） D = data （权重）。

SparkR: 不直接支持 Graph Minining。

Sparklyr: 通过拓展程序，`graphframes` 实现图挖掘，比如Pagerank、LPA等。

下面是一个通过 `graphframes` 实现 Pagerank 的例子：

```{r}
library(graphframes)
# 复制  highschool 数据集到到 spark
highschool_tbl <- copy_to(sc, ggraph::highschool, "highschool")

# 通过 dplyr 初始化节点列表
vertices_tbl <- sdf_bind_rows(
  highschool_tbl %>% distinct(from) %>% transmute(id = from),
  highschool_tbl %>% distinct(to) %>% transmute(id = to)
)

# 初始化边列表  create a table with <source, destination> edges
edges_tbl <- highschool_tbl %>% transmute(src = from, dst = to)

gf_graphframe(vertices_tbl, edges_tbl) %>%
  gf_pagerank(reset_prob = 0.15, max_iter = 10L, source_id = "1")
```

## 深度学习

SparkR 不直接支持 Deep Learnig。
Sparklyr 通过拓展程序 [Rsparkling](http://spark.rstudio.com/guides/h2o/#deep-learning) 实现深度学习，比如 Anto-Encoder

# 总结

目前，SparkR 仅在实时计算上领先于 Sparklyr，在图计算、机器学习、深度学习等领域已经被拉开差距，在大多数场景下，Sparklyr将是一个更好的选择，在不久的将来，Sparklyr也将集成Streaming模块，届时将全面覆盖SparkR功能。

相比于 pandas 和 pyspark，R 和 SparkR 的差异更小，并且如果你已经掌握了 dplyr 操作 mysql 的方法，学习 Sparklyr 将变得十分容易，因为他们共用同一套数据处理的语法，使用spark几乎只有参数配置的学习成本， 更多 Sparklyr 教程可见 Sparklyr 官网 spark.rstudio.com 以及 Sparklyr 使用手册:https://github.com/rstudio/cheatsheets/raw/master/translations/chinese/sparklyr-cheatsheet_zh_CN.pdf 。

# 参考资料

* https://eddjberry.netlify.com/post/2017-12-05-sparkr-vs-sparklyr/
* https://github.com/rstudio/sparklyr/issues/502
* https://databricks.com/session/r-and-spark-how-to-analyze-data-using-rstudios-sparklyr-and-h2os-rsparkling-packages
* https://github.com/kevinykuo/sparklygraphs
* http://docs.h2o.ai/h2o/latest-stable/h2o-docs/data-science/deep-learning.html
* https://github.com/rstudio/graphframes
