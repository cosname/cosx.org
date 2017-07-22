---
title: 使用R语言构造投资组合的有效前沿
date: '2013-08-20T09:45:15+00:00'
author: 邓一硕
categories:
  - 数据分析
tags:
  - R语言
  - 投资组合
  - 收益率
  - 有效前沿
  - 股票交易
slug: use-r-to-do-portfolio-optimization
forum_id: 418955
---

构造投资组合是金融投资分析中历久弥新的问题。多年以来，学界、业界提出诸多对投资组合进行优化的方法。比如，最经典的基于收益率均值和收益率波动性进行组合优化，由于马克维滋提出用收益率方差表示收益率的波动性，所以，这种方法又称为的 `M-V` 方法，即`Mean-Variance` 方法的缩写；后来，又衍生出基于夏普比率（`Sharp Ratio`）的投资组合优化方法；近年来，随着`VaR` (`Value at Risk`) 和 `CVaR` (`Conditional Vaule at Risk`) 概念的兴起，基于 `VaR` 和 `CVaR` 对投资组合进行优化的思路也开始勃兴；除此之外，对冲基金届还有一种非常有生命力的投资组合优化方法，即桥水公司（`Bridge-Water`）公司提出的风险均摊方法（ `Risk Pairy` ），这种方法的核心思路在于，估计组合中各个资产的风险度及其占组合风险的比率，然后，按照该比例对组合头寸进行分配。

几种方法中，在学界和业界最收关注的还是 `M-V` 方法。而在 `M-V` 方法中最基本的一个知识点，就是构造投资组合的有效前沿。理论这里不再赘述，简单说一下其在 `R` 语言中的实现。构造有效前沿的步骤大致可按照获取数据、将数据加工处理为收益率矩阵、以收益率矩阵为输入计算得到有效前沿这三个步骤来完成。下面分布来说一说。<!--more-->


  
第一步，获取数据。最简单的方法是使用 `quantmod` 中的 `getSymbols` 函数。因为要要做的事是构建资产组合，因此，得同时获取多只股票的交易数据，这里取 QQQ/SPY/YHOO 三只股票为例。需要运行的代码：

```r
# 载入 quatnmod 包
require(quantmod) 
# 下载 QQQ/SPY/YHOO 交易数据
getSymbols(c('QQQ','SPY','YHOO')) 
```

第二步，将交易数据处理为收益率数据。这一步可以用 dailyReturn 函数来完成。

```r
# 计算收益率序列
QQQ_ret=dailyReturn(QQQ)  
SPY_ret=dailyReturn(SPY)
YHOO_ret=dailyReturn(YHOO)
```

第三步，合并收益率序列。

```r
dat=merge(QQQ_ret,SPY_ret,YHOO_ret)
```

第四步，计算投资组合的有效前沿。这一步使用 portfolioFrontier 函数来完成。由于 portfolioFrontier 函数的输入必须是 timeSeries 类，因而，得将数据类型进行转化。

```r
## 转化为 timeSeries 类
require(timeSeries)
dat=as.timeSeries(dat)  
## 载入 fPortfolio
require(fPortfolio)
## 求frontier 
Frontier = portfolioFrontier(dat)
Frontier

Title:
 MV Portfolio Frontier 
 Estimator:         covEstimator 
 Solver:            solveRquadprog 
 Optimize:          minRisk 
 Constraints:       LongOnly 
 Portfolio Points:  5 of 50 

Portfolio Weights:
   daily.returns daily.returns.1 daily.returns.2
1         0.0000          1.0000          0.0000
13        0.2409          0.7541          0.0050
25        0.4853          0.5090          0.0057
37        0.7296          0.2640          0.0065
50        1.0000          0.0000          0.0000

Covariance Risk Budgets:
   daily.returns daily.returns.1 daily.returns.2
1         0.0000          1.0000          0.0000
13        0.2355          0.7596          0.0049
25        0.4877          0.5065          0.0058
37        0.7390          0.2545          0.0065
50        1.0000          0.0000          0.0000

Target Return and Risks:
     mean     mu    Cov  Sigma   CVaR    VaR
1  0.0002 0.0002 0.0151 0.0151 0.0368 0.0233
13 0.0003 0.0003 0.0149 0.0149 0.0361 0.0230
25 0.0003 0.0003 0.0148 0.0148 0.0358 0.0234
37 0.0004 0.0004 0.0149 0.0149 0.0356 0.0241
50 0.0005 0.0005 0.0152 0.0152 0.0357 0.0249

Description:
 Fri Aug 09 11:21:31 2013 by user: Owner 
```

上面结果中 title 部分表明的是本次操作过程中使用的相关方法。Portfolio Weights 部分返回的是三只股票在投资组合中的头寸比例，每一行的和都是 1 。对于第二行，它表示的是在投资组合中将总头寸以 24.09% 、 75.41% 、 0.50% 的比例分散到三只股票标的上。Covariance Risk Budgets 表示的是协方差风险预算矩阵。Target Return and Risks 表示目标组合的预期收益率和风险数据。

调用 plot 函数可以对上述结果进行绘图，调用 plot 之后，R 控制台会返回一组绘图选项卡：

```r
plot(Frontier)

Make a plot selection (or 0 to exit): 

1:   Plot Efficient Frontier
2:   Add Minimum Risk Portfolio
3:   Add Tangency Portfolio
4:   Add Risk/Return of Single Assets
5:   Add Equal Weights Portfolio
6:   Add Two Asset Frontiers [LongOnly Only]
7:   Add Monte Carlo Portfolios
8:   Add Sharpe Ratio [Markowitz PF Only]
```

