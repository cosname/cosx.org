---
title: 股市稳赚不亏？标普 500的 40 年的投资回报
date: '2016-07-03T22:09:31+00:00'
author: 覃 文锋
categories:
  - 统计图形
  - 软件应用
  - 金融统计
tags:
  - 可视化
  - 投资
  - 股票
slug: investing-returns-on-s-and-p-500
---

_本文翻译自 GitHub 项目 [`zonination/investing`](https://github.com/zonination/investing) 的描述文件 `README.md`。译者对原文顺序有所改动。_

_原文以 MIT 协议发布，已征得作者  Zoni Nation 许可进行翻译。译文版权归统计之都所有，转载请注明出处。_

很多人是从 Reddit 上的 “个人理财”（/r/personalfinance）板块的贴子和评论里认识我的。我最近也经常逛“美丽数据”（/r/dataisbeautiful）板块。（译者注：Reddit 是一个在美国受众广泛的娱乐、社交及新闻网站。它与论坛类似，注册用户可以在网站上发布文字和链接。）

前段时间，我开始了我的第一个数据可视化项目。我先从 Robert Shiller 的[标普 500 数据项目](https://github.com/datasets/s-and-p-500)中下载了标普 500 的一些数据，开始了疯狂的数据可视化之旅。

最近，我终于把手头上的其他几个项目处理好，安定下来，于是我又回到这些数据上，同时决定用它完成一个完整的可视化项目。

这里引用美联储主席 Alan Greenspan 对 股神 Warren Buffet 说过的一段话：

Warren，你让我太震惊了！你只要不去理会股票市场的短期甚至长期的衰退，咬紧牙关，什么也不做，不卖出任何一支股票，你就总能获得好的股票收益。也就是，你只要把你所有的钱都投到股票里，然后回家看也不看它们一眼，之后你获得的收益比每天尝试进行股票交易的情况还要高。

“个人理财”板块上经常有人在讨论长期持仓（buy and hold）策略的资金安全问题，是选择长期持仓，还是选时操作捕捉市场（time the market）。在这个可视化项目中，我尝试做下面三件事情：

  * 客观地回顾标普 500 相关股票的各个切面的长期投资收益（过去和现在）。
  * 验证和量化 “Invest Early and Invest Often” “早投资，勤投资” 这一格言。
  * 观察使用长期持仓策略会带来什么，以及这个策略的收益。

**长期持仓收益**

![长期持仓收益](https://cdn.rawgit.com/zonination/investing/47d3dbc90f9b5df488bb3cdfadf697327085f899/returns.png)

<!--more-->

**长期持仓收益与平均收益**

![长期持仓收益与平均收益](https://cdn.rawgit.com/zonination/investing/47d3dbc90f9b5df488bb3cdfadf697327085f899/returns-average.png)

上图由标普 500 的历史收益数据生成。在第一年，我们把标普 500 的每一支股票一年内的收益，加上股息减掉通货膨胀，把计算得到的数值作为第一年的相对收益，并以点的形状绘制到图形中。然后，我们使用同样的方法处理第二年，第三年的数据，依次类推。具体代码见于文末，过程挺无聊的。这个程序可能会花很长一段时间来运行。

简单的说，在上图里，如果你选择投资了 X 年，你将会得到一个基于历史数据的 Y 的收益分布。

我知道了，你一定迫不及待地想问我：“等等！Zoni，这个历史长达 145 年，没有人能够活这么长时间来进行投资啊！！”

我考虑到了，因此让我们来分析一个更为实际的问题，如果你在 20 岁的时候进行投资，在 60 岁的时候退休，也就是投资 40 年的时间，结果会是怎么样的呢？下图就是对应的结果。

![40 年投资](https://cdn.rawgit.com/zonination/investing/47d3dbc90f9b5df488bb3cdfadf697327085f899/returns-40yr.png)

等一下！ 让我们放大来看一下那些亏损的年份。

提醒一下，这些结果是收益的分布。经过 1 年的投资，股票可能涨了也可能跌了。经过 20 年投资，你几乎可以保证不会亏本。经过 40 年的投资，你会获得很大的收益。

那每一个投资时长对应亏损的概率是多少呢？代码在[这里](https://github.com/zonination/investing/blob/master/snippets/snip1.R)，运行代码可以生成下图。

![每一个投资时长对应亏损的概率](https://cdn.rawgit.com/zonination/investing/47d3dbc90f9b5df488bb3cdfadf697327085f899/snippets/short-probability.png)

这些结果已经考虑了美国历史上历次最严重的股票崩盘，如大萧条、上世纪 70 年代的衰退、黑色星期一、互联网泡沫、2008 年金融危机等。同时，我们注意到，股票市场都能够在这些危机的一段时间后得到完全的恢复。

下面是一个基于历史数据，使用不同时长的长期持仓策略仍然会亏损的年份。注意到，一些年份覆盖了某个特定的时期。

  * 长期持仓 **10** 年 (11.8%)：
  
    1908 1909 1910 1911 1912 1929 1930 1936 1937 1964 1965 1966 1967 1968 1969 1970 1971 1972 1973 1998 1999 2000 2001
  * 长期持仓 **15** 年 (4.73%)：
  
    1905 1906 1907 1929 1964 1965 1966 1967 1968 1969
  * 长期持仓 **20** 年 (0.0664%)：
  
    1901
  * 长期持仓 **25** 年 (0%)：
  
    无

这些分析没有考虑到，一些年份的收益可能刚好到达平均水平，而一些年份收益可能会偏高。

让我们重新绘制之前一个图形， 把 Y 轴的范围设置为 0% 到 100%，可以得到下图。

![每一个投资时长对应亏损的概率0-100%](https://cdn.rawgit.com/zonination/investing/47d3dbc90f9b5df488bb3cdfadf697327085f899/snippets/short-probability-2.png)

用一句话总结之前的结果，那就是：长期持仓，长期投资，而不是短期，不要选时操作捕捉市场，同时，即使你在市场高位开始投资，在长期里你仍然能够获得不错的收益。

## [](#%E5%A3%B0%E6%98%8E){#user-content-声明.anchor}声明

注意到，本项目模拟的股票投资组合是 100% 的美国股票。虽然很多结果显示 100% 的美国股票投资可以获得不错的收益，但是这不是一个理想的投资组合。

一个投资组合需要由一组多样化的美国股票，国际股票和债券构成。这样的多样化的投资策略能够对冲市场动荡，同时帮助投资者获得比本项目更为理想的收益。

同时，这个曲线只关注到了一次投资的一次性远期回报的问题。一个典型的投资者，通常不会选择这种方法作为长期的投资策略，而是选择平均成本投资法，分多期投入资本。（这样的策略会让曲线更为平滑。）

如果你对理财感兴趣，不妨继续阅读“深入阅读”章节的几篇文章。

## [](#%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98){#user-content-常见问题.anchor}常见问题

#### [](#%E9%97%AE%E4%B8%BA%E4%BB%80%E4%B9%88%E4%B8%8D%E9%80%89%E6%8B%A9%E5%B9%B3%E5%9D%87%E6%88%90%E6%9C%AC%E6%8A%95%E8%B5%84%E6%B3%95dollar--cost-averaging-%E8%80%8C%E6%98%AF%E9%80%89%E6%8B%A9%E6%80%BB%E9%A2%9D%E6%8A%95%E8%B5%84%E6%B3%95lump--sum-investing){#user-content-问为什么不选择平均成本投资法dollar--cost-averaging-而是选择总额投资法lump--sum-investing.anchor}问：为什么不选择平均成本投资法（Dollar Cost Averaging ），而是选择总额投资法（Lump Sum Investing）？

答：

这个问题有点难回答。我把分析的源代码都公开出来了，它们是开源的，你可以按照你想法来修改代码，进行对应的分析。同时，我还想提几点：

  * 在本研究中，把现金乘数（cash multiplier）作为主要的结果，就是使用无量纲的指标作为研究的结果，因此需要确定一个基期的数值。也许选择使用每年购买一份的标普 500 的股票更适合这个无量纲的问题？
  * 数据中提供了通货膨胀的数据，如果你选择使用美元作为单位，你就需要考虑它。例如，怎么样对比 1992年 1 美元 和 2002 年的 1 美元的价值呢？
  * 平均成本投资法需要考虑折现的问题，你需要准确地调整现有算法来反应目前使用的总额投资法的投资情况。

我的预测是，使用平均成本投资法将会使图形更加“瘦小”，让更多的数值往平均值压缩。这样会使投资更为安全一些，但是得到较慢的收益增长。

#### [](#%E9%97%AE%E8%BF%99%E4%B8%AA%E9%A1%B9%E7%9B%AE%E4%B8%AD%E7%9A%84%E8%B5%84%E4%BA%A7%E7%BB%84%E5%90%88%E4%B8%BA--100-%E8%82%A1%E7%A5%A8%E9%82%A3%E6%8D%A2%E6%88%90%E5%80%BA%E5%88%B8%E5%9B%BD%E9%99%85%E8%82%A1%E7%A5%A8%E6%88%96%E8%80%85%E6%98%AF%E4%B8%89%E8%80%85%E7%9A%84%E7%BB%84%E5%90%88%E4%BC%9A%E6%80%8E%E4%B9%88%E6%A0%B7){#user-content-问这个项目中的资产组合为--100-股票那换成债券国际股票或者是三者的组合会怎么样.anchor}问：这个项目中的资产组合为 100% 股票？那换成债券、国际股票，或者是三者的组合会怎么样？

答：

拥有这些数据是我的梦想。如果有人有类似的国际股票、债券、票据、现金、比特币或者其他类似的数值的数据，请在 Reddit 上私信我。

我希望总有一天我能分析美股、债券、国际股票混合资产的数据。

#### [](#%E9%97%AE%E5%A6%82%E6%9E%9C%E8%82%A1%E7%A5%A8%E5%B8%82%E5%9C%BA%E5%88%9A%E5%A5%BD%E5%9C%A8%E6%88%91%E9%80%80%E4%BC%91%E7%9A%84%E6%97%B6%E5%80%99%E5%B4%A9%E7%9B%98%E4%BA%86%E5%85%A8%E4%B8%96%E7%95%8C%E9%83%BD%E7%A9%B7%E5%BE%97%E5%93%8D%E5%8F%AE%E5%BD%93%E7%BE%8E%E5%85%83%E6%B1%87%E7%8E%87%E4%B8%8B%E8%B7%8C%E6%88%91%E8%AF%A5%E6%80%8E%E4%B9%88%E5%8A%9E){#user-content-问如果股票市场刚好在我退休的时候崩盘了全世界都穷得响叮当美元汇率下跌我该怎么办.anchor}问：如果股票市场刚好在我退休的时候崩盘了，全世界都穷得响叮当，美元汇率下跌，我该怎么办？

答：

好吧，下面是几个小点子：

  1. 你能够假设这个灾难真的发生了，但是你同样可以想象你的假设几乎不可能发生。真正的风险不是基于概率的，而是发生的概率乘以事件的损失程度。
  2. 不，这个灾难不是一定会发生的，快干了这碗鸡汤。
  3. 没人会建议购买 100% 的美国股票作为退休保障，而更多的是选择债券。
  4. “天快塌了”这类口吻是给会赚钱的标题党用的，跟这些人较真真是没意思。

## [](#%E5%85%B6%E4%BB%96%E5%8F%AF%E8%A7%86%E5%8C%96%E7%BB%93%E6%9E%9C){#user-content-其他可视化结果.anchor}其他可视化结果

这个图形是一个动画，它展示了投资时长为某一特定年限，随着投资时长的增长，每一年的收益分布的具体变化情况。

![动图](https://cdn.rawgit.com/zonination/investing/47d3dbc90f9b5df488bb3cdfadf697327085f899/altplots/growth.gif)

让我们逐帧地来看这个图形：

![10](https://cdn.rawgit.com/zonination/investing/47d3dbc90f9b5df488bb3cdfadf697327085f899/altplots/geom_real10.png)

![20](https://cdn.rawgit.com/zonination/investing/47d3dbc90f9b5df488bb3cdfadf697327085f899/altplots/geom_real20.png)

![30](https://cdn.rawgit.com/zonination/investing/47d3dbc90f9b5df488bb3cdfadf697327085f899/altplots/geom_real30.png)

![40](https://cdn.rawgit.com/zonination/investing/47d3dbc90f9b5df488bb3cdfadf697327085f899/altplots/geom_real40.png)

## 数据来源

  * [Robert Shiller 整理和维护的标普 500 数据](https://github.com/datasets/s-and-p-500)

## [](#%E6%B7%B1%E5%85%A5%E9%98%85%E8%AF%BB){#user-content-深入阅读.anchor}深入阅读

  * [本项目的源代码](https://github.com/zonination/investing)
  * [个人理财板块的 Reddit Wiki 页面](https://www.reddit.com/r/personalfinance/wiki/investing)
  * [我有 X 元，我应该怎么样投资它？](https://www.reddit.com/r/personalfinance/wiki/commontopics)
  * [Bogleheads 关于 Three-fund Portfolios 的 Wiki 页面](https://www.bogleheads.org/wiki/Three-fund_portfolio)
  * [cFIREsim – 一个开源的个人理财计算器](http://www.cfiresim.com/)

## [](#%E6%BA%90%E4%BB%A3%E7%A0%81){#user-content-源代码.anchor}源代码

<pre><span class="pl-c"># 注意：我的代码写得很垃圾，你将就着看吧</span>

<span class="pl-c"># 设置工作目录，引入对应 R 包</span>
setwd(<span class="pl-s"><span class="pl-pds">"</span>~/Dropbox/R/Stock Market<span class="pl-pds">"</span></span>)
library(<span class="pl-smi">ggplot2</span>)
library(<span class="pl-smi">scales</span>)
library(<span class="pl-smi">lubridate</span>)
source(<span class="pl-s"><span class="pl-pds">"</span>z_theme.r<span class="pl-pds">"</span></span>)

<span class="pl-c"># 数据源：</span>
<span class="pl-c"># 我强烈建议使用下面的链接来获得最新的数据。</span>
<span class="pl-c"># "https://raw.githubusercontent.com/datasets/s-and-p-500/master/data/data.csv"</span>

<span class="pl-smi">sp500</span><span class="pl-k">&lt;-</span>read.csv(<span class="pl-s"><span class="pl-pds">"</span>stocks.csv<span class="pl-pds">"</span></span>, <span class="pl-v">stringsAsFactors</span><span class="pl-k">=</span><span class="pl-c1">FALSE</span>)

<span class="pl-c"># 如果你使用的数据是自行从数据源下载的，请注释掉下面这一行代码，同时取消注释下方的“主循环”代码。</span>
<span class="pl-smi">stocks</span><span class="pl-k">&lt;-</span>read.csv(<span class="pl-s"><span class="pl-pds">"</span>returns.csv<span class="pl-pds">"</span></span>, <span class="pl-v">stringsAsFactors</span><span class="pl-k">=</span><span class="pl-c1">FALSE</span>)

<span class="pl-c"># 处理日期:</span>
<span class="pl-c"># 格式化日期，让 R 能够识别它们.</span>
<span class="pl-smi">sp500</span><span class="pl-k">$</span><span class="pl-smi">Date</span><span class="pl-k">&lt;-</span>as.Date(<span class="pl-smi">sp500</span><span class="pl-k">$</span><span class="pl-smi">Date</span>,<span class="pl-s"><span class="pl-pds">"</span>%Y-%m-%d<span class="pl-pds">"</span></span>) 

<span class="pl-c"># 标普 500 始于 1923 年， 其他历史数据来自于 Shiller. 如果你只想要“真实”的标普 500 历史数据，请取消下面一行代码的注释。</span>
<span class="pl-c"># sp500&lt;-subset(sp500,sp500$Date &gt;= as.Date("1926-01-01","%Y-%m-%d"))</span>

<span class="pl-c"># 计算实际收益 (所有股息都被重新投资)</span>
<span class="pl-smi">sp500</span><span class="pl-k">$</span><span class="pl-smi">real.return</span> <span class="pl-k">&lt;-</span> <span class="pl-c1">1</span> <span class="pl-c"># 最开始，在股票市场中投资一元</span>
<span class="pl-k">for</span>(<span class="pl-smi">r</span> <span class="pl-k">in</span> <span class="pl-c1">2</span><span class="pl-k">:</span>nrow(<span class="pl-smi">sp500</span>)){
  <span class="pl-smi">sp500</span><span class="pl-k">$</span><span class="pl-smi">real.return</span>[<span class="pl-smi">r</span>]<span class="pl-k">&lt;-</span>
    <span class="pl-c"># 前一期的价格</span>
    <span class="pl-smi">sp500</span><span class="pl-k">$</span><span class="pl-smi">real.return</span>[<span class="pl-smi">r</span><span class="pl-k">-</span><span class="pl-c1">1</span>]<span class="pl-k">*</span>
    <span class="pl-c"># 乘以上一个月价格的百分比</span>
    (((<span class="pl-smi">sp500</span><span class="pl-k">$</span><span class="pl-smi">Real.Price</span>[<span class="pl-smi">r</span>]<span class="pl-k">-</span><span class="pl-smi">sp500</span><span class="pl-k">$</span><span class="pl-smi">Real.Price</span>[<span class="pl-smi">r</span><span class="pl-k">-</span><span class="pl-c1">1</span>])<span class="pl-k">/</span>
        (<span class="pl-smi">sp500</span><span class="pl-k">$</span><span class="pl-smi">Real.Price</span>[<span class="pl-smi">r</span><span class="pl-k">-</span><span class="pl-c1">1</span>]))<span class="pl-k">+</span><span class="pl-c1">1</span>)<span class="pl-k">+</span>
    <span class="pl-c"># 最后加上上一个月的股息，它们被全部重新投资</span>
    (<span class="pl-smi">sp500</span><span class="pl-k">$</span><span class="pl-smi">Real.Dividend</span>[<span class="pl-smi">r</span><span class="pl-k">-</span><span class="pl-c1">1</span>]<span class="pl-k">/</span><span class="pl-smi">sp500</span><span class="pl-k">$</span><span class="pl-smi">Real.Price</span>[<span class="pl-smi">r</span><span class="pl-k">-</span><span class="pl-c1">1</span>])<span class="pl-k">*</span>
    (<span class="pl-smi">sp500</span><span class="pl-k">$</span><span class="pl-smi">real.return</span>[<span class="pl-smi">r</span><span class="pl-k">-</span><span class="pl-c1">1</span>]<span class="pl-k">/</span><span class="pl-c1">12</span>)
}

<span class="pl-c"># 主循环 - 计算收入数据集</span>
<span class="pl-c"># 如果使用的数据是自己从数据源下载的，请取消注释下面的代码</span>
<span class="pl-c"># 警告：下面的代码会运行较长时间。</span>
<span class="pl-c">###############</span>
<span class="pl-c"># stocks&lt;-data.frame(NA,NA,NA,NA)</span>
<span class="pl-c"># names(stocks)&lt;-c("year","real","percent","inv.year")</span>
<span class="pl-c"># for(f in 1:145){</span>
<span class="pl-c">#   sp500$future.f&lt;-NA    #远期标普 500 价格</span>
<span class="pl-c">#   sp500$cpi.f &lt;- NA     #远期 CPI</span>
<span class="pl-c">#   sp500$future.r &lt;- NA  #远期实际收益</span>
<span class="pl-c">#   for(n in (f*12+1):nrow(sp500)){</span>
<span class="pl-c">#     # 计算 f 年的远期价格</span>
<span class="pl-c">#     sp500$future.f[n-f*12] &lt;- sp500$SP500[n]                      # 远期标普 500 价格</span>
<span class="pl-c">#     sp500$cpi.f[n-f*12] &lt;- sp500$Consumer.Price.Index[n]          # 远期 CPI</span>
<span class="pl-c">#     sp500$future.r[n-f*12] &lt;- sp500$real.return[n]                # 远期实际收益</span>
<span class="pl-c">#     stocks&lt;-rbind(stocks,c(f,sp500$future.r[n-f*12],                   # 记录所有数据</span>
<span class="pl-c">#                   (sp500$future.r[n-f*12]-sp500$real.return[n-f*12]) /</span>
<span class="pl-c">#                     sp500$real.return[n-f*12],</span>
<span class="pl-c">#                   year(sp500$Date[n-f*12])</span>
<span class="pl-c">#                   ))</span>
<span class="pl-c">#   }</span>
<span class="pl-c">#   print(paste(f, " of ", 145, " completed: ", round(f/145*100,2),"%",sep=""))</span>

<span class="pl-c"># 使用现金乘数:</span>
<span class="pl-smi">stocks</span><span class="pl-k">$</span><span class="pl-smi">multip</span><span class="pl-k">&lt;-</span><span class="pl-smi">stocks</span><span class="pl-k">$</span><span class="pl-smi">percent</span><span class="pl-k">+</span><span class="pl-c1">1</span>
<span class="pl-c"># write.table(stocks,"returns.csv") # 保存收益数据集</span>

<span class="pl-c"># 绘制图形</span>
ggplot(subset(<span class="pl-smi">stocks</span>,<span class="pl-smi">year</span><span class="pl-k">&lt;</span><span class="pl-k">=</span><span class="pl-c1">40</span><span class="pl-k">&</span><span class="pl-smi">inv.year</span><span class="pl-k">&gt;</span><span class="pl-k">=</span><span class="pl-c1">1957</span>),aes(<span class="pl-v">x</span><span class="pl-k">=</span><span class="pl-smi">year</span>,<span class="pl-v">y</span><span class="pl-k">=</span><span class="pl-smi">multip</span>,<span class="pl-v">group</span><span class="pl-k">=</span><span class="pl-smi">year</span>),<span class="pl-v">na.rm</span><span class="pl-k">=</span><span class="pl-c1">T</span>)<span class="pl-k">+</span>
<span class="pl-c"># geom_boxplot(outlier.shape=NA,coef=0,fatten=0,fill="steelblue",color=NA)+</span>
  geom_jitter(<span class="pl-v">color</span><span class="pl-k">=</span><span class="pl-s"><span class="pl-pds">"</span>limegreen<span class="pl-pds">"</span></span>,<span class="pl-v">alpha</span><span class="pl-k">=</span>.<span class="pl-c1">05</span>,<span class="pl-v">width</span><span class="pl-k">=</span><span class="pl-c1">1</span>)<span class="pl-k">+</span>
  ggtitle(<span class="pl-s"><span class="pl-pds">"</span>Returns After Investing<span class="pl-pds">"</span></span>)<span class="pl-k">+</span>
  stat_summary(<span class="pl-v">fun.y</span><span class="pl-k">=</span><span class="pl-s"><span class="pl-pds">"</span>mean<span class="pl-pds">"</span></span>,<span class="pl-v">colour</span><span class="pl-k">=</span><span class="pl-s"><span class="pl-pds">"</span>black<span class="pl-pds">"</span></span>,<span class="pl-v">fill</span><span class="pl-k">=</span><span class="pl-s"><span class="pl-pds">"</span>limegreen<span class="pl-pds">"</span></span>,<span class="pl-v">geom</span><span class="pl-k">=</span><span class="pl-s"><span class="pl-pds">"</span>point<span class="pl-pds">"</span></span>,<span class="pl-v">shape</span><span class="pl-k">=</span><span class="pl-c1">21</span>)<span class="pl-k">+</span>
  ylab(<span class="pl-s"><span class="pl-pds">"</span>Cash Multiplier (After Inflation and Dividends)<span class="pl-pds">"</span></span>)<span class="pl-k">+</span>
  xlab(<span class="pl-s"><span class="pl-pds">"</span>Years Invested in US Stocks (Buy and Hold)<span class="pl-pds">"</span></span>)<span class="pl-k">+</span>
  scale_y_log10(<span class="pl-v">breaks</span><span class="pl-k">=</span><span class="pl-c1">2</span><span class="pl-k">^</span>c(<span class="pl-k">-</span><span class="pl-c1">3</span><span class="pl-k">:</span><span class="pl-c1">15</span>),
                <span class="pl-c"># 转化为文本，以美化图形输出结果</span>
                <span class="pl-v">labels</span><span class="pl-k">=</span>as.character(<span class="pl-c1">2</span><span class="pl-k">^</span>c(<span class="pl-k">-</span><span class="pl-c1">3</span><span class="pl-k">:</span><span class="pl-c1">15</span>)))<span class="pl-k">+</span>
  scale_x_continuous(<span class="pl-v">breaks</span><span class="pl-k">=</span>seq(<span class="pl-c1"></span>,<span class="pl-c1">200</span>,<span class="pl-c1">5</span>))<span class="pl-k">+</span>
  geom_smooth()<span class="pl-k">+</span>
z_theme()</pre>
