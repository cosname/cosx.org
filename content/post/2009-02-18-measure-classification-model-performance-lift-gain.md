---
title: '分类模型的性能评估——以SAS Logistic回归为例(3): Lift和Gain'
date: '2009-02-18T17:38:59+00:00'
author: 胡江堂
categories:
  - 数据挖掘与机器学习
  - 统计图形
tags:
  - Confusion Matrix
  - Gain
  - Kolmogorov-Smirnov
  - Lift
  - Logistic回归
  - Lorentz Curve
  - SAS
  - Sensitiveity
  - Specificity
  - 分类模型
  - 数据挖掘
  - 混淆矩阵
slug: measure-classification-model-performance-lift-gain
forum_id: 418770
---

书接[前文](/2008/12/measure-classification-model-performance-roc-auc/)。跟ROC类似，Lift（提升）和Gain（增益）也一样能简单地从[以前的Confusion Matrix](/2008/12/measure-classification-model-performance-confusion-matrix/)以及Sensitivity、Specificity等信息中推导而来，也有跟一个baseline model的比较，然后也是很容易画出来，很容易解释。以下先修知识，包括所需的数据集：<!--more-->

1. [分类模型的性能评估——以SAS Logistic回归为例(1): 混淆矩阵](/2008/12/measure-classification-model-performance-confusion-matrix/)
1. [分类模型的性能评估——以SAS Logistic回归为例(2): ROC和AUC](/2008/12/measure-classification-model-performance-roc-auc/)

# 一些准备

说，混淆矩阵(Confusion Matrix)是我们永远值得信赖的朋友：

|      |     | 预测                   |                  |                     |
|:----:|:---:|:----------------------:|:----------------:|:-------------------:|
|      |     |1                       |0                 |                     |
|实    |1    |d, True Positive        |c, False Negative |c+d, Actual Positive |
|际    |0    |b, False Positive       |a, True Negative  |a+b, Actual Negative |
|      |     |b+d, Predicted Positive |a+c, Predicted Negative |               |

几个术语需要随时记起：

1. **Sensitivity**（覆盖率，True Positive Rate）=正确预测到的正例数/实际正例总数
     Recall (True Positive Rate，or Sensitivity) =true positive/total actual positive=d/c+d
1. PV+ (命中率，Precision, **Positive Predicted Value**) =正确预测到的正例数/预测正例总数
     Precision (Positive Predicted Value, PV+) =true positive/ total predicted positive=d/b+d
1. **Specificity** (负例的覆盖率，True Negative Rate) =正确预测到的负例个数/实际负例总数
    Specificity (True Negative Rate) =true negative/total actual negative=a/a+b

首先记我们valid数据中，正例的比例为pi1（念做pai 1），在我们的例子中，它等于c+d/a+b+c+d=0.365。单独提出pi1，是因为有时考虑oversampling后的一些小调整，比如正例的比例只有0.001，但我们把它调整为0.365（此时要在SAS proc logistic回归的score语句加一个priorevent=0.001选项）。本文不涉及oversampling。现在定义些新变量：

> Ptp=proportion of true positives=d/a+b+c+d=(c+d/a+b+c+d)\*(d/c+d) =pi1\* Sensitivity，正确预测到的正例个数占总观测值的比例
>
> Pfp=proportion of false positives=b/a+b+c+d= (a+b/a+b+c+d)\*(b/a+b) = (1-c+d/a+b+c+d)\*(1-a/a+b) = (1-pi1)\*(1- Specificity) ，把负例错误地预测成正例的个数占总数的比例
>
> **Depth**=proportion allocated to class 1=b+d/a+b+c+d=Ptp+Pfp，预测成正例的比例
>
> **PV_plus**=Precision (Positive Predicted Value, PV+) = d/b+d=Ptp/depth，正确预测到的正例数占预测正例总数的比例
>
> **Lift**= (d/b+d)/(c+d/a+b+c+d)=PV_plus/pi1，提升值，解释见下节。

以上都可以利用valid_roc数据计算出来：

```sas
%let pi1=0.365;

data valid_lift;

set valid_roc;

cutoff=PROB;

Ptp=&pi1*SENSIT;

Pfp=(1-&pi1)*1MSPEC;

 depth=Ptp+Pfp;

 PV_plus=Ptp/depth;

 lift=PV_plus/&pi1;

keep cutoff SENSIT 1MSPEC depth PV_plus lift;

run;
```
先前我们说ROC curve是不同阈值下Sensitivity和1-Specificity的轨迹，类似，

> Lift chart是不同阈值下Lift和Depth的轨迹
>
> Gains chart是不同阈值下PV+和Depth的轨迹

# Lift

**Lift** = (d/b+d)/(c+d/a+b+c+d)=PV_plus/pi1)，这个指标需要多说两句。它衡量的是，与不利用模型相比，模型的预测能力“变好”了多少。不利用模型，我们只能利用“正例的比例是c+d/a+b+c+d”这个样本信息来估计正例的比例（baseline model），而利用模型之后，我们不需要从整个样本中来挑选正例，只需要从我们预测为正例的那个样本的子集（b+d）中挑选正例，这时预测的准确率为d/b+d。

