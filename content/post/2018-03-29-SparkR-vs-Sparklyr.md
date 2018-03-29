---
title: '深入对比数据科学工具箱: SparkR vs Sparklyr'
date: '2018-03-29'
author: Harry Zhu
slug: sparkr-vs-sparklyr
---

![](https://media.licdn.com/mpr/mpr/AAEAAQAAAAAAAAjKAAAAJDc4NWRjNGE5LTA0ZTktNGE3Mi1iZjBiLWE0YzIyZmVhOGJkZg.png)

# 背景介绍

SparkR 和 Sparklyr 是两个基于Spark的R语言接口，通过简单的语法深度集成到R语言生态中。SparkR 由 Spark 社区维护，通过源码级别更新SparkR的最新功能，最初从2016年夏天的1.5版本开始支持，从使用上非常像`Spark Native`。Sparklyr 由 RStudio 社区维护，通过深度集成 RStudio 的方式，提供更易于扩展和使用的方法，更强调统计特性与机器学习，实现本地与分布式代码的一致性，通常会比SparkR延迟1-2个版本，从使用上看接近于`dplyr`。

# 整体对比

特性|	SparkR|	sparklyr
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



# 深度对比

## 文档

两者文档相对来说 Sparklyr 更加丰富一些，其中包含了业界/学界大量案例，但以中文版较少。SparkR 由第三方提供了中文版文档。

SparkR 文档：http://spark.apachecn.org/docs/cn/2.3.0/structured-streaming-programming-guide.html
Sparklyr 文档：https://spark.rstudio.com

## 安装便利性

SparkR: 从官网下载,支持最新2.3版本。
Sparklyr: `sparklyr::install_spark()`，不依赖于Spark版本，spark 2.X 完美兼容1.X。截止2018年3月18日，目前暂不支持2.3版本。

## Spark初始化

SparkR:
```
Sys.setenv("SPARKR_SUBMIT_ARGS"="--master yarn-client sparkr-shell")


sc <- SparkR::sparkR.session(enableHiveSupport = T,
                             sparkHome = "/data/FinanceR/Spark")
```

Sparklyr:

```
sc <- sparklyr::spark_connect(master = "yarn-client", spark_home = "/data/FinanceR/Spark", version = "2.2.0", config = sparklyr::spark_config())

```

## 数据IO

以写Parquet文件为例

SparkR:
```
df <- SparkR::as.DataFrame(faithful) 

SparkR::write.parquet(df,path= "/user/FinanceR",mode="overwrite",partition_by = "dt")
```

Sparklyr:
```
df <- sparklyr::copy_to(sc,faithful,"df")
sparklyr::spark_write_parquet(df,path="/user/FinanceR",mode="overwrite",partition_by = "dt")
```

## 数据清洗

以统计计数为例：

SparkR
```
library(SparkR)
library(magrittr)

df %>%
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

Sparklyr
```
library(sparklyr)
library(dplyr)

# 在 mutate 中支持 Hive UDF

df %>%
mutate(a = b+2) %>%
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

SparkR
```
df <- SparkR::sql('SELECT * FROM financer_tbl WHERE dt = "20180318"')
```

Sparklyr

所有操作几乎和MySQL完全一样，学习成本≈0
```
df <- sc %>% 
      dplyr::tbl(dplyr::sql('SELECT * FROM financer_tbl WHERE dt = "20180318"'))

sc %>% DBI::dbGetQuery('SELECT * FROM financer_tbl WHERE dt = "20180318" limit 10') # 直接将数据 collect 到本地, 与操作MySQL完全一样
      
df %>% dbplyr::sql_render() # 将 pipeline 自动翻译为 SQL
# SELECT * FROM financer_tbl WHERE dt = "20180318"
```

## 分发R代码

SparkR
```
#SparkR::dapply/SparkR::gapply/SparkR::lapply

func <- function(x){x + runif(1) } # 原生R代码

SparkR::gapplyCollect(x = df, func = func,group = "key")
```

Sparklyr:
```
func <- function(x){x + runif(1) } # 原生 R代码

sparklyr::spark_apply(x = df,packages=T,name = c("key","value"),func =func,group = "key")
```

SparkR 手动通过 `spark.addFile` 加载本地依赖，Sparklyr 自动将本地依赖分发到集群上


## 流式计算

SparkR

```

stream <- SparkR::read.stream(source = "kafka",
                 "kafka.bootstrap.servers" = "a1.financer.com:9092,a2.financer.com:9092",
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

Sparklyr 暂时不支持流式计算，功能开发中

## 图计算

SparkR 不直接支持 Graph Mining，具体实现通过GraphX来实现
Sparklyr 通过拓展程序，`graphframes` 实现图挖掘，比如Pagerank、LPA等

```
library(graphframes)
# copy highschool dataset to spark
highschool_tbl <- copy_to(sc, ggraph::highschool, "highschool")

# create a table with unique vertices using dplyr
vertices_tbl <- sdf_bind_rows(
  highschool_tbl %>% distinct(from) %>% transmute(id = from),
  highschool_tbl %>% distinct(to) %>% transmute(id = to)
)

# create a table with <source, destination> edges
edges_tbl <- highschool_tbl %>% transmute(src = from, dst = to)

gf_graphframe(vertices_tbl, edges_tbl) %>%
  gf_pagerank(reset_prob = 0.15, max_iter = 10L, source_id = "1")
```

## 深度学习

SparkR 不直接支持 Deep Learning
Sparklyr 通过拓展程序 [Rsparkling](http://docs.h2o.ai/h2o/latest-stable/h2o-docs/data-science/deep-learning.html) 实现深度学习，比如 Anto-Encoder

# 总结

目前，SparkR 仅在实时计算上领先于 Sparklyr，在图计算、机器学习、深度学习等领域已经被拉开差距，在大多数场景下，Sparklyr将是一个更好的选择，在不久的将来，Sparklyr也将集成Streaming模块，届时将全面覆盖SparkR功能。

相比于 pandas 和 pyspark，R 和 SparkR 的差异更小，并且如果你已经掌握了 dplyr 操作 mysql 的方法，学习 Sparklyr 将变得十分容易，因为他们共用同一套数据处理的语法，使用spark几乎只有参数配置的学习成本， 更多 Sparklyr教程可见 spark.rstudio.com 以及 Sparklyr 使用手册:https://github.com/rstudio/cheatsheets/raw/master/translations/chinese/sparklyr-cheatsheet_zh_CN.pdf 。

# 参考资料

* https://eddjberry.netlify.com/post/2017-12-05-sparkr-vs-sparklyr/
* https://github.com/rstudio/sparklyr/issues/502
* https://databricks.com/session/r-and-spark-how-to-analyze-data-using-rstudios-sparklyr-and-h2os-rsparkling-packages
* https://github.com/kevinykuo/sparklygraphs
* http://docs.h2o.ai/h2o/latest-stable/h2o-docs/data-science/deep-learning.html
* https://github.com/rstudio/graphframes
