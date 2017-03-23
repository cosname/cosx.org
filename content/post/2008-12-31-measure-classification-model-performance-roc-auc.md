---
title: '分类模型的性能评估&mdash;&mdash;以SAS Logistic回归为例(2): ROC和AUC'
date: '2008-12-31T13:09:43+00:00'
author: 胡江堂
categories:
  - 数据挖掘与机器学习
  - 生物与医学统计
  - 统计图形
tags:
  - AUC
  - Confusion Matrix
  - Logistic回归
  - Receiver Operating Characteristic Curve
  - ROC
  - SAS
  - Sensitiveity
  - Specificity
  - Wilcoxon-Mann-Whitney
  - 分类模型
  - 命中率
  - 接受者操作特性曲线
  - 数据挖掘
  - 混淆矩阵
  - 覆盖率
slug: measure-classification-model-performance-roc-auc
---

**ROC**

[上回](/2008/12/measure-classification-model-performance-confusion-matrix/)我们提到，ROC曲线就是不同的阈值下，以下两个变量的组合（如果对Sensitivity和Specificity两个术语没有概念，不妨返回，_《_[_分类模型的性能评估——以SAS Logistic回归为例(1): 混淆矩阵_](/2008/12/measure-classification-model-performance-confusion-matrix/)_》_，强烈建议读者对着看）：

> Sensitivity（覆盖率，True Positive Rate）
> 
> 1-Specificity (Specificity, 负例的覆盖率，True Negative Rate)

<!--more-->

二话不说，先把它画出来（以下脚本的主体是标红部分，数据集valid_roc，还是出自上面提到的<a href="/2008/12/measure-classification-model-performance-confusion-matrix/" target="_blank">那篇</a>）：

> axis order=(**** to **1** by **.1**) label=none length=**4**in;
> 
> symbol i=join v=none c=black;
> 
> symbol2 i=join v=none c=black;
> 
> <span style="color: #ff0000;"><strong>proc</strong> <strong>gplot</strong> data = valid_roc;</span>
> 
>  <span style="color: #ff0000;">plot _SENSIT_*_1MSPEC_ _1MSPEC_*_1MSPEC_</span>
> 
> / overlay vaxis=axis haxis=axis;
> 
> **run**; **quit**;

