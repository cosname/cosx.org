---
title: 手把手带你搭建个人博客（基础版）
author: 庄亮亮
date: '2021-11-16'
categories:
  - 统计软件
meta_extra: "审稿：叶寻"
slug: build-blog-step-by-step
---

## 简介

你是不是特别想创建一个自己的私人博客？使用 `blogdown` 搭建博客难度大不大？与其他方式搭建博客相比又有什么优点？

在使用过一段时间后，个人认为 `blogdown` 搭建博客的优势在于：它能将 `R Markdown` 与 `Hugo` 相结合，再加上 `GitHub` 和一个可以部署的网站，读者可以轻松的将一篇篇 `Rmarkdown/markdown` 的文章自动上传。而 `R Markdown` 的优势在于：代码结果可以轻松呈现，而不是“复制粘贴”结果！

> 如果读者不熟悉 Rmarkdown，推荐阅读 [R Markdown 入门教程](https://cosx.org/2021/04/rmarkdown-introduction/)，并结合 [B 站视频](https://www.bilibili.com/video/BV1ib4y1X7r9?spm_id_from=333.999.0.0)，这样学习效果更佳。

本文是作者在学习和使用中记录的一个详细笔记，主要参考：谢益辉的[《blogdown: Creating Websites with R Markdown》](https://bookdown.org/yihui/blogdown/ "《blogdown: Creating Websites with R Markdown》")，王诗翔的[B 站直播视频](<https://www.bilibili.com/video/BV13v41147BH?from=search&seid=3349593737199514913> " b 站直播视频")以及一些[ YouTube 视频教程](<https://www.youtube.com/watch?v=ox_Ue9yzf-0> " YouTube 视频教程")。

![本文框架](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20211116131444590.png)

## 1. 入门教程

### 1.1 安装

安装 `blogdown` 包：

    install.packages("blogdown")

> **注意**：操作是在 RStudio 下进行操作的，RStudio 的界面介绍可见[视频](https://www.bilibili.com/video/BV1Jh411y76L?spm_id_from=333.999.0.0)。

### 1.2 创建

安装完后，新建一个新的 `Project（File - New project）`，然后选择 `New Directory`。鼠标滑到底部，找到 `Website using blogdown` 并点击进入。

![创建新的项目](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719154631549.png)

进入到以下界面（注意：**项目名称**建议使用英文，**目录**自行选择）。默认情况下 `Hugo theme` 是谢益辉的模板，这里将其进行拓展，使用了个人比较喜欢的主题：`Fastbyte01/KeepIt`，左下角勾选打开新的 session。

> **注意**：为了保证整个演示流程的完整性，将“选择不同 Hugo 主题”教程放到文末作为附加内容。请注意整个演示逻辑，以免越学越糊涂。

![新建界面时的设置](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719145109508.png)

新建后界面如下，右下角给出了整个项目的文件。其中，圈起来的最为关键，稍后详细介绍。先编译这个初始 `blogdown`。

![初始 blogdown](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719145533256.png)

选择 `Tool - addins`（Windows 更方便找到）然后选择以下按钮。

![addins 插件](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719144620808.png)

稍等片刻，得到原始博客模板。

> 如果做到这，恭喜你！基本已经会 1/3 了，没错就是这么简单。

### 1.3 模板修改

不同的模板修改起来是不一样的，但是原理类似，如果你知道一些 YAML 的知识，那可能会更好。如果不会，就慢慢改咯！

> **使用技巧**：改一个地方，保存下，右下角 viewer 会自动编译，可以根据变化看看是不是想要的结果（"笨"方法）。

这里以该模板为例：主要修改 `config.yaml` 文件。首先将其打开，得到的界面如下：

![`config.yaml` 文件](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719160220457.png)

主要修改内容：`title`（第 4 行），`subtitle`（第 84 行）。保存该文件，右下角即可快速得到以下界面：

![本地网站](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719160440312.png)

如果想修改头像，可以在该 `yaml` 文件的第 34 行找到代码 `avatar: /images/me/avatar.jpeg`。此时从桌面打开该文件夹，更换该 JPEG 文件即可，例如：

![修改头像](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719160756100.png)

如果界面没有更新（可能是 Bug），可以运行代码，类似重启一下：

    blogdown::stop_server()
    blogdown:::serve_site()

![修改后的 blog](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719161006304.png)

### 1.4 将项目与 GitHub 相连

本地博客基本构建完毕，接下来将其连接到自己的 GitHub 上，再部署到线上。首先，先将该文件夹上传到自己的 GitHub 上，你可以使用 Git（如果你熟悉的话），这里使用按钮式操作的桌面版本 GitHub （入门新手使用更佳）。

> **注意**：如果第一次使用 GitHub，或者还没下载 GitHub 桌面版本的小白。可以通过各个平台资源，简单学习下，这里不做过多介绍了。

-   GitHub 桌面版本操作

    连接本地的文件夹（`zss`），按照下面操作。

    ![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719150226752.png)

    之后如果出现以下界面，点击蓝色字

    ![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719150332449.png)

    跳转到以下界面，设置线上 GitHub 对应仓库的相关信息。

    ![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719150402141.png)

    之后将创建好的仓库 publish 上去。`Keep this code private` 勾不勾都可以，勾选后仓库只能自己查看，不勾选取就将其变成公开的仓库。

    ![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719152432162.png)

-   查看是否上传

    检查 GitHub 是否有这个仓库，如下：

    ![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719152558356.png)

    这时，本地项目和 GitHub 已经连接好啦！

> 恭喜！你已经会了 2/3 啦。马上就可以拥有自己的私人网站！


### 1.5 使用 Netlify 部署网站

这里使用 Netlify：[https://app.netlify.com](https://app.netlify.com) 进行部署网站。当然读者也可以使用和 Netlify 类似的 Vercel，或者其他方式，具体可见 《Creating Websites with R Markdown》 的[第三章](https://bookdown.org/yihui/blogdown/deployment.html)。

首先是注册新用户（创建不难，如果进不去可能需要科学上网）。之后将其与 GitHub 相连接，进入以下界面：

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719150812523.png)

点击  `New site from Git`，跟着步骤往下做。点击左下角的 Github，选择刚才创建的仓库（`zss`）。

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719150849453.png)

根据以下界面进行部署网站。

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719151017788.png)

等待部署，得到以下界面。注意，读者可以通过 `Site settings` 修改自己的网站名。你可以到 Porkbun 或 Namecheap 等网站购买专属域名。

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719151045133.png)

