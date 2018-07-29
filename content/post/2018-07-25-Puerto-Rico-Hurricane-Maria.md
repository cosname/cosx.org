---
title: 飓风过后的波多黎各
author: 
  - 李泳欣
  - 于淼
date: '2018-07-25'
slug: Puerto-Rico-Hurricane-Maria
categories:
  - 统计应用
tags:
  - 估计
  - 新闻
 forum_id: 420097
---

2017年9月20日，超级飓风“玛利亚”袭击了美属波多黎各自治邦，这场近90年来最强的飓风造成当地的基础设施严重损毁。同年12月9日，波多黎各政府发布的数据显示截止11月底，有64人死于飓风灾害。消息一出，社会舆论一片哗然，多家媒体和学术机构对此数据表示怀疑，认为这与当地受灾情况的严重程度不符。《纽约时报》的[独立调查](https://www.nytimes.com/interactive/2017/12/08/us/puerto-rico-hurricane-maria-death-toll.html)显示，截至17年10月底，遇难人数可能多达1052人；[Center for Investigative Journalism](http://periodismoinvestigativo.com/2017/12/nearly-1000-more-people-died-in-puerto-rico-after-hurricane-maria/)认为至少985人在灾害后的40天内死亡；波多黎各大学马亚圭斯分校的学者[计算](http://academic.uprm.edu/wrolke/research/Maria%20Deaths%20-%20Significance.pdf)出的死亡人数为822；一篇来自宾州州立大学与独立研究者的[论文](https://osf.io/preprints/socarxiv/s7dmu)估计出，因飓风遇难的人数应该是官方数据的10倍；2018年2月来自[Latino USA](http://latinousa.org/)对波多黎各健康署的数据分析显示，17年9月与10月应该有1194人死于飓风；而2018年5月来自哈佛大学的一份发表在《新英格兰医学杂志》上的[研究报告](http://www.nejm.org/doi/pdf/10.1056/NEJMsa1803972)则称截至17年底，“玛利亚”至少造成了当地4645人死亡。

遇难人数的统计是灾害损失评估的重要部分，其准确性直接影响到当地灾后重建和灾害预防工作的质量。对于波多黎各飓风的遇难人数，政府、社会和学术界给出了一系列相差巨大的数字，究竟谁更接近真实情况？政府是否真的严重低估了遇难人数？是有意为之还是无心之失？

## 官方统计口径的局限

统计口径不同可能是造成各方说法不一的一个原因。官方的统计口径有一定的局限性，容易低估死亡人数。比如波多黎各政府规定，任何由自然灾害导致死亡的尸体必须经过法医鉴定。而灾区资源紧张，部分尸体可能都根本没有进行鉴定。此外，政府遇难人数的统计仅包括由自然灾害导致的直接死亡， 而非直接死亡（例如由于灾害耽误了治疗时间或者造成慢性病的恶化）是不被记录的。因此，在所有真正是由自然灾害而死亡的遇难者中，只有一部分得到了法医鉴定，而这其中又只有一部分的鉴定正确。这些都影响了官方数据的准确性。

## 遇难人数的估计

当调查存在偏差，基于统计学的估计可能是更好的解决方案。估计的思路可以非常直接：将波多黎各灾后（2017年9月20日至12月31日）的死亡率与2016年同期死亡率进行比较，推算出飓风造成的死亡人数。就《新英格兰医学杂志》上的这篇文章而言，由于研究者当时未能获得灾后的死亡人数，因此是通过分层抽样选取了波多黎各的3299个家庭，对其进行调查访问才得出灾后的死亡率。值得注意的是4645这个数其实是点估计，其95%置信区间估计为793到8498，很多新闻媒体直接报道了点估计而忽略了区间估计及估计与真值的区别解释，这同样会对民众或政府产生误导。

但类似的抽样调查耗时耗力，如果能获得灾区灾后的死亡情况（比如每月或者每日的死亡人数）和人口基数，我们是可以更快地估计出遇难人数的。2018年5月，波多黎各政府迫于社会压力，公布了波多黎各灾后死亡人数数据。《新英格兰医学杂志》论文作者之一的Rafael Irizarry教授在申请获得每日数据后，对遇难人数重新进行了[估计](https://simplystatistics.org/2018/06/08/a-first-look-at-recently-released-official-puerto-rico-death-count-data/)。相比之前基于抽样调查的分析，这次的数据粒度精确到天并考虑了人口老龄化和季节更迭带来的死亡率变化。下面我们通过复原其分析过程来说明估计是如何得出的。

首先画出波多黎各2017和2018年的每日死亡人数：


```r
library(tidyverse)
library(showtext)
library(lubridate)

official <- read_csv('https://raw.githubusercontent.com/yufree/democode/master/data/PuertoRico.csv')

theme_set(theme_bw())
official %>% filter(year >= 2017 & deaths > 0) %>%
  ggplot(aes(date, deaths)) + 
  geom_point(alpha = 0.5) + 
  geom_vline(xintercept = make_date(2017,09,20), lty=2, col="grey") +
  scale_x_date(date_labels = "%b", date_breaks = "1 months") +
  xlab('日期') + ylab('死亡人数')+
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  ggtitle("2017-2018年数据")
```

![fig1](https://github.com/yongxin14/hurricane/raw/master/figures/raw_data.png)

可以看到"玛利亚"飓风登陆之后的2-3个星期内，波多黎各每日死亡人数都明显增加，并在之后的3-4个月仍处于较高的数值。为保证数据质量，不考虑2018年4月15后的数据。

随后结合从网上获得的波多黎各人口基数计算出每天的死亡率。取每年9月20日之前的日死亡率的中位数作为年死亡率（2018年由于数据缺失，取2017年的年死亡率），以此反映人口老龄化对死亡率的影响。由于自然死亡率还会随季节发生波动，因此利用2015年和2016年的数据计算每年同一天，日死亡率与年死亡率差值的均值。并用局部回归法重新拟合出一条光滑曲线，作为季节项。


```r
population_by_year <- read_csv("https://raw.githubusercontent.com/yongxin14/hurricane/master/pr_popest_2010_17.csv")

tmp <- bind_rows(data.frame(date = make_date(year = 2010:2017, month = 7, day = 2), 
                            pop = population_by_year$pop),
                 data.frame(date = make_date(year=c(2017,2017,2017,2017,2018,2018), 
                                             month=c(9,10,11,12,1,2), 
                                             day = c(19,15,15,15,15,15)),
                            pop = c(3337000, 3237000, 3202000, 3200000, 3223000, 3278000)))
tmp <- approx(tmp$date, tmp$pop, xout=official$date, rule = 2)
predicted_pop <- data.frame(date = tmp$x, pop = tmp$y)

official <- official %>% left_join(predicted_pop, by = "date") %>%
  mutate(rate = (deaths/pop)*365*1000)

# 年死亡率
year_rate <- official %>% filter (month <=8 | (month == 9 & day < 20)) %>% 
  group_by(year) %>%
  summarise(year_rate=median(rate))
year_rate[4,'year_rate'] <- year_rate[3,'year_rate']

# 拟合季节项
avg <- official %>% filter(year(date) < 2017 & !(month==2 & day == 29)) %>%
  left_join(population_by_year, by = "year") %>%
  left_join(year_rate, by='year') %>%
  group_by(month,day) %>%
  summarize(avg_rate = mean(rate - year_rate)) %>%
  ungroup()

day <- as.numeric(make_date(1970, avg$month, avg$day)) + 1
xx <- c(day - 365, day, day + 365)
yy<- rep(avg$avg_rate, 3)
fit <- loess(yy ~ xx, degree = 1, span = 0.15, family = "symmetric")
trend <- fit$fitted[366:(365*2)]
trend <- data.frame(month = avg$month, day = avg$day, trend = trend)
official <- official %>% left_join(trend, by = c("month", "day"))

official %>%  
  filter(date >=ymd("2017-01-01") & date < ymd("2018-01-01")) %>%
  ggplot(aes(date, trend)) +
  geom_line() + 
  xlab('日期')+ylab('与年死亡率的差值')+
  scale_x_date(date_labels = "%b", date_breaks = "1 months") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
  ggtitle("日死亡率的季节波动")
```

![fig2](https://github.com/yongxin14/hurricane/raw/master/figures/trend.png)

接下来，将2017年1月1日至2018年4月15日的日死亡率序列进行季节和老龄化趋势调整，并以飓风登陆日期2017年9月20日为分界点，分别对灾前和灾后调整后的死亡率重新进行局部加权回归，拟合为两条光滑曲线。


```r
after_smooth <- official %>% 
  filter(date >=ymd("2017-01-01") & date < ymd("2017-09-20")) %>%
  left_join(year_rate, by='year') %>%
  mutate(y = rate - year_rate -  trend, x = as.numeric(date)) %>%
  loess(y ~ x, degree = 2, span = 2/3, data = .)
before_smooth <- official %>% 
  filter(date >=ymd("2017-09-20") & date < ymd("2018-04-15")) %>%
  left_join(year_rate, by='year') %>%
  mutate(y = rate - year_rate -  trend, x = as.numeric(date)) %>%
  loess(y ~ x, degree = 2, span = 2/3, data = .)
tmp <- official %>% filter(date>=ymd("2017-01-01") & date < ymd("2018-04-15")) %>%
  mutate(smooth = c(after_smooth$fitted, before_smooth$fitted),
         se_smooth = c(predict(before_smooth, se=TRUE)$se, predict(after_smooth, se=TRUE)$se))

tmp %>% left_join(year_rate, by='year') %>%
  mutate(diff = rate - year_rate - trend) %>%
  ggplot(aes(date, diff)) +
  geom_point(alpha=0.5) +
  geom_ribbon(aes(date, ymin = smooth - 1.96*se_smooth, ymax = smooth + 1.96*se_smooth), 
              fill="blue", alpha = 0.25) +
  geom_line(aes(date, smooth), col = "blue") +
  scale_x_date(date_labels = "%b", date_breaks = "1 months") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
  ggtitle("日死亡率的变化") + 
  xlab('日期')+ylab("日死亡率与年死亡率和季节波动的差值") + 
  geom_hline(yintercept = 0, lty = 2)
```

![fig3](https://github.com/yongxin14/hurricane/raw/master/figures/diff.png)

如果假设2017年波多黎加的总人口恒定，以2016年底的人口数作为基数，那么结合之前已进行调整的死亡率，可以计算出灾后每天累积的“额外死亡人数”，即遇难人数。


```r
the_pop <- filter(population_by_year, year == 2016) %>% .$pop
tmp %>% left_join(year_rate, by='year') %>%
  filter(date >=ymd("2017-09-20")) %>%
  mutate(diff = rate - year_rate - trend,
         raw_cdf = cumsum(diff*the_pop/1000/365), 
         smooth_cdf =cumsum(smooth*the_pop/1000/365)) %>%
  ggplot() +
  geom_step(aes(date, raw_cdf)) +
  scale_x_date(date_labels = "%b", date_breaks = "1 months") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
  ggtitle("每日累积遇难人数") + 
  xlab('日期')+ylab("累积遇难人数") + 
  geom_hline(yintercept = 64, lty=2, col="grey")
```

![fig4](https://github.com/yongxin14/hurricane/raw/master/figures/mortality.png)

结果显示，截止17年10月底，飓风就已造成超过1000人遇难，远高于官方声称的64人。虽然研究者一开始假设17年和18年的年死亡率相同，但由于巨灾导致了大量的人口迁移和死亡，社会年龄结构已产生较大变化，该假设是否合理需要进一步验证。不过基本可以肯定的是，政府确实严重低估了遇难人数。

## 其他类型的自然灾害

不只是飓风，几乎所有的自然灾害都会要求统计死亡人数。而像流行病一类影响地域更广的灾害，死亡人数的统计方法也更加复杂。在一份关于2009年甲型H1N1流感造成的死亡人数[分析报告](http://journals.plos.org/plosmedicine/article?id=10.1371/journal.pmed.1001558)中，研究者将分析过程分为两步。第一步筛选出全球20个国家或地区（占全球总人口的35%），利用多元线性回归估计每个国家的死亡人数。第二步采用层次多重填补法，考虑国家之间地理位置、经济和健康差异，基于第一步得到的结果填补剩余国家的数据，从而得到全球死亡人数。最后该报告估计出的死亡人数是世界卫生组织发布的10倍。

## 小结

波多黎各死亡人数事件告诉我们，基于直接数据的调查与间接数据的估计可能都不是完美的，前者受限于记录手段而后者则需要假设成立，因此在看到新闻报道的数据时我们都要留个神。要知道，准确的估计或许无法挽回逝去的生命，但能辅助更合理应急预案的设计。同时，西方媒体与学界对突发事件的快速反应与质疑也值得国内借鉴，自下而上的讨论会矫正固有政策或调查方法的偏见。

最后，数字是冰冷的，愿逝者安息。