[![roc](https://cos.name/wp-content/uploads/2008/12/roc-thumb.png)](https://cos.name/wp-content/uploads/2008/12/roc.png)

上图那条曲线就是ROC曲线，横轴是1-Specificity，纵轴是Sensitivity。[以前](/2008/12/measure-classification-model-performance-confusion-matrix/)提到过，随着阈值的减小（更多的客户就会被归为正例），Sensitivity和1-Specificity也相应增加（也即Specificity相应减少），所以ROC呈递增态势（_至于__ROC__曲线凹向原点而非凸向原点，不知道有无直观的解释，不提_）。那条45度线是作为参照（baseline model）出现的，就是说，ROC的好坏，乃是跟45度线相比的，怎么讲？

回到以前，我们分析valid数据，知道有36.5%的bad客户（Actual Positive ）和63.5%的good客户(Actual Negative)。这两个概率是根据以往的数据计算出来的，可以叫做“先验概率”( prior probability)。后来，我们用logistic回归模型，再给每个客户算了一个bad的概率，这个概率是用模型加以修正的概率，叫做“后验概率”（Posterior Probability）。

<table border="0" cellspacing="0" cellpadding="2" width="609">
  <tr>
    <td width="48" valign="top">
    </td>
    
    <td width="45" valign="top">
    </td>
    
    <td width="189" valign="top">
      预测
    </td>
    
    <td width="179" valign="top">
    </td>
    
    <td width="146" valign="top">
    </td>
  </tr>
  
  <tr>
    <td width="50" valign="top">
    </td>
    
    <td width="46" valign="top">
    </td>
    
    <td width="189" valign="top">
      1
    </td>
    
    <td width="179" valign="top">
    </td>
    
    <td width="146" valign="top">
    </td>
  </tr>
  
  <tr>
    <td width="50" valign="top">
      实
    </td>
    
    <td width="47" valign="top">
      1
    </td>
    
    <td width="189" valign="top">
      <span style="color: #ff0000;">d</span>, True Positive
    </td>
    
    <td width="179" valign="top">
      c, False Negative
    </td>
    
    <td width="146" valign="top">
      c+d, Actual Positive
    </td>
  </tr>
  
  <tr>
    <td width="50" valign="top">
      际
    </td>
    
    <td width="48" valign="top">
    </td>
    
    <td width="189" valign="top">
      b, False Positive
    </td>
    
    <td width="179" valign="top">
      a, True Negative
    </td>
    
    <td width="146" valign="top">
      a+b, Actual Negative
    </td>
  </tr>
  
  <tr>
    <td width="50" valign="top">
    </td>
    
    <td width="49" valign="top">
    </td>
    
    <td width="189" valign="top">
      b+d, Predicted Positive
    </td>
    
    <td width="179" valign="top">
      a+c, Predicted Negative
    </td>
    
    <td width="147" valign="top">
    </td>
  </tr>
</table>

如果不用模型，我们就根据原始数据的分布来指派，随机地把客户归为某个类别，那么，你得到的True Positive对False Positive之比，应该等于Actual Positive对Actual Negative之比（你做得跟样本分布一样好）——即，d/b=(c+d)/(a+b)，可以有(d/c+d)/(b/a+b)=1，而这正好是Sensitivity/(1-Specificity)。在不使用模型的情况下，Sensitivity和1-Specificity之比恒等于1，这就是45度线的来历。一个模型要有所提升，首先就应该比这个baseline表现要好。ROC曲线就是来评估模型比baseline好坏的一个著名图例。这个可能不够直观，但可以想想线性回归的baseline model：

[![clip_image003](https://cos.name/wp-content/uploads/2008/12/clip-image003-thumb.jpg)](https://cos.name/wp-content/uploads/2008/12/clip-image003.jpg)

如果不用模型，对因变量的最好估计就是样本的均值（上图水平红线）。绿线是回归线（模型），回归线与水平线之间的偏离，称作Explained Variability， 就是由模型解释了的变动，这个变动（在方差分析里，又称作model sum of squares, SSM）越大，模型表现就越好了（决定系数R-square标准）。同样的类比，ROC曲线与45度线偏离越大，模型的效果就越好。最好好到什么程度呢？

在最好的情况下，Sensitivity为1（正确预测到的正例就刚好等于实际的正例总数），同时Specificity为1（正确预测到的负例个数就刚好等于实际的负例数），在上图中，就是左上方的点(0,1)。因此，ROC曲线越往左上方靠拢，Sensitivity和Specificity就越大，模型的预测效果就越好。同样的思路，你还可以解释为什么ROC曲线经过点(0,0)和(1.1)，不提。

**AUC, Area Under the ROC Curve**

ROC曲线是根据与45度线的偏离来判断模型好坏。图示的好处是直观，不足就是不够精确。到底好在哪里，好了多少？这就要涉及另一个术语，AUC(Area Under the ROC Curve，ROC曲线下的面积)，不过也不是新东西，只是ROC的一个派生而已。

回到先前那张ROC曲线图。45度线下的面积是0.5，ROC曲线与它偏离越大，ROC曲线就越向左上方靠拢，它下面的面积(AUC)也就应该越大。我们就可以根据AUC的值与0.5相比，来评估一个分类模型的预测效果。

SAS的Logistic回归能够后直接生成AUC值。跑完上面的模型，你可以在结果报告的Association Statistics找到一个叫c的指标，它就是AUC（本例中，c=AUC=0.803，45度线的c=0.5）。

/*注：以上提到的c不是AUC里面那个’C’。这个c是一个叫[Wilcoxon-Mann-Whitney](http://en.wikipedia.org/wiki/Mann-Whitney_U) 检验的统计量。这个说来话长，不过这个c却等价于ROC曲线下的面积（AUC）。*/

**ROC、AUC：SAS9.2****一步到位******

SAS9.2有个非常好的新功能，叫ODS Statistical Graphics，有兴趣可以[去它主页看看](http://support.sas.com/rnd/base/topics/statgraph/)。在SAS9.2平台提交以下代码，Logistic回归参数估计和ROC曲线、AUC值等结果就能一起出来（有了上面的铺垫，就不惧这个黑箱了）：

> ods graphics on;
> 
> **proc** **logistic** data=train plots(only)=roc;
> 
> model good_bad=checking history duration savings property;
> 
> **run**;
> 
> ods graphics off;

[![ROCCurve](https://cos.name/wp-content/uploads/2008/12/roccurve-thumb.png)](https://cos.name/wp-content/uploads/2008/12/roccurve.png)

这个ROC图貌似还漂亮些，眼神好能看见标出来的AUC是0.8029。 最后提一句，ROC全称是Receiver Operating Characteristic Curve，中文叫“接受者操作特性曲线”，江湖黑话了（有朋友能不能出来解释一下，谁是Receiver，为什么Operating，何谓Characteristic——这个看着好像是Sensitivity和Specificity），不过并不妨碍我们使用ROC作为模型评估的工具。

<a name="_Toc218314980"><strong> </strong></a>**下期预告：****Lift和Gain**

不多说，只提一句，跟ROC类似，Lift（提升）和Gain（增益）也一样能简单地从<a href="/2008/12/measure-classification-model-performance-confusion-matrix/" target="_blank">以前的Confusion Matrix</a>以及Sensitivity、Specificity等信息中推导而来，也有跟一个baseline model的比较，然后也是很容易画出来，很容易解释。

**参考资料******

  1. Mithat Gonen. 2007. _Analyzing Receiver Operating Characteristic Curves with SAS_. Cary, NC: SAS Institute Inc.
  2. Mike Patetta. 2008. _Categorical Data Analysis Using Logistic Regression Course Notes._ Cary, NC: SAS Institute Inc.
  3. Dan Kelly, etc. 2007. _Predictive Modeling Using Logistic Regression Course Notes_. Cary, NC: SAS Institute Inc.
  4. _Receiver operating characteristic_, **see** [http://en.wikipedia.org/wiki/Receiver\_operating\_characteristic](http://en.wikipedia.org/wiki/Receiver_operating_characteristic)
  5. _The magnificent ROC_, **see** <http://www.anaesthetist.com/mnm/stats/roc/Findex.htm>

<div class="wlWriterSmartContent" style="padding-right: 0px; display: inline; padding-left: 0px; float: none; padding-bottom: 0px; margin: 0px; padding-top: 0px">
  del.icio.us Tags: <a rel="tag" href="http://del.icio.us/popular/Wilcoxon-Mann-Whitney">Wilcoxon-Mann-Whitney</a>,<a rel="tag" href="http://del.icio.us/popular/Confusion%20Matrix">Confusion Matrix</a>,<a rel="tag" href="http://del.icio.us/popular/%e8%a6%86%e7%9b%96%e7%8e%87">覆盖率</a>,<a rel="tag" href="http://del.icio.us/popular/Logistic%e5%9b%9e%e5%bd%92">Logistic回归</a>,<a rel="tag" href="http://del.icio.us/popular/SAS">SAS</a>,<a rel="tag" href="http://del.icio.us/popular/Sensitiveity">Sensitiveity</a>,<a rel="tag" href="http://del.icio.us/popular/Specificity">Specificity</a>,<a rel="tag" href="http://del.icio.us/popular/%e5%88%86%e7%b1%bb%e6%a8%a1%e5%9e%8b">分类模型</a>,<a rel="tag" href="http://del.icio.us/popular/%e5%91%bd%e4%b8%ad%e7%8e%87">命中率</a>,<a rel="tag" href="http://del.icio.us/popular/%e6%95%b0%e6%8d%ae%e6%8c%96%e6%8e%98">数据挖掘</a>,<a rel="tag" href="http://del.icio.us/popular/%e6%b7%b7%e6%b7%86%e7%9f%a9%e9%98%b5">混淆矩阵</a>,<a rel="tag" href="http://del.icio.us/popular/ROC">ROC</a>,<a rel="tag" href="http://del.icio.us/popular/AUC">AUC</a>,<a rel="tag" href="http://del.icio.us/popular/Receiver%20Operating%20Characteristic%20Curve">Receiver Operating Characteristic Curve</a>,<a rel="tag" href="http://del.icio.us/popular/%e6%8e%a5%e5%8f%97%e8%80%85%e6%93%8d%e4%bd%9c%e7%89%b9%e6%80%a7%e6%9b%b2%e7%ba%bf">接受者操作特性曲线</a>
</div>
