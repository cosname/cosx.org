---
title: 统计之都投稿指南
author: 统计之都
date: '2017-05-19'
tags:
  - 投稿
  - GIT
  - Github
  - Markdown
  - RStudio
  - blogdown
---

整个 COS 主站的源代码托管在 Github 库 [cosname/cosx.org](https://github.com/cosname/cosx.org) 中，其中多数文章都使用 Markdown 文档格式。如果您熟悉 Github 和 Markdown，请直接给该库提交合并请求（Pull Request，简称 PR）。如果您只习惯使用 Office，请发送邮件给editor@cosx.org。为了审稿方便，我们强烈建议您在 Github 上向我们提交 PR。根据您的技术背景，可以选择以下投稿指南阅读。

- [快速入门](#quick)
- [我什么都会，投稿的格式是什么？](#format)
- [懂一些 Markdown 不懂 Github](#web)
- [Markdown 是个啥？](#markdown)
- [高阶作者与编辑需要注意的格式](#high)

# <span id="quick">快速入门</span>

这是一个超简单的教程，按照以下四步，就可以上传最简单的草稿，不需要命令行的操作。

1. 点击这个链接：<https://github.com/cosname/cosx.org/new/master/content/post/>；
1. 点击绿色的大框：Fork this repository and propose changes；
1. 添加、更新文章的内容；
1. 一路绿色按钮点下去直到没有东西可以点。

以下是视频教程：

<video controls="controls" height=500px width=100%>
<source src="https://uploads.cosx.org/images/github-web-pr.webm" type="video/webm">
</video>

您可以在[这里](https://github.com/cosname/cosx.org/pull/558)看到一份测试的草稿。注意：如果您的 PR 被编辑要求继续修改，请**不要**关闭它并重开一个新的 PR，而是继续修改它里面的文件。如下图所示，切换到 PR 界面的 Files changed 一栏中，点击相应文件的编辑按钮即可。如果您使用了 GIT 命令行而不是 Github 界面提交的文章，请继续向原来的 GIT 分支提交修改。一篇新文章从开始到结束都应该留在同一个 PR 中进行。

![编辑合并请求](https://uploads.cosx.org/images/edit-pr.png)

# <span id="format">我什么都会，投稿的格式是什么？</span>

在您写好一个Markdown文档之后， 无论是用git来提交，还是用网页版提交，都需要注意格式，可以参考[这篇文章](https://raw.githubusercontent.com/cosname/cosx.org/master/content/post/2017-02-13-xaringan-presentation.md)。简单的来说，需要注意两件事情：

- 文件名和路径
- 文件头的信息

## RStudio 用户

如果您是 RStudio 用户，请先克隆或者下载我们的 [Github 库](https://github.com/cosname/cosx.org)。克隆库的时候需要 `--recursive` 参数来加入子模块。

```
git clone --recursive git@github.com:cosname/cosx.org.git
```

打开里面的 `cosx.Rproj` 文件，然后安装 **blogdown** 包^[本站便是基于 **blogdown** 包编译生成。]：

```r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("rstudio/blogdown")
blogdown::install_hugo()
```

然后使用RStudio 工具栏上的 Addins 菜单中的 [New Post](https://bookdown.org/yihui/blogdown/rstudio-ide.html) 插件弹出一个窗口（见下图），在窗口中填入所需要的信息就可以完成完成新文章的生成。其中文件名（Filename）一栏会自动生成，但通常来说，对中文文章的文件名需要您手工调整为英文，注意保留文件名中的 `post/2017-02-14-` 部分，只修改后面的基础文件名。修改文件名之后 Slug 一栏会自动更新，它会是将来您的文章网址的最后组成部分。例如下图中的示例文章最终的网址是 `/2017/02/hello-r-markdown-world` （实际网址还要包含前面的域名，对本站来说域名是 `https://cosx.org`）。

[![RStudio 插件 New Post](https://bookdown.org/yihui/blogdown/images/new-post.png)](https://bookdown.org/yihui/blogdown/rstudio-ide.html)

如果想在本地预览网站，请点击 Addins 菜单中的 Serve Site，整个网站便会在本地被编译并显示在您的 RStudio Viewer 中。

## 文件名和路径

文件应以 `content/post/2017-02-14-base-name.md` 的形式保存，其中 `content/` 是本站源代码库根目录下的文件夹。文件名包含日期与英文简写，用减号 `-` 隔开。

## 文件头的信息

以下是文件头的信息，请把这段内容复制到文章的最前面，并填写相关的信息。其中 categories 为分类名称，tags 为文章的关键字，方便归档。如果有不清楚该怎么填的地方可以先留空，等审稿人反馈。

文章所属分类名称请参见[现有分类](/categories/)；除非着实有必要，否则请勿新建类名。


```yaml
---
title: "文章的标题"
date: YYYY-mm-dd
author: "作者"
categories: ["分类1", "分类2"]
tags: ["标签1", "标签2"]
slug: article-base-name-in-english
---
```

![default](https://cloud.githubusercontent.com/assets/7221728/26232013/947c3d34-3c85-11e7-8436-bb5b1d0e77aa.png)

# <span id="web">懂一些 Markdown 不懂 Github</span>

如果对 Github 不熟，可以按照以下步骤进行投稿：

1. [申请Github账号](https://github.com/join?source=header-home)；
1. 在[这个页面](https://github.com/cosname/cosx.org/new/master/content/post)投稿，最好按照[这个格式](#format)增加头文字信息；
1. 文件名为 `YYYY-mm-dd-article-name.md` 的形式；
1. 随后 Github 会指导您提交合并请求。

![default](https://cloud.githubusercontent.com/assets/7221728/26232013/947c3d34-3c85-11e7-8436-bb5b1d0e77aa.png)

# <span id="markdown">Markdown 是个啥？</span>

Markdown 是一门轻量级的标注语言，谢益辉在《[knitr与可重复的统计研究](/2012/06/reproducible-research-with-knitr/)》一文中提到：

> 我选择Markdown作为给初学者入门的媒介，原因就是它超级简单，你可以在五分钟之内基本学会它的用法，若再多花点时间，完全有可能学完它的用法，注意是“学完”。这世上能被学完的语言不多，因为大多数语言都想让自己功能多，而Markdown是为了让功能少。

Markdown是个简单的语言，设计的初衷是让使用者专注于内容而不是格式，以下是一个示例文档：

````markdown
# 这是一级标题

## 这是二级标题

正文里面，我们来说点什么吧！

无序列表用 `-`

- **粗体**
- *斜体*
- 行内公式 `$\alpha+\beta$`

有序列表用 `1.`

1. ~~删除线~~
1. [统计之都的网站](https://cosx.org)

代码部分

```r
print("Hello World")
```
````

网站中会自动生成：

> # 这是一级标题
> 
> ## 这是二级标题
> 
> 正文里面，我们来说点什么吧！
> 
> 无序列表用 `-`
> 
> - **粗体**
> - *斜体*
> - 行内公式 `$\alpha+\beta$`
> 
> 有序列表用 `1.`
> 
> 1. ~~删除线~~
> 1. [统计之都的网站](https://cosx.org)
> 
> 代码部分
> 
> ```r
> print("Hello World")
> ```


以上的语法应该可以应对大部分功能，想学完功能可以看[RStudio中Markdown的介绍](http://rmarkdown.rstudio.com/lesson-8.html)，并参考下一节的注意事项。

# <span id="high">高阶作者与编辑需要注意的格式</span>

以下是编辑文章时的一些规则，注明了一些 Markdown 语法的细节问题。

1. 所有文章的小节标题一律从第一级标题开始，即一个井号 `#`，表示节。下一级标题用两个井号，表示小节，以此类推。

    ```markdown
    # 第一节

    ## 1.1 小节

    ### 1.1.1 小小节

    # 第二节
    ```

1. 若无必要，尽量避免使用原始 HTML 语法。如果您不懂什么是 HTML，那就最好。

1. 句中数学公式用 `` `$LaTeX公式$` `` 语法，注意两端必须有反引号，例如 `` `$X_i + Y_i$` ``；单独占一个段落的公式用 `` `$$LaTeX公式$$` `` 语法，注意仍然有两端的反引号。公式代码中不能有空白行。数学公式内部可以用 LaTeX 语法如 `\\` 换行，只是不能有单独的空白行。

1. 中文句中的标点符号用中文全角标点，如“，。；！”，不要用半角符号如“, . ; !”。

1. 不同类型的元素之间需要[尽量留出空行](https://yihui.name/cn/2017/05/blank-line/)，不要紧挨着，例如段落之间、标题与段落之间、代码块与段落之间、YAML 元数据与正文之间、图片与段落之间、列表与段落之间，等等。错误的例子：

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

1. 对强迫癌晚期患者，可以在英文单词（包括数字）与中文字符之间敲上空格，除非英文单词后紧接着就是中文标点符号。例如 `你好world` 应该写作 `你好 world`。本站使用了[盘古](https://github.com/vinta/pangu.js)库，所以在网页最终渲染时，中英文之间的空格一般会被自动加上。

希望本指南对您有所帮助。统计之都编辑部期待着您的投稿，并将尽全力帮助您发表您的作品。对于每一篇投稿文章，统计之都将安排专业相关人员进行审稿并择优录用。文章内容建议涵盖但不限于（可参考统计之都[已发表文章](/archives/)）：

  * 产业相关数据实践
  * 编程语言/工具介绍及应用
  * 统计、机器学习建模科普及实践
  * ……

为了提高文章的可读性、趣味性，审稿人将与您进一步沟通并提出反馈意见。最终修改成文稿件将在统计之都平台（主站+微信）公开发表。

即使您不想亲自写稿投稿，也仍然可以以邮件或其它方式向我们推荐稿件，需要注意的是请您在推荐之前协助解决作者授权问题，本站不发布未经授权的文章。
