---
title: WinBUGS在统计分析中的应用（第四部分）
date: '2009-06-29T14:15:13+00:00'
author: 齐韬
categories:
  - 统计图形
  - 统计软件
  - 贝叶斯方法
tags:
  - ArcInfo
  - GeoBUGS
  - R语言
  - WinBUGS
  - 中国地图
  - 空间统计
slug: statistical-analysis-and-winbugs-part-4
forum_id: 418797
---

# 如何生成一个GeoBUGS格式的中国地图

## 第一节 导言

![R, WinBUGS and ArcInfo](https://uploads.cosx.org/2009/06/r_bugs_esri.png) 之前有些对GeoBUGS感兴趣的同学发邮件询问我有没有GeoBUGS的中国地图，以用于分析中国国内的一些空间数据。我想有必要将如何生成GeoBUGS格式的地图的方法分享给大家。这样的话， GeoBUGS就可以真正为我们所用，从而对于其他GeoBUGS没有自带的地图，我们也可以轻松生成了。本节不涉及统计分析，仅为GeoBUGS的研究使用者提供一个软件使用的技术参考。关于GeoBUGS的统计的书，国外实在是很多了，但关于这块地图定制的参考资料较少，故提出来供大家参阅。

<!--more-->



目前分析用地图普遍采用的是shp格式，该格式可以用ESRI公司开发的ArcInfo工具进行编辑和分析。由于其通用性，故很容易在网上找到相应的资源。比如可以在国家基础地理信息系统的网站（<http://nfgis.nsdi.gov.cn/nfgis/chinese/>）上下载到有用的shp文件。我们主要需要的是其中的国界和省界的shp文件。可以点击链接下载[中国省级行政区域地图shp版](https://uploads.cosx.org/2009/06/bou2_4m.zip)。我们要用到的是其中的bou2_4p.shp文件。

## 第二节 用ArcInfo生成一个GeoBUGS格式的中国地图

第一步，打开ArcInfo，选中Layers（图层），点击右键，在打开的菜单中选择Add Data…（添加数据…），并定位到bou2_4p.shp，确定。![添加图层](https://uploads.cosx.org/2009/06/add_layers.png)

第二步，打开位于图层工具箱上方的Editor按钮菜单，在其中选中Start Editing。

第三步，选中bou2_4p图层，右键选中Open Attribute Table，

![open_attr_table](https://uploads.cosx.org/2009/06/open_attr_table.png)

你会发现这个地图的精度过高，如浙江省的舟山群岛，多边形区域数目很多，而在一般的GeoBUGS分析中，这些多边形区域可以不予显示。所以我们可以通过删减，得到只含有主要部分的中国行政区域地图。一个简便的方法是对区域面积进行排序，小于一定阈值的区域予以删除。例如可以以Area=.066的香港特别行政区为界，删除所以面积小于0.066的区域。

![attr_table](https://uploads.cosx.org/2009/06/attr_table.png)

第四步，打开位于图层工具箱上方的Editor按钮菜单，在其中选中Stop Editing，并保存你的修改。

第五步，在ArcToolBox中选择Conversion Tools  -> To Coverage -> Feature Class To Coverage。

![arc_tool_box](https://uploads.cosx.org/2009/06/arc_tool_box.png)

将Input Feature classes定位到修改后的bou2_4p.shp。在XY Tolerance（optional）中设定精度，这里我将其设定为0.005 Decimal degrees。其他参数取默认值。

第六步，在ArcToolBox中选择Coverage Tools  -> Conversion -> From Coverage -> Ungenerate。将Input Coverage 定位到bou2\_4p\_feat。Feature Type选region. bou2_4p。Numeric Format取FIXED。其他选项取默认值。

第七步，编辑GeoBUGS支持的格式，在bou2\_4p\_feat1.txt中添加一段头，如下

```
map: 33
1 Heilongjiang
2 NeiMonggol
3 Xingjiang
4 Jilin
5 Liaoning
6 Gansu
7 Hebei
8 Beijing
9 Shanxi
10 Tianjin
11 Shaanxi
12 Ningxia
13 Qinghai
14 Shandong
15 Xizang
16 Henan
17 Jiangsu
18 Anhui
19 Sichuan
20 Hubei
21 Chongqing
22 Shanghai
23 Zhejiang
24 Hunan
25 Jiangxi
26 Yunnan
27 Guizhou
28 Fujian
29 Guangxi
30 Taiwan
31 Hainan
32 Guangdong
33 Hongkong

regions
1 Heilongjiang
2 NeiMonggol
3 Xingjiang
4 Jilin
5 Liaoning
6 Gansu
7 Hebei
8 Beijing
9 Shanxi
10 Tianjin
11 Hebei
12 Shaanxi
13 Ningxia
14 Qinghai
15 Shandong
16 Xizang   
17 Henan
18 Jiangsu
19 Anhui
20 Sichuan
21 Hubei
22 Chongqing
23 Shanghai
24 Shanghai
25 Zhejiang
26 Hunan
27 Jiangxi
28 Yunnan
29 Guizhou
30 Fujian
31 Guangxi
32 Taiwan
33 Hainan
34 Guangdong
35 Hongkong
END
```

map: 33表示这个中国地图有33个行政区域，而regions: 35表示后面给出的通过经纬坐标描述的多边形区域隶属于那个行政区域。

第八步，在GeoBUGS中打开这个txt文件，然后选择Map -> Import ArcInfo。

第九步，保存成GeoBUGS的.map文件

第十步，重启GeoBUGS，恭喜你可以在GeoBUGS中使用中国地图进行分析了。

![china_map](https://uploads.cosx.org/2009/06/china_map.png)

生成的地图可以在这里下载[中国行政区域地图GeoBUGS版](https://uploads.cosx.org/2009/06/China.zip)。我们可以在许多政府官网得到许多可以分析的数据资源，如<http://www.moh.gov.cn/publicfiles//business/htmlfiles/zwgkzt/pwstj/index.htm>

那么就下载一些数据用GeoBUGS进行分析吧

WinBUGS在统计分析中的应用 第四部分完
