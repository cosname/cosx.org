---
title: 比率估计为什么精确
date: '2009-06-01T09:33:27+00:00'
author: 左辰
categories:
  - 抽样调查
  - 推荐文章
  - 经典理论
  - 统计推断
tags:
  - 估计
  - 抽样
  - 方差
  - 模拟
  - 比率
  - 辅助变量
slug: why-ratio-estimation-is-more-accurate-in-sampling
forum_id: 418789
---

# 一、比率的方差估计式

比率估计量是抽样技术理论里一大重要估计量，其定义为两个总体总量或总体均值之比。借助适当的辅助变量，比率估计也可以得到主要变量的参数估计

由于通过辅助变量实质上引入了更多的信息，因此有理由**猜测**比率估计量可能更加精确。但是比率估计的方差和简单估计相比所谓的改进是否确切的存在，即使存在，改进的程度又有多大呢？
<!--more-->

记总体大小为`$N$`，抽样大小为`$n$`,抽样比例为`$f=\frac{n}{N}$`,辅助变量的总体值为`$ X_1,X_2,…,X_N$`,样本值为`$x_1,x_2,…,x_n$`：主要变量的总体值为`$Y_1,Y_2,…,Y_N$`,样本值为`$y_1,y_2,…,y_n$`。教材上常见的一个估计式是：

`$$ Var(\hat R) \approx \frac{1-f}{\overline{X} n (N-1)}\sum(Y_i – R X_i)^2$$`

据此，可以给出主要变量相应参数的估计方差。以总体总值为例：

`$$Var(\hat{Y}) =Var(\hat{R}N \overline{X}) \approx \frac{1-f}{n}\frac{1}{N-1} \sum (Y_i-RX_i)^2 $$`

注意到上式使用了`$\approx$`而不是“＝”；也就是说是一个近似值。更确切地说，上式估计的只是一个方差下界，因为上式右端实质上是`$ Var(\frac{\overline{y}}{\overline{X}}) $`;而`$\hat{R}=\frac{\overline{y}}{\overline{x}}$`。可以看到，比率估计`$\hat{R}$`方差包括分子、分母两部分波动因素，而估计式中忽略了分母部分的波动，因此得到的方差估计是偏小的。

要使等号严格成立的条件是：

`$$\overline{x} = \overline{X},a.s.$$`

在有限总体的情况下，表示辅助变量恒为定值。注意：此时辅助变量已经没有意义了，因为它不能带来更多的信息，比率估计量与简单估计量的精度是完全相同的。

实际应用的时候，为了使方差估计式成立，我们也必须保证：

`$$\overline{x} \approx \overline{X}$$`

即样本均值`$\overline{x}$`总在`$\overline{X}$`附近波动，且波动范围很小。在这种情况下，辅助变量的意义也很小.

这就是矛盾的所在：**比率估计量的方差估计严格成立的场合，也是比率估计量失去应用价值的时候。**

# 二、一个模拟的例子

在样本均值`$\overline{x}$`波动比较大的时候，比率估计的方差究竟有多大的改进呢？对于这个问题，可以用统计模拟来实现。

我的例子如下：数据来源是人民大学版的《抽样技术》例题4.3，估计33个乡的粮食总产量，抽样得到10个乡粮食产量Y，耕地面积X，村的数量M。Y= (22, 22.8, 30.2, 21.7, 24.3, 31.2, 26, 20.5, 33.8, 23.6)，X= (800, 780, 1000, 700, 880, 1100, 850, 800, 1200, 830)，M＝ (15, 18, 26, 14, 20, 28, 21, 19, 31, 17)。

我们可以比较三种方法估计的理论方差：简单估计，以耕地面积作辅助变量的比率估计，以村数量作辅助变量的比率估计。因为总体数据未知，我首先以有放回的抽样模拟一个样本量为33的数据；然后枚举所有可能抽样组合，计算三种估计量。另一方面，对于每种抽样结果，我也采用方差估计式求方差估计值。最后可以将不同方差进行比较。考虑到计算量的问题，仅模拟了样本量为5的情形.