显然，lift(提升指数)越大，模型的运行效果越好。如果这个模型的预测能力跟baseline model一样，那么d/b+d就等于c+d/a+b+c+d（lift等于1），这个模型就没有任何“提升”了（套一句金融市场的话，它的业绩没有跑过市场）。这个概念在数据库营销中非常有用，举个[例子](http://johnthu.spaces.live.com/blog/cns!2053CD511E6D5B1E!308.entry)：

比如说你要向选定的1000人邮寄调查问卷（a+b+c+d=1000）。以往的经验告诉你大概20%的人会把填好的问卷寄回给你，即1000人中有200人会对你的问卷作出回应（response，c+d=200），用统计学的术语，我们说baseline response rate是20%（c+d/a+b+c+d=20%）。

如果你现在就漫天邮寄问卷，1000份你期望能收回200份，这可能达不到一次问卷调查所要求的回收率，比如说工作手册规定邮寄问卷回收率要在25%以上。

通过以前的问卷调查，你收集了关于问卷采访对象的相关资料，比如说年龄、教育程度之类。利用这些数据，你确定了哪类被访问者对问卷反应积极。假设你已经利用这些过去的数据建立了模型，这个模型把这1000人分了类，现在你可以从你的千人名单中挑选出反应最积极的100人来（b+d=100），这10%的人的反应率 (response rate)为60%（d/b+d=60%，d=60）。那么，对这100人的群体（我们称之为Top 10%），通过运用我们的模型，相对的提升(lift value)就为60%/20%=3；换句话说，与不运用模型而随机选择相比，运用模型而挑选，效果提升了3倍。

上面说lift chart是不同阈值下Lift和Depth的轨迹，先画出来：

```sas
symbol i=join v=none c=black;

proc gplot data=valid_lift;

 plot lift*depth;

run; quit;
```

![lift](https://uploads.cosx.org/2009/02/lift.png)

上图的纵坐标是lift，意义已经很清楚。横坐标depth需要多提一句。以前说过，随着阈值的减小，更多的客户就会被归为正例，也就是depth（预测成正例的比例）变大。当阈值设得够大，只有一小部分观测值会归为正例，但这一小部分（一小撮）一定是最具有正例特征的观测值集合（用上面数据库营销的例子来说，这一部分人群对邮寄问卷反应最为活跃），所以在这个depth下，对应的lift值最大。

同样，当阈值设定得足够的小，那么几乎所有的观测值都会被归为正例（depth几乎为1）——这时分类的效果就跟baseline model差不多了，相对应的lift值就接近于1。

一个好的分类模型，就是要偏离baseline model足够远。在lift图中，表现就是，在depth为1之前，lift一直保持较高的（大于1的）数值，也即曲线足够的陡峭。

>注：在一些应用中（比如[信用评分](http://johnthu.spaces.live.com/blog/cns!2053CD511E6D5B1E!308.entry)），会根据分类模型的结果，把样本分成10个数目相同的子集，每一个子集称为一个decile，其中第一个decile拥有最多的正例特征，第二个decile次之，依次类推，以上lift和depth组合就可以改写成lift和decile的组合，也称作lift图，含义一样。刚才提到，“随着阈值的减小，更多的客户就会被归为正例，也就是depth（预测成正例的比例）变大。当阈值设得够大，只有一小部分观测值会归为正例，但这一小部分（第一个decile）一定是最具有正例特征的观测值集合。”

# Gains

Gains (增益) 与 Lift （提升）相当类似：Lift chart是不同阈值下Lift和Depth的轨迹，Gains chart是不同阈值下PV+和Depth的轨迹，而PV+=lift*pi1= d/b+d（见上），所以它们显而易见的区别就在于纵轴刻度的不同：

```sas
symbol i=join v=none c=black;

proc gplot data=valid_lift;

 plot pv_plus*depth;

run; quit;
```

![gains](https://uploads.cosx.org/2009/02/gains.png)

上图阈值的变化，含义与lift图一样。随着阈值的减小，更多的客户就会被归为正例，也就是depth（预测成正例的比例，b+d/a+b+c+d）变大（b+d变大），这样PV+（d/b+d，正确预测到的正例数占预测正例总数的比例）就相应减小。当阈值设定得足够的小，那么几乎所有的观测值都会被归为正例（depth几乎为1），那么PV+就等于数据中正例的比例pi1了（这里是0.365。在Lift那一节里，我们说此时分类的效果就跟baseline model差不多，相对应的lift值就接近于1，而PV+=lift*pi1。Lift的baseline model是纵轴上恒等于1的水平线，而Gains的baseline model是纵轴上恒等于pi1的水平线）。显然，跟lift 图类似，一个好的分类模型，在阈值变大时，相应的PV+就要变大，曲线足够陡峭。

>注：我们一般看到的Gains Chart，图形是往上走的，咋一看跟上文相反，其实道理一致，只是坐标选择有差别，不提。

# 总结和下期预告：K-S

以上提到的ROC、Lift、Gains，都是基于混淆矩阵及其派生出来的几个指标（Sensitivity和Specificity等等）。如果愿意，你随意组合几个指标，展示到二维空间，就是一种跟ROC平行的评估图。比如，你plot Sensitivity*Depth一把，就出一个新图了，——很不幸，这个图叫做Lorentz Curve（劳伦兹曲线），不过你还可以尝试一下别的组合，然后凑一个合理的解释。

Gains chart是不同阈值下PV+和Depth的轨迹（Lift与之类似），而ROC是sensitivity和1-Specificity的对应，前面还提到，Sensitivity（覆盖率，True Positive Rate）在欺诈监控方面更有用（所以ROC更适合出现在这个场合），而PV+在数据库营销里面更有用（这里多用Gains/Lift）。

混淆矩阵告一段落。接下来将是K-S(Kolmogorov-Smirnov)。参考资料同[上一篇](/2008/12/measure-classification-model-performance-roc-auc/)。
