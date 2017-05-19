---
title: 投稿指南
date: '2017-05-19'
author: COS编辑部
tags: [投稿] 
slug: work-with-COS
description: "COS主站的文章已经全部迁移至github.com，从今以后，所有主站的文章可以通过更新github的项目内容来实现。
更新一个markdown文件之后，后台服务器会自动完成编译，更新，发布的工作。本文将详细介绍如何为新的统计之都网站投稿。"
---


> COS主站的文章已经全部迁移至github.com，从今以后，所有主站的文章可以通过更新github的项目内容来实现。更新一个markdown文件之后，后台服务器会自动完成编译，更新，发布的工作。本文将详细介绍如何为新的统计之都网站投稿。
以及最重要的：

**欢迎各种方式的贡献与投稿！**

## 投稿指北

如果你懂Github和Markdown，请直接给[COS主站的项目](http://github.com/cosname/cosx.org)提PR。

如果你只习惯使用office，请发送邮件给edior@cos.name。

本文结束，再见[鼓掌]~


------


哦，如果介于二者之间，可能需要根据自己的情况从下面的话题中选一个，别担心，这些内容都在本页面，而且非常精炼。

- [快速入门](#quick)
- [我什么都会，投稿的格式是什么？](#format)
- [我只会git & Github，不会Markdown](#web)
- [懂一些 markdown 不懂 github](#part)
- [Markdown是个啥？](#markdown)
- [高阶作者与编辑需要注意的格式](#high)

# <span id="quick">快速入门</span>

TODO：待更新一个简短的入门以及视频

TODO: 上传图片及更新

# <span id="format">我什么都会，投稿的格式是什么？</span>

在你写好一个Markdown文档之后， 无论是用git来提交，还是用网页版提交，都需要注意格式，可以参考[这里](https://raw.githubusercontent.com/cosname/cosx.org/master/content/post/2017-04-27-google-ghost-ads.md)。简单的来说，需要注意两个事情

- 文件名和路径
- 文件头的信息

## 文件名和路径

文件应以 `content/post/2017-05-19-how-to-work-with-COS.md` 的形式保存。

文件名包含日期与英文简写，用`-`隔开，保存路径为`content/post`。

## 文件头的信息

以下是文件头的信息，请把这段内容复制到文章的最前面，并填写相关的信息。

```yaml
---
title: 文章的标题
date: '文章的时间：YYYY-MM-DD'
author: 作者
tags: [标签1,标签2] 
slug: article-name-english
description: "描述部分"
---
```

注意：

- tags中的标签也就是文章的关键字，方便归档
- slug与文件名的英文简写一致（不带日期）

![default](https://cloud.githubusercontent.com/assets/7221728/26232013/947c3d34-3c85-11e7-8436-bb5b1d0e77aa.png)

# <span id="web">懂一些 markdown 不懂 github</span>

如果对github不熟，可以按照以下步骤进行投稿：

1. [申请Github账号](https://github.com/join?source=header-home)
1. 在[**这个页面**](https://github.com/cosname/cosx.org/new/master/content/post)投稿，最好按照[这个格式](#format)增加头文字信息
1. 文件名为YYY-MM-DD-article-name.md的形式
1. 随后 Github 会指导你提交合并请求（pull request，简称 PR）

编辑和进一步的修改请查看[编辑须知wiki](https://github.com/cosname/cosx.org/wiki/Github%E5%9F%BA%E7%A1%80%E6%93%8D%E4%BD%9C)

![default](https://cloud.githubusercontent.com/assets/7221728/26231824/48274d1c-3c84-11e7-9002-2f9a441d5978.png) 

# <span id="part">我只会git & Github，不会Markdown</span>

你一定是在逗我！

# <span id="markdown">Markdown是个啥？</span>

Markdown 是一门轻量级的标注语言，谢益辉在[knitr与可重复的统计研究](http://cos.name/2012/06/reproducible-research-with-knitr/)聊到：
 
> 我选择Markdown作为给初学者入门的媒介，原因就是它超级简单，你可以在五分钟之内基本学会它的用法，若再多花点时间，完全有可能学完它的用法，注意是“学完”。这世上能被学完的语言不多，因为大多数语言都想让自己功能多，而Markdown是为了让功能少。

Markdown是个简单的语言，设计的初衷是让使用者专注于内容而不是格式，以下是常用的功能：

如果你使用写出以下的Markdown的内容
```markdown
# 这是一级标题
## 这是二级标题

正文里面，我们来说点什么吧！

无序列表用`-`
- **粗体**
- *斜体*
- 行内公式`print`

有序列表用`1.`
1. ~~删除线~~
1. [统计之都的网站](cos.name)
  
代码部分
````
```r
print("Hello World")
```
````
```

网站中会自动生成：
# 这是一级标题
## 这是二级标题

正文里面，我们来说点什么吧！

无序列表用`-`
- **粗体**
- *斜体*
- 行内公式`print`

有序列表用`1.`
1. ~~删除线~~
1. [统计之都的网站](cos.name)
  
代码部分

```r
print("Hello World")
```

以上的语法足以应对90%以上的问题，想学完功能可以看[Rstudio中Markdown的介绍](http://rmarkdown.rstudio.com/lesson-8.html)，或者看[高阶作者与编辑须知](#high)

# <span id="high">高阶作者与编辑需要注意的格式</span>

以下是编辑文章时的一些规则，明确了一些 Markdown 语法的用法，同时避免繁琐的基础 HTML 语法。

***

1. 每篇文章的开头 YAML 元数据（即三横线之间的数据）中，需要一个 description 选项作为文章的摘要（这个选项可以写在任意行）。这个摘要会作为主站文章列表页面中显示的内容。它应该是**一个**单独的段落，不要包含特殊格式的内容如列表项，也不要写多个段落。例如：

    ```yaml
    ---
    title: "你好世界"
    description: "我是一段摘要。"
    ---
    ```

1. 所有文章的小节标题一律从第一级标题开始，即一个井号 `#`。例如一篇文章若以 `### 故事部分` 开始，那么应该修改为 `# 故事部分`。下一级标题用两个井号，以此类推。

    ```markdown
    # 第一节
    
    ## 1.1 小节
    
    ### 1.1.1 小小节
    
    # 第二节
    ```

1. 文章正文中的 HTML 标签若能替换成 Markdown 语法则替换


1. 句中数学公式用 `` `$LaTeX公式$` `` 语法，注意两端最好有反引号（除非你确定公式中不含任何可能被当做 Markdown 语法的东西例如下划线），例如 `$X_i + Y_i$` 修改为 `` `$X_i + Y_i$` ``，`$a+b$` 则可以不用修改（因为它不含任何特殊字符）；单独占一个段落的公式用 `` `$$LaTeX公式$$` `` 语法，注意仍然有两端的反引号。公式代码中有空行的，需要把空行移除。原文中可能有时候用图片代替了 LaTeX 公式，碰到这种情况应该把图片替换为 LaTeX 原生公式。数学公式内部可以换行，但不能有空行。如果正文中碰巧有一对美元符号但它们并不代表数学公式的话，可以用反斜杠引导，例如 `\$50 $100`。

1. 中文句中的标点符号用中文全角标点，如“，。；！”，不要用半角符号如“, . ; !”。

1. 如果需要插入编者注，请用**脚注**语法 `^[脚注文字]` 在正文的相关位置中插入，例如 `若想了解更多信息，请参见[这个链接](http://example.com)。^[编者注：啥啥啥啥。]`

1. 不同类型的元素之间需要尽量留出空行，不要紧挨着，例如段落之间、标题与段落之间、代码块与段落之间、YAML 元数据与正文之间、图片与段落之间、列表与段落之间，等等。错误的例子：

    ```markdown
    # 标题
    段落
    ![图片](地址)
    ```
    
    正确的例子：
    
    ```markdown
    # 标题
    
    段落
    
    ![图片](地址)
    ```

1. 对强迫癌晚期患者，可以在英文单词（包括数字）与中文字符之间敲上空格，除非英文单词后紧接着就是中文标点符号。例如 `你好world` 修改为 `你好 world`。这一项修改属于可选。主要目的是为了行末断行稍微合理一点，比如要是没有空格，前面的例子中“好world”会被视作一个整体断行，有空格的话，“world”是一个单独的单词，可以自行被断到下一行上。

详细内容请参考[wiki页面](https://github.com/cosname/cosx.org/wiki)
