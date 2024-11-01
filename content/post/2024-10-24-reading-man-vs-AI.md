---
title: "人工阅读 vs AI 阅读：以《苏东坡传》为例"
date: "2024-10-24"
author: "汪利军"
categories:
  - 统计应用
tags:
  - 知识图谱
  - 图数据库
  - 可视化
  - 大语言模型
  - LightRAG
slug: reading-man-vs-AI
forum_id: 425419
---

去年五月，我在阅读林语堂的《苏东坡传》时，边读边整理了书中主要人物的关系。最后，借助图数据库 [Neo4j](https://neo4j.com/) 将这些人物关系存储在数据库中，并以可视化的方式呈现。完成后，我还写了一篇[读书博客](https://blog.hohoweiya.xyz/2023/05/31/su-shi/)，其中展示了这个可视化的人物关系图。当时，怡轩读到这篇博客，邀请我投稿到统计之都。然而由于拖延症发作，一拖就是一年半。

前几天逛 GitHub 时，发现了一个名为 [LightRAG](https://github.com/HKUDS/LightRAG) 的热门项目，其中的“RAG”指的是检索增强生成（Retrieval-Augmented Generation）。这是结合信息检索（retrieval）与生成模型（generation）的自然语言处理技术。RAG 的核心目标是通过引入外部知识库或文档中的相关信息（如一本书），提升生成模型的性能，尤其在需要特定领域知识或上下文信息的任务中有显著的表现。

一个很自然的应用场景就是让语言模型“读”一本书，然后构建基于该书的知识图谱。由于 RAG 的生成过程依赖于外部知识库（“读”书），它能够在生成过程中引用真实的外部信息，特别是在回答涉及特定知识的问题时，表现得更加可靠和准确。

于是便用 LightRAG 对《苏东坡传》进行“阅读”，构建了一个基于书本内容的知识图谱，这样就可以与去年手动整理的知识图谱做一个简单比较。

## 人工读书

首先，先介绍下去年我手动整理的知识图谱。当时，怡轩提醒我在投稿时可以补充一些数据整理的细节，但心想，哪有什么整理过程啊，所有数据都是一行一行手动输入的（哈哈哈）。

整理出的数据格式如下：

```shell
# 数据文件在此仓库中： https://github.com/szcf-weiya/Su-Shi/blob/master/Su-shi.csv
$ head Su-shi.csv 
chapter,chapter_name,location,name,name_zi,name_hao,name_other,career,relation,activities,comments,poem_to,poem_from
1,文忠公,,,,,,,,,,,大略如行云流水，初无定质，但常行于所当行，常止于不可不止。文理自然，姿态横生。
1,文忠公,黄州,李琪,,,,歌伎,,,,,东坡四年黄州住，何事无言及李琪。却似西川杜工部，海棠虽好不吟诗。
2,眉山,眉山,苏洵,明允,老泉,,,父亲,,,,
2,眉山,眉山,苏辙,子由,,颍滨遗老；苏栾城,,弟弟,,,,
2,眉山,眉山,苏轼,子瞻,东坡,,,本人,,,,
2,眉山,眉山,苏序,,,,,祖父,,,,
2,眉山,眉山,程某,,,,,外祖母,,,,
3,童年与青年,眉山,陈太初,,,,道士,同学,,,,
3,童年与青年,眉山,苏辙,,,,,弟弟,,,我初从公，赖以有知。抚我则兄，诲我则师。,我少知子由，天资和且清。岂独为吾弟，要是贤友生。
```

每一行记录了以下内容：

- 人物（名字 `name`, 字 `name_zi`, 号 `name_hao`, 其他名字 `name_other`）
- 出现的章节 (`chapter` 和 `chapter_name`)
- 地点 (`location`)
- 职业 (`career`)
- 与苏轼的关系 (`relation`)
- 写给苏轼的诗词 (`poem_to`)
- 苏轼写来的诗词 (`poem_from`)

我的整理流程很简单：一边读书一边填写表格。随着《苏东坡传》读完，这个表格也逐渐填满。尽管部分数据存在缺失，但关键的人物关系已经基本完整，因此决定使用可视化工具来呈现这些关系。

选择 Neo4j 的原因是我之前接触过知识图谱项目，对这个工具比较熟悉。Neo4j 是一个专门用于存储和处理图数据的图数据库管理系统，它与传统的关系型数据库不同，采用图结构来表示数据：结点 (node) 表示实体，边 (edge) 表示实体之间的关系。这种结构特别适合处理复杂的关系数据，例如社交网络、推荐系统和知识图谱等。

Neo4j 使用 [Cypher](https://neo4j.com/docs/cypher-manual/current/introduction/) 作为查询语言，类似 SQL，但它专为图结构设计，能够更直观地查询和操作结点、边及其关系。

### 安装配置 Neo4j

对于 Neo4j 的入门及安装教程，可以参考这篇[知乎文章](https://zhuanlan.zhihu.com/p/88745411)，不做赘述。这里记录一下在 Ubuntu 系统下根据[官方教程](https://neo4j.com/deployment-center/)的安装流程：

```shell
wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -
echo 'deb https://debian.neo4j.com stable 4.4' | sudo tee /etc/apt/sources.list.d/neo4j.list
sudo apt-get update
sudo apt-get install openjdk-11-jdk
sudo apt-get install neo4j
```

然后安装 [Apoc](https://github.com/neo4j/apoc) 插件：

1. 从 GitHub releases 界面下载与 Neo4j 匹配版本的 Apoc `.jar` 文件
2. 将 `.jar` 文件复制到 `$NEO4J_HOME/plugins` 目录中

准备完成后，可以通过以下命令启动 Neo4j：

```shell
neo4j start
```

### 构建数据库

因为我关注的是人物关系，所以只采用原数据中的三列：`name`, `relation`, `career`。以下分三步采用 Cypher 查询语言给每个人 (`name`) 创建一个结点（如有职业 `career` 信息，则标注），并为每个人与苏轼根据 `relation` 建立一条联系：

1. 对于职业 (`career`) 不为空的人，创建结点时构造两个标签：`People` 和具体职业 `career`

```cypher
LOAD CSV WITH HEADERS FROM 'https://github.com/user-attachments/files/17481791/sushi-relation2.csv' AS row
WITH row WHERE row.career <> ''
CALL apoc.create.node(["People", row.career], {name: row.name, relation: row.relation}) YIELD node
RETURN *
```

2. 对于职业未知的人，创建结点时只赋予 `People` 的标签

```cypher
LOAD CSV WITH HEADERS FROM 'https://github.com/user-attachments/files/17481791/sushi-relation2.csv' AS row
WITH row where row.career = ''
CALL apoc.create.node(["People"], {name: row.name, relation: row.relation}) YIELD node
RETURN *
```

3. 然后对于每一个结点，都建立一个与苏轼的关系，其中具体关系类型便是数据中的 `relation`

```cypher
// add relation
MATCH (a:People) where a.relation <> '' and a.name <> '苏轼'
MATCH (o:People) where o.name = '苏轼'
CALL apoc.create.relationship(a, a.relation, {}, o) YIELD rel
RETURN *
```

最后，执行以下查询展示整个关系图：

```cypher
MATCH (n) RETURN n
```

![](https://user-images.githubusercontent.com/13688320/242476681-8dd232b7-896a-40a1-b4fe-40df51cd1f81.png)

## AI“读”书

这一部分开始介绍使用大语言模型来“读”书并构建知识图谱。

### 安装运行 LightRAG

安装流程直接参考[官方仓库](https://github.com/HKUDS/LightRAG)：

```shell
conda create --name lightRAG python=3.10
conda activate lightRAG
git clone git@github.com:HKUDS/LightRAG.git
cd LightRAG
pip install -e .
```

如果你使用 OpenAI 的模型，需要申请一个 `OPENAI_API_KEY`，并设置好环境变量（当然 LightRAG 也支持其他大语言模型）：

```shell
export OPENAI_API_KEY="sk-..."
```

准备就绪后，便可以在 Python 运行以下脚本初始化 LightRAG：

```python
from lightrag import LightRAG, QueryParam
from lightrag.llm import gpt_4o_mini_complete, gpt_4o_complete

WORKING_DIR = "./sushi"

rag = LightRAG(
    working_dir=WORKING_DIR,
    llm_model_func=gpt_4o_mini_complete 
)
```

接下来就是让语言模型“读”书了，我们需要一本文字版的《苏东坡传》，比如[这个仓库](https://github.com/0voice/expert_readed_books/blob/master/%E4%BA%BA%E7%89%A9%E4%BC%A0/%E6%9E%97%E8%AF%AD%E5%A0%82%EF%BC%9A%E8%8B%8F%E4%B8%9C%E5%9D%A1%E4%BC%A0.txt)。下载到本地后，指定存储路径，便可以让 RAG 读书了：

```python
with open("/home/weiya/GitHub/expert_readed_books/人物传/林语堂：苏东坡传.txt") as f:
    rag.insert(f.read())
```

读书过程中 (`f.read()`)，可能会遇到编码问题，比如

> UnicodeDecodeError: 'utf-8' codec can't decode byte 0xc4 in position 1: invalid continuation byte

这个错误通常是由于文件的编码格式不是 UTF-8 导致的，你可以使用 `iconv` 工具将文件转换为 UTF-8 编码格式：

```shell
iconv -f GB18030 林语堂：苏东坡传.txt -t UTF8 -o 林语堂：苏东坡传_UTF8.txt
```

如果书本文件过大，一次性读取整本书可能会超出 GPT 的速率限制，出现以下类似错误：

> openai.RateLimitError: Error code: 429 - {'error': {'message': 'Rate limit reached for gpt-4o-mini in organization ****** on tokens per min (TPM): Limit 200000, Used 195869, Requested 4412. Please try again in 84ms. Visit https://platform.openai.com/account/rate-limits to learn more.', 'type': 'tokens', 'param': None, 'code': 'rate_limit_exceeded'}}

可以采用一种简单的解决方式：将书本拆分成多个小文件，然后逐一读取。例如，下面将书分成五部分，每部分大约 300 行，依次读取：

```shell
with open("/home/weiya/GitHub/expert_readed_books/人物传/sushi_utf8_part1.txt") as f:
    rag.insert(f.read())

with open("/home/weiya/GitHub/expert_readed_books/人物传/sushi_utf8_part2.txt") as f:
    rag.insert(f.read())

with open("/home/weiya/GitHub/expert_readed_books/人物传/sushi_utf8_part3.txt") as f:
    rag.insert(f.read())

with open("/home/weiya/GitHub/expert_readed_books/人物传/sushi_utf8_part4.txt") as f:
    rag.insert(f.read())

with open("/home/weiya/GitHub/expert_readed_books/人物传/sushi_utf8_part5.txt") as f:
    rag.insert(f.read())
```

### 构建数据库

在读书的过程中，LightRAG 已经得到了实体及其之间的关系，并存储在 `graph_chunk_entity_relation.graphml` 文件中。

为了可视化这些关系，使用 LightRAG 提供的[示例程序](https://github.com/HKUDS/LightRAG/blob/main/examples/graph_visual_with_neo4j.py)，将 `graphml` 文件转换为 JSON 格式后导入到 Neo4j 中。在导入之前，清空已有数据以免混淆：

```cypher
MATCH (n) DETACH DELETE n
```

最终数据库中存储了 2004 个结点，1150 条关系。为了图形展示的清晰度，仅能展示 300 条关系（`LIMIT 300`）。通过可视化图谱，可以直观地查看不同实体之间的关联。 

![image](https://github.com/user-attachments/assets/a5be9228-3714-4683-9873-1a8517730443)

### 知识图谱

以下基于已经构建好的图数据库，通过对结点的类型（比如，人 `n:PERSON` 或地点 `n:POSITION`）和关系的类型（比如，友情 `r:friendship`）做查询进行一些探索。

#### 亲密关系

首先我们来看看苏东坡的家人：

```cypher
MATCH (n:PERSON {id: '苏东坡'})-[r]-(m:PERSON)
WHERE type(r) CONTAINS 'family'
   OR type(r) CONTAINS 'love'
RETURN n, r, m
```

![image](https://github.com/user-attachments/assets/9f6aa2aa-cac4-4a2c-937e-78d261f999d7)

图中主要有

- “我少知子由，天资和且清。岂独为吾弟，要是贤友生” 的弟弟苏辙（子由）
- “十年生死两茫茫，不思量，自难忘。千里孤坟，无处话凄凉”的妻子王弗
- 坊间传闻的初恋“堂妹”

这里我们也可以看出一个明显的问题——实体的不唯一，我们都知道“苏子由”，“兄弟子由”，以及“苏辙”都是同一个人，但上图却分成了三个实体。

同样，我们可以看看苏轼的朋友们：

```cypher
MATCH (n:PERSON {id: '苏东坡'})-[r]-(m:PERSON)
WHERE type(r) CONTAINS 'friend'
RETURN n, r, m
```

![image](https://github.com/user-attachments/assets/41577ee7-bb80-444c-9647-b980423a673f)

其中有

- “生不愿封万户侯，但愿一识苏徐州”的秦观
- “画竹必先得成竹于胸中”的文与可
- “师唱谁家曲，宗风嗣阿谁，借君拍板与门槌，我也逢场作戏莫相疑。溪女方偷眼，山僧莫皱眉，却愁弥勒下生迟，不见阿婆三五少年时”中“山僧”——大通禅师

#### 人生足迹

接着我们可以看看苏轼曾造访过的地方，

```cypher
MATCH (n)-[r]-(m)
WHERE any(label IN labels(n) WHERE label IN ['GEO', 'LOCATION'])
RETURN n, r, m 
LIMIT 300
```

![image](https://github.com/user-attachments/assets/e2ab1d5e-845d-47a7-b76a-16fae67160c3)

有两个很明显的地理簇：杭州和西湖。毕竟修浚西湖时建造了“西湖十景”之首的“苏堤春晓”；还有那脍炙人口的“水光潋滟晴方好，山色空蒙雨亦奇。欲把西湖比西子，淡妆浓抹总相宜。”

![image](https://github.com/user-attachments/assets/03d572ff-de30-4a45-bbe2-ef5ee24610b4)

苏轼一生足迹遍布全中国，小至一叶扁舟，大至一座孤岛：

- 江山小舟：“壬戌之秋，七月既望，苏子与客泛舟游于赤壁之下。...盖将自其变者而观之，则天地曾不能以一瞬；自其不变者而观之，则物与我皆无尽也，而又何羡乎！...”
- 庐山：“横看成岭侧成峰，远近高低各不同。”
- 承天寺：“念无与乐者，逐步至承天寺，寻张怀民。怀民亦未寝，相与步于中庭。庭下如积水空明，水中藻荇交横，盖竹柏影也。何夜无月，何处无竹柏，但少闲人如吾两人耳。”
- 海南：“吾始至南海，环视天水无际，凄然伤之曰：‘何时得出此岛也？’已而思之：天地在积水中，九洲在大瀛海中，中国在少海中。有生孰不在岛者？譬如注水于地，小草浮其上，一蚁抱草叶求活。已而水干，遇他蚁而泣曰：‘不意尚能相见尔！’小蚁岂知瞬间竟得全哉？”

#### 文学家

首先看直接与诗词 `poet*` 的关系：

```cypher
MATCH p=()-[r]->() WHERE type(r) CONTAINS 'poet' RETURN p LIMIT 300
```

![image](https://github.com/user-attachments/assets/dad9d11b-d1bf-4a2c-b42b-76a6b6045c49)

其中有

- 门士：秦少游（秦观），黄庭坚
- 至交诗僧参寥：“记取西湖西畔，正春山好处，空翠烟霏。算诗人相得，如我与君稀。约它年、东还海道，愿谢公雅志莫相违。西州路，不应回首，为我沾衣。”——《八声甘州·寄参寥子》
- 名篇《赤壁怀古》：“大江东去，浪淘尽，千古风流人物。”

然而其中的李师师与苏轼的关系有点令人怀疑，在这本书中并没有提及二人之间的关系，唯一一次出现李师师的地方在于

> 598: 在苏东坡时代的生活里，酒筵公务之间与歌妓相往还，是官场生活的一部分。.....宋徽宗微服出宫，夜访名妓李师师家。....，可是当日杭州的诗人则为歌女公然写诗。即使是颇负众望的正人君子，为某名妓写诗相赠也是寻常事。在那个时代，不但韩琦、欧阳修曾留下有关妓女的诗，甚至端肃严谨的宰相如范仲淹、司马光诸先贤，也曾写有此类情诗。再甚至精忠爱国的民族英雄岳飞，也曾在一次宴席上写诗赠予歌妓。

但是 LightRAG 给出两人的关系为

> 苏东坡 interacted with 李师师, acknowledging the role of courtesans in society and expressing admiration for them through poetry.

虽然苏轼确实赠诗给过歌伎李琪——“东坡四年黄州住，何事无言及李琪。却似西川杜工部，海棠虽好不吟诗”，但却不是李师师，这有点张冠李戴之嫌。


接着，我们关注更宽泛的文学 `literary*` 联系：

```cypher
MATCH p=()-[r]->() WHERE type(r) CONTAINS 'literary' RETURN p LIMIT 300
```

![image](https://github.com/user-attachments/assets/99219d29-a9f7-4405-9c4c-d2c1535d1527)

其中有

- 文学名篇：“但愿人长久，千里共婵娟”——《水调歌头》；“江流有声，断岸千尺，山高月小，水落石出。”——《后赤壁赋》；《东坡志林》
- 文学论辩：乌台诗案
- 文学继承：李白
- 文学源泉：西湖

需要指出的是《辩奸论》是苏洵所作，但它与苏轼的关系是 `literary critique`，

> "苏东坡 critiques the harshness of political discourse in his essays, showing the relationship of literary and political commentary."
>

这对应原文

> 269:　　老苏写《辩奸论》时，苏东坡说他和弟弟子由都认为责骂得太重。

#### 艺术家

现在我们来看艺术方面的关系：

```cypher
MATCH p=()-[r]->() WHERE type(r) CONTAINS 'art' RETURN p LIMIT 300
```

![image](https://github.com/user-attachments/assets/cc888d8e-47c5-4524-a0f2-eb1abf89a72e)

其中主要有两点：

- 仙鹤图：“苏东坡 creates 仙鹤图 to express his philosophical views and artistic vision, showcasing the spirit of nature.”

相关原文：

> 1112: 但是只凭观察与精确，并不能产生真艺术。画家必须运用直觉的洞察力，等于是对大自然中的鸟兽有一种物我胞与的喜悦。也许要真懂苏东坡描绘万物的内在肌理之时，他所努力以求的是什么，最好看他画的一幅仙鹤图上的题诗。他说，仙鹤立在沮洳之地看见有人走近，甚至仙鹤连一根羽毛还未曾动，已先有飞走之意，但是四周无人之时，仙鹤完全是一副幽闲轻松的神气。这就是苏东坡想表现的仙鹤内在精神。

- 文人画：“	苏东坡 is credited with the development of 文人画, showcasing his influence on Chinese art.”

相关原文：

> 1091: 苏东坡不仅创了他有名的墨竹，他也创造了中国的文人画。他和年轻艺术家米芾共同创造了以后在中国最富有特性与代表风格的中国画。


#### 政治家

有趣的是，当聚焦政治层面的关系 `poli*` (如 `political support`, `political impact`, `policy reform`, ...)，出现了三足鼎立之势：王安石，苏东坡，皇帝。主要就是围绕王安石变法，这也是非常合乎常理了。

```cypher
MATCH p=()-[r]->() where type(r) CONTAINS 'poli' RETURN p LIMIT 300
```

![image](https://github.com/user-attachments/assets/eb7a2519-146a-4d98-9b5c-e304add9f5c3)

#### 美食家

众所周知，苏轼还是个十足的美食家，

> 荔枝：“日啖荔枝三百颗，不辞长作岭南人。”
>
> 黄州猪肉：“富者不肯吃，贫者不解煮。”
>
> 烤羊脊：“骨间亦有微肉，煮熟热酒漉，随意用酒薄点盐炙，微焦食之，终日摘剔牙綮，如蟹螯逸味。”
>

在结点标签也确实看到一个 `FOOD` 标签，但是点进去一看，笑了，竟然只有一个结点——“丸子”，很是震惊，搜索原文发现，“丸”出现的场合也很难说是食物。

![image](https://github.com/user-attachments/assets/55ee3140-985f-413a-a5af-0a43e5462bfb)

```shell
$ grep -n "丸" 林语堂：苏东坡传_UTF8.txt
755:　　西南火星如弹丸，角尾奕奕苍龙幡。
950:　　关于炼制外丹，苏东坡写了两篇札记，一篇叫“阳丹”，一篇叫“阴丹”。阴丹是从生第一胎男婴的母乳中提炼出来的。把乳在文火上加热，用的锅是银汞合金制成的，一边加热，一边用同一金属制的调羹缓缓扰动，直到奶凝结，最后制成药丸状。阳丹是用尿蛋白中的尿素制成。此一蛋白沉淀物经过多次净化，最后变成白色无味的粉状物，再加枣泥做成药丸，空腹用酒送服。
```

于是查询在结点描述中带食物的结点及其关系：

```cypher
MATCH (n)-[r]-(m)
WHERE any(keyword IN ['酒', '肉', '鸡', '鸭', '羊', '鱼']
            WHERE n.description CONTAINS keyword)
RETURN n, r, m
LIMIT 300
```

![image](https://github.com/user-attachments/assets/bb032894-2c7c-45ac-a940-caf5742c1b21)

这样东坡的美食便都出来了。

有趣的是，王安石及其妻子胖太太也出场了，仔细一看，他们是因为“鹿肉丝”

```shell
$ grep -ni "鹿肉丝" 林语堂：苏东坡传_UTF8.txt
254:　　又有一天，朋友们告诉王安石的胖太太，说她丈夫爱吃鹿肉丝。
$ head -n 260 林语堂：苏东坡传_UTF8.txt | tail -n 7
　　又有一天，朋友们告诉王安石的胖太太，说她丈夫爱吃鹿肉丝。
　　胖太太大感意外，她说：“我不相信。他向来不注意吃什么。他怎么会突然爱吃鹿肉丝了呢？你们怎么会这样想？”
　　大家说：“在吃饭时他不吃别的盘子里的菜，只把那盘鹿肉丝吃光了，所以我们才知道。”
　　太太问：“你们把鹿肉丝摆在了什么地方？”
　　大家说：“摆在他正前面。”
　　太太明白了，向众人说：“我告诉你们。明天你们把别的菜摆在他前面，看会怎么样？”
　　朋友们第二天把菜的位置调换了，把鹿肉丝放得离他最远，大家留意他吃什么。王安石开始吃靠近他的菜，桌子上照常摆了鹿肉，他竟然完全不知道。
```

## 总结


首先，大语言模型处理的信息量远超我逐行阅读并整理所能达到的水平。我的人工阅读仅限于一百多个人物与苏轼之间的关系，而大语言模型则构建出了涉及人物、地点、事件等超过两千个实体的知识图谱。

尽管大语言模型展现出强大的知识图谱构建能力，从准确性角度来看，仍然无法与人工阅读相媲美，具体体现在以下几个方面：

1. 实体的唯一性问题：除了上文提及的“苏子由”与“苏辙”，还有“苏东坡”与“东坡”，我们都知道都是同一个实体，但是语言模型会创建两个实体

![image](https://github.com/user-attachments/assets/334fc1b9-c64f-4e6c-b2cf-11dcdbada8c0)

为了解决这一问题，我们可以使用以下查询语句合并这两个实体：

```cypher
MATCH (n1 {id: '东坡'}), (n2 {id: '苏东坡'})
CALL apoc.refactor.mergeNodes([n1, n2]) YIELD node
RETURN node
```

然而，如何高效地对所有实体进行类似的操作仍需进一步研究。

2. 更精确的关系分类：当前的关系分类显得有些零散，例如关于政治的许多 `political *` 短语。此外，将所有分类统一为中文可能会更为合理。

3. 更明确的结点类别划分：当前有些结点类别划分明显有问题，比如上文提到的食物竟然只有一个“丸子”，而像“猪肉”这种明显是食物 `FOOD` 的类别却被划分在事件 `EVENT` 类别中。同样地，将结点类别统一成中文可能也更为合理。

4. 大语言模型仍然可能会一本正经地胡说八道，比如

![image](https://github.com/user-attachments/assets/eb2f345c-500a-4067-82a2-31b815964b01)


