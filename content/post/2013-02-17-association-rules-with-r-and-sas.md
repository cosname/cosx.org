---
title: 关联规则：R与SAS的比较
date: '2013-02-17T20:10:19+00:00'
author: 高燕
categories:
  - 统计软件
  - 软件应用
tags:
  - R语言
  - SAS
  - 关联分析
slug: association-rules-with-r-and-sas
forum_id: 418909
---

啤酒和尿布的故事是关联分析方法最经典的案例，而用于关联分析的Apriori算法更是十大数据挖掘算法之一（<http://www.cs.uvm.edu/~icdm/algorithms/index.shtml>，这个排名虽然是几年前的调查结果，但是其重要性仍可见一斑）。本文以《[R and Data Mining](http://www.rdatamining.com/docs)》书中使用的泰坦尼克号人员的生存数据为例，介绍如何使用R和SAS的Apriori算法进行关联分析，比较两者的建模结果并对结果中存在的差异进行解释分析。

**一、关联分析**

网上有很多资料介绍关联分析算法，本文就不再赘述。我自己看的是《Introduction to Data Mining》(有对应的中文版，人民邮电出版社的《[数据挖掘导论](http://book.douban.com/subject/1786120/)》)，愿意看英文的同学可以访问：[http://www-users.cs.umn.edu/~kumar/dmbook/ch6.](http://www-users.cs.umn.edu/~kumar/dmbook/ch6.pdf)[pdf](http://www-users.cs.umn.edu/~kumar/dmbook/ch6.pdf)。网上其他的资料我也大致翻过，对比之后感觉这本书是一本相当不错的教材，算法方面介绍地比较全面且有一定深度。我本人不建议大家去看那些非专业人士总结的关联分析算法介绍，虽然浅显易懂，但是内容片面，容易误导初学者，错把树木当成了森林。

对于关联分析在行业应用中的经验分享、初学者的误区和最佳实践方面的资料很少，唯一能找到的一本好书是清华大学出版社的《[啤酒与尿布](http://book.douban.com/subject/3283973/)》，主要介绍购物篮分析在零售行业的应用。我始终认为分析师除了算法和软件，还需要了解行业背景，不然挖出的只是模式，而不是切实可行并且能带来商业价值的模式，甚至还有可能是错误的模式。 <!--more-->

**二、软件**

我只用过R和SAS，其他的软件没碰过，所以只能对这两个软件进行比较。

<table cellspacing="1" cellpadding="5">
  <tr>
    <td>
      <strong>算法</strong>
    </td>
    
    <td>
      <strong>R/ARULES</strong>
    </td>
    
    <td>
      <strong>SAS/EM</strong>
    </td>
  </tr>
  
  <tr>
    <td>
      Apriori
    </td>
    
    <td>
      Yes
    </td>
    
    <td>
      Yes
    </td>
  </tr>
  
  <tr>
    <td>
      ECLAT
    </td>
    
    <td>
      Yes
    </td>
    
    <td>
      No
    </td>
  </tr>
  
  <tr>
    <td>
      FP-Growth
    </td>
    
    <td>
      No
    </td>
    
    <td>
      No
    </td>
  </tr>
</table>

据网友说Excel也能做关联分析，但是因为其对数据进行了抽样，所以每次运行的结果都不一样。SPSS的Modeler不知道怎么样，有用过的同学请分享一下经验，最好使用泰坦尼克号的数据进行分析，这样可以比较一下各软件的结果是否相同。

**三、R的代码和结果**

R的代码主要来自《[R and Data Mining](http://www.rdatamining.com/docs)》，我只加了下载数据的代码和对代码的中文说明。

1）下载泰坦尼克数据

setInternet2(TRUE)
  
con <- url(“<http://www.rdatamining.com/data/titanic.raw.rdata>“)
  
load(con)
  
close(con) # url() always opens the connection
  
str(titanic.raw)

2）关联分析

library(arules)
  
\# find association rules with default settings
  
rules <- apriori(titanic.raw)
  
inspect(rules)

3）只保留结果中包含生存变量的关联规则

\# rules with rhs containing “Survived” only
  
rules <- apriori(titanic.raw, parameter = list(minlen=2, supp=0.005, conf=0.8), appearance = list(rhs=c(“Survived=No”, “Survived=Yes”), default=“lhs”),control = list(verbose=F))
  
rules.sorted <- sort(rules, by=“lift”)
  
inspect(rules.sorted)

R 总共生成了12条跟人员生存相关的规则：
  
lhs       rhs      support      confidence      lift
  
1 {Class=2nd, Age=Child}                         => {Survived=Yes}
  
0.010904134 1.0000000 3.095640
  
2 {Class=2nd, Sex=Female, Age=Child}  => {Survived=Yes}
  
0.005906406 1.0000000 3.095640
  
3 {Class=1st, Sex=Female}                      => {Survived=Yes}
  
0.064061790 0.9724138 3.010243
  
4 {Class=1st, Sex=Female, Age=Adult}    => {Survived=Yes}
  
0.063607451 0.9722222 3.009650
  
5 {Class=2nd, Sex=Male, Age=Adult}        => {Survived=No}
  
0.069968196 0.9166667 1.354083
  
6 {Class=2nd, Sex=Female}                      => {Survived=Yes}
  
0.042253521 0.8773585 2.715986
  
7 {Class=Crew, Sex=Female}                   => {Survived=Yes}
  
0.009086779 0.8695652 2.691861
  
8 {Class=Crew, Sex=Female, Age=Adult} => {Survived=Yes}
  
0.009086779 0.8695652 2.691861
  
9 {Class=2nd, Sex=Male}                           => {Survived=No}
  
0.069968196 0.8603352 1.270871
  
10 {Class=2nd, Sex=Female, Age=Adult}  => {Survived=Yes}
  
0.036347115 0.8602151 2.662916
  
11 {Class=3rd, Sex=Male, Age=Adult}       => {Survived=No}
  
0.175829169 0.8376623 1.237379
  
12 {Class=3rd, Sex=Male}                          => {Survived=No}
  
0.191731031 0.8274510 1.222295

4）去除冗余的规则

\# find redundant rules
  
subset.matrix <- is.subset(rules.sorted, rules.sorted)
  
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
  
redundant <- colSums(subset.matrix, na.rm=T) >= 1
  
which(redundant)

\# remove redundant rules
  
rules.pruned <- rules.sorted[!redundant]
  
inspect(rules.pruned)

去除冗余的规则后剩下8条规则：
  
lhs       rhs      support      confidence      lift
  
1 {Class=2nd, Age=Child}                   => {Survived=Yes}
  
0.010904134  1.0000000 3.095640
  
<span style="color: #ff0e40">2 {Class=1st, Sex=Female}                => {Survived=Yes}<br /> 0.064061790  0.9724138 3.010243<br /> 3 {Class=2nd, Sex=Female}               => {Survived=Yes}<br /> </span><span style="color: #ff0e40">0.042253521  0.8773585 2.715986<br /> </span>4 {Class=Crew, Sex=Female}            => {Survived=Yes}
  
0.009086779  0.8695652 2.691861
  
5 {Class=2nd, Sex=Male, Age=Adult} => {Survived=No}
  
0.069968196  0.9166667 1.354083
  
6 {Class=2nd, Sex=Male}                   => {Survived=No}
  
0.069968196  0.8603352 1.270871
  
7 {Class=3rd, Sex=Male, Age=Adult}  => {Survived=No}
  
0.175829169  0.8376623 1.237379
  
8 {Class=3rd, Sex=Male}                    => {Survived=No}
  
0.191731031  0.8274510 1.222295

5）结果的解释

对于结果的解释，一定要慎重，千万不要盲目下结论。从下面的四条规则看，好像确实像电影中描述的那样：妇女和儿童优先。

1 {Class=2nd, Age=Child}              => {Survived=Yes} 0.010904134  1.0000000 3.095640
  
2 {Class=1st, Sex=Female}           => {Survived=Yes} 0.064061790  0.9724138 3.010243
  
3 {Class=2nd, Sex=Female}          => {Survived=Yes} 0.042253521  0.8773585 2.715986
  
4 {Class=Crew, Sex=Female}       => {Survived=Yes} 0.009086779  0.8695652 2.691861

如果我们减小最小支持率和置信度的阈值，则能看到更多的真相。

rules <- apriori(titanic.raw, parameter = list(minlen=3, supp=0.002, conf=0.2), appearance = list(rhs=c(“Survived=Yes”), lhs=c(“Class=1st”, “Class=2nd”, “Class=3rd”, “Age=Child”, “Age=Adult”), default=“none”), control = list(verbose=F))
  
rules.sorted <- sort(rules, by=“confidence”)
  
inspect(rules.sorted)

lhs                        rhs           support     confidence lift
  
1 {Class=2nd, Age=Child} => {Survived=Yes} 0.010904134 1.0000000 3.0956399
  
2 {Class=1st, Age=Child} => {Survived=Yes} 0.002726034 1.0000000 3.0956399
  
<span style="color: #ff0b5d">3 {Class=1st, Age=Adult} => {Survived=Yes} 0.089504771 0.6175549 1.9117275<br /> </span>4 {Class=2nd, Age=Adult} => {Survived=Yes} 0.042707860 0.3601533 1.1149048
  
<span style="color: #fe1967">5 {Class=3rd, Age=Child} => {Survived=Yes} 0.012267151 0.3417722 1.0580035<br /> </span>6 {Class=3rd, Age=Adult} => {Survived=Yes} 0.068605179 0.2408293 0.7455209

从规则3和规则5以及之前的规则2和3可以看出泰坦尼克号获得优先权的主要是头等舱、二等舱的妇孺。

据统计，头等舱男乘客的生还率比三等舱中儿童的生还率还稍高一点。美国新泽西州州立大学教授、著名社会学家戴维·波普诺研究后毫不客气地修改了曾使英国人颇感“安慰”的“社会规范”(妇女和儿童优先)：“在泰坦尼克号上实践的社会规范这样表述可能更准确一些：‘头等舱和二等舱的妇女和儿童优先’。”

这些是关于泰坦尼克号生存数据分析的资料：
  
[泰坦尼克号逃生真相：“妇女儿童优先”只是个传说](http://news.163.com/12/0413/03/7UUM5NJV00014AED.html)
  
[历史没有那么温暖](http://www.360doc.com/content/09/0403/11/9807_3007700)

6）可视化

\# visualize rules
  
library(arulesViz)
  
plot(rules)
  
plot(rules, method=“graph”, control=list(type=“items”))
  
plot(rules, method=“paracoord”, control=list(reorder=TRUE))

对于不熟悉R的SAS用户，可以阅读以下资料学习R以及ARULES包：
  
<http://cran.r-project.org/web/packages/arules/vignettes/arules.pdf>
  
[https://science.nature.nps.gov/im/datamgmt/statistics/R/documents/R\_for\_SAS\_SPSS\_users.pdf](https://science.nature.nps.gov/im/datamgmt/statistics/R/documents/R_for_SAS_SPSS_users.pdf)

四、SAS代码和结果

1）下载泰坦尼克数据

**<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">proc</span></span></span>** **<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">iml</span></span></span>**<span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">;<br /> </span></span><span style="font-family: Courier New;color: #ff0000;font-size: small"><span style="font-family: Courier New;color: #ff0000;font-size: small"><span style="font-family: Courier New;color: #ff0000;font-size: small">submit</span></span></span> <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">/R;<br /> </span></span>setInternet2(TRUE)
  
con <- url(<span style="font-family: Courier New;color: #800080;font-size: small"><span style="font-family: Courier New;color: #800080;font-size: small"><span style="font-family: Courier New;color: #800080;font-size: small">[http://www.rdatamining.com/data/titanic.raw.rdata](http://www.rdatamining.com/data/titanic.raw.rdata)</span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">)<br /> </span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">load(con)<br /> </span></span>close(con) # url() always opens the connection
  
endsubmit;

<span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">call</span></span></span> <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">ImportDataSetFromR(</span></span><span style="font-family: Courier New;color: #800080;font-size: small"><span style="font-family: Courier New;color: #800080;font-size: small"><span style="font-family: Courier New;color: #800080;font-size: small">“Work.titanic”</span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">,</span></span> <span style="font-family: Courier New;color: #800080;font-size: small"><span style="font-family: Courier New;color: #800080;font-size: small"><span style="font-family: Courier New;color: #800080;font-size: small">“titanic.raw”</span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">);<br /> </span></span>**<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">run</span></span></span>**<span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">;</span></span>**<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">quit</span></span></span>**<span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">;</span></span>

2）将数据转换成SAS/EM要求的格式

**<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">data</span></span></span>** <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">items2;<br /> </span></span><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">set</span></span></span> <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">titanic;<br /> </span></span><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">length</span></span></span> <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">tid</span></span> **<span style="font-family: Courier New;color: #008080;font-size: small"><span style="font-family: Courier New;color: #008080;font-size: small"><span style="font-family: Courier New;color: #008080;font-size: small">8</span></span></span>**<span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">;<br /> </span></span><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">length</span></span></span> <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">item $</span></span>**<span style="font-family: Courier New;color: #008080;font-size: small"><span style="font-family: Courier New;color: #008080;font-size: small"><span style="font-family: Courier New;color: #008080;font-size: small">8</span></span></span>**<span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">;<br /> </span></span>tid = \_n\_;
  
item = class;
  
<span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">output</span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">;<br /> </span></span>item = sex;
  
<span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">output</span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">;<br /> </span></span>item = age;
  
<span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">output</span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">;<br /> </span></span>item = survived;
  
<span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">output</span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">;<br /> </span></span><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">keep</span></span></span> <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">tid item;<br /> </span></span><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">run</span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">;</span></span>

3）关联分析

**<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">proc</span></span></span>** **<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">dmdb</span></span></span>** <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">data=items2 dmdbcat=dbcat;<br /> </span></span><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">class</span></span></span> <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">tid item;<br /> </span></span>**<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">run</span></span></span>**<span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">;</span></span> **<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">quit</span></span></span>**<span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">;</span></span>

**<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">proc</span></span></span>** **<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">assoc</span></span></span>** <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">data=items2 dmdbcat=dbcat pctsup=</span></span>**<span style="font-family: Courier New;color: #008080;font-size: small"><span style="font-family: Courier New;color: #008080;font-size: small"><span style="font-family: Courier New;color: #008080;font-size: small">0.5</span></span></span>** <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">out=frequentItems;<br /> </span></span><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">id</span></span></span> <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">tid;<br /> </span></span>target item;
  
**<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">run</span></span></span>**<span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">;</span></span>

**<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">proc</span></span></span>** **<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">rulegen</span></span></span>** <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">in=frequentItems dmdbcat=dbcat out=rules minconf=</span></span>**<span style="font-family: Courier New;color: #008080;font-size: small"><span style="font-family: Courier New;color: #008080;font-size: small"><span style="font-family: Courier New;color: #008080;font-size: small">80</span></span></span>**<span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">;<br /> </span></span>**<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">run</span></span></span>** <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">;</span></span>

**<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">proc</span></span></span>** **<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">sort</span></span></span>** <span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">data</span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">=rules;<br /> </span></span><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">by</span></span></span> <span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">descending</span></span></span> <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">conf;<br /> </span></span>**<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">run</span></span></span>** <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">;</span></span>

4） 只保留结果中包含生存变量的关联规则

**<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">data</span></span></span>** <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">surviverules;<br /> </span></span><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">set</span></span></span> <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">rules(</span></span><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">where</span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">=(set_size></span></span>**<span style="font-family: Courier New;color: #008080;font-size: small"><span style="font-family: Courier New;color: #008080;font-size: small"><span style="font-family: Courier New;color: #008080;font-size: small">1</span></span></span>** <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">and (_rhand=</span></span><span style="font-family: Courier New;color: #800080;font-size: small"><span style="font-family: Courier New;color: #800080;font-size: small"><span style="font-family: Courier New;color: #800080;font-size: small">‘Yes’</span></span></span> <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">or _rhand=</span></span><span style="font-family: Courier New;color: #800080;font-size: small"><span style="font-family: Courier New;color: #800080;font-size: small"><span style="font-family: Courier New;color: #800080;font-size: small">‘No’</span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">)));<br /> </span></span><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">run</span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">;</span></span>

**<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">proc</span></span></span>** **<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">print</span></span></span>** <span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">data</span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">=surviverules;<br /> </span></span><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">var</span></span></span> <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">conf support lift rule ;<br /> </span></span>**<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small">run</span></span></span>** <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">;</span></span>

SAS 结果:

<table summary="Procedure Print: Data Set WORK.SURVIVERULES" rules="all" cellspacing="0" cellpadding="5">
  <tr>
    <th scope="col">
      Obs
    </th>
    
    <th scope="col">
      CONF
    </th>
    
    <th scope="col">
      SUPPORT
    </th>
    
    <th scope="col">
      LIFT
    </th>
    
    <th scope="col">
      RULE
    </th>
  </tr>
  
  <tr>
    <th scope="row">
      1
    </th>
    
    <td>
      100.00
    </td>
    
    <td>
      1.09
    </td>
    
    <td>
      3.10
    </td>
    
    <td>
      2nd & Child ==> Yes
    </td>
  </tr>
  
  <tr>
    <th scope="row">
      2
    </th>
    
    <td>
      100.00
    </td>
    
    <td>
      0.59
    </td>
    
    <td>
      3.10
    </td>
    
    <td>
      2nd & Child & Female ==> Yes
    </td>
  </tr>
  
  <tr>
    <th scope="row">
      3
    </th>
    
    <td>
      100.00
    </td>
    
    <td>
      0.50
    </td>
    
    <td>
      3.10
    </td>
    
    <td>
      2nd & Child & Male ==> Yes
    </td>
  </tr>
  
  <tr>
    <th scope="row">
      4
    </th>
    
    <td>
      97.24
    </td>
    
    <td>
      6.41
    </td>
    
    <td>
      3.01
    </td>
    
    <td>
      1st & Female ==> Yes
    </td>
  </tr>
  
  <tr>
    <th scope="row">
      5
    </th>
    
    <td>
      97.22
    </td>
    
    <td>
      6.36
    </td>
    
    <td>
      3.01
    </td>
    
    <td>
      1st & Adult & Female ==> Yes
    </td>
  </tr>
  
  <tr>
    <th scope="row">
      6
    </th>
    
    <td>
      91.67
    </td>
    
    <td>
      7.00
    </td>
    
    <td>
      1.35
    </td>
    
    <td>
      2nd & Adult & Male ==> No
    </td>
  </tr>
  
  <tr>
    <th scope="row">
      7
    </th>
    
    <td>
      87.74
    </td>
    
    <td>
      4.23
    </td>
    
    <td>
      2.72
    </td>
    
    <td>
      2nd & Female ==> Yes
    </td>
  </tr>
  
  <tr>
    <th scope="row">
      8
    </th>
    
    <td>
      86.96
    </td>
    
    <td>
      0.91
    </td>
    
    <td>
      2.69
    </td>
    
    <td>
      Crew & Female ==> Yes
    </td>
  </tr>
  
  <tr>
    <th scope="row">
      9
    </th>
    
    <td>
      86.96
    </td>
    
    <td>
      0.91
    </td>
    
    <td>
      2.69
    </td>
    
    <td>
      Adult & Crew & Female ==> Yes
    </td>
  </tr>
  
  <tr>
    <th scope="row">
      10
    </th>
    
    <td>
      86.03
    </td>
    
    <td>
      7.00
    </td>
    
    <td>
      1.27
    </td>
    
    <td>
      2nd & Male ==> No
    </td>
  </tr>
  
  <tr>
    <th scope="row">
      11
    </th>
    
    <td>
      86.02
    </td>
    
    <td>
      3.63
    </td>
    
    <td>
      2.66
    </td>
    
    <td>
      2nd & Adult & Female ==> Yes
    </td>
  </tr>
  
  <tr>
    <th scope="row">
      12
    </th>
    
    <td>
      83.77
    </td>
    
    <td>
      17.58
    </td>
    
    <td>
      1.24
    </td>
    
    <td>
      3rd & Adult & Male ==> No
    </td>
  </tr>
  
  <tr>
    <th scope="row">
      13
    </th>
    
    <td>
      82.75
    </td>
    
    <td>
      19.17
    </td>
    
    <td>
      1.22
    </td>
    
    <td>
      3rd & Male ==> No
    </td>
  </tr>
</table>

有关SAS/EM关联分析的公开资料很少，产品的在线帮助文档大概从4.3以后的版本就设置了访问权限，只有SAS/EM的用户才能阅读，新版本的功能和界面跟4.3版本有很大差别。这里只能给大家一些4.3的帮助文档，主要是上面代码中用到的几个过程步：<http://support.sas.com/documentation/onlinedoc/miner/em43/dmdb.pdf>
  
<http://support.sas.com/documentation/onlinedoc/miner/em43/assoc.pdf>
  
<http://support.sas.com/documentation/onlinedoc/miner/em43/sequence.pdf>
  
<http://support.sas.com/documentation/onlinedoc/miner/em43/rulegen.pdf>

mbscore(购物篮数据的预测，是EM 6.1/SAS 9.2 时新引入的过程步，支持层次关联<Hierarchical Association>)

五、结果比较

从上面的结果看，R生成了12条规则，而SAS生成了13条规则，对比每条规则后，发现SAS的第3条规则在R中没有。

<table summary="Procedure Print: Data Set WORK.SURVIVERULES" rules="all" cellspacing="0" cellpadding="5">
  <tr>
    <th scope="row">
      3
    </th>
    
    <td>
      100.00
    </td>
    
    <td>
      0.50
    </td>
    
    <td>
      3.10
    </td>
    
    <td>
      2nd & Child & Male ==> Yes
    </td>
  </tr>
</table>

我猜测原因是两个软件对最小支持度的处理不太一样，SAS可能是对最小支持度百分比乘以总记录条数后取整了。此处，泰坦尼克数据总共有2201条记录，最小支持度百分比为 0.5%，两者相乘积为11.005，而 2nd & Child & Male ==> Yes 这条规则总共出现过11次，如果严格按照实数大小比较，不应该出现在最后的结果中，但是如果按照整数部分比较，则结果正确。打算将SAS模型切换到R或者将R模型切换到SAS的同学要注意这个差异，结果有时不完全一样！

<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><strong>data</strong></span></span></span> <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small"><span style="color: #000000">min_support;<br /> </span></span></span></span></span></span><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><strong>set</strong></span></span></span> <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small"><strong>frequentItems;<br /> </strong></span></span>**<span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">if</span></span></span> <span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">count=int(</span></span><span style="font-family: Courier New;color: #008080;font-size: small"><span style="font-family: Courier New;color: #008080;font-size: small"><span style="font-family: Courier New;color: #008080;font-size: small">2201</span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">*</span></span><span style="font-family: Courier New;color: #008080;font-size: small"><span style="font-family: Courier New;color: #008080;font-size: small"><span style="font-family: Courier New;color: #008080;font-size: small">0.005</span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small">);<br /> </span></span>**<span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><strong>run</strong></span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small"><strong><span style="color: #000000">;</span></strong></span></span>

<span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><strong>proc</strong></span></span></span> <span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><strong>print</strong></span></span></span> <span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small"><span style="font-family: Courier New;color: #0000ff;font-size: small">data</span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small"><span style="color: #000000">=min_support;<br /> </span></span></span><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><strong>run</strong></span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;color: #000000;font-size: small">;</span></span><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><span style="font-family: Courier New;color: #000080;font-size: small"><strong>quit</strong></span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small"><span style="color: #000000">;</span></span></span><span style="font-family: Courier New;font-size: small"><span style="font-family: Courier New;font-size: small"> </span></span>

<table summary="Procedure Print: Data Set WORK.MIN_SUPPORT" rules="all" cellspacing="0" cellpadding="5">
  <tr>
    <th scope="col">
      Obs
    </th>
    
    <th scope="col">
      SET_SIZE
    </th>
    
    <th scope="col">
      COUNT
    </th>
    
    <th scope="col">
      ITEM1
    </th>
    
    <th scope="col">
      ITEM2
    </th>
    
    <th scope="col">
      ITEM3
    </th>
    
    <th scope="col">
      ITEM4
    </th>
    
    <th scope="col">
      ITEM5
    </th>
    
    <th scope="col">
      ITEM6
    </th>
  </tr>
  
  <tr>
    <th scope="row">
      1
    </th>
    
    <td>
      3
    </td>
    
    <td>
      11
    </td>
    
    <td>
      2nd
    </td>
    
    <td>
      Child
    </td>
    
    <td>
      Male
    </td>
    
    <td>
       
    </td>
    
    <td>
       
    </td>
    
    <td>
       
    </td>
  </tr>
  
  <tr>
    <th scope="row">
      2
    </th>
    
    <td>
      4
    </td>
    
    <td>
      11
    </td>
    
    <td>
      2nd
    </td>
    
    <td>
      Child
    </td>
    
    <td>
      Male
    </td>
    
    <td>
      Yes
    </td>
    
    <td>
       
    </td>
    
    <td>
       
    </td>
  </tr>
</table>

相比SAS，R关联分析中比较吸引人的功能就是从规则集中去除冗余的规则，这一功能SAS里面好像没有（我没找到）。SAS用户如果想要使用R的这个功能，我找到的唯一办法就是将SAS的关联规则导出成PMML文件，然后再将PMML文件导入R生成对应的Rule对象，但是这个方法因为我的环境有点问题，所以我自己没试。

有兴趣的同学，可以看看下面的资料：
  
1）[如何将PMML文件导入R生成Rule对象](http://r-forge.r-project.org/forum/forum.php?set=custom&forum_id=84&style=nested&max_rows=50&submit=Change+View)？
  
2）[如何在SAS EMM 中使用PMML？](http:///groups/Using-PMML-SAS-Enterprise-Miner-2328634.S.199575798)

附：PMML技术的未来

对于模型的部署和使用，尤其是跨软件、平台的使用场景下或者对于大数据的分析，PMML是一个可行的解决方案，有一些厂商已经在自己的产品中通过PMML这种方式来实现对大数据的分析预测。

Zementis：
  
[Deploying Predictive Analytics with PMML, R evolution R, and ADAPA](http://www.revolutionanalytics.com/news-events/free-webinars/2011/deploying-predictive-analytics/Deploying-Predictive-Analytics-with-PMML.pdf)
  
[<span style="color: #1e5faa">PMML: Accelerating the Time to Value for Predictive Analytics in the Big Data Era</span>](http://www.sybase.com/files/White_Papers/Sybase_AcceleratingTimeToValue_wp.pdf)

IBM：[Database Mining Guide](ftp://ftp.software.ibm.com/software/analytics/spss/documentation/modeler/14.2/en/DatabaseMiningGuide.pdf)
