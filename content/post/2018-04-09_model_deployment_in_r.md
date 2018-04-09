---
title: 模型部署的R实现
date: 2018-04-09
author: 周震宇
---

## 引入模型部署
* 什么是模型部署？
    * 从web service的角度简要说明模型部署
    * 用一个例子说明模型部署中线上与线下的含义是什么，为什么要做模型部署。
    * 涉及概念：数据流
* 浅谈get与post方法
* web service in R
    * 介绍几个常用的R web service包：plumber，fiery，opencpu，httpuv


## 模型部署的流程
下面均结合实际案例来分析，主要介绍plumbeR

首先介绍使用数据，

### 输入与输出
这部分介绍:
* 如何将输入参数传递至处理程序(handler)中，以及得到返回值（response）。
* 什么是router，filters，endpoint，传入数据后的处理机制
* 输入与输出的调节

### 负荷测试

* 内存占用情况、文件系统的情况
* api的状态管理、实时监控
