---
date: "2020-04-02"
slug: connect-mysql-from-r
title: 从 R 连接 MySQL
author: 黄湘云
categories:
  - 统计软件
  - R 语言
tags:
  - MySQL
  - MariaDB
  - data.table
  - dplyr
  - Fedora 29
forum_id: 421363
---

> Code should be written to minimize the time it would take for someone else to understand it.
>
> --- The Art of Readable Code, Boswell, D. / Foucher, T.

# 安装配置 MySQL {#setup-mysql}

MySQL 是 Oracle （甲骨文）公司出品的一款数据库管理系统，社区版以 [GPL 2.0](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html) 协议开源[^mysql-repo]。毕竟开源社区不希望被 Oracle 公司牵着走，所以出现了 MySQL 的开源替代版 [MariaDB](https://zh.wikipedia.org/wiki/MariaDB)，后者保证保持开源状态，所以那批原始的 MySQL 的开发者已经跑到 MariaDB 这杆旗下，下游的其它语言的接口，比如 [RMySQL](https://github.com/r-dbi/RMySQL) 包正逐步被 [RMariaDB](https://github.com/r-dbi/RMariaDB) 包替换，MySQL Server 也必将逐步被 [MariaDB Server](https://mariadb.org/) 替换。本文介绍的 MariaDB Server 版本为 10.3.18，在本文的环境下，完全可以将 MariaDB Server 看作 MySQL Server。

```bash
# 从系统仓库安装开源版
sudo dnf install -y mariadb-devel
# 启动 mysql 服务
systemctl start mariadb.service
# 设置开机启动
systemctl enable mariadb.service
```

初始密码是空的，无密码，直接回车即可登录进去。

```bash
mysql -u root -p
```

进入 MySQL 后可以设置新的 root 账户密码，比如这里的 xxx。 [^mysql-password]

```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'xxx';
```

进入 MySQL 数据库管理系统，创建一个名叫 demo 的数据库。[^sql-grammar]

```sql
CREATE DATABASE demo;
```

[^mysql-repo]: 以本文 Fedora 29 系统为例，从 MySQL 官网获取 Oracle 出品的开源社区版，需要先导入安装源。

    ```bash
    dnf install https://dev.mysql.com/get/mysql80-community-release-fc29-2.noarch.rpm
    # 从 Oracle 仓库安装开源版
    dnf install mysql-community-server
    # 启动 mysql 服务
    systemctl start mysqld.service
    # 设置开机启动
    systemctl enable mysqld.service
    ```

    除了红帽系的 Fedora 系统还有 CentOS/Ubuntu/MacOS/Windows 等等，开源软件一大特点就是跨系统平台，支持的系统和版本详见 [MySQL 官网下载页面](https://dev.mysql.com/downloads/mysql/)

[^sql-grammar]: 你可能已经发现 SQL 语法中，对关键词是不区分大小写的，比如 `create` 或 `CREATE` 都是可以的，但是在 SQL 代码中应尽量保持一致，对保留字都用大写，对自造的库名、表名、列名都用小写，我司采用的 Hive 仓库前端 [HUE](https://github.com/cloudera/hue) 就支持 SQL 语句格式化，再辅以手动调整，用起来也比较方便，这主要针对交付阶段的代码整理，以便协作和共享。还有一些网站也提供免费的 SQL 代码格式化工具，比如 [SQLFormat](https://sqlformat.org/)

[^mysql-password]: 不要尝试用此密码来登录我的数据库系统，我从来不在主机上操作可能泄露隐私的事，都是在虚拟环境里操作，如果你真的攻进来了，欢迎加个好友！

# 从 R 连接 MySQL {#connect-mysql}

在安装配置好 MySQL 的情况下，准备好 R 软件和 R 扩展包

```r
install.packages(c('DBI','RMySQL'))
```

然后加载 R包连接 MySQL 数据库， dbname 是要连接的数据库名称，host 是数据库所在的网络位置，本机常常是 localhost。 远程的话，就是 IP 地址，port 是连接 MySQL 数据库系统的端口，MySQL 作为一款软件，同时也是一个数据库管理系统，要访问它，就要知道访问它的通道，默认开放的端口就是 3306，user 用来指定登录的用户，比如拥有最高权限的 root 账户或其它账户，password 就是对应的账户密码。[^root-password]

```r
library(DBI)
# 用 root 账户登录连接数据库 demo
con <- DBI::dbConnect(RMySQL::MySQL(), dbname = 'demo', host = "localhost", port = 3306, user = "root", password = "xxx")
```

到目前为止，数据库 demo 里还什么表都没有，先从将 R 环境中默认加载的数据集 mtcars 写入 demo 库，并将表名也命名为 mtcars

```r
dbWriteTable(con, "mtcars", mtcars)
```

我们再来看看上面那行 R 代码在数据库中产生什么效果，进入数据库 demo 执行

```sql
SELECT * FROM mtcars;
```

```
MariaDB [demo]> SELECT * FROM mtcars;
+---------------------+------+------+-------+------+------+-------+-------+------+------+------+------+
| row_names           | mpg  | cyl  | disp  | hp   | drat | wt    | qsec  | vs   | am   | gear | carb |
+---------------------+------+------+-------+------+------+-------+-------+------+------+------+------+
| Mazda RX4           |   21 |    6 |   160 |  110 |  3.9 |  2.62 | 16.46 |    0 |    1 |    4 |    4 |
| Mazda RX4 Wag       |   21 |    6 |   160 |  110 |  3.9 | 2.875 | 17.02 |    0 |    1 |    4 |    4 |
| Datsun 710          | 22.8 |    4 |   108 |   93 | 3.85 |  2.32 | 18.61 |    1 |    1 |    4 |    1 |
| Hornet 4 Drive      | 21.4 |    6 |   258 |  110 | 3.08 | 3.215 | 19.44 |    1 |    0 |    3 |    1 |
| Hornet Sportabout   | 18.7 |    8 |   360 |  175 | 3.15 |  3.44 | 17.02 |    0 |    0 |    3 |    2 |
| Valiant             | 18.1 |    6 |   225 |  105 | 2.76 |  3.46 | 20.22 |    1 |    0 |    3 |    1 |
| Duster 360          | 14.3 |    8 |   360 |  245 | 3.21 |  3.57 | 15.84 |    0 |    0 |    3 |    4 |
| Merc 240D           | 24.4 |    4 | 146.7 |   62 | 3.69 |  3.19 |    20 |    1 |    0 |    4 |    2 |
| Merc 230            | 22.8 |    4 | 140.8 |   95 | 3.92 |  3.15 |  22.9 |    1 |    0 |    4 |    2 |
| Merc 280            | 19.2 |    6 | 167.6 |  123 | 3.92 |  3.44 |  18.3 |    1 |    0 |    4 |    4 |
| Merc 280C           | 17.8 |    6 | 167.6 |  123 | 3.92 |  3.44 |  18.9 |    1 |    0 |    4 |    4 |
| Merc 450SE          | 16.4 |    8 | 275.8 |  180 | 3.07 |  4.07 |  17.4 |    0 |    0 |    3 |    3 |
| Merc 450SL          | 17.3 |    8 | 275.8 |  180 | 3.07 |  3.73 |  17.6 |    0 |    0 |    3 |    3 |
| Merc 450SLC         | 15.2 |    8 | 275.8 |  180 | 3.07 |  3.78 |    18 |    0 |    0 |    3 |    3 |
| Cadillac Fleetwood  | 10.4 |    8 |   472 |  205 | 2.93 |  5.25 | 17.98 |    0 |    0 |    3 |    4 |
| Lincoln Continental | 10.4 |    8 |   460 |  215 |    3 | 5.424 | 17.82 |    0 |    0 |    3 |    4 |
| Chrysler Imperial   | 14.7 |    8 |   440 |  230 | 3.23 | 5.345 | 17.42 |    0 |    0 |    3 |    4 |
| Fiat 128            | 32.4 |    4 |  78.7 |   66 | 4.08 |   2.2 | 19.47 |    1 |    1 |    4 |    1 |
| Honda Civic         | 30.4 |    4 |  75.7 |   52 | 4.93 | 1.615 | 18.52 |    1 |    1 |    4 |    2 |
| Toyota Corolla      | 33.9 |    4 |  71.1 |   65 | 4.22 | 1.835 |  19.9 |    1 |    1 |    4 |    1 |
| Toyota Corona       | 21.5 |    4 | 120.1 |   97 |  3.7 | 2.465 | 20.01 |    1 |    0 |    3 |    1 |
| Dodge Challenger    | 15.5 |    8 |   318 |  150 | 2.76 |  3.52 | 16.87 |    0 |    0 |    3 |    2 |
| AMC Javelin         | 15.2 |    8 |   304 |  150 | 3.15 | 3.435 |  17.3 |    0 |    0 |    3 |    2 |
| Camaro Z28          | 13.3 |    8 |   350 |  245 | 3.73 |  3.84 | 15.41 |    0 |    0 |    3 |    4 |
| Pontiac Firebird    | 19.2 |    8 |   400 |  175 | 3.08 | 3.845 | 17.05 |    0 |    0 |    3 |    2 |
| Fiat X1-9           | 27.3 |    4 |    79 |   66 | 4.08 | 1.935 |  18.9 |    1 |    1 |    4 |    1 |
| Porsche 914-2       |   26 |    4 | 120.3 |   91 | 4.43 |  2.14 |  16.7 |    0 |    1 |    5 |    2 |
| Lotus Europa        | 30.4 |    4 |  95.1 |  113 | 3.77 | 1.513 |  16.9 |    1 |    1 |    5 |    2 |
| Ford Pantera L      | 15.8 |    8 |   351 |  264 | 4.22 |  3.17 |  14.5 |    0 |    1 |    5 |    4 |
| Ferrari Dino        | 19.7 |    6 |   145 |  175 | 3.62 |  2.77 |  15.5 |    0 |    1 |    5 |    6 |
| Maserati Bora       |   15 |    8 |   301 |  335 | 3.54 |  3.57 |  14.6 |    0 |    1 |    5 |    8 |
| Volvo 142E          | 21.4 |    4 |   121 |  109 | 4.11 |  2.78 |  18.6 |    1 |    1 |    4 |    2 |
+---------------------+------+------+-------+------+------+-------+-------+------+------+------+------+
32 rows in set (0.000 sec)
```


上一行 SQL 语句在 R 中的等价表示

```r
dbGetQuery(con, "SELECT * FROM mtcars")
```

其实我们还想知道按照默认方式写入的表在 MySQL 中的存储情况，看看各个字段存储的数据类型

```sql
SHOW columns FROM mtcars;
```

```
+-----------+--------+------+-----+---------+-------+
| Field     | Type   | Null | Key | Default | Extra |
+-----------+--------+------+-----+---------+-------+
| row_names | text   | YES  |     | NULL    |       |
| mpg       | double | YES  |     | NULL    |       |
| cyl       | double | YES  |     | NULL    |       |
| disp      | double | YES  |     | NULL    |       |
| hp        | double | YES  |     | NULL    |       |
| drat      | double | YES  |     | NULL    |       |
| wt        | double | YES  |     | NULL    |       |
| qsec      | double | YES  |     | NULL    |       |
| vs        | double | YES  |     | NULL    |       |
| am        | double | YES  |     | NULL    |       |
| gear      | double | YES  |     | NULL    |       |
| carb      | double | YES  |     | NULL    |       |
+-----------+--------+------+-----+---------+-------+
12 rows in set (0.001 sec)
```

```r
dbGetQuery(con, "SHOW columns FROM mtcars")
```

然后和 R 环境中 mtcars 数据集的存储情况对比

```r
str(mtcars)
```
```
'data.frame':	32 obs. of  11 variables:
 $ mpg : num  21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
 $ cyl : num  6 6 4 6 8 6 8 4 4 6 ...
 $ disp: num  160 160 108 258 360 ...
 $ hp  : num  110 110 93 110 175 105 245 62 95 123 ...
 $ drat: num  3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 ...
 $ wt  : num  2.62 2.88 2.32 3.21 3.44 ...
 $ qsec: num  16.5 17 18.6 19.4 17 ...
 $ vs  : num  0 0 1 1 0 1 0 1 1 1 ...
 $ am  : num  1 1 1 0 0 0 0 0 0 0 ...
 $ gear: num  4 4 4 3 3 3 3 4 4 4 ...
 $ carb: num  4 4 1 1 2 1 4 2 2 4 ...
```

截止目前，我们可以看出一些差别，在数据库中，写入 mtcars 数据集的时候，默认将它的行名作为一列写入了，并且存储为 text 类型，在数据库中数值型标记为 double 类型，实际上它相当于  R 中的 numeric 类型，只要不显式声明，默认都会以双精度浮点存储。[^row-names]

[^row-names]: 要想带行名的数据集以不带行名的方式写入 MySQL 库，需要添加参数设置 `row.names = FALSE` 即

    ```sql
    dbWriteTable(con, "mtcars", mtcars, row.names = FALSE)
    ```
    
    顺便一提，从上面还可以看出 `tibble::rownames_to_column(mtcars)` 函数的相通之处了，tibble 包作为 dplyr 家族的一员，在数据库操作层面的对标是非常一致的。关于 dplyr 乃至 tidyverse 的数据库接口层的讨论详见 [帖子](https://d.cosx.org/d/420769-base-r-vs-tidyverse-bt/8)

[^root-password]: 一般来讲，root 账户对应于超级管理员，拥有最高管理权限，系统中数据库、表等等想删哪个删哪个，但是权力越大责任也越大，在 Linux 系统中，每个登录系统的账户在首次使用 sudo 命令的时候都会蹦出如下警告，

    ```
    We trust you have received the usual lecture from the local System
    Administrator. It usually boils down to these three things:
    
        #1) Respect the privacy of others.
        #2) Think before you type.
        #3) With great power comes great responsibility.
    
    root's password:
    ```
    
    如果是系统是中文环境，则会看到这样一段，
    
    ```
    我们信任您已经从系统管理员那里了解了日常注意事项。
    总结起来无外乎这三点：
    
        #1) 尊重别人的隐私。
        #2) 输入前要先考虑(后果和风险)。
        #3) 权力越大，责任越大。
    ```

    因此，数据库权限管理就是非常重要的话题，这里就不多展开了。总之，权限管理不到位，后果很严重，想了解的看[删库新闻](https://www.pingwest.com/a/206242)，还有一则漫画[^drop-table]。
    
    ![exploits-of-a-mom](https://imgs.xkcd.com/comics/exploits_of_a_mom.png)



[^drop-table]: <https://stackoverflow.com/questions/332365/how-does-the-sql-injection-from-the-bobby-tables-xkcd-comic-work>

# SQL 与 R 数据操作 {#sql-in-r}

R 语言本身就是擅长数据分析的，各个数据操作都很完备，下面以统计数据库里表的行数为例做简要介绍[^count-trick]

```sql
SELECT COUNT(*) AS rows_count FROM mtcars;
```

```
+------------+
| rows_count |
+------------+
|         32 |
+------------+
1 row in set (0.000 sec)
```

等价的 dplyr 操作 [^dplyr-count]

```r
dplyr::count(tibble::as_tibble(mtcars))
```
```
#> # A tibble: 1 x 1
#>       n
#> * <int>
#> 1    32
```

等价的 data.table 操作 [^data-table-count]

```r
dim(mtcars)[1]
# 或者
library(data.table)
mt <- as.data.table(mtcars)
mt[, .N]
```
```
[1] 32
```

[^data-table-count]: 作为数据分析师，数据操作方面，除了 SQL，我司的主力工具就是 data.table，[深受领导和大家的喜爱](https://mp.weixin.qq.com/s/LwpNbYwbSed2hvPQa0IwVw)，它的底层全部用 C 语言写，C 代码占比 **65.5%** 覆盖测试达到 **99.9%**，支持 3.1.0 至今的所有 R 软件版本，没有任何第三方软件和 R 包的硬性依赖，也不会有用户可见的 breaking changes ，核心开发者**49**人，自 2006年4月15日发布至今已经过去 **5000** 天，久经考验，核心开发者中包含多位华人，汉化程度在所有 R 包中 **最高**，没有之一。积累了大量数据操作的案例，多语言支持吸引了很多的用户和开发者，而 dplyr 将很多实验性的功能暴露给用户，然后不断 breaking changes，让用户很痛苦 --- [别在生产环境中用净土](https://shrektan.com/post/2019/11/14/use-no-tdv-in-production/)！

[^dplyr-count]: 几乎每次看到 dplyr 包，心里都有些不爽，因为我发现之前能用的函数在这里要么不能用了，要么已经变成 Deprecated 了。更加恼火的是 `dplyr::count` 已经不支持 data.frame 类型的数据对象了，现在必须调用 `tibble::as_tibble` 转化为它认可的类型。在此之前，是可以用 `tibble::as.tibble` 函数来做的，现在被替换为 `tibble::as_tibble`，否则不久的将来就要面临代码运行报错的风险。所以 dplyr 以后就尽量不介绍了，除非 Hadley Wickham 真的如他所说 dplyr 发布 1.0.0 版本之后，将不再做大量的 breaking changes.

    > After this release, dplyr will be a 1.0.0, which means that you should expect very few breaking changes in the future. We’ll continue to add new functions and arguments but will be much more conservative about modifying or removing features. [^dplyr-homepage]
    >
    > --- Hadley Wickham

[^dplyr-homepage]: <https://www.tidyverse.org/blog/2020/03/dplyr-1-0-0-is-coming-soon/>

[^count-trick]: 偶然间搜到一篇[帖子](https://dba.stackexchange.com/questions/151769/mysql-difference-between-using-count-and-information-schema-tables-for-coun)在讨论为什么用 information\_schema 统计的行数不对了，原因是在大规模数据集下，两种计算方式不一致，前者是精确计算，后者是近似计算。作为补充，特意看了下在这个迷你的 mtcars 数据集上是否也是近似计算行数？实际是和 count 计算结果一致，看来 information\_schema 近似计算的准确度也比较高，内部近似计算的公式以后有空分享。希望从理论上了解不同体量的数据集上的近似效果！

    ```sql
    SELECT table_rows "rows_count"
    FROM information_schema.tables
    WHERE TABLE_NAME="mtcars"
      AND table_schema="demo";
    ```
    ```
    +------------+
    | rows_count |
    +------------+
    |         32 |
    +------------+
    1 row in set (0.000 sec)
    ```


# MySQL 入门命令 {#naive-commands}

1. 查看系统中有哪些数据库

    ```sql
    SHOW databases;
    ```
    ```
    +--------------------+
    | Database           |
    +--------------------+
    | demo               |
    | information_schema |
    | mysql              |
    | performance_schema |
    +--------------------+
    4 rows in set (0.000 sec)
    ```

    除了 demo 库，information\_schema,  mysql,  performance\_schema 是数据库管理系统 MySQL 默认的三个数据库
    
    - **mysql** 存储 MySQL server 所需的系统信息
    - **information\_schema** 提供数据库元数据的连接
    - **performance\_schema**  监控 MySQL Server 的底层执行情况


2. 数据库里有哪些表，比如本文创建的 demo 数据库

    ```sql
    SHOW FULL TABLES FROM demo;
    ```
    ```
    +----------------+------------+
    | Tables_in_demo | Table_type |
    +----------------+------------+
    | mtcars         | BASE TABLE |
    +----------------+------------+
    1 row in set (0.000 sec)
    ```

1. 查看数据库 demo 里有哪些函数


    ```sql
    SHOW FUNCTION status WHERE db = 'demo';
    ```

1. 查看数据库里包含些什么表，以及类型

    ```sql
    SELECT TABLE_NAME, table_type
    FROM information_schema.tables
    WHERE table_schema = 'demo'
    ORDER BY TABLE_NAME;
    ```
    ```
    +------------+------------+
    | table_name | table_type |
    +------------+------------+
    | mtcars     | BASE TABLE |
    +------------+------------+
    1 row in set (0.001 sec)
    ```

# MySQL 和 markdown 表格 {#mysql-markdown}

有时候需要将存储的 MySQL 表的各个字段的含义说清楚，以便交流协作。将查询结果转化为 markdown 表格就是一个有用的技巧

```sql
SELECT *
FROM information_schema.tables
WHERE table_schema = 'demo'
  AND TABLE_NAME = 'mtcars';
```
```
+---------------+--------------+------------+------------+--------+---------+------------+------------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+-------------------+----------+----------------+---------------+------------------+-----------+
| TABLE_CATALOG | TABLE_SCHEMA | TABLE_NAME | TABLE_TYPE | ENGINE | VERSION | ROW_FORMAT | TABLE_ROWS | AVG_ROW_LENGTH | DATA_LENGTH | MAX_DATA_LENGTH | INDEX_LENGTH | DATA_FREE | AUTO_INCREMENT | CREATE_TIME         | UPDATE_TIME         | CHECK_TIME | TABLE_COLLATION   | CHECKSUM | CREATE_OPTIONS | TABLE_COMMENT | MAX_INDEX_LENGTH | TEMPORARY |
+---------------+--------------+------------+------------+--------+---------+------------+------------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+-------------------+----------+----------------+---------------+------------------+-----------+
| def           | demo         | mtcars     | BASE TABLE | InnoDB |      10 | Dynamic    |         32 |            512 |       16384 |               0 |            0 |         0 |           NULL | 2020-03-14 08:48:44 | 2020-03-14 08:48:44 | NULL       | latin1_swedish_ci |     NULL |                |               |                0 | N         |
+---------------+--------------+------------+------------+--------+---------+------------+------------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+-------------------+----------+----------------+---------------+------------------+-----------+
1 row in set (0.001 sec)
```

将表 mtcars 的列名和存储类型抽取出来转化成 markdown 表格，后期我们还可以自己填一个字段，用来解释说明每个字段的含义 [^table-desc]

```r
library(DBI)
# 用 root 账户登录连接数据库 demo
con <- DBI::dbConnect(RMySQL::MySQL(), dbname = 'demo', host = "localhost", port = 3306, user = "root", password = "xxx")
# 返回查询结果
table_desc <- dbGetQuery(con, "SHOW columns FROM mtcars")
# 转化为 md 表格
knitr::kable(table_desc[, c('Field', 'Type')], format = 'markdown', row.names = F)
# 将结果直接贴在 md 文档里，见下表
```

|Field     |Type   |
|:---------|:------|
|row_names |text   |
|mpg       |double |
|cyl       |double |
|disp      |double |
|hp        |double |
|drat      |double |
|wt        |double |
|qsec      |double |
|vs        |double |
|am        |double |
|gear      |double |
|carb      |double |


[^table-desc]: 你可能会觉得 mtcars 数据集不就在 R 环境中吗，还啰里八嗦地用 SQL 查询的方式获取表的列名。实际上生产环境中， MySQL 里存储的库表是非常大的，不适合都拉到 R 环境中，即使 R 环境能放下，流程上也不对，会直接导致数据操作的性能低下。我们要考虑数据操作的性能，流程上的优化、让数据库和分析软件做各自擅长的事！


# 本篇彩蛋 {#bonus}

在容器中如何连接使用数据库是类似的，集成到 R Markdown 文档中的使用介绍见 [Databases in R Markdown](https://xiangyunhuang.github.io/db-in-rmd/db-in-rmd.html)[^db-in-rmd]


[^db-in-rmd]: 这篇文章完全是在 Docker 容器内编译 Rmd 源文档生成的，虽然基于 Debian GNU/Linux 10 和 PostgreSQL 但是丝毫不与本文相悖，反而可以互为补充。

# 写作环境

```r
sessionInfo()
```
```
#> R version 3.6.1 (2019-07-05)
#> Platform: x86_64-redhat-linux-gnu (64-bit)
#> Running under: Fedora 29 (Twenty Nine)
#>
#> Matrix products: default
#> BLAS/LAPACK: /usr/lib64/R/lib/libRblas.so
#>
#> locale:
#>  [1] LC_CTYPE=zh_CN.UTF-8       LC_NUMERIC=C
#>  [3] LC_TIME=zh_CN.UTF-8        LC_COLLATE=zh_CN.UTF-8
#>  [5] LC_MONETARY=zh_CN.UTF-8    LC_MESSAGES=zh_CN.UTF-8
#>  [7] LC_PAPER=zh_CN.UTF-8       LC_NAME=C
#>  [9] LC_ADDRESS=C               LC_TELEPHONE=C
#> [11] LC_MEASUREMENT=zh_CN.UTF-8 LC_IDENTIFICATION=C
#>
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base
#>
#> other attached packages:
#> [1] DBI_1.1.0
#>
#> loaded via a namespace (and not attached):
#>  [1] compiler_3.6.1  magrittr_1.5    tools_3.6.1     htmltools_0.4.0
#>  [5] yaml_2.2.1      Rcpp_1.0.3      stringi_1.4.6   rmarkdown_2.1
#>  [9] highr_0.8       RMySQL_0.10.19  knitr_1.28      stringr_1.4.0
#> [13] xfun_0.12       digest_0.6.25   rlang_0.4.5     evaluate_0.14
```

<sup>Created on 2020-03-14 by the [reprex package](https://reprex.tidyverse.org) (v0.3.0)</sup>

# 参考文献

1. SQL 代码格式化网站 <https://sqlformat.org/>
1. 赖明星 MySQL 笔记 <http://mingxinglai.com/cn/>
1. 无名氏的读书笔记 --- 编写可读代码的艺术 <http://beiyuu.com/readable-code>
1. 在线通过网络安装迷你版 CentOS 8  <https://linuxhint.com/install_centos8_netboot_iso/>