各选项卡对应的绘图类型依次是：有效前沿、最小风险组合、切线组合、单个资产的风险/收益、等权重投资组合、两资产投资组合的有效前沿（禁止卖空）、模特卡罗模拟得到的投资组合、夏普比率。依次，选择可以看到相应的绘图结果：

```
Selection: 1

Make a plot selection (or 0 to exit): 

1:   Plot Efficient Frontier
2:   Add Minimum Risk Portfolio
3:   Add Tangency Portfolio
4:   Add Risk/Return of Single Assets
5:   Add Equal Weights Portfolio
6:   Add Two Asset Frontiers [LongOnly Only]
7:   Add Monte Carlo Portfolios
8:   Add Sharpe Ratio [Markowitz PF Only]
```

![1](https://cloud.githubusercontent.com/assets/18478302/25556624/64101902-2d32-11e7-8aa7-a86d26a11038.png)

```
Selection: 2

Make a plot selection (or 0 to exit): 

1:   Plot Efficient Frontier
2:   Add Minimum Risk Portfolio
3:   Add Tangency Portfolio
4:   Add Risk/Return of Single Assets
5:   Add Equal Weights Portfolio
6:   Add Two Asset Frontiers [LongOnly Only]
7:   Add Monte Carlo Portfolios
8:   Add Sharpe Ratio [Markowitz PF Only]
```

![2](https://cloud.githubusercontent.com/assets/18478302/25556627/69cd045e-2d32-11e7-8760-702972d70372.png)

```
Selection: 3

Make a plot selection (or 0 to exit): 

1:   Plot Efficient Frontier
2:   Add Minimum Risk Portfolio
3:   Add Tangency Portfolio
4:   Add Risk/Return of Single Assets
5:   Add Equal Weights Portfolio
6:   Add Two Asset Frontiers [LongOnly Only]
7:   Add Monte Carlo Portfolios
8:   Add Sharpe Ratio [Markowitz PF Only]
```

![3](https://cloud.githubusercontent.com/assets/18478302/25556629/6c9a6780-2d32-11e7-9812-6693583e1b58.png)

```
Selection: 4

Make a plot selection (or 0 to exit): 

1:   Plot Efficient Frontier
2:   Add Minimum Risk Portfolio
3:   Add Tangency Portfolio
4:   Add Risk/Return of Single Assets
5:   Add Equal Weights Portfolio
6:   Add Two Asset Frontiers [LongOnly Only]
7:   Add Monte Carlo Portfolios
8:   Add Sharpe Ratio [Markowitz PF Only]
```

![4](https://cloud.githubusercontent.com/assets/18478302/25556630/6e73deec-2d32-11e7-8407-92cba6db4d87.png)

```
Selection: 5

Make a plot selection (or 0 to exit): 

1:   Plot Efficient Frontier
2:   Add Minimum Risk Portfolio
3:   Add Tangency Portfolio
4:   Add Risk/Return of Single Assets
5:   Add Equal Weights Portfolio
6:   Add Two Asset Frontiers [LongOnly Only]
7:   Add Monte Carlo Portfolios
8:   Add Sharpe Ratio [Markowitz PF Only]
```

![5](https://cloud.githubusercontent.com/assets/18478302/25556631/6fb507c2-2d32-11e7-9c46-942186ec3b2d.png)

```
Selection: 6

Make a plot selection (or 0 to exit): 

1:   Plot Efficient Frontier
2:   Add Minimum Risk Portfolio
3:   Add Tangency Portfolio
4:   Add Risk/Return of Single Assets
5:   Add Equal Weights Portfolio
6:   Add Two Asset Frontiers [LongOnly Only]
7:   Add Monte Carlo Portfolios
8:   Add Sharpe Ratio [Markowitz PF Only]
```

![6](https://cloud.githubusercontent.com/assets/18478302/25556632/70f91ff6-2d32-11e7-8250-fa6b5b36825e.png)

```
Selection: 7

Make a plot selection (or 0 to exit): 

1:   Plot Efficient Frontier
2:   Add Minimum Risk Portfolio
3:   Add Tangency Portfolio
4:   Add Risk/Return of Single Assets
5:   Add Equal Weights Portfolio
6:   Add Two Asset Frontiers [LongOnly Only]
7:   Add Monte Carlo Portfolios
8:   Add Sharpe Ratio [Markowitz PF Only]
```

![7](https://cloud.githubusercontent.com/assets/18478302/25556668/e8d4e23a-2d32-11e7-93e6-dc22a6bf9070.png)

```
Selection: 8

Make a plot selection (or 0 to exit): 

1:   Plot Efficient Frontier
2:   Add Minimum Risk Portfolio
3:   Add Tangency Portfolio
4:   Add Risk/Return of Single Assets
5:   Add Equal Weights Portfolio
6:   Add Two Asset Frontiers [LongOnly Only]
7:   Add Monte Carlo Portfolios
8:   Add Sharpe Ratio [Markowitz PF Only]
```

![8](https://cloud.githubusercontent.com/assets/18478302/25556669/ea4455ce-2d32-11e7-93de-0930f5617385.png)

注：本文转载自邓一硕博客，原文请[点击此处](http://yishuo.org/r/2013/08/09/use-r-to-do-portfolio-optimization.html)。转载请注明出处。
