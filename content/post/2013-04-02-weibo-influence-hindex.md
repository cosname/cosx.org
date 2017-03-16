---
title: 微博用户影响力评价的H-Index指数
date: '2013-04-02T20:06:46+00:00'
author: Liyun
categories:
  - 数据挖掘与机器学习
  - 统计图形
tags:
  - H-index指数
  - Rweibo
  - SNS
  - 微博用户影响力
  - 新浪微博
  - 社交网络
slug: weibo-influence-hindex
---

H-index其实更广泛的应用于学术论文评价，其定义为：

> h代表“高引用次数”（high citations），一名科研人员的h指数是指他至多有h篇论文分别被引用了至少h次。

约在半年前，小编就和一位老师打趣地说这东西能不能用于评价微博用户的影响力。定义相应可以改为：

> 一名微博用户的h指数是指他至多有h个粉丝数超过h的粉丝。

怎奈后来抓数据奇慢无比，遂放弃。

转过年来，春天都到了，Rweibo这个包也出来好久了，不动手试试多少有点痒痒。新浪微博的API对于测试帐号限制较多，一小时只有150次请求机会。唉，只能无耻的多帐号多API一个个抓。就算这样，到最后在有限的时间之内小编也只成功的抓取了一百多个用户的信息，勉强绘就了一张微博的H-index指数与粉丝数的关系图。

当然，一切的第一步自然是以小编自己的帐号为测试中心。前段时间涨了不少粉丝，貌似却不怎么互动。所以小编有理由认为自己的H-index可能偏低。结果证明，在小编的近1100粉丝之中，只有287人的粉丝数超过了287。这样，小编的H-index就华丽丽的定格在287了。

