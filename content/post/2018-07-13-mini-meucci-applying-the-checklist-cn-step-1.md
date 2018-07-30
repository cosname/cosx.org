title: "mini-Meucci：应用指南 - 第 1 步"

author: "何国星"

date: '2018-07-13'

output: 
  pdf_document: 
    latex_engine: xelatex
    
meta_extra: 原著：Peter Chan

forum_id: null

slug: mini-meucci-applying-the-checklist-cn-step-1

tags:
- 高级风险
- 投资组合管理
- 指南
- 不变性
- Meucci
- Python
categories: 推荐文章
---

> 本文翻译自 [mini-Meucci: Applying The Checklist - Step 1](http://www.returnandrisk.com/2016/06/mini-meucci-applying-checklist-step-1.html)，作者Peter Chan。本文已获得原作者授权。
> ——译者注

> “千里之行始于足下“
> ——中国古代学者老子（公元前604年-公元前531年）

## 介绍
在这个mini-Meucci系列的文章中，我们将通过构建Python中的低波动率组合，将指南中的10个步骤付诸实践。

这里举一个简单的例子，读者可以在这个例子的基础上去探索更多内容。

之前的指南可以在[ssnr.com](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=1753788)上找到。

此外，你可以参加[2016年8月15日到20日在纽约举行的Attilio Meucci的ARPM训练营](https://www.arpm.co/bootcamp/)进行进一步的了解。如果你要参加训练营的话，当你注册时，可以提及我们这一系列带你入门的应用指南。

### 基础示例说明
既然这是一个入门示例，所以为了简便起见，我们将通过仅使用股票构建低波动率投资组合（我可能稍后会加入债券ETF来强调部分内容），并且在道琼斯工业平均指数组成股的范围内讨论。

在这个示例中，我们将使用从雅虎下载的每日数据，并假设投资期限为1个月（21个交易日）。

我还在[GitHub](https://github.com/returnandrisk/meucci-python)上上传了实现的Python代码，读者可以直接前往下载。

### Python 设置
我通过安装Anaconda3-4.0.0 64位发行版在Windows 10 上运行Python 3.4环境。另外，我还计划使用开源Zipline包在动态分配步骤中进行回溯测试。

## 指南摘要

> 此系列指南是一个分十步整体介绍高级风险和投资组合管理，应用在 : **i)所有资产类别**；**ii)资产管理、银行和保险**；iii)**投资组合和企业方面。**

高级风险与投资管理的10+1步分别是：

  - 寻求不变性
  - 估计
  - 规划
  - 定价
  - 估价
  - 聚合
  - 评估
  - 动因分析
  - 实践
  - 执行
  - 动态分配
  - 事后绩效分析

>目标是在当前时间和未来投资期限内，管理风险并优化投资组合的绩效。
>为了执行我们的任务，我们可以访问数据，随着时间的推移直至现在为止。

## 步骤1.探索不变性
第一步的基本思想是：将历史价格数据的时间序列，转换为一些具有 IID（独立和相同分布）或不变性的良好属性的变量。实际上，我们永远无法确定它们是否是IID - 我想这就是为什么它被称为一个探索的原因。
这一步有2个部分，事实证明，对于股票我们可以很容易地获得良好的**第一近似值**。

### 步骤1a.确定风险驱动因素
按照幻灯片第五页，获取每日股票价格的日志以获得其风险驱动因素。

### 步骤1b.定义不变量
幻灯片第六页：取连续风险驱动值之间的差值=更改或增量=log 收益值=连续复合每日收益值=定值(近似).

### Python代码示例

```python
%matplotlib inline
from pandas_datareader import data
import numpy as np
import datetime
import matplotlib.pyplot as plt
import seaborn

# Get Yahoo data on 30 DJIA stocks and a few ETFs
tickers = ['MMM','AXP','AAPL','BA','CAT','CVX','CSCO','KO','DD','XOM','GE','GS',
           'HD','INTC','IBM','JNJ','JPM','MCD','MRK','MSFT','NKE','PFE','PG',
           'TRV','UNH','UTX','VZ','V','WMT','DIS','SPY','DIA','TLT','SHY']
start = datetime.datetime(2005, 12, 31)
end = datetime.datetime(2016, 5, 30)
rawdata = data.DataReader(tickers, 'yahoo', start, end) 
prices = rawdata.to_frame().unstack(level=1)['Adj Close']
risk_drivers = np.log(prices)
invariants = risk_drivers.diff().drop(risk_drivers.index[0])

# Plots
plt.figure()
prices['AAPL'].plot(figsize=(10, 8), title='AAPL Daily Stock Price (Value)')
plt.show()
plt.figure()
risk_drivers['AAPL'].plot(figsize=(10, 8), 
    title='AAPL Daily Log of Stock Price (Log Value = Risk Driver)')
plt.show()
plt.figure()
invariants['AAPL'].plot(figsize=(10, 8), 
    title='AAPL Continuously Compounded Daily Returns (Log Return = Invariant)')
plt.show()
```
![](/Users/apple/Desktop/1.png)

![](/Users/apple/Desktop/2.png)

![](/Users/apple/Desktop/3.png)

## 测试不变性
Attilio还提供不变性的可视化测试，糟糕的是他的所有代码都是用[Matlab](https://www.mathworks.com/matlabcentral/profile/authors/409528-attilio-meucci)写的。
好消息是，他的所有代码都将用Python写，并且可供训练营的参加者使用。同时，你可以等我将它转化为Python代码（希望不是很差）。

### 测试模拟数据
下面的图表显示了使用模拟数据进行不变性测试，模拟数据的构造是IID，前两个图表是对同分布的测试——数据简单地分为两半，如果它们是同分布的，则两个直方图应该看起来很相似。
底部图表是测试数据的独立性或无关性，如果数据是独立的，那么位置-分散度椭圆应该是圆形的（而不是椭圆形或者雪茄形）。

```python
# Test for invariance using simulated data
import rnr_meucci_functions as rnr
np.random.seed(3)
Data = np.random.randn(1000)
rnr.IIDAnalysis(Data)
```

![](/Users/apple/Desktop/4.png)

### 对真实数据的测试
我们以AAPL为例进行测试。

```python
# Test for invariance using real data
rnr.IIDAnalysis(invariants.ix[:,'AAPL'])
```

![](/Users/apple/Desktop/5.png)

这看起来还不错（大致上是不变性成立），所以我们可以检查指南中的第一个框。顺便说一下，你应该对所有的代码进行这个测试，我将把它作为联系留给感兴趣的读者。

下一篇文章将介绍第二步:估计

另外，如果你注册训练营，请让ARPM优秀的工作人员知道您在 <returnandrisk.com> 上了解到了这一点！
