---
title: 十行代码预测插旗西雅图
date: '2017-05-19T12:06:00+00:00'
author: 侯澄钧
categories:
  - Web API
  - 数据分析
  - 数据挖掘与机器学习
slug: rdota2-seattle-prediction
---


## 背景故事

我错了，我承认我是标题党，怎么可能用十行代码完成**信仰2 ~~Dota2~~ 比赛数据的抓取, 清洗与预测建模呢**。
不过为了发扬继承郎大为“十行代码”系列的优良传统，我决定沿用这个名字，希望能把品牌做大做强，走出亚洲，面向世界。。。

事情的起因是这样的：上周与同为信仰粉的大为接上头之后，被安利了一个叫 RDota2 的 R pacakge。
这个工具包使用 Steam API，可以让 R 直接提取有关 Dota2 的各种数据：除了每一场游戏的具体信息，还可以提取英雄，物品，战队，和联赛的资料。
所以我就萌生了用 RDota2 抓一批比赛数据，然后建模预测比赛胜负的想法。结果还是相当有趣的，且听我慢慢道来。
不过在此之前，我想先为对建模感兴趣但不知道什么是 Dota2 的同学，简单介绍一下这款游戏。

![](https://cloud.githubusercontent.com/assets/11251354/26287701/050b8c4c-3e4f-11e7-8bba-05edd84f4614.JPG)  
Dota2众型男
<!--more-->

Dota2 来源于暴雪魔兽争霸的一张自定义地图，又叫 RPG 图，就是由地图开发者在魔兽争霸这个游戏之上自己创建了一种玩法。
这张地图的名字就叫做 Dota，Defense of the Ancient，被视为当下十分流行的 MOBA 类游戏的鼻祖。
MOBA 游戏的机制是，两队人马以摧毁对方大本营为目的互相厮杀，五个玩家组成一队，每个玩家从各具特色的一百多个英雄中选出一个，互相支援配合。
一场比赛的用时大概在半小时到一小时之间，当然也有十几分钟的短局，或者三四小时的膀胱局。
Dota 的首个版本于03年由开发者 Eul 发布，中间更换好几次开发者之后，由伟大的 Icefrog 冰蛙于05年开始接手开发至今，开启了一个传奇的时代。
我是从冰蛙接手后的6.41版本开始接触 Dota 的，不要问我怎么把版本号记得那么清楚，
当一件事不是为了生计，而是完全出于喜爱而持续做了十年的时候，就成为了一种信仰（庄严脸）。

![](https://cloud.githubusercontent.com/assets/11251354/26287704/050dc76e-3e4f-11e7-85de-30a051af88c8.JPG)  
6.48版本载入画面 

当然很少有游戏能连续流行十几年。所以 Dota 的经久不衰要感谢 Dota2 的一波续命。
09年，拥有全球最大在线游戏销售平台 Steam 的游戏公司 Valve 看中了 Dota 的巨大潜力，把冰蛙招入麾下着手开发独立的一款游戏 Dota2，
使其摆脱魔兽争霸一张地图的身份。
为此还引发了反应慢半拍的暴雪和 Valve 之间的版权纠纷。
Dota2 所有理念和设计完全照搬 Dota，但因为能独立于魔兽争霸之外，新的引擎给 Dota2 更绚丽的画面，更流畅的手感，以及游戏本身更高的自由度。
但是 Dota2 在10年刚推出的时候，因为本身的完成度很低，Dota 本体还十分火热等原因，基本上没人能够或者愿意玩。
直到11年 Valve 在德国科隆游戏展上举办了首届 Dota2 国际竞标赛 The International (TI)，Dota2 才成功展示了自己的存在。
Valve 的这一手“千金买马骨”玩得实在溜，要知道当时即使在电竞最发达的欧洲，各大比赛的奖金基本上就几千欧，
突然石破天惊来一个总奖金160万美元，冠军100万美元，这能不让世界各地的网瘾少年们目瞪口呆吗。
如今的各职业大佬回忆起当时情景，无一例外得表示他们的第一反应都是，这公司是骗子吧。
然后 TI 的传统就延续了下来，除了 TI1，之后的5届都在 Valve 总部西雅图举办，其中中国战队拿了 TI2，TI4，和 TI6的冠军，
去年 TI6 的总奖金更是超过了2000万美元。不论从哪个角度，荣誉还是金钱，把红旗插上西雅图 TI 冠军领奖台都是每个中国战队的终极梦想。

![](https://cloud.githubusercontent.com/assets/11251354/26287703/050c573a-3e4f-11e7-8b95-46edafc29d3f.JPG)  
IG在TI2上首次插旗成功

现在的我看 Dota 比赛比自己玩更有乐趣，主要因素还是水平稀烂吧。除了大学时参加校联赛，关于 Dota 最深刻的记忆也还是看比赛：
清楚记得看 TI2 中国战队与国外战队决赛直播时，基友一脸便秘的紧张神情，还有和另一半和基友去 TI5 现场时感受到的盛况空前。
好了，人长大了回忆起来就没完，下面进入正题：正文分三个章节，首先聊聊工具包 RDota2 的使用，
然后写如何从 API 抓取到的数据里提取有用信息用来建模，第三部分就是建模的步骤和结果了。
等不急想知道哪些英雄对比赛胜负影响最大的老司机，可以直接跳到文章末尾先一睹为快。

![](https://cloud.githubusercontent.com/assets/11251354/26287700/050b6e56-3e4f-11e7-964a-a664ae0c6b0a.JPG)  
TI6现场西雅图Key-Arena



## RDota2 简介

在使用 RDota2 之前，我们需要到 [Steam 网站](https://steamcommunity.com/login/home/?goto=%2Fdev%2Fapikey) 申请 Steam API 的 Key。
有 Steam 账号的话马上就能得到。加载 RDota2 之后，只需要设定一次 Key，就能愉快得通过 API 提取数据了。


```r
library(RDota2)
API_key = readRDS("Steam_API_Key")
key_actions(action = 'register_key', value = API_key)
```

当然，更安全的方式是把 Key 存在操作系统的环境变量中，以后引用这个变量即可，
具体流程可以参考 [这里](https://cran.r-project.org/web/packages/RDota2/vignettes/RDota2.html)。


### get_xxx 系列函数

RDota2 通过各种 get 函数连接 Steam API 抓取数据。
所有的 get 函数的返回值都包含三个元素：

* url: 该次 API 请求的链接，可以把这个链接复制到浏览器的地址栏，回车得到相应的返回值
* content: 该次 API 请求的具体返回值，因为原始返回数据是 json 格式的，在 R 里面 content 的形式是一个层叠列表
* response：该次 API 请求在 Steam 服务器里的处理信息

除了提取详细比赛信息的函数 `get_match_details()` 和 `get_match_history_by_sequence_num()` 之外，这两个函数会在后面具体介绍，
还有以下的函数提取一般比赛和职业联赛的信息：

* `get_event_stats_for_account(eventid, accountid)`：返回账号 `accountid` 在一般联赛 `eventid` 里的记录
* `get_league_listing()`: 返回所有联赛的信息
* `get_live_league_games()`: 返回正在进行中的联赛以及选手信息
* `get_scheduled_league_games()`: 返回已安排的联赛信息
* `get_team_info_by_team_id(start_at_team_id, teams_requested)`: 从 `start_at_team_id` 开始提取 `teams_requested` 个职业战队的信息
* `get_top_live_game()`: 返回正在进行中的高水平一般比赛和职业联赛，返回值里面有双方的平均 MMR（战斗力），这也是整个 API 里唯一关联 MMR 的函数
* `get_tournament_player_stats(account_id)`: 返回账号 `account_id` 在国际锦标赛 TI 里的记录
* `get_tournament_prize_pool()`: 返回国际锦标赛 TI 奖金池状态

以下函数可以提取其他的游戏信息：

* `get_game_items(language)`: 返回所有游戏物品的 data.frame，指定 `language` 还可以得到物品在这种语言下的名称
* `get_heroes(language)`: 返回所有 Dota 英雄的 data.frame，指定 `language` 还可以得到英雄在这种语言下的名称
* `get_item_icon_path(iconname, icontype)`: 指定物品名称 `iconname` 和类型 `icontype`（0=常规，1=大图，3=游戏内），返回物品图标 CDN 地址
* `get_rarities(language)`: 这个是<span style="color:red">重点</span>，返回 Dota2 商店内饰品和皮肤的掉落率


```r
hero.df <- get_heroes(language = 'zh')$content
head(hero.df)
```

```
##                           name id localized_name
## 1       npc_dota_hero_antimage  1         敌法师
## 2            npc_dota_hero_axe  2           斧王
## 3           npc_dota_hero_bane  3       祸乱之源
## 4    npc_dota_hero_bloodseeker  4       嗜血狂魔
## 5 npc_dota_hero_crystal_maiden  5       水晶室女
## 6    npc_dota_hero_drow_ranger  6       卓尔游侠
```


### get_match_details 函数

使用 `get_match_details(match_id)` 返回比赛详细信息时需要指定该场比赛的 ID，也就是所谓的录像编号。一般比赛会返回一个长度是23的列表，
第1个元素包含了10名玩家的具体游戏信息，它本身也是一个复杂列表，除此之外，其他的元素都是一元的。它们包括：

* radiant_win: 天辉是否获胜，1=是, 0=否
* duration: 比赛总时长，以秒计
* pre_game_duration: 正式比赛前准备时长
* start_time: 游戏开始时间，Unix 时间形式，下面例子里有时间转化方法
* match_id: 比赛 ID
* match_seq_num: 比赛序列号，该编号按比赛开始时间呈次序排列
* tower_status_radiant: 天辉防御塔状态，具体参考 [此处](https://dota2api.readthedocs.io/en/latest/responses.html#towers-and-barracks)
* tower_status_dire: 夜魇防御塔状态，具体同上
* barracks_status_radiant: 天辉兵营状态，具体参考 [此处](https://dota2api.readthedocs.io/en/latest/responses.html#towers-and-barracks)
* barracks_status_dire: 夜魇兵营塔状态，具体同上
* first_blood_time: 一血时间
* lobby_type: 游戏大厅，具体参考 [此处](https://dota2api.readthedocs.io/en/latest/responses.html#lobby-type)，常见的有：
    + 0=公共比赛
    + 1=练习，但所有职业比赛都在这一类里
    + 4=与AI合作/对战，就是所谓的打电脑
    + 7=排位赛，就是所谓的天梯
    + 8=单人比赛，主要用于中路1对1
* human_players: 非机器人的玩家数量
* leagueid: 联赛 ID，0=一般比赛
* positive_votes: “喜欢”投票
* negative_votes: “不喜欢”投票
* game_mode: 游戏模式，具体参考 [此处](https://dota2api.readthedocs.io/en/latest/responses.html#game-mode)，常见的有：
    + 1=全阵营
    + 2=队长模式
    + 3=随机征召
    + 4=个别征召
    + 5=全阵营随机
    + 12=生疏模式
    + 18=随机模型（技能）
    + 20=全阵营死亡模式
    + 21=中路1对1
    + 22=排位全阵营
* flags: 未知
* engine: 0=source1, 1=source2
* radiant_score: 天辉击杀数
* dire_score: 夜魇击杀数


```r
match_normal <- get_match_details(match_id = 3170508667)$content
unlist(match_normal[-1])
```

```
##             radiant_win                duration       pre_game_duration 
##                       1                    2981                      90 
##              start_time                match_id           match_seq_num 
##              1494464883              3170508667              2769162669 
##    tower_status_radiant       tower_status_dire barracks_status_radiant 
##                    1846                       0                      63 
##    barracks_status_dire                 cluster        first_blood_time 
##                       0                     121                      64 
##              lobby_type           human_players                leagueid 
##                       7                      10                       0 
##          positive_votes          negative_votes               game_mode 
##                       0                       0                      22 
##                   flags                  engine           radiant_score 
##                       1                       1                      48 
##              dire_score 
##                      28
```

```r
as.POSIXct(match_normal$start_time, origin = '1970-01-01', tz = 'GMT')
```

```
## [1] "2017-05-11 01:08:03 GMT"
```

职业联赛返回列表更长，除了上面的这些信息外，还有两支对决战队的信息，以及列表第34个元素包含的 Ban/Pick 详细信息。
这里取4月亚洲锦标赛的一场决赛为例。祝贺B神得偿所望！


```r
match_league <- get_match_details(match_id = 3097027819)$content
unlist(match_league[-c(1, 34)])
```

```
##             radiant_win                duration       pre_game_duration 
##                  "TRUE"                  "3800"                    "90" 
##              start_time                match_id           match_seq_num 
##            "1491285612"            "3097027819"            "2704563366" 
##    tower_status_radiant       tower_status_dire barracks_status_radiant 
##                  "1796"                  "1792"                    "63" 
##    barracks_status_dire                 cluster        first_blood_time 
##                    "58"                   "224"                   "687" 
##              lobby_type           human_players                leagueid 
##                     "1"                    "10"                  "5197" 
##          positive_votes          negative_votes               game_mode 
##                  "5468"                   "320"                     "2" 
##                   flags                  engine           radiant_score 
##                     "1"                     "1"                    "38" 
##              dire_score         radiant_team_id            radiant_name 
##                    "18"                     "5"       "Invictus Gaming" 
##            radiant_logo   radiant_team_complete            dire_team_id 
##    "528418381437908544"                     "1"               "2586976" 
##               dire_name               dire_logo      dire_team_complete 
##              "OG Dota2"    "263849025209840320"                     "1" 
##         radiant_captain            dire_captain 
##             "140153524"              "94155156"
```

玩家列表（函数返回值的第一个元素）包含10个元素，对应10个玩家，前5个是天辉，后5个是夜魇。
下面是某一个玩家的具体信息，包括所选英雄，物品栏，击杀/死亡/助攻，正反补，金钱经验每分钟，造成伤害/治疗等。第30个元素是关于技能升级的列表。


```r
unlist(match_league$players[[1]][-30])
```

```
##          account_id         player_slot             hero_id 
##           140153524                   0                  37 
##              item_0              item_1              item_2 
##                 102                  65                 214 
##              item_3              item_4              item_5 
##                  30                 229                  31 
##          backpack_0          backpack_1          backpack_2 
##                  46                   0                   0 
##               kills              deaths             assists 
##                   2                   7                  17 
##       leaver_status           last_hits              denies 
##                   0                  92                   3 
##        gold_per_min          xp_per_min               level 
##                 272                 439                  25 
##         hero_damage        tower_damage        hero_healing 
##                7097                 750               13644 
##                gold          gold_spent  scaled_hero_damage 
##                2086               14560                4440 
## scaled_tower_damage scaled_hero_healing 
##                 427                6426
```

值得注意的是，`player_slot` 这一栏在设定上是可以区分1到5号位的，但是实际中并没有用到，所以0至4为天辉，128至132为夜魇，玩家按进入游戏次序排列。

```
┌─────────────── 0=天辉 1=夜魇
│ ┌─┬─┬─┬─────── 没用
│ │ │ │ │ ┌─┬─┬─ 队伍中的1到5号位 (0-4)
0 0 0 0 0 0 0 0
```

以上就是 `get_match_details()` 函数的所有返回值。
`get_match_history_by_sequence_num(start_at_match_seq_num, matches_requested)` 函数的返回值是一模一样的形式，
唯一的不同就是这个函数可以返回多场比赛的详细信息，从 `start_at_match_seq_num` 开始往后 `matches_requested` 场比赛，
注意这里必须输入比赛序列号 match_seq_num，该编号按比赛开始时间呈次序排列。另外1次请求最多能返回100场比赛的信息。


```r
match_multi <- get_match_history_by_sequence_num(start_at_match_seq_num=2769162669, matches_requested=10)$content
c(match_multi$matches[[1]]$match_id, match_multi$matches[[10]]$match_id)
```

```
## [1] 3170508667 3170522270
```

其实还有一个 get 函数 `get_match_history()`，可以通过输入不同的参数例如 game_mode 来筛选返回的比赛。
但在我测试时，有些输入参数并没有正确的筛选比赛，而且返回的比赛信息太简略，缺少比赛胜负信息，我就没有用这个函数提取比赛数据。
另外插一句，我的文章都发布在统计之都主站（<https://cos.name/>现转移至<https://cosx.org/>）和微信公众号。
一些网站会把文章拿过去作为自己的原创内容，这里稍微测试一下，看看他们的小编是直接复制粘贴，还是也稍微编辑一番。



## 数据提取和处理

### 确定建模目标

数据提取需要服务于建模的目的，即这个模型回答了什么问题。
预测比赛胜负是一个直观明确的目标，但是还需要思考的是，通过哪些信息预测比赛胜负，在什么时候预测比赛胜负，
是进入游戏之前，英雄选择之后，还是游戏进行当中？
我们可以用天辉夜魇双方的击杀数来预测比赛胜负，但是需要注意两点：首先击杀数是随着游戏时间而变化的，
其次击杀数领先的一方有显著更高的几率获胜，特别是游戏进入尾声时，击杀数领先一方几乎都是获胜方，虽然有例外存在。
所以我对用击杀数建模预测胜负的兴趣并不大。

Dota 或者说 MOBA 类游戏可以长盛不衰的魅力就在于英雄的设计，他们各具特色，又相辅相成，不同的英雄给人完全不同的游戏体验。
且我认为 Dota2 的英雄设计不管从丰富，平衡，还是特色的角度看都是最出众的。从 TI6 出场英雄数高达105个就可见一斑：现在 Dota2 总英雄数是113，
除去少数几个当时还不能参加正式联赛的英雄，超过95%的英雄登上了 TI6 的舞台；考虑105取10的组合，这是一个接近3万亿的巨大数字！
所以这次建模，我想纯粹通过英雄选择，来预测比赛胜负。


### 数据提取

首先，我提取了5000场游戏的基本信息，想对比赛数据有一个直观的了解。用到的是我整合后的 R 程序“dota2_data_query.R”，
从 [这里](https://github.com/chengjunhou/Tutorial/blob/master/rdota2/dota2_data_query.R) 查看代码。
用法是指定一条 match_id 给 `mid.a`，和想要提取比赛的总数给 `N`，程序就会自动找到对应的 match_seq_num，然后往后开始提取 `N` 条比赛信息。
最后程序会把所有信息汇总到一个 data.table，并储存在当前工作文件夹下的一个 rds 文件“RDSxxxxxx”里，“xxxxxx”即为 `mid.a`。

因为 Steam 服务器对一段时间内的 API 访问数或者访问数据量有限制（具体不明），
用`get_match_history_by_sequence_num()` 函数以最大值100条提取数据时，很快就会因为达到上限而无法继续，需要等待一段时间再发送请求。
所以在我程序里设置了1次提取数据的数量，目前是10。
总体数据提取效率还可以，10万条大概用时一个小时多一点，当然网络连接速度对用时有很大影响。

回到之前5000场的样本，我们看一下游戏大厅（lobby_type）和游戏模式（game_mode）的分布：


```r
library(data.table)
sample5k = readRDS("rds/5k_sample")
table(sample5k$lobby, sample5k$gmode)
```

```
##    
##        1    2    3    4    5   12   18   20   21   22
##   0    0    6  188  439   21    5   64    5    0 1288
##   1    0    8    1    0    0    0    0    0    1    0
##   4   58    0    0    0    0    0    0    0    0    0
##   7    0   13  230    0    0    0    0    0    0 1243
##   8    0    0    0    0    0    0    0    0   13    0
```

可以看到大多数游戏集中在了公共比赛（lobby_type=0）和排位比赛（lobby_type=7）的排位全阵营模式（game_mode=22）中，
一般全阵营模式（game_mode=1）只出现在与AI的比赛中（lobby_type=4）。
带 Ban/Pick 的队长模式（game_mode=2）只出现在了公共比赛（lobby_type=0），练习赛（lobby_type=1），和排位赛（lobby_type=7）中，
且这8场队长模式练习赛都是联赛（league_id>0）。此外，所有10场练习赛（lobby_type=1）都是联赛（league_id>0）。
然后我决定建模数据只包括，排位赛（lobby_type=22）的全部模式，和练习赛的队长模式（game_mode=2），
因为这些比赛的质量比较有保证，不大会出现消极游戏等情况。
同时要保证每场比赛必须有10位玩家参加。这些筛选条件都已经包含在“dota2_data_query.R”中，可以根据需要自行修改。

为了获得建模数据，我选了5场联赛，它们分别发生在4月30日，4月24日，4月18日，4月12日，和4月6日，然后往后各取了10万条比赛记录。
不用担心会有重复，因为一天内进行的比赛数远远超过了我一开始的猜测。同时这几天也避开了重大的版本更新。
经过筛选后的 rds 文件我分享在了 [这里](https://github.com/chengjunhou/Tutorial/tree/master/rdota2)，
下面的程序可以读取它们，然后我们分别看一下10万场比赛筛选后还剩多少，以及它们发生在多长时间里：


```r
mvec = c(3149572447, 3138232418, 3126514246, 3113809516, 3101804175)
dt = list()
for (i in 1:5) {
  mid.a = mvec[i]
  dt[[i]] = readRDS(paste0("RDS",mid.a))
  dt[[i]] = dt[[i]][order(dt[[i]]$mid),]
 }
sapply(dt, function(x) dim(x)[1])
```

```
## [1] 44610 47251 47156 42472 43906
```

```r
sapply(dt, function(x) max(x$st)-min(x$st)) / 3600
```

```
## [1] 3.863056 4.441667 6.003333 3.206944 4.184722
```

10万条筛选后还剩下4万多，而且发生在了3到6小时内，虽然有极少量被赋予序列号的比赛并没有正式开始，
但保守估计1小时里进行1万场比赛还是有的。
然后画一下游戏时长（分钟）的分布：


```r
library(ggplot2)
ggplot(dt[[1]], aes(duration/60)) + geom_histogram(aes(y = ..density..), binwidth=1)
```

![](rdota2_files/figure-html/unnamed-chunk-9-1.png)<!-- -->


### 数据处理


```r
head(dt[[1]])
```

```
##           mid lobby gmode leagueid  R1 R2 R3  R4 R5 D1  D2  D3  D4  D5
## 1: 3149535257     7    22        0 107 98 70   5 30 74 104  56 110  50
## 2: 3149536656     7    22        0  50  2 42 102 98 93  26  74  90 114
## 3: 3149545061     7    22        0 105 67 53  40 98 75  42  74  11  19
## 4: 3149545128     7    22        0   2 71  4   8  9 40  80 106  97  23
## 5: 3149549011     7    22        0  70 67  9  99  5 41  94  74  33  36
## 6: 3149549590     7    22        0   1 98 14  19  5  9  35  63 114  31
##            st duration Rscore Dscore  Rwin
## 1: 1493577817     5686     68     68 FALSE
## 2: 1493577885     5976     65     52 FALSE
## 3: 1493578262     5998     96    107  TRUE
## 4: 1493578268     5443    100     81  TRUE
## 5: 1493578411     4888     73     62  TRUE
## 6: 1493578432     5138     62     83  TRUE
```

在提取的数据中，天辉的英雄选择放在了“R1”到“R5”，夜魇则是“D1”到“D5”。
但是这里的1到5并不是1到5号位，相反1到5之间并没有次序关系，即使它们之间相互交换内容，也不应该对建模结果造成影响。
所以需要用下面的代码进一步处理数据。在处理之前游戏时长少于15分钟的比赛会被剔除。


```r
MRD = list()
for (i in 1:5) {
  mid.a = mvec[i]
  dt[[i]] = dt[[i]][dt[[i]]$duration>=900,]
  # radiant info
  dt.m = reshape2::melt(dt[[i]][,c("mid","R1","R2","R3","R4","R5"),with=F],id="mid")
  mx = as.matrix(table(dt.m$mid, dt.m$value))
  colnames(mx) = paste0("R",colnames(mx))
  MRD[[i]] = mx[order(rownames(mx)),]
  # dire info
  dt.m = reshape2::melt(dt[[i]][,c("mid","D1","D2","D3","D4","D5"),with=F],id="mid")
  mx = as.matrix(table(dt.m$mid, dt.m$value))
  colnames(mx) = paste0("D",colnames(mx))
  # summarize
  gtype = rep(NA, dim(dt[[i]])[1])
  gtype[dt[[i]]$lobby==1&dt[[i]]$gmode==2] = "PRO"
  gtype[dt[[i]]$lobby==7&dt[[i]]$gmode==2] = "RCM"
  gtype[dt[[i]]$lobby==7&dt[[i]]$gmode==22] = "RAP"
  gtype[dt[[i]]$lobby==7&dt[[i]]$gmode==3] = "RRD"
  gtype = model.matrix(~.-1,data=data.frame(gtype))
  # combine
  MRD[[i]] = cbind(MRD[[i]], mx[order(rownames(mx)),])
  MRD[[i]] = cbind(MRD[[i]], gtype)
  MRD[[i]] = cbind(MRD[[i]], dt[[i]]$duration, as.integer(dt[[i]]$Rwin))
  colnames(MRD[[i]])[(dim(MRD[[i]])[2]-1):(dim(MRD[[i]])[2])] = c("duration","Rwin")
}
head(MRD[[1]][,c(1,2,112,113,114,115,225,226)])
```

```
##            R1 R2 R113 R114 D1 D2 D113 D114
## 3149535257  0  0    0    0  0  0    0    0
## 3149536656  0  1    0    0  0  0    0    1
## 3149545061  0  0    0    0  0  0    0    0
## 3149545128  0  1    0    0  0  0    0    0
## 3149549011  0  0    0    0  0  0    0    0
## 3149549590  1  0    0    0  0  0    0    1
```

可以看到处理之后的数据，如果天辉方选择了编号为2的英雄，那么“R2”这个位置就会为1，反之为0。
显然，每一行（一场比赛）代表英雄选择的0/1加起来一定是10。游戏大厅和游戏模式的信息我也总结了一下，放在 `gtype` 里。
除此之外我还加入了游戏时长，虽然这个信息在比赛开始之前并不能获知，但 Dota2 里英雄的作用随着游戏时间有着巨大的变化。
不同英雄组成的阵容有明显不同的强势弱势时期，获胜的基本策略之一就是在敌人强势时期避免作战，在己方强势时期结束比赛。

现在建模的脉络就很清晰了，自变量包括天辉英雄选择，夜魇英雄选择，游戏模式和时长，因变量是天辉是否获胜。
我还想过把1条数据变成2条来建模，即自变量为己方阵容，因变量为己方是否获胜。
但是如果这样处理，英雄阵容之间的克制关系就不能反映出来了，所以作罢。



## 建模及结果

处理之后的数据 `MRD` 中 ，我选出第3个，即4月18日为起点提取的数据，作为验证数据（holdout），大概占总数据的20%，其余的作为训练数据（train）。


```r
mrd = rbind(MRD[[1]], MRD[[2]], MRD[[4]], MRD[[5]])
vrd = MRD[[3]]
```

不过在建模之前我还想介绍一个常用比较二元（binary）分类模型性能的参数 AUC（area-under-curve）。


### 模型性能参数 AUC

“天辉是否获胜”是一个典型的二元分类问题，可以用正确率来衡量这类问题的预测结果，但存在一些问题。
比如说100条记录里，真实的“是”（Yes/1）有20条，“否”（No/0）有80条。那么即使我们不做任何预测，直接标记所有100条记录为“否”，也有80%的正确率。
此时真实“是”里被标记正确的比例（true-positive-rate）为0%，真实“否”里被标记错误的比例也为（false-positive-rate）0%。
如果标记所有记录为“是”，那么这两个比例分别为100%和100%。
而一个完美的模型，即正确标记20条“是”记录和80条“否”记录的模型，给出的 true-positive-rate 为100%，false-positive-rate 为0%。

大多数二元分类模型给出的预测量是记录为“是”的概率，一个0和1之间的连续值。
所以需要建模者额外指定一个分界值，预测概率大于这个值的记录会被标记为“是”，反之为“否”。
而 AUC 描述的就是，针对不同的分界值，模型尽早挑出正确的“是”同时避免错误“否”的能力。
AUC（area-under-curve）顾名思义就是曲线下的面积，而这条被称为 ROC 曲线的绘制方法是：
把记录按预测概率从大到小排列，每个预测概率作为分界值时都会有与之对应的 true-positive-rate 和 false-positive-rate，
以 false-positive-rate 作为横轴，true-positive-rate 作为纵轴绘制点，即可得到 ROC 曲线。
比如预测概率从大到小排列为(0.92, 0.87, 0.76, 0.73, 0.68, 0.67, 0.64, 0.55, 0.43, 0.39)，
真实值为(1, 1, 1, 1, 0, 0, 1, 0, 0, 0), 相应的 ROC 为下边左图：


```r
library(ROCR)
roc1 = performance(prediction(c(0.92, 0.87, 0.76, 0.73, 0.68, 0.67, 0.64, 0.55, 0.43, 0.39), 
                              c(1, 1, 1, 1, 0, 0, 1, 0, 0, 0)), measure = "tpr", x.measure = "fpr")
roc2 = performance(prediction(c(0.92, 0.87, 0.76, 0.73, 0.68, 0.67, 0.64, 0.55, 0.43, 0.39), 
                              c(1, 0, 1, 0, 1, 0, 1, 0, 1, 0)), measure = "tpr", x.measure = "fpr")
par(mfrow=c(1,2))
plot(roc1, type="o")
plot(roc2, type="o")
```

![](rdota2_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

右图是随机预测时产生的 ROC。记录点多了之后，左边 ROC 就变为一条曲线，右边 ROC 就是(0, 0)到(1, 1)的对角线。
如果是完美的模型，那么 ROC 会从(0, 0)直接上升到(1, 0)，再向右至(1, 1)。
完美模型 ROC 下的面积就是这个边长为1的正方形的面积，随机模型 ROC 即对角线之下的面积为0.5，所以一般模型 AUC 在0.5和1之间。
简单讲，模型 AUC 在0.8以上即被认为具有相当好的预测性能，0.6到0.8之间意味着数据具有一定的可预测性。
没什么预测能力的模型 AUC 会接近0.5，如果遇到小于0.5的情况，那应该是在处理数据或者建模的时候发生了错误。


### naiveBayes 模型

首先我决定用 naiveBayes 模型尝试只用英雄信息建模。naiveBayes 的核心是条件概率：首先计算训练数据里天辉获胜的总体概率，
然后计算天辉获胜时各英雄的分布情况，再由条件概率得到选了某几个英雄时天辉获胜的概率。
模型特点是简单，不用调试任何参数，不容易过拟合，计算效率高。它在文本分析/情感分析方面被证实效果还是不错的：
Dota2 英雄的数量只有124，1篇文章里面独特的字/词数可就多了，需要一个高效的算法处理这些信息。
下面的代码就完成了 naiveBayes 模型拟合，然后分别预测 train 和 holdout 并计算 AUC。 


```r
library(e1071)
nb_tr <- naiveBayes(x=mrd[,-c(227:232)], y=mrd[,232])
trY_nb = predict(nb_tr, mrd[,-c(227:232)], type="raw")[,2]
ooY_nb = predict(nb_tr, vrd[,-c(227:232)], type="raw")[,2]
roc_trY = prediction(trY_nb, mrd[,232])
roc_ooY = prediction(ooY_nb, vrd[,232])
c(train = performance(roc_trY, measure="auc")@y.values[[1]],
  holdout = performance(roc_ooY, measure="auc")@y.values[[1]])
```

```
##     train   holdout 
## 0.6041896 0.5912212
```

可以看到两个 AUC 非常接近，说明没有发生过拟合。
而且 ACU 接近0.6，表明英雄选择对比赛胜负还是有一定影响的。


### gradient-boosting-machine 模型

然后我决定用 gradient-boosting-machine（GBM）模型，对所有信息进行建模。 
GBM 的核心是树状模型（tree-based model），它与 random forest 最大的不同就在于，
random forest 里每一个树都是相对独立的，而 GBM 的单个树状模型是基于上一个树的拟合结果而建立的，是一个渐进过程。
在一个分类（classification）GBM 迭代过程中，当前的树模型会集中关注造成过往树模型分类错误的数据，目标就是更进一步提高模型预测的准确度。
这就使得 GBM 往往可以把衡量模型预测能力的一些指标推到一个非常高的程度，让它在很多建模比赛里拔得头筹。
GBM 最大的问题就是很容易发生过度拟合（over-fitting），所以需要反复调试拟合参数。

建模用到 R package xgboost，是现在最好用的拟合 GBM 软件包，R/Python/Java都有各自版本，特点是提供了非常多可供调试的参数，拟合效率高。
模型参数通过交叉验证调整得到，具体的过程就不介绍了，这里只给出调整后的参数：


```r
library(xgboost)
xgb_params_1 = list(
  objective = "binary:logistic",             # binary classification
  eta = 0.42,                                # learning rate
  max.depth = 6,                             # max tree depth
  eval_metric = "error"                      # evaluation/loss metric
)
xgb_tr = xgboost(data = mrd[,-232], label = mrd[,232],
                 params = xgb_params_1,
                 nrounds = 68,               # max number of trees
                 early_stopping_rounds = 12, # stop if no improvement
                 nthread = 8,
                 verbose = TRUE,                                         
                 print_every_n = 1
)
trY = predict(xgb_tr, mrd[,-232])
roc_trY = prediction(trY, mrd[,232])
ooY = predict(xgb_tr, vrd[,-232])
roc_ooY = prediction(ooY, vrd[,232])
c(train = performance(roc_trY, measure="auc")@y.values[[1]],
  holdout = performance(roc_ooY, measure="auc")@y.values[[1]])
```

```
##     train   holdout 
## 0.7289853 0.6484574
```

可以看到 train AUC 明显高于 holdout AUC，说明存在一些过拟合。
但其实用 GBM 建模或多或少都会存在一些过拟合，只要拟合迭代时 holdout error 没有先下降然后开始明显上升，那都是可以接受的。
同时 holdout AUC 达到了0.65，比之前有明显提升。因为模型给出的预测是天辉获胜的概率，所以需要指定一个分界值，决定哪些比赛可以预测为天辉胜利。
这批数据里天辉获胜几率（53.6%）略高于夜魇（46.4%），所以0.5作为分解值是并不是最合适的。
我们可以在 train 预测值上调整分界值，目标是最大化 train 上的预测正确率。
调整后的分界值为0.51，此时 train 上正确率是66.4%，holdout 上正确率是60.5%。


```r
# train actual win rate
table(mrd[,232])/length(trY)
```

```
## 
##         0         1 
## 0.4641332 0.5358668
```

```r
# holdout prediction accuracy
confmx = as.matrix(table(ooY>=0.51, vrd[,232])/length(ooY))
confmx[1,1] + confmx[2,2]
```

```
## [1] 0.6049084
```

然后还可以提取模型的变量重要度排行。下面给出排行前列的几个变量。
第一列是变量，第二列 `Gain` 是指该变量给模型带来正确率提升的占比，
`Cover` 和 `Frequency` 分别指在所有树结构模型中，由该变量区分的数据占比，和变量使用次数占比。
可以看到，游戏时长是排行第一的变量，但它肯定是与英雄选择相互发生作用（interaction）来提高模型预测能力的。
之后的变量就都是英雄选择了，有趣的是，排行高的几个英雄都是成对出现的，说明他们对模型预测能力的提高作用是稳定的，不管在出现在天辉方还是夜魇方。


```r
imp.mat <- xgb.importance(feature_names=colnames(mrd), model=xgb_tr)
imp.mat[1:19, ]
```

```
##      Feature        Gain       Cover   Frequency
##  1: duration 0.227688763 0.060770796 0.254714244
##  2:       R1 0.026870650 0.003792105 0.009863650
##  3:      D67 0.025435243 0.011213101 0.008123006
##  4:       D1 0.023355898 0.003844770 0.013344938
##  5:      R67 0.022864301 0.009683906 0.006672469
##  6:      R74 0.018455103 0.002057769 0.015085582
##  7:     R114 0.016838178 0.007829966 0.007252683
##  8:     D114 0.014348216 0.008087355 0.004061503
##  9:      D74 0.014201942 0.003115250 0.010443864
## 10:      D93 0.013244021 0.001380625 0.011604294
## 11:      R36 0.013032265 0.006278652 0.008123006
## 12:      D42 0.011977432 0.008374766 0.005802147
## 13:       R2 0.011327917 0.012955063 0.006382361
## 14:      R42 0.011086417 0.010314060 0.006962576
## 15:      R93 0.010629432 0.002912086 0.009573542
## 16:      D36 0.010243000 0.007596881 0.007252683
## 17:       D2 0.010004687 0.008047376 0.010733972
## 18:      D32 0.009754152 0.008742571 0.006382361
## 19:      R32 0.009720471 0.011873393 0.006382361
```

接着让我们看一下这些英雄都是谁吧。敌法师，幽鬼，两大后期是头两名。
之后出现了祈求者，齐天大圣，斯拉克，并不意外，天梯比赛里敢选出来应该都是绝活吧。
需要注意的是，这个排名针对的是变量在模型中的预测能力，
这里很难分析出单独某个英雄对比赛胜负是正面还是负面作用，因为树模型中的变量都是互相影响着发挥作用的。
比如说祈求者和力丸搭配胜率很高，如果队伍中同时出现敌法师和幽鬼那基本就别想赢了。
另外还有游戏时长这个重要变量，敌法师和幽鬼这种大后期的胜率是随着游戏时长增加而显著提高的。


```r
sapply(c(1, 67, 74, 114, 93, 36, 42, 2, 32), 
       function(x) hero.df$localized_name[hero.df$id==x])
```

```
## [1] "敌法师"   "幽鬼"     "祈求者"   "齐天大圣" "斯拉克"   "瘟疫法师"
## [7] "冥魂大帝" "斧王"     "力丸"
```

![](https://cloud.githubusercontent.com/assets/11251354/26287702/050bbea6-3e4f-11e7-900c-4f2aa4ab1a35.JPG)  
还是祈求者最上相


### 模型总结

除了上述模型，我还试了 python 的深度学习 package Keras，效果并不理想。
GBM 模型0.65的 AUC，和略高于60%的正确率还是让人满意的。
因为除了英雄选择，影响一场比赛胜负的因素实在太多了，有的甚至发生在游戏之外。
如果选了某几个英雄就有很大几率赢得比赛，那么只能说这个游戏在英雄设计上是有巨大问题的，游戏也会因缺少跌宕起伏而乏味。
之前看到过一篇文章比较了 Dota2 和英雄联盟的不同，里面提到了 Dota2 地图从相对位移来说明显大于 lol，更大地图意味着更多变数。
同时 Dota2 更复杂的视野机制，物品，野怪等等，都给比赛增加了更多的不确定因素。
而韩国人在英雄联盟独领风骚的诀窍之一就在于对游戏进程的精准把握，什么时间该干什么都精确到秒，但这些都必须基于一个较稳定的系统。
面对 Dota2，这一套就不那么好使了，所以韩国战队在 Dota2 比赛里一直被各支中国队伍花式吊打。

但是话又说回来，游戏越复杂，推广起来就越不容易。好了，就写到这里。
在我写这篇文章的时候，统计之都正在清华举办第十届中国R会。
通过统计之都，我认识了很多优秀的朋友，在这里也获益良多，所以祝统计之都越办越好，也期待更多人的加入！








