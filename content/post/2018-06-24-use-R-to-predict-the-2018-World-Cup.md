---
title: R代码模拟世界杯1000次，足球小白速成世界杯预言姐
author: 夏丰盛
date: '2018-06-24'
slug: use-R-to-predict-the-2018-World-Cup
meta_extra: 原作者：杨环；译者：夏丰盛；审稿：郎大为；编辑：雷博文；
categories:
  - R语言
  - 统计应用
tags:
  - R语言
  - 世界杯
forum_id: 420058
---
>本文翻译自[Mango Solution的博客](https://www.mango-solutions.com/blog/another-prediction-of-fifa-world-cup-2018)，作者杨环，就职于Mango Solutions，担任数据科学咨询顾问。本文已获得原作者授权。


几周前的皇家马德里VS利物浦的欧冠总决赛是我差不多十年来唯一严肃认真看完的一场比赛，但我居然会挺胸抬头地预测捧起2018年大力神杯的会是巴西队？如果（真假伪）各界球迷朋友发现本文口感略柴，可能是因为我的足球类自然语言处理能力欠佳。不要紧，你可以关注下面更有趣的模型训练、预测模拟与代码实现的讨论。 

> 本文主要基于 Claus Thorn EkstrÃ¸m.在eRum2018上关于2018年世界杯的预测。第一手资料请点击,[PPT](http://www.biostatistics.dk/talks/eRum2018/#1),[视频](https://www.youtube.com/watch?v=urJ1obHPsV8),[代码](https://github.com/MangoTheCat/blog_worldcup2018/blob/master/github.com/ekstroem/socceR2018),如果你没有梯子，视频链接在[这里](https://pan.baidu.com/s/1r1NuJppNGkNeeybEVgs3SA)

本文的想法是，每次模拟比赛都会产生冠军、亚军、季军等。在N次（比如10000次）模拟后， 我们就能综合计算出每一个球队的胜率。

除了预测谁是冠军外，本文还试图预测哪个球队的得分会最高以及最高得分是多少。在Claus's rmarkdown分析文件的基础上，我收集了新数据，把函数集成到R包中并且尝试了一个新的模型。模型本身十分简单，所以准确率难免有点低，但是模型能预估一个大概的趋势。你可以以这个模型为基础做出改进。

# 初始化

首先，加载包含 `worldcup`在内的R包，我把我的函数都集成到了[`worldcup`](https://github.com/MangoTheCat/blog_worldcup2018/tree/master/worldcup)里。R包是一个分享代码、集成函数和加速迭代的便捷方式。`dataMod.Rmd`头部的YAML部分中声明了**normalgoals**（世界杯中一场比赛的平均进球数）和**nsim**（模拟次数）两个变量。


接着我们加载了三个数据集，这三个数据集的原始数据来自开源数据集，我对原始数据做了一些改进。收集数据、调整队伍名称和清洗特征花了我非常多的时间。

* team_data包含跟队伍有关的特征
* group_match_data是比赛时间表，来自公开数据
* wcmatches_train是一个处理过的数据，数据源自[Kaggle比赛](https://www.kaggle.com/abecklas/fifa-world-cup/data)。这个数据可以作为训练集来估计lambda参数（每个球队的场均进球数），训练集采用了1994-2014年的数据。

```r
library(tidyverse)
library(magrittr)
devtools::load_all("worldcup")

normalgoals <- params$normalgoals 
nsim <- params$nsim

data(team_data) 
data(group_match_data) 
data(wcmatches_train)
```

# 游戏开始

Claus提出了三个计算单场比赛结果的模型。第一个模型基于两个独立的泊松分布，在这个模型中两个球队平等对待，所以无论他们实际技术和天赋如何，比赛的结果都是随机的。第二个模型假设一场比赛的分数是两个泊松事件，以及这两个泊松事件的差服从 skellam 分布。由于参数是根据实际的投注估计的，所以这个模型的结果更加可靠。第三个模型基于ELO评分( World Football Elo Ratings，一个通用的球员[评分规则](https://www.eloratings.net/about)， 根据现在ELO评分，我们计算一场比赛中单个队伍的成绩，结果可以被看做二项分布中成功的概率。由于二项分布的性质（只有0和1）这个模型忽略了平局的存在。

第四个模型是我的第一次尝试，这里简单介绍下。在这个模型中我们假设了两个独立的泊松事件，它们的lambda参数是另一个已经训练好的泊松分布模型的预测结果，预测的结果又由rpois模拟。

`play_game`函数包装封装好了上述四个模型，模型的选择由参数**play_fun**实现。

```r
# 选定西班牙和葡萄牙作为对手
play_game(play_fun = "play_fun_simplest", 
          team1 = 7, team2 = 8, 
          musthavewinner=FALSE, normalgoals = normalgoals)
```

```r
##      Agoals Bgoals
## [1,]      1      3
```

```r
play_game(team_data = team_data, play_fun = "play_fun_skellam", 
          team1 = 7, team2 = 8, 
          musthavewinner=FALSE, normalgoals = normalgoals)
```

```r

##      Agoals Bgoals
## [1,]      0      2
```

```r
play_game(team_data = team_data, play_fun = "play_fun_elo", 
          team1 = 7, team2 = 8)
```

```r
##      Agoals Bgoals
## [1,]      1      0
```

```r
play_game(team_data = team_data, train_data = wcmatches_train, 
          play_fun = "play_fun_double_poisson", 
          team1 = 7, team2 = 8)
```

```r
##      Agoals Bgoals
## [1,]      0      1
```

# 在训练中估计泊松均值

让我们快速浏览下回归函数`glm`中的核心部分，`glm`函数中的因变量是一个队伍一场比赛中的进球数，自变量是2014年世界杯开始前的FIFA评分和ELO评分。FIFA评分和ELO评分都是著名的评分系统，两者之间的区别在于FIFA评分是官方的而ELO不是。ELO评分是基于国际象棋排名方法更改的。

```r
mod <- glm(goals ~ elo + fifa_start, family = poisson(link = log), data = wcmatches_train)
broom::tidy(mod)
```

```r
##          term      estimate    std.error  statistic      p.value
## 1 (Intercept) -3.5673415298 0.7934373236 -4.4960596 6.922433e-06
## 2         elo  0.0021479463 0.0005609247  3.8292949 1.285109e-04
## 3  fifa_start -0.0002296051 0.0003288228 -0.6982638 4.850123e-01
```

从模型的summary可以看出，在从统计学的角度，ELO评分比FIFA评分更重要显著。更有趣的是FIFA评分的系数竟然是负数,1分FIFA评分平均能降低0.0002296进球数。总体而言，ELO评分的预测性要好于FIFA评分。由于模型中的自变量是2014年世界杯开始前的FIFA评分和ELO评分，所以这也可能是导致这样结果的原因，更进一步，可能我们需要考虑更早的世界杯数据.毕竟有关于FIFA评分的预测效果不好已经不是什么[新闻](https://www.sbnation.com/soccer/2017/11/16/16666012/world-cup-2018-draw-elo-rankings-fifa)了。

训练集**wcmatches_train**有一个**is_home**列，代表在这个比赛中队伍是不是主场。然而，很难说明主客场因素在第三方国家进行的比赛和有职业联赛之间有很大的不同。而且，对于本届俄罗斯世界杯我也没有找到明确划分主客场的方法。我们可以新增一个相似特征-主场优势来表征这个国家、这个洲是否是主场，这在未来的建模可以派上用场。主场优势这个特征暂时没有出现在**wcmatches_train**数据集中。

# 小组赛和淘汰赛结果预测

下面展示的是在不同场景中预测获胜队伍的结果，包含小组赛、16强、1/4决赛、半决赛和总决赛。

```r
find_group_winners(team_data = team_data, 
                   group_match_data = group_match_data, 
                   play_fun = "play_fun_double_poisson",
                   train_data = wcmatches_train)$goals %>% 
  filter(groupRank %in% c(1,2)) %>% collect()
```

```r
## # A tibble: 16 x 11
##    number name        group rating   elo fifa_start points goalsFore
##     <int> <chr>       <chr>  <dbl> <dbl>      <dbl>  <dbl>     <int>
##  1      1 Egypt       A      151    1646        636      7         7
##  2      2 Russia      A       41    1685        493      4         4
##  3      6 Morocco     B      501    1711        681      6         2
##  4      8 Spain       B        7    2048       1162      6         7
##  5     11 France      C        7.5  1984       1166      9         9
##  6     12 Peru        C      201    1906       1106      4         5
##  7     14 Croatia     D       34    1853        975      7         7
##  8     16 Nigeria     D      201    1699        635      4         4
##  9     17 Brazil      E        5    2131       1384      6         6
## 10     19 Switzerland E      101    1879       1179      6         4
## 11     21 Germany     F        5.5  2092       1544      9         5
## 12     22 South Korea F      751    1746        520      6         3
## 13     25 Belgium     G       12    1931       1346      6         6
## 14     27 Panama      G     1001    1669        574      4         4
## 15     30 Japan       H      301    1693        528      5         2
## 16     32 Senegal     H      201    1747        825      4         5
## # ... with 3 more variables: goalsAgainst <int>, goalsDifference <int>,
## #   groupRank <int>
```

```r
find_knockout_winners(team_data = team_data, 
                     match_data = structure(c(3L, 8L, 10L, 13L), .Dim = c(2L, 2L)), 
                      play_fun = "play_fun_double_poisson",
                      train_data = wcmatches_train)$goals
```

```r
##   team1 team2 goals1 goals2
## 1     3    10      0      4
## 2     8    13      1      1
```

# 模拟比赛

终于来到了最激动人心的部分！我们编写了一个函数`simulate_one()`来模拟一次比赛，然后用`replicate()`函数重复模拟多次。如果想要模拟的次数很多（比如10000次），你可能需要开启并行计算。为了简单起见，我只模拟了1000次。

说了这么多，我们最后把上述提到的关键功能都打包到了函数`simulate_tournament()`里，函数的返回结果是`nsim`次模拟比赛的排名和进球数，`nsim`就是`simulate_tournament()`函数的`nsim`参数。每次模拟结果都包含32支队伍。`set.seed()`函数设置随机数种子以保证结果可以复现。

```r
# 模拟nsim次世界杯
set.seed(000)
result <- simulate_tournament(nsim = nsim, play_fun = "play_fun_simplest") 
result2 <- simulate_tournament(nsim = nsim, play_fun = "play_fun_skellam")
result3 <- simulate_tournament(nsim = nsim, play_fun = "play_fun_elo")
result4 <- simulate_tournament(nsim = nsim, play_fun = "play_fun_double_poisson", train_data = wcmatches_train)
```



# 冠军名单

`get_winner()`函数返回一个获胜概率的表单，从高到低依次往下排列。除了随机泊松模型外，其余三个模型都认为巴西会获得冠军，巴西和德国包揽了比赛的前两名。至于第三名和第四名，当随机数种子不同时队伍（下图中深蓝色）很有可能会变化。方差可能是一个可以深挖的点。

```r
get_winner(result) %>% plot_winner()
```

![r1i](https://github.com/MangoTheCat/blog_worldcup2018/raw/master/dataMod_files/figure-markdown_github/winner-1.png)

```r
get_winner(result2) %>% plot_winner()
```

![r2i](https://github.com/MangoTheCat/blog_worldcup2018/raw/master/dataMod_files/figure-markdown_github/winner-2.png)

```r
get_winner(result3) %>% plot_winner()
```

![ri3](https://github.com/MangoTheCat/blog_worldcup2018/raw/master/dataMod_files/figure-markdown_github/winner-3.png)

```r
get_winner(result4) %>% plot_winner()
```

![ri4](https://github.com/MangoTheCat/blog_worldcup2018/raw/master/dataMod_files/figure-markdown_github/winner-4.png)

# 哪个队伍进球数最多呢？

四个模型中，skellum模型似乎最可靠，我的双泊松模型所给出的得分频率要比实际的更低。这两个模型的结果都认为巴西将获得最多的进球数。

```r
get_top_scorer(nsim = nsim, result_data = result2) %>% plot_top_scorer()
```

![score1](https://github.com/MangoTheCat/blog_worldcup2018/raw/master/dataMod_files/figure-markdown_github/top_score_team-1.png)



```r
get_top_scorer(nsim = nsim, result_data = result4) %>% plot_top_scorer()
```



![score2](https://github.com/MangoTheCat/blog_worldcup2018/raw/master/dataMod_files/figure-markdown_github/top_score_team-2.png)

# 总结

模型的整体框架还是很清晰的，. 只需要通过`game_fun_blah`函数定义自己的单场比赛模型 ，然后把它作为参数传递给`play_game`函数

欢迎优秀的大家在Github上给[ekstroem/socceR2018](https://github.com/ekstroem/socceR2018)提交PR。谁又能成为本届世界杯最佳预言帝呢？

如果你喜欢这篇文章，欢迎给这篇文章的[Github](https://github.com/MangoTheCat/blog_worldcup2018)点Star，fork，提交issue或者扔香蕉，文章所提及的所有代码都在[Github](https://github.com/MangoTheCat/blog_worldcup2018)中。同时非常感谢Rich, Doug, Adnan以及所有分享过想法的人，没有他们的帮助就没有这篇文章，让我们一起把知识传递给算法。




# 补充

1. 数据收集。**team_data**数据集里面并没有最新的赔率和ELO评分。如果你想添加这些信息，它们可以从下面三个网站获取。FIFA评分获取是最简单的，能用常规的爬虫获得，而赔率和ELO评分似乎是由JavaScript代码提供，我还没想到一个很好的解决方案。至于一些投注和赔率信息，你可以从Betfair获取。Betfair是一个在线投注交易网站，它提供了获取信息的API，R包[abettor](https://github.com/phillc73/abettor)能直接爬取。投注信息对于不仅关心预测结果而且想要做策略的人来说更加重要。
   - <https://www.betfair.com/sport/football>
   - <https://www.eloratings.net/2018_World_Cup>
   - <http://www.fifa.com/fifa-world-ranking/ranking-table/men/index.html>
2. 模型改进。这可能是最关键的一点。举例而言，已经有不少的研究证明双变量的泊松分布对足球预测是有帮助的。
3. 特征工程。GDP之类的经济因素；球员总价、球员保险、球员受伤等市场因素可能也会帮助提升精度。
4. 模型评价。了解我们的模型是否具有良好的预测可信度的一种方法是在2018年7月15日之后根据实际结果评估预测结果。目前来自博彩公司的赔率也是一个参考因素。在历史数据集上运行模型也不是也不能的，比如可以对2014世界杯运行模型，并对模型进行选择。
5. 函数和R包还有改善的余地，代码也可以进一步整理。