然后小编好奇呀，那些跟我差不多的人，他们的情况是怎么样呢？于是从自己的粉丝中（我只能直接影响到这些人嘛）上下选了一下，粉丝数>500且小于2000的显然是个不错的对比范围(受限于新浪微博API的控制，力不从心呀）。

不一会儿，数据抓完了。然后算算H-index，就有了下面这张图：

<figure id="attachment_7583" style="width: 875px" class="wp-caption aligncenter">[<img class=" wp-image-7583 " alt="新浪微博用户影响力H-index指数(点击大图)" src="http://cos.name/wp-content/uploads/2013/03/h_index_result.png" width="875" height="509" srcset="http://cos.name/wp-content/uploads/2013/03/h_index_result.png 875w, http://cos.name/wp-content/uploads/2013/03/h_index_result-300x174.png 300w, http://cos.name/wp-content/uploads/2013/03/h_index_result-500x290.png 500w" sizes="(max-width: 875px) 100vw, 875px" />](http://cos.name/wp-content/uploads/2013/03/h_index_result.png)<figcaption class="wp-caption-text">新浪微博用户影响力H-index指数(点击大图)</figcaption></figure>
  
<!--more-->


  
巧的或者不巧的，小编我正好在线性回归线上面。标准用户呀！然后一橫一竖，就可以分出来跟我相比的四群人：

  * 左上：粉丝<1095但h-index大于287。这群人得好好关注呀，高质量的圈子！
  * 左下：粉丝<1095且>=500,h-index小于287。不过大部分人还是在回归线附近的，所以大家发展趋势还是很好的。那些远远甩开回归线的，是新来的童鞋呢还是僵尸粉呢？
  * 右上：粉丝>1095且H-index>287，不用说了，大牛云集的区域！各种羡慕。
  * 右下：粉丝>1095但H-index<287。喂，那些离回归线远远的童鞋，你们是不是买僵尸粉啦？坦白从宽哦。虽然新浪不一定检测的出来你的僵尸粉，但是你们的嫌疑大大滴！比如那个“xx书友会”，哼你关注我的第一天我就开始怀疑你了，一直苦无证据，如今，嘻嘻&#8230;

&#8212;&#8212;&#8212;&#8212;碎碎念的细节&#8212;&#8212;&#8212;-
  
1. 新浪微博的API如果只是自己玩玩，还是比较好用的，至少比爬虫要快一点点&#8230;而且权限稍微大一点点（比如粉丝可以抓全而不用受限于显示页面）。
  
2. 如果希望抓全粉丝，就不能用[friendships/followers](http://open.weibo.com/wiki/2/friendships/followers "2/friendships/followers") 而是要用直接抓ID的[friendships/followers/ids](http://open.weibo.com/wiki/2/friendships/followers/ids "2/friendships/followers/ids").
  
3. 其实可以递归的继续定义高阶H-index，比如二阶，定义为有h2个粉丝的（一阶）h-index大于h2&#8230;对于粉丝动辄过万的大V来说，递归几次可能更有意思。吾等小玩意儿就不用了。
  
4.然后附上这张图的原始数据&#8230;大家的微博ID我就不隐藏了，都可以直接搜到&#8230;按h-index指数排序哦。

<table>
  <tr>
    <td>
      weibo_name
    </td>
    
    <td>
      followers_count
    </td>
    
    <td>
      h-index
    </td>
  </tr>
  
  <tr>
    <td>
      崔婧Janet
    </td>
    
    <td>
      1534
    </td>
    
    <td>
      634
    </td>
  </tr>
  
  <tr>
    <td>
      Gideon_Ge
    </td>
    
    <td>
      1682
    </td>
    
    <td>
      515
    </td>
  </tr>
  
  <tr>
    <td>
      数据逻辑
    </td>
    
    <td>
      1663
    </td>
    
    <td>
      508
    </td>
  </tr>
  
  <tr>
    <td>
      blogkid
    </td>
    
    <td>
      1409
    </td>
    
    <td>
      448
    </td>
  </tr>
  
  <tr>
    <td>
      董友良_飘香一剑
    </td>
    
    <td>
      1334
    </td>
    
    <td>
      436
    </td>
  </tr>
  
  <tr>
    <td>
      数据鱼_谢宇
    </td>
    
    <td>
      1887
    </td>
    
    <td>
      425
    </td>
  </tr>
  
  <tr>
    <td>
      黠之大者
    </td>
    
    <td>
      1706
    </td>
    
    <td>
      420
    </td>
  </tr>
  
  <tr>
    <td>
      bicloud笑西西
    </td>
    
    <td>
      1352
    </td>
    
    <td>
      407
    </td>
  </tr>
  
  <tr>
    <td>
      super00011127
    </td>
    
    <td>
      1270
    </td>
    
    <td>
      380
    </td>
  </tr>
  
  <tr>
    <td>
      MINI金石头
    </td>
    
    <td>
      1803
    </td>
    
    <td>
      378
    </td>
  </tr>
  
  <tr>
    <td>
      长颈鹿27
    </td>
    
    <td>
      1106
    </td>
    
    <td>
      362
    </td>
  </tr>
  
  <tr>
    <td>
      G_will
    </td>
    
    <td>
      1113
    </td>
    
    <td>
      360
    </td>
  </tr>
  
  <tr>
    <td>
      Sevennick
    </td>
    
    <td>
      1357
    </td>
    
    <td>
      348
    </td>
  </tr>
  
  <tr>
    <td>
      Leo在梧桐山下
    </td>
    
    <td>
      642
    </td>
    
    <td>
      344
    </td>
  </tr>
  
  <tr>
    <td>
      王昕-CALL谁谁OFFER
    </td>
    
    <td>
      1090
    </td>
    
    <td>
      339
    </td>
  </tr>
  
  <tr>
    <td>
      波波头一头
    </td>
    
    <td>
      1216
    </td>
    
    <td>
      337
    </td>
  </tr>
  
  <tr>
    <td>
      晓帆目标130斤
    </td>
    
    <td>
      806
    </td>
    
    <td>
      329
    </td>
  </tr>
  
  <tr>
    <td>
      科隆王子Original
    </td>
    
    <td>
      1139
    </td>
    
    <td>
      327
    </td>
  </tr>
  
  <tr>
    <td>
      指间战争
    </td>
    
    <td>
      989
    </td>
    
    <td>
      326
    </td>
  </tr>
  
  <tr>
    <td>
      小刚C
    </td>
    
    <td>
      898
    </td>
    
    <td>
      311
    </td>
  </tr>
  
  <tr>
    <td>
      谢益辉
    </td>
    
    <td>
      1511
    </td>
    
    <td>
      311
    </td>
  </tr>
  
  <tr>
    <td>
      安泰科宏观部
    </td>
    
    <td>
      1133
    </td>
    
    <td>
      310
    </td>
  </tr>
  
  <tr>
    <td>
      jia华_伪学术
    </td>
    
    <td>
      664
    </td>
    
    <td>
      305
    </td>
  </tr>
  
  <tr>
    <td>
      老马-InSydney
    </td>
    
    <td>
      849
    </td>
    
    <td>
      301
    </td>
  </tr>
  
  <tr>
    <td>
      洛川有机好苹果
    </td>
    
    <td>
      1082
    </td>
    
    <td>
      297
    </td>
  </tr>
  
  <tr>
    <td>
      P-Jackie
    </td>
    
    <td>
      967
    </td>
    
    <td>
      296
    </td>
  </tr>
  
  <tr>
    <td>
      身边汇康康
    </td>
    
    <td>
      1253
    </td>
    
    <td>
      295
    </td>
  </tr>
  
  <tr>
    <td>
      pepsidav
    </td>
    
    <td>
      785
    </td>
    
    <td>
      292
    </td>
  </tr>
  
  <tr>
    <td>
      jiangfeng_scir
    </td>
    
    <td>
      871
    </td>
    
    <td>
      285
    </td>
  </tr>
  
  <tr>
    <td>
      王函大帆船
    </td>
    
    <td>
      929
    </td>
    
    <td>
      284
    </td>
  </tr>
  
  <tr>
    <td>
      万幸_Wonder
    </td>
    
    <td>
      746
    </td>
    
    <td>
      282
    </td>
  </tr>
  
  <tr>
    <td>
      cloud_wei
    </td>
    
    <td>
      965
    </td>
    
    <td>
      279
    </td>
  </tr>
  
  <tr>
    <td>
      数据挖掘racoon
    </td>
    
    <td>
      737
    </td>
    
    <td>
      278
    </td>
  </tr>
  
  <tr>
    <td>
      DATA309
    </td>
    
    <td>
      846
    </td>
    
    <td>
      277
    </td>
  </tr>
  
  <tr>
    <td>
      左根永
    </td>
    
    <td>
      690
    </td>
    
    <td>
      277
    </td>
  </tr>
  
  <tr>
    <td>
      猎头王俊宏
    </td>
    
    <td>
      925
    </td>
    
    <td>
      275
    </td>
  </tr>
  
  <tr>
    <td>
      林小妖系小球童
    </td>
    
    <td>
      700
    </td>
    
    <td>
      274
    </td>
  </tr>
  
  <tr>
    <td>
      rxjia
    </td>
    
    <td>
      942
    </td>
    
    <td>
      272
    </td>
  </tr>
  
  <tr>
    <td>
      lijian001
    </td>
    
    <td>
      1387
    </td>
    
    <td>
      271
    </td>
  </tr>
  
  <tr>
    <td>
      大雁_sysu
    </td>
    
    <td>
      627
    </td>
    
    <td>
      271
    </td>
  </tr>
  
  <tr>
    <td>
      汪琨1987
    </td>
    
    <td>
      1054
    </td>
    
    <td>
      270
    </td>
  </tr>
  
  <tr>
    <td>
      许亮_在路上
    </td>
    
    <td>
      914
    </td>
    
    <td>
      268
    </td>
  </tr>
  
  <tr>
    <td>
      TT小和子
    </td>
    
    <td>
      742
    </td>
    
    <td>
      264
    </td>
  </tr>
  
  <tr>
    <td>
      TerryMANG
    </td>
    
    <td>
      931
    </td>
    
    <td>
      262
    </td>
  </tr>
  
  <tr>
    <td>
      李响_ICT_NLP
    </td>
    
    <td>
      656
    </td>
    
    <td>
      261
    </td>
  </tr>
  
  <tr>
    <td>
      李直
    </td>
    
    <td>
      840
    </td>
    
    <td>
      252
    </td>
  </tr>
  
  <tr>
    <td>
      AnnaPatio
    </td>
    
    <td>
      641
    </td>
    
    <td>
      252
    </td>
  </tr>
  
  <tr>
    <td>
      七桃ple
    </td>
    
    <td>
      853
    </td>
    
    <td>
      249
    </td>
  </tr>
  
  <tr>
    <td>
      william_ou
    </td>
    
    <td>
      720
    </td>
    
    <td>
      249
    </td>
  </tr>
  
  <tr>
    <td>
      雁起平沙
    </td>
    
    <td>
      675
    </td>
    
    <td>
      243
    </td>
  </tr>
  
  <tr>
    <td>
      上海芒果商务咨询
    </td>
    
    <td>
      1472
    </td>
    
    <td>
      243
    </td>
  </tr>
  
  <tr>
    <td>
      叶茂亮
    </td>
    
    <td>
      592
    </td>
    
    <td>
      243
    </td>
  </tr>
  
  <tr>
    <td>
      Jordi_Liang
    </td>
    
    <td>
      637
    </td>
    
    <td>
      239
    </td>
  </tr>
  
  <tr>
    <td>
      天天向上的胖子
    </td>
    
    <td>
      671
    </td>
    
    <td>
      238
    </td>
  </tr>
  
  <tr>
    <td>
      爱宇直-抠脚不闻非君子
    </td>
    
    <td>
      748
    </td>
    
    <td>
      238
    </td>
  </tr>
  
  <tr>
    <td>
      邓一硕
    </td>
    
    <td>
      804
    </td>
    
    <td>
      236
    </td>
  </tr>
  
  <tr>
    <td>
      月亮先生Zsir
    </td>
    
    <td>
      381
    </td>
    
    <td>
      236
    </td>
  </tr>
  
  <tr>
    <td>
      taishanfan
    </td>
    
    <td>
      729
    </td>
    
    <td>
      233
    </td>
  </tr>
  
  <tr>
    <td>
      智博是老青年
    </td>
    
    <td>
      1005
    </td>
    
    <td>
      224
    </td>
  </tr>
  
  <tr>
    <td>
      ivanlauCOM
    </td>
    
    <td>
      679
    </td>
    
    <td>
      222
    </td>
  </tr>
  
  <tr>
    <td>
      Puriney
    </td>
    
    <td>
      1180
    </td>
    
    <td>
      218
    </td>
  </tr>
  
  <tr>
    <td>
      陈筱歪
    </td>
    
    <td>
      1025
    </td>
    
    <td>
      215
    </td>
  </tr>
  
  <tr>
    <td>
      百变小倩1314
    </td>
    
    <td>
      863
    </td>
    
    <td>
      214
    </td>
  </tr>
  
  <tr>
    <td>
      达斯托洛夫斯基
    </td>
    
    <td>
      661
    </td>
    
    <td>
      213
    </td>
  </tr>
  
  <tr>
    <td>
      Deer一只鹿
    </td>
    
    <td>
      1070
    </td>
    
    <td>
      208
    </td>
  </tr>
  
  <tr>
    <td>
      Delphiyeh
    </td>
    
    <td>
      898
    </td>
    
    <td>
      206
    </td>
  </tr>
  
  <tr>
    <td>
      飞鱼姬Sindy
    </td>
    
    <td>
      417
    </td>
    
    <td>
      202
    </td>
  </tr>
  
  <tr>
    <td>
      mlzboy
    </td>
    
    <td>
      1252
    </td>
    
    <td>
      200
    </td>
  </tr>
  
  <tr>
    <td>
      top糊涂虫
    </td>
    
    <td>
      441
    </td>
    
    <td>
      199
    </td>
  </tr>
  
  <tr>
    <td>
      爱美丽高
    </td>
    
    <td>
      670
    </td>
    
    <td>
      196
    </td>
  </tr>
  
  <tr>
    <td>
      罗小妮_focus
    </td>
    
    <td>
      467
    </td>
    
    <td>
      195
    </td>
  </tr>
  
  <tr>
    <td>
      thinkfan
    </td>
    
    <td>
      619
    </td>
    
    <td>
      191
    </td>
  </tr>
  
  <tr>
    <td>
      無限追云
    </td>
    
    <td>
      438
    </td>
    
    <td>
      191
    </td>
  </tr>
  
  <tr>
    <td>
      默尔根
    </td>
    
    <td>
      454
    </td>
    
    <td>
      189
    </td>
  </tr>
  
  <tr>
    <td>
      黎胖
    </td>
    
    <td>
      373
    </td>
    
    <td>
      188
    </td>
  </tr>
  
  <tr>
    <td>
      发现神回复_Denny
    </td>
    
    <td>
      400
    </td>
    
    <td>
      184
    </td>
  </tr>
  
  <tr>
    <td>
      忙碌的灵麟
    </td>
    
    <td>
      855
    </td>
    
    <td>
      184
    </td>
  </tr>
  
  <tr>
    <td>
      谭卫国Forest
    </td>
    
    <td>
      619
    </td>
    
    <td>
      180
    </td>
  </tr>
  
  <tr>
    <td>
      乐美家的乐子
    </td>
    
    <td>
      785
    </td>
    
    <td>
      180
    </td>
  </tr>
  
  <tr>
    <td>
      刘坤林Jason
    </td>
    
    <td>
      617
    </td>
    
    <td>
      179
    </td>
  </tr>
  
  <tr>
    <td>
      omgpumelo
    </td>
    
    <td>
      652
    </td>
    
    <td>
      179
    </td>
  </tr>
  
  <tr>
    <td>
      sirius
    </td>
    
    <td>
      486
    </td>
    
    <td>
      176
    </td>
  </tr>
  
  <tr>
    <td>
      Fancy_zju
    </td>
    
    <td>
      488
    </td>
    
    <td>
      175
    </td>
  </tr>
  
  <tr>
    <td>
      晨曦彩虹
    </td>
    
    <td>
      740
    </td>
    
    <td>
      173
    </td>
  </tr>
  
  <tr>
    <td>
      田宪允
    </td>
    
    <td>
      588
    </td>
    
    <td>
      171
    </td>
  </tr>
  
  <tr>
    <td>
      对半切开的奇异果
    </td>
    
    <td>
      1106
    </td>
    
    <td>
      167
    </td>
  </tr>
  
  <tr>
    <td>
      八爪鱼Rainie
    </td>
    
    <td>
      485
    </td>
    
    <td>
      164
    </td>
  </tr>
  
  <tr>
    <td>
      唐吉_诃德
    </td>
    
    <td>
      607
    </td>
    
    <td>
      162
    </td>
  </tr>
  
  <tr>
    <td>
      can_sunny
    </td>
    
    <td>
      734
    </td>
    
    <td>
      159
    </td>
  </tr>
  
  <tr>
    <td>
      LeprechaunTon
    </td>
    
    <td>
      478
    </td>
    
    <td>
      157
    </td>
  </tr>
  
  <tr>
    <td>
      女鬼小倩
    </td>
    
    <td>
      554
    </td>
    
    <td>
      153
    </td>
  </tr>
  
  <tr>
    <td>
      Nefeli要过正常人的生活
    </td>
    
    <td>
      602
    </td>
    
    <td>
      146
    </td>
  </tr>
  
  <tr>
    <td>
      猪头开Lucas
    </td>
    
    <td>
      403
    </td>
    
    <td>
      140
    </td>
  </tr>
  
  <tr>
    <td>
      elemenTY
    </td>
    
    <td>
      690
    </td>
    
    <td>
      139
    </td>
  </tr>
  
  <tr>
    <td>
      彤言彤趣
    </td>
    
    <td>
      577
    </td>
    
    <td>
      136
    </td>
  </tr>
  
  <tr>
    <td>
      左后卫左后卫
    </td>
    
    <td>
      377
    </td>
    
    <td>
      136
    </td>
  </tr>
  
  <tr>
    <td>
      soulwangh
    </td>
    
    <td>
      414
    </td>
    
    <td>
      136
    </td>
  </tr>
  
  <tr>
    <td>
      不动点-
    </td>
    
    <td>
      432
    </td>
    
    <td>
      133
    </td>
  </tr>
  
  <tr>
    <td>
      Gossip_Nathen
    </td>
    
    <td>
      425
    </td>
    
    <td>
      133
    </td>
  </tr>
  
  <tr>
    <td>
      我是小志童鞋
    </td>
    
    <td>
      1271
    </td>
    
    <td>
      126
    </td>
  </tr>
  
  <tr>
    <td>
      yangleicq
    </td>
    
    <td>
      320
    </td>
    
    <td>
      124
    </td>
  </tr>
  
  <tr>
    <td>
      nsol
    </td>
    
    <td>
      397
    </td>
    
    <td>
      115
    </td>
  </tr>
  
  <tr>
    <td>
      毛毛虫_Oak
    </td>
    
    <td>
      618
    </td>
    
    <td>
      112
    </td>
  </tr>
  
  <tr>
    <td>
      心卧缘
    </td>
    
    <td>
      323
    </td>
    
    <td>
      111
    </td>
  </tr>
  
  <tr>
    <td>
      十九向日葵
    </td>
    
    <td>
      1371
    </td>
    
    <td>
      110
    </td>
  </tr>
  
  <tr>
    <td>
      codememory
    </td>
    
    <td>
      385
    </td>
    
    <td>
      110
    </td>
  </tr>
  
  <tr>
    <td>
      薛定谔的粥稀稀
    </td>
    
    <td>
      357
    </td>
    
    <td>
      100
    </td>
  </tr>
  
  <tr>
    <td>
      雪中炭忐d
    </td>
    
    <td>
      662
    </td>
    
    <td>
      88
    </td>
  </tr>
  
  <tr>
    <td>
      Preec
    </td>
    
    <td>
      314
    </td>
    
    <td>
      87
    </td>
  </tr>
  
  <tr>
    <td>
      呼和浩特书友会
    </td>
    
    <td>
      1298
    </td>
    
    <td>
      65
    </td>
  </tr>
</table>

最后附上一段短小精悍的代码。lijian哥的Rweibo包真是给力！

<div style="line-height:19.5px">
</div>
