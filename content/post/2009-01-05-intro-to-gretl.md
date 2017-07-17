---
title: 开源的计量经济学软件gretl
date: '2009-01-05T21:43:31+00:00'
author: 陈堰平
categories:
  - 时间序列
  - 统计软件
  - 计量经济学
tags:
  - gretl
  - 计量经济学软件
slug: intro-to-gretl
forum_id: 418765
---

gretl（**G**nu **R**egression，**E**conometrics and **T**ime-series **L**ibrary）是一款跨平台的计量分析软件。它是开源软件，用C语言写成，由 Allin Cottrell和Riccardo “Jack” Lucchettii 共同开发。<!--more-->


# 主要特性

* 简单友好的界面
* 多种估计方法：最小二乘、极大似然、GMM
* 时间序列方法：ARMA，GARCH，VAR和VECM，单位根和协整检验
* 模型结果以LaTeX文件的形式输出，包括表格和方程
* 通过鼠标菜单操作，或通过脚本语言的命令操作
* 为蒙特卡洛模拟和迭代估计过程提供循环的命令语句
* 可以和R连接进行进一步的数据分析
* 安装插件包（X-12-ARIMA 和TRAMO/SEATS）可以实现ARIMA模型里的季节调整
* 提供有多部经典计量经济学教材的数据和程序，包括Wooldridge、 Gujarati 等

# 数据类型

* gretl自身的文件格式是XML，但它还可输入Excel、Gnumeric、Stata、EViews、RATS、GNU Octave、PcGive、JMulTi和ASCII文件，也可以输出到GNU Octave、GNU R、JMulTi和PcGive文件格式。

# 界面截图


![gretl界面截图](https://uploads.cosx.org/2009/01/gretl_screenshot.jpg)
<p style="text-align: center;">gretl界面截图</p>

# 相关链接

* [gretl主页](http://gretl.sourceforge.net/)
* Lee Adkins的[Using gretl for Principles of Econometrics, 3rd edition](http://www.learneconometrics.com/gretl.html)
* 杨亦农的[gretl使用指南](http://yaya.it.cycu.edu.tw/gretl/)
* [wiki for gretl](http://en.wikipedia.org/wiki/Gretl)