考虑到数据量大，在生成全组合时，采用了字典排序的算法，(可参见[http://www.blogjava.net/stme/archive/2007/10/23/94361.html](http://www.blogjava.net/stme/archive/2007/10/23/94361.html))

```r
#放回抽样，生成总体数据
INDEX = sample(1:10, 33, rep = T)
M = c(15, 18, 26, 14, 20, 28, 21, 19, 31, 17)[INDEX]
Y = c(22, 22.8, 30.2, 21.7, 24.3, 31.2, 26, 20.5,
    33.8, 23.6)[INDEX]
X = c(800, 780, 1000, 700, 880, 1100, 850, 800, 1200,
    830)[INDEX]
#总体总值计算
M0 = sum(M)
X0 = sum(X)
y.simple <- y.m <- y.x <- var.m <- var.x <- NULL

index = c(rep(1, 5), rep(0, 28))

y.simple = c(y.simple, 33 * sum(Y_M * index)/5)
R.m = sum(Y * index)/sum(M * index)
R.x = sum(Y * index)/sum(X * index)
y.m = c(y.m, M0 * R.m)
y.x = c(y.x, X0 * R.x)
var.m = c(var.m, sum((Y[index == 1] - R.m * M[index ==
    1])^2))
var.x = c(var.x, sum((Y[index == 1] - R.x * X[index ==
    1])^2))

i = 1
j = 0
while (prod(index[29:33]) != 1) {
    while (i < 33) {
        if (index[i] == 1 & index[i + 1] == 0) {
            index[i] = 0
            index[i + 1] = 1
            k = sum(index[1:(i - 1)])
            if (k > 0) {
                index[1:k] = 1
                index[(k + 1):i] = 0
            }
            y.simple = c(y.simple, 33 * sum(Y * index)/5)
            R.m = sum(Y * index)/sum(M * index)
            R.x = sum(Y * index)/sum(X * index)
            y.m = c(y.m, M0 * R.m)
            y.x = c(y.x, X0 * R.x)
            var.m = c(var.m, sum((Y[index == 1] - R.m * M[index ==
                1])^2))
            var.x = c(var.x, sum((Y[index == 1] - R.x * X[index ==
                1])^2))
            i = 1
            j = j + 1
            print(j)
        }
        else {
            i = i + 1
        }
    }
}
var.m = var.m/4 * (1/5 - 1/33) * 33 * 33
var.x = var.x/4 * (1/5 - 1/33) * 33 * 33  # simple sampling
> mean(y.simple)
[1] 844.8968
> var(y.simple)
[1] 2678.197
 #ratio with respect to M
> mean(y.m)
[1] 847.828
> var(y.m)
[1] 1156.886
> mean(var.m)
[1] 1111.191
 #ratio with respect to X
> mean(y.x)
[1] 844.9335
> var(y.x)
[1] 221.964
> mean(var.x)
[1] 220.7296
```
模拟的均值估计结果为：三种方法均值估计为：844.90, 847.83, 844.93;方差为2678.20, 1156.89, 221.96;方差估计的期望为2678.20, 1111.19, 220.73。

这个结果有些出人意料：虽然采用方差估计式得到了低估的结果，但是低估的程度很低，甚至可以忽略不计。也就是说，即使在样本均值波动比较大的场合，比率方差估计的偏误并不大。

这就启示我们对方差估计式的含义重新思考。

# 三、方差估计式的另一种解释

比率估计量的偏误为：

`$$E(\frac{\overline y -R \overline x}{\overline x})^2=E( \frac{\overline y -R \overline x}{\overline X})^2 (\frac{\overline X}{\overline x})^2 $$`

如果假设每次抽样的残差`$\overline y -R \overline x$`都是一个与 `$ \overline x$`独立的随机变量，则有：

`$$E(\frac{\overline y -R \overline x}{\overline x})=E(\frac{\overline y-R \overline x}{\overline X})^2E(\frac{\overline X}{\overline x})^2$$`

由Jensen不等式，得到

`$$E(\frac{\overline X}{\overline x})^2 \geq \frac{\overline X ^2}{E ^2 \overline x }=1$$`

这解释了方差确实存在低估的，而且低估的比例为`$ E(\overline X^2 / \overline x^2)$`。

采用之前模拟的例子计算这个比例，得到利用耕地面积作辅助变量的抽样方差为121356，但是方差的低估比例仅为1.0035。用此比例修正方差估计，结果为221.51,和真实值221.96几乎相同。

由此可见，**即使在辅助变量波动较大，样本两较小，辅助变量抽样均值`$\overline x$`方差较大的情形，方差低估的比例也可能是很低的，所以采用方差估计式依然可以得到较好的结果。**

# 四、题外话

这个问题给我们的启示：统计学归根结底离不开数学，定量的分析才能给予问题严格的解决。

关于定性和定量的话题，让我想到关于正态分布均值的T检验问题，有的统计学教材上刻意强调了这样一句话：当样本量无限增大的时候，检验结果总是趋向于拒绝。果真如此吗？

上述论断的依据是：随着样本两n的增大，样本均值方差`$s^2/n \rightarrow 0$`，所以非拒绝域 `$(\overline x -t_{\alpha/2}s/\sqrt n,\overline x+t_{\alpha/2}s/\sqrt n)$`收缩为一点，因此该拒绝域包括均值`$\mu$`的可能性为零。

事实上，该论断的谬误是显而易见的：虽然样本方差趋向于零，但是拒绝域包括均值的概率是恒定不变的，这是由拒绝域的构造得到的：

`$Pr\{\mu \in (\overline x -t_{\alpha/2}s/\sqrt n,\overline x+t_{\alpha/2}s/ \sqrt n) \} \equiv 1-\alpha$`

即使在大样本情形，虽然均值方差趋近于0，非拒绝域的区间非常短，但是只要样本服从原假设下的正态分布，样本均值偏离真实值的可能性也会很小。大数定律告 诉我们，在大样本的情形，样本均值哪怕偏离一丝一毫的概率都为0。因此，哪怕样本均值只有很小的偏离，拒绝零假设也是没有任何问题的。

这就再次说明定量分析的重要。
