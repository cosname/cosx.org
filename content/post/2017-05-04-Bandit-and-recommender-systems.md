---
title: Bandit算法与推荐系统
author: 陈开江
date: '2017-05-04'
categories:
  - 统计计算
tags: [推荐系统]
slug: Bandit-and-recommender-systems
forum_id: 419209
---

注:本文首发于《程序员》杂志

# 0.导语

推荐系统里面有两个经典问题：EE问题和冷启动问题。前者涉及到平衡准确和多样，后者涉及到产品算法运营等一系列东西。bandit算法是一种简单的在线学习算法，常常用于尝试解决这两个问题，本文为你介绍基础的bandit算法及一系列升级版，以及对推荐系统这两个经典问题的思考。

# 1.什么是bandit算法

## 1.1 为选择而生

我们会遇到很多选择的场景。上哪个大学，学什么专业，去哪家公司，中午吃什么，等等。这些事情，都让选择困难症的我们头很大。那么，有算法能够很好地对付这些问题吗？

当然有！那就是bandit算法！

![MAB问题](https://dn-shimo-image.qbox.me/2bUHX2SBO88rm28U/image.png!thumbnail)

bandit算法来源于历史悠久的赌博学，它要解决的问题是这样的^[https://en.wikipedia.org/wiki/Multi-armed_bandit]：

一个赌徒，要去摇老虎机，走进赌场一看，一排老虎机，外表一模一样，但是每个老虎机吐钱的概率可不一样，他不知道每个老虎机吐钱的概率分布是什么，那么每次该选择哪个老虎机可以做到最大化收益呢？这就是多臂赌博机问题(Multi-armed bandit problem, K-armed bandit problem, MAB)。

怎么解决这个问题呢？最好的办法是去试一试，不是盲目地试，而是有策略地快速试一试，这些策略就是bandit算法。

这个多臂问题，推荐系统里面很多问题都与他类似：

1. 假设一个用户对不同类别的内容感兴趣程度不同，那么我们的推荐系统初次见到这个用户时，怎么快速地知道他对每类内容的感兴趣程度？这就是推荐系统的冷启动。
1. 假设我们有若干广告库存，怎么知道该给每个用户展示哪个广告，从而获得最大的点击收益？是每次都挑效果最好那个么？那么新广告如何才有出头之日？
1. 我们的算法工程师又想出了新的模型，有没有比A/B test更快的方法知道它和旧模型相比谁更靠谱？
1. 如果只是推荐已知的用户感兴趣的物品，如何才能科学地冒险给他推荐一些新鲜的物品？

这些问题本质上全都是关乎如何选择。只要是关于选择，都可以简化成一个多臂赌博机问题，毕竟小赌怡情嘛，人生何处不赌博。

## 1.2 bandit算法与推荐系统

在推荐系统领域里，有两个比较经典的问题常被人提起，一个是EE问题，另一个是用户冷启动问题。

什么是EE问题？又叫exploit－explore问题。exploit就是：对用户比较确定的兴趣，当然要利用开采迎合，好比说已经挣到的钱，当然要花；explore就是：光对着用户已知的兴趣使用，用户很快会腻，所以要不断探索用户新的兴趣才行，这就好比虽然有一点钱可以花了，但是还得继续搬砖挣钱，不然花完了就得喝西北风。

用户冷启动问题，也就是面对新用户时，如何能够通过若干次实验，猜出用户的大致兴趣。

我想，屏幕前的你已经想到了，推荐系统冷启动可以用bandit算法来解决一部分。

这两个问题本质上都是如何选择用户感兴趣的主题进行推荐，比较符合bandit算法背后的MAB问题。

比如，用bandit算法解决冷启动的大致思路如下：

用分类或者Topic来表示每个用户兴趣，也就是MAB问题中的臂（Arm），我们可以通过几次试验，来刻画出新用户心目中对每个topic的感兴趣概率。

这里，如果用户对某个topic感兴趣（提供了显式反馈或隐式反馈），就表示我们得到了收益，如果推给了它不感兴趣的topic，推荐系统就表示很遗憾(regret)了。

如此经历“选择-观察-更新-选择”的循环，理论上是越来越逼近用户真正感兴趣的topic的。

## 1.3 怎么选择bandit算法？

现在来介绍一下bandit算法怎么解决这类问题的。bandit算法需要量化一个核心问题：错误的选择到底有多大的遗憾？能不能遗憾少一些？

王家卫在《一代宗师》里寄出一句台词：

人生要是无憾，那多无趣？

而我说：算法要是无憾，那应该是过拟合了。

所以说：怎么衡量不同bandit算法在解决多臂问题上的效果？首先介绍一个概念，叫做累积遗憾(regret)^[http://nbviewer.jupyter.org/github/CamDavidsonPilon/Probabilistic-Programming-and-Bayesian-Methods-for-Hackers/blob/master/Chapter6_Priorities/Chapter6.ipynb#]：

`\begin{align*}
R_T & = \sum_{i=1}^T(w_{opt}-w_{B(i)}) \\
&= T_{w^*}-\sum_{i=1}^Tw_{B(i)} 
\end{align*}`

这个公式就是计算bandit算法的累积遗憾，解释一下：

首先，这里我们讨论的每个臂的收益非0即1，也就是伯努利收益。

然后，每次选择后，计算和最佳的选择差了多少，然后把差距累加起来就是总的遗憾。

`$w_{B(i)}$`是第i次试验时被选中臂的期望收益，`$w^*$`是所有臂中的最佳那个，如果上帝提前告诉你，我们当然每次试验都选它，问题是上帝不告诉你，所以就有了bandit算法，我们就有了这篇文章。

这个公式可以用来对比不同bandit算法的效果：对同样的多臂问题，用不同的bandit算法试验相同次数，看看谁的regret增长得慢。

那么到底不同的bandit算法有哪些呢？

## 1.4 常用bandit算法

### Thompson sampling算法

thompson  sampling算法简单实用，因为它只有一行代码就可以实现^[https://en.wikipedia.org/wiki/Thompson_sampling ]。简单介绍一下它的原理，要点如下：

1. 假设每个臂是否产生收益，其背后有一个概率分布，产生收益的概率为p。
2. 我们不断地试验，去估计出一个置信度较高的“概率p的概率分布”就能近似解决这个问题了。
3. 怎么能估计“概率p的概率分布”呢？ 答案是假设概率p的概率分布符合beta(wins, lose)分布，它有两个参数: wins, lose。
4. 每个臂都维护一个beta分布的参数。每次试验后，选中一个臂，摇一下，有收益则该臂的wins增加1，否则该臂的lose增加1。
5. 每次选择臂的方式是：用每个臂现有的beta分布产生一个随机数b，选择所有臂产生的随机数中最大的那个臂去摇。

以上就是Thompson采样，用python实现就一行：

```
import  numpy as np
import  pymc
#wins 和 trials 是一个N维向量，N是赌博机的臂的个数，每个元素记录了
choice = np.argmax(pymc.rbeta(1 + wins, 1 + trials - wins)) 
wins[choice] += 1
trials += 1
```

### UCB算法

UCB算法全称是Upper Confidence Bound(置信区间上界)，它的算法步骤如下^[http://hunch.net/~coms-4771/lecture20.pdf ]：

1. 初始化：先对每一个臂都试一遍
2. 按照如下公式计算每个臂的分数，然后选择分数最大的臂作为选择：
   `$$\bar{x}_j(t)+\sqrt{\frac{2\ln{t}}{T_{j,t}}}$$`
3. 观察选择结果，更新t和`$T_{jt}$`。其中加号前面是这个臂到目前的收益均值，后面的叫做bonus，本质上是均值的标准差，t是目前的试验次数，`$T_{jt}$`是这个臂被试次数。

这个公式反映一个特点：均值越大，标准差越小，被选中的概率会越来越大，同时哪些被选次数较少的臂也会得到试验机会。

### Epsilon-Greedy算法

这是一个朴素的bandit算法，有点类似模拟退火的思想：

1. 选一个(0,1)之间较小的数作为epsilon
2. 每次以概率epsilon做一件事：所有臂中随机选一个
3. 每次以概率1-epsilon 选择截止到当前，平均收益最大的那个臂。

是不是简单粗暴？epsilon的值可以控制对Exploit和Explore的偏好程度。越接近0，越保守，只想花钱不想挣钱。

### 朴素bandit算法

最朴素的bandit算法就是：先随机试若干次，计算每个臂的平均收益，一直选均值最大那个臂。这个算法是人类在实际中最常采用的，不可否认，它还是比随机乱猜要好。

以上五个算法，我们用10000次模拟试验的方式对比了其效果如图，实验代码来源^[https://gist.github.com/anonymous/211b599b7bef958e50af ]：

![](https://dn-shimo-image.qbox.me/cSjOYaxmbz4ufGb3/simulation.png!thumbnail)

算法效果对比一目了然：UCB算法和Thompson采样算法显著优秀一些。

至于你实际上要选哪一种bandit算法，你可以选一种bandit算法来选bandit算法。。。

# 2.bandit算法与线性回归

## 2.1 UCB算法

UCB算法在做EE(Exploit-Explore)的时候表现不错，但它是上下文无关(context free)的bandit算法，它只管埋头干活，根本不观察一下面对的都是些什么特点的arm，下次遇到相似特点但不一样的arm也帮不上什么忙。

UCB解决Multi-armed bandit问题的思路是：用置信区间。置信区间可以简单地理解为不确定性的程度，区间越宽，越不确定，反之亦反之。

每个item的回报均值都有个置信区间，随着试验次数增加，置信区间会变窄（逐渐确定了到底回报丰厚还是可怜）。 每次选择前，都根据已经试验的结果重新估计每个item的均值及置信区间。 选择置信区间上限最大的那个item。

“选择置信区间上界最大的那个item”这句话反映了几个意思：

1. 如果item置信区间很宽（被选次数很少，还不确定），那么它会倾向于被多次选择，这个是算法冒风险的部分；
2. 如果item置信区间很窄（备选次数很多，比较确定其好坏了），那么均值大的倾向于被多次选择，这个是算法保守稳妥的部分；
3. UCB是一种乐观的算法，选择置信区间上界排序，如果时悲观保守的做法，是选择置信区间下界排序。

## 2.2 UCB算法加入特征信息

Yahoo!的科学家们在2010年发表了一篇论文^[http://www.research.rutgers.edu/~lihong/pub/Li10Contextual.pdf ]，给UCB引入了特征信息，同时还把改造后的UCB算法用在了Yahoo!的新闻推荐中，算法名叫LinUCB，刘鹏博士在《计算广告》一书中也有介绍LinUCB在计算广告中的应用^[《计算广告：互联网商业变现的市场与技术》p253, 刘鹏，王超著]。

![应用LinUCB算法的Yahoo!首页](https://dn-shimo-image.qbox.me/l8WKUvxeMKw1TRzX/image.png!thumbnail)

单纯的老虎机回报情况就是老虎机自己内部决定的，而在广告推荐领域，一个选择的回报，是由User和Item一起决定的，如果我们能用feature来刻画User和Item这一对CP，在每次选择item之前，通过feature预估每一个arm（item）的期望回报及置信区间，选择的收益就可以通过feature泛化到不同的item上。

为UCB算法插上了特征的翅膀，这就是LinUCB最大的特色。

LinUCB算法做了一个假设：一个Item被选择后推送给一个User，其回报和相关Feature成线性关系，这里的“相关feature”就是context，也是实际项目中发挥空间最大的部分。

于是试验过程就变成：用User和Item的特征预估回报及其置信区间，选择置信区间上界最大的item推荐，观察回报后更新线性关系的参数，以此达到试验学习的目的。
LinUCB基本算法描述如下：

![LinUCB算法描述](https://dn-shimo-image.qbox.me/tMRcWGzSOHEC0O7d/image.png!thumbnail)

对照每一行解释一下(编号从1开始)：

1. 设定一个参数`$\alpha$`，这个参数决定了我们Explore的程度
2. 开始试验迭代
3. 获取每一个arm的特征向量`$x_{a,t}$`
4. 开始计算每一个arm的预估回报及其置信区间
5. 如果arm还从没有被试验过，那么：
6. 用单位矩阵初始化`$A_a$`
7. 用0向量初始化`$b_a$`，
8. 处理完没被试验过的arm
9. 计算线性参数`$\theta$`
10. 用`$\theta$`和特征向量`$x_{a,t}$`计算预估回报, 同时加上置信区间宽度
11. 处理完每一个arm
12. 选择第10步中最大值对应的arm，观察真实的回报`$r_t$`
13. 更新`$A_{at}$`
14. 更新`$b_{at}$`
15. 算法结束

注意到上面的第4步，给特征矩阵加了一个单位矩阵，这就是岭回归（ridge regression），岭回归主要用于当样本数小于特征数时，对回归参数进行修正^[https://en.wikipedia.org/wiki/Tikhonov_regularization ]。
对于加了特征的bandit问题，正符合这个特点：试验次数（样本）少于特征数。

每一次观察真实回报之后，要更新的不止是岭回归参数，还有每个arm的回报向量`$b_a$`。

## 2.3 详解LinUCB的实现

根据论文给出的算法描述，其实很好写出LinUCB的代码^[https://github.com/Fengrui/HybridLinUCB-python/blob/master/policy_hybrid.py ]，麻烦的只是构建特征。
 
代码如下，一些必要的注释说明已经写在代码中。

```
class LinUCB:
    def __init__(self):
        self.alpha = 0.25 
        self.r1 = 1 # if worse -> 0.7, 0.8
        self.r0 = 0 # if worse, -19, -21
        # dimension of user features = d
        self.d = 6
        # Aa : collection of matrix to compute disjoint part for each article a, d*d
        self.Aa = {}
        # AaI : store the inverse of all Aa matrix
        self.AaI = {}
        # ba : collection of vectors to compute disjoin part, d*1
        self.ba = {}
        
        self.a_max = 0
        
        self.theta = {}
        
        self.x = None
        self.xT = None
        # linUCB

    def set_articles(self, art):
        # init collection of matrix/vector Aa, Ba, ba
        for key in art:
            self.Aa[key] = np.identity(self.d)
            self.ba[key] = np.zeros((self.d, 1))
            self.AaI[key] = np.identity(self.d)
            self.theta[key] = np.zeros((self.d, 1))
            
    """
    这里更新参数时没有传入更新哪个arm，因为在上一次recommend的时候缓存了被选的那个arm，所以此处不用传入
    
    另外，update操作不用阻塞recommend，可以异步执行
    """        
    def update(self, reward):
        if reward == -1:
            pass
        elif reward == 1 or reward == 0:
            if reward == 1:
                r = self.r1
            else:
                r = self.r0
            self.Aa[self.a_max] += np.dot(self.x, self.xT)
            self.ba[self.a_max] += r * self.x
            self.AaI[self.a_max] = linalg.solve(self.Aa[self.a_max], np.identity(self.d))
            self.theta[self.a_max] = np.dot(self.AaI[self.a_max], self.ba[self.a_max])
        else:
        # error
            pass
    
    """
    预估每个arm的回报期望及置信区间
    """
    def recommend(self, timestamp, user_features, articles):
        xaT = np.array([user_features])
        xa = np.transpose(xaT)
        art_max = -1
        old_pa = 0
        
        # 获取在update阶段已经更新过的AaI(求逆结果)
        AaI_tmp = np.array([self.AaI[article] for article in articles])
        theta_tmp = np.array([self.theta[article] for article in articles])
        art_max = articles[np.argmax(np.dot(xaT, theta_tmp) + self.alpha * np.sqrt(np.dot(np.dot(xaT, AaI_tmp), xa)))]

        # 缓存选择结果，用于update
        self.x = xa
        self.xT = xaT
        # article index with largest UCB
        self.a_max = art_max
        
        return self.a_max  

```

## 2.4 怎么构建特征

LinUCB算法有一个很重要的步骤，就是给User和Item构建特征，也就是刻画context。在原始论文里，Item是文章，其中专门介绍了它们怎么构建特征的，也甚是精妙。容我慢慢表来。

### 原始用户特征

* 人口统计学：性别特征（2类），年龄特征（离散成10个区间）
* 地域信息：遍布全球的大都市，美国各个州
* 行为类别：代表用户历史行为的1000个类别取值

### 原始文章特征

* URL类别：根据文章来源分成了几十个类别
* 编辑打标签：编辑人工给内容从几十个话题标签中挑选出来的

原始特征向量都要归一化成单位向量。
还要对原始特征降维，以及模型要能刻画一些非线性的关系。
用Logistic Regression去拟合用户对文章的点击历史，其中的线性回归部分为：

`$$\phi_u^\mathrm{T}W\phi_a$$`

拟合得到参数矩阵W，可以将原始用户特征（1000多维）投射到文章的原始特征空间（80多维），投射计算方式：

`$$\psi_u\stackrel{def}{=}\phi_u^\mathrm{T}W$$`

这是第一次降维，把原始1000多维降到80多维。

然后，用投射后的80多维特征对用户聚类，得到5个类簇，文章页同样聚类成5个簇，再加上常数1，用户和文章各自被表示成6维向量。

Yahoo!的科学家们之所以选定为6维，因为数据表明它的效果最好^[http://www.gatsby.ucl.ac.uk/~chuwei/paper/isp781-chu.pdf ]，并且这大大降低了计算复杂度和存储空间。

我们实际上可以考虑三类特征：U（用户），A（广告或文章），C（所在页面的一些信息）。

前面说了，特征构建很有发挥空间，算法工程师们尽情去挥洒汗水吧。

总结一下LinUCB算法，有以下优点：

1. 由于加入了特征，所以收敛比UCB更快（论文有证明）；
2. 特征构建是效果的关键，也是工程上最麻烦和值的发挥的地方；
3. 由于参与计算的是特征，所以可以处理动态的推荐候选池，编辑可以增删文章；
4. 特征降维很有必要，关系到计算效率。

# 3.bandit算法与协同过滤

## 3.1 协同过滤背后的哲学 

推荐系统里面，传统经典的算法肯定离不开协同过滤。协同过滤背后的思想简单深刻，在万物互联的今天，协同过滤的威力更加强大。协同过滤看上去是一种算法，不如说是一种方法论，不是机器在给你推荐，而是“集体智慧”在给你推荐。

它的基本假设就是“物以类聚，人以群分”，你的圈子决定了你能见到的物品。这个假设很靠谱，却隐藏了一些重要的问题：作为用户的我们还可能看到新的东西吗？还可能有惊喜吗？还可能有圈子之间的更迭流动吗？这些问题的背后其实就是在前面提到过的EE问题（Exploit & Explore）。我们关注推荐的准确率，但是我们也应该关注推荐系统的演进发展，因为“推荐系统不止眼前的Exploit，还有远方的Explore”。

做Explore的方法有很多，bandit算法是其中的一种流派。前面也介绍过几种bandit算法，基本上就是估计置信区间的做法，然后按照置信区间的上界来进行推荐，以UCB,LinUCB为代表。

作为要寻找诗和远方的bandit浪漫派算法，能不能和协同过滤这种正统算法结合起来呢？事实上已经有人这么尝试过了，叫做COFIBA算法，具体在题目为Collaborative Filtering Bandits^[http://arxiv.org/abs/1401.8257 ]和Online Clustering of Bandits^[http://arxiv.org/abs/1502.03473 ]）的两篇文章中有详细的描述，它就是bandit和协同过滤的结合算法，两篇文章的区别是后者只对用户聚类（即只考虑了User-based的协同过滤），而前者采用了协同聚类（co-clustering，可以理解为item-based和user-based两种协同方式在同时进行），后者是前者的一个特殊情况。下面详细介绍一下这种结合算法。

## 3.2 bandit结合协同过滤

很多推荐场景中都有这两个规律：

1. 相似的用户对同一个物品的反馈可能是一样的。也就是对一个聚类用户群体推荐同一个item，他们可能都喜欢，也可能都不喜欢，同样地，同一个用户会对相似的物品反馈相同。这是属于协同过滤可以解决的问题；
2. 在使用推荐系统过程中，用户的决策是动态进行的，尤其是新用户。这就导致无法提前为用户准备好推荐候选，只能“走一步看一步”，是一个动态的推荐过程。

每一个推荐候选item，都可以根据用户对其偏好不同（payoff不同）将用户聚类成不同的群体，一个群体来集体预测这个item的可能的收益，这就有了协同的效果，然后再实时观察真实反馈回来更新用户的个人参数，这就有了bandit的思想在里面。

举个例子，如果你父母给你安排了很多相亲对象，要不要见面去相一下？那需要提前看看每一个相亲对象的资料，每次大家都分成好几派，有说好的，有说再看看的，也有说不行的；你自己也会是其中一派的一员，每次都是你所属的那一派给你集体打分，因为他们是和你“三观一致的人”，“诚不欺我”；这样从一堆资料中挑出分数最高的那个人，你出去见TA，回来后把实际感觉说给大家听，同时自己心里的标准也有些调整，重新给剩下的其它对象打分，打完分再去见，周而复始......

以上就是协同过滤和bandit结合的思想。

另外，如果要推荐的候选item较多，还需要对item进行聚类，这样就不用按照每一个item对user聚类，而是按照每一个item的类簇对user聚类，如此以来，item的类簇数相对于item数要大大减少。

## 3.3 COFIBA算法

基于这些思想，有人提出了算法COFIBA（读作coffee bar）^[https://github.com/qw2ky/CoLinUCB_Revised/blob/master/COFIBA.py ]，简要描述如下：

在时刻t，用户来访问推荐系统，推荐系统需要从已有的候选池子中挑一个最佳的物品推荐给他，然后观察他的反馈，用观察到的反馈来更新挑选策略。 这里的每个物品都有一个特征向量，所以这里的bandit算法是context相关的。 这里依然是用岭回归去拟合用户的权重向量，用于预测用户对每个物品的可能反馈（payoff），这一点和linUCB算法是一样的。

对比LinUCB算法，COFIBA算法的不同有两个：

1. 基于用户聚类挑选最佳的item（相似用户集体决策的bandit）
2. 基于用户的反馈情况调整user和item的聚类（协同过滤部分）

整体算法过程如下：

![COFIBA算法描述](https://dn-shimo-image.qbox.me/v3LRSExuxoA9kNQ4/image.png!thumbnail)

核心步骤是，针对某个用户i，在每一轮试验时做以下事情：

1. 首先计算该用户的bandit参数W（和LinUCB相同），但是这个参数并不直接参与到bandit的选择决策中（和LinUCB不同），而是用来更新用户聚类的；
2. 遍历候选item，每一个item表示成一个context向量了。
3. 每一个item都对应一套用户聚类结果，所以遍历到每一个item时判断当前用户在当前item下属于哪个类簇，然后把对应类簇中每个用户的M矩阵(对应LinUCB里面的A矩阵)，b向量（payoff向量，对应linUCB里面的b向量）聚合起来，从而针对这个类簇求解一个岭回归参数（类似LinUCB里面单独针对每个用户所做），同时计算其payoff预测值和置信上边界
4. 每个item都得到一个payoff预测值及置信区间上界，挑出那个上边界最大的item推出去（和LinUCB相同）
5. 观察用户的真实反馈，然后更新用户自己的M矩阵和b向量（更新个人的，对应类簇里其他的不更新）

以上是COFIBA算法的一次决策过程。在收到用户真实反馈之后，还有两个计算过程：

1. 更新user聚类
2. 更新item聚类

如何更新user和item的聚类呢？示意图为：

![User和Item聚类更新描述](https://dn-shimo-image.qbox.me/ILQ4rKG2lB4p3PWP/image.png!thumbnail)

解释一下这个图。

(a) 这里有6个user，8个item，初始化时，user和item的类簇个数都是1

(b1) 在某一轮试验时，推荐系统面对的用户是4。推荐过程就是遍历1～8每个item，然后看看对应每个item时，user4在哪个类簇中，把对应类簇中的用户聚合起来为这个item预测payoff和CB。这里假设最终item5胜出，被推荐出去了。

(b2)
在时刻t，item有3个类簇，需要更新的用户聚类是item5对应的user4所在类簇。更新方式：看看该类簇里面除了user4之外的用户，对item5的payoff是不是和user4相近，如果是，则保持原来的连接边，否则删除原来的连接边。删除边之后重新构建聚类结果。这里假设重新构建后原来user4所在的类簇分裂成了两个类簇：{4,5}和{6}

(c) 更新完用户类簇后，item5对应的类簇也要更新。更新方式是：对于每一个和item5(被推荐出的那个item)还存在连接边的item j，都去构造一个user的近邻集合N，这个集合的用户对item j有相近的payoff，然后看看N是不是和刚刚更新后的user4所在的类簇相同，是的话，保留item5和item j之间的连接边，否则删除。这里假设item 3和item 5之间的连接边被删除。item3独立后给他初始化了一个聚类结果：所有用户还是一个类簇。

简单来说就是这样：

* User-based协同过滤来选择要推荐的item，选择时用了LinUCB的思想
* 根据用户的反馈，调整User-based和Item-based的聚类结果
* Item-based的聚类变化又改变了User的聚类
* 不断根据用户实时动态的反馈来划分User-Item矩阵

# 4.总结

Exploit-Explore这一对矛盾一直客观存在，bandit算法是公认的一种比较好的解决EE问题的方案。除了bandit算法之外，还有一些其他的explore的办法，比如：在推荐时，随机地去掉一些用户历史行为（特征）。

解决Explore，势必就是要冒险，势必要走向未知，而这显然就是会伤害用户体验的：明知道用户肯定喜欢A，你还偏偏以某个小概率给推荐非A。

实际上，很少有公司会采用这些理性的办法做Explore，反而更愿意用一些盲目主观的方式。究其原因，可能是因为：

1. 互联网产品生命周期短，而Explore又是为了提升长期利益的，所以没有动力做；
2. 用户使用互联网产品时间越来越碎片化，Explore的时间长，难以体现出Explore 的价值；
3. 同质化互联网产品多，用户选择多，稍有不慎，用户用脚投票，分分钟弃你于不顾。
4. 已经成规模的平台，红利杠杠的，其实是没有动力做Explore的；

基于这些，我们如果想在自己的推荐系统中引入Explore机制，需要注意以下几点：

1. 用于Explore的item要保证其本身质量，纵使用户不感兴趣，也不至于引起其反感；
2. Explore本身的产品需要精心设计，让用户有耐心陪你玩儿；
3. 深度思考，这样才不会做出脑残的产品，产品不会早早夭折，才有可能让Explore机制有用武之地。

# 参考文献