点击网站链接，即可得到私人网站啦！

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719151437396.png)

> 恭喜你，你已经会简单创建自己的网站啦！

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719153023496.png)

![白色版本](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719153323458.png)

![黑色版本](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719153341901.png)

## 2. 工作流

在前面几项任务都完成好后，接下来创建 RMD 文件，保存，GitHub 提交，之后过几分钟网站就会自动同步你的最新博客！

> 这整个流程非常香，你唯一担心的是：**如何写好你的博客**。而完全不需要担心如何排版，如何部署 `rmd/md` 文件等问题。这就回到了最为纯粹的知识输出环节啦！

接下来，介绍如何创建新的 post 以及如何提交（难度不大）。

### 2.1 创建 RMD 文件

打开项目所在的文件夹（zll-blog），点击 Rproject 文件。

> **技巧**：直接打开桌面版本的 GitHub，找到对应的 Repository，按快捷键（红色框框给出了，`Show in Finder`）如下所示：

![GitHub 桌面版本界面](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210725171639643.png)

> 当然，可以按快捷键直接进入网上的 Github 仓库。

进入 RStudio 界面后，打开插件 addin。 mac 是在菜单栏 `Tools -> addins`中，Windows 直接在菜单栏就有一个小按钮 `addins`。选择下面红色框的内容，并点击执行（Execute）即可。

![选中红色框，执行](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210725171808872.png)

> 或者直接在控制台输入代码也可以创建新的 Post（`blogdown::new_post()`）。建议在打开这个 Project 之后先把博客渲染出来（`blogdown::serve_site()`）。

之后会跳转出一个框，根据所需填写！注意 Format 有三种形式。与 R 代码无关的可以直接创建 `.md` 文件，点击 Done 按钮，即可。

![New Post 示例](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210725172050133.png)

### 2.2 填写内容

如果提前已经渲染了博客，右边的 Viewer 窗口就会自动同步所写内容。

![开始内容输出！](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210725194655246.png)

接下来，靠你自己啦！可以写一些读书笔记，科研想法等。小编这里给出前段时间写的一篇博客的内容作为示范。

![填写内容](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210725194617200.png)

> **注意**：写好的 MD 文件可以直接将其导入。但是注意的是，图片等需要你手动添加到对应的目录下，或者使用图床进行线上存储，可以参考该篇[教程](https://mp.weixin.qq.com/s/djEicXPS-H-LTFNKDe26ig)。

保存后，new post 就已经完成啦！

![new post 完成](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210725194742883.png)

### 2.3 使用 GitHub 上传内容

最后一步，将刚才修改过的内容，通过 GitHub 进行上传。操作流程如下，之后等几分钟，Netlify 网站知道你的该 GitHub 仓库内容出现变化后，会自动更新网站。

![上传到 GitHub](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210725192651824.png)

这时一切完毕！恭喜你，已经掌握整个搭博客和写博客的流程啦！

## 附件： hugo 主题选择

[Hugo主题网站](https://hugothemesfree.com/ "Hugo主题网站")给出了很多免费试用的主题模板，读者可以选择个人偏好的主题（不需要和我上面一样），该网站的封面如下：

![Hugo主题网站](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719163448115.png)

本文使用示例为：[A simple but not simpler blog theme for Hugo](https://hugothemesfree.com/a-simple-but-not-simpler-blog-theme-for-hugo/ "A simple but not simpler blog theme for Hugo")，进入之后，点击 View GitHub 进入对应仓库。

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719144857943.png)

打开对应 GitHub 仓库后，复制名称到创建界面时的（Hugo theme）中。

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210719145024762.png)

前面所述主题就是这样得到的。

## 后记

-   如果读者为初学者，对 RStudio，GitHub ，Hugo，HTML 都不是很熟悉的话。建议按照上面流程照搬实现一次。然后再进行拓展，创建其他不同的 Hugo 模板。

-   搭建自己的博客，比较简单，难在持续输出内通和花时间和精力去维护。



