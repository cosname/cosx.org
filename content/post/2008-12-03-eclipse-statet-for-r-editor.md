---
title: 打造得心应手的统计编程平台－－Eclipse + StatET
date: '2008-12-03T13:31:04+00:00'
author: 胡荣兴
categories:
  - 统计软件
tags:
  - Eclipse
  - R语言
  - StatET
  - 编辑器
slug: eclipse-statet-for-r-editor
forum_id: 418747
---

本文的目的是告诉你如何打造一个好的R的编程界面和环境，让你充分享受用R编程的乐趣。这不是一个关于R的教程，可以访问[这里](http://a-lucky-bird.spaces.live.com/blog/cns!9FE71C3A1FA0267F!662.entry)以获得更多关于R的资源。大家也可以加入QQ群42131822和[R的邮件列表](http://groups.google.com/group/R-Forum?hl=zh-CN)(需要google账号)可以认识正在使用R的更多的朋友，也可以通过`hurongxing[at]126.com`和我联系。本文论坛讨论帖参见[这里](https://cos.name/cn/topic/12136 "Eclipse + StatET真的不错")。

<!--more-->

### 为什么会选用Eclipse呢？

  * 和R一样，Eclipse也是开源的。你可以免费从[www.eclipse.org](http://www.eclipse.org)下载
  * Eclipse是一个很好的编辑器
  * 通过Eclipse，你可以非常方便地维护R的脚本文件
  * Eclipse是一个开放的平台，通过插件，你可以为自己量身订做个性化的编辑环境。

除了Eclipser，我们还需要Stephan Wahlbrink为Eclipser写的R插件StatET（[www.walware.de/goto/statet](http://www.walware.de/goto/statet)）

### StatET的特点：

  * 支持在Eclipse平台上（通过将代码发送到R）运行R代码
  * 支持语法高亮显示
  * 支持使用R代码模板
  * 支持创建R的文档文件(*.Rd)
  * 可以从Eclipse运行R命令

# 1. 安装软件

step 1: 在R中执行命令`install.packages("rJava")`，安装rJava包。

step 2: Eclipse是一个Java程序，所以需要Java Runtime Environment(JRE)，先从[www.java.com](http://www.java.com)下载并安装[JRE](http://www.java.com/zh_CN/download/manual.jsp#win).

step 3: 从[www.eclipse.org](http://www.eclipse.org)下载[Eclipse Classic](http://www.eclipse.org/downloads/download.php?file=/eclipse/downloads/drops/R-3.4.1-200809111700/eclipse-SDK-3.4.1-win32.zip)。Eclipse不需要安装，解压即可使用。

step 4: 安装StatET。StatET可以通过Eclipse安装：

  * 启动Eclipse (废话)。
  * 依次选择“Help”－＞“Software Updates”，在弹出的对话框中选择“Available Software”标签。
  * 点击“Add Site”按扭，在弹出的对话框中将“`http://download.walware.de/eclipse-3.4`”加入到更新源中（如果是3.3版本的Eclipse则添加`http://download.walware.de/eclipse-3.3`），确定后，出现下图

![安装](https://uploads.cosx.org/2010/03/install.png)

然后按提示安装StatET。

# 2. Eclipse使用基础

下面我们来看Eclipse是如何使我们的R的编程这旅变得更方便。这里只对Eclipse作一个简介，有关Eclipse的更多信息可以参考Eclipse的在线文档：

<http://www.eclipse.org/documentation>

## 2.1 Eclipse的界面

Eclipse启动后如下图。

![开始界面](https://uploads.cosx.org/2010/03/startup.png)

依次选择菜单栏中的“Wndows”，“Open perspective”，“Other”,在弹出的对话框中选中“StatET”并单击“确定”，我们就打开了StatET视界（perspective），如下图：

![视界](https://uploads.cosx.org/2010/03/perspective.png)

这儿的概念视界（perspective）就是指的Eclipse提供的一个桌面开发环境，它包含不同的窗口，编辑器和视图，它们分别被归类到不同的标签（tab）中。这些组件可以随意拖动，放到不同的位置。

## 2.2  Eclipse中的工程

与大多数编程环境一样，Eclipse也是用工程（project）来管理我们工作的。在我们开始编程前应当新建一个工程。

### 2.2.1  新建一个工程

依次选择菜单栏中的“File”, “New”,“R-Project”，打开新建R的工程的对话框。如下图所示


![建立工程](https://uploads.cosx.org/2010/03/project.jpg)

在上图所示的对话框填好工程名和工作路径后，单击”Finish”按钮。我们的工程就建好了。新建好的工程我们可以在“Project Explorer”视图中看到。在下图中，我建立了一个名为myProject的工程。

![myproject](https://uploads.cosx.org/2010/03/myproject.jpg)

一个工程就相当于一个容器，你可以在其中添加或新建各种各样的文件。建好一个工程后，在该工程的工作目录下就会多出一个“.project”文件，该文件用来保存整个工程的各种信息。

### 2.2.2 向工程添加文件。

右键单击“Project Explorer”中的工程名，依次选择“New”,“R-Script file”，打开新建R的脚本文件对话框。如下图

![添加R脚本](https://uploads.cosx.org/2010/03/script.jpg)

在选择好文件夹，指定了文件名后，单击“Finish”，我们的R脚本文件就建好了。本例中，我建立了一个名为“prime.R”的文件，用来查找质数。

  * 你可以通在工程名上单击右键选择“Import”，导入其它文件。需要注意的是被导入的文件将被复制到当前工程的目录下，以后在工程中对文件的修改不会应用到原始文件。
  * 与导入不同，你可以通过在工程名上单击右键选择“File”，在弹出的对话框中选择“`Advanced`”，将外部文件链接到工程中来，这样该文件就不会复制到当前工程的工作目录中。
  * 为了更好地组织你的文件，你也可以在工程下建立子目录。

## 2.3 文本编辑

现在我们来体验下Eclipse，选择我们刚刚建立的prime.R文件，在其中输入
```r
prime = function(n){
    prime1 = function(x){
        y = TRUE
        for(i in (x %/% 2):2){
            if(x %% i == 0) y = FALSE
            if(x == 2 | x == 3) y = TRUE
        }
        y
    }
    x = c()
    for (i in 2:n){
        if(prime1(i)) x = c(x,i)
        if(i == n) return(x)
    }
}
prime(100)
prime(1000)
```

感觉到它的魅力了吧。支持自动缩进，语法高亮显示。Eclipse还有很多特性可以让我们更愉快、更高效地编程。它的部分特征还包括：

  * 行号和自动区分： 要在文本编辑器中显示行号和快速区分，请右键单击文本编辑器左侧灰色竖条，在上下文菜单中选中“Show Line Numbers”和“Quick Diff”。快速区分的可以区分不同的代码段，如不同的函数体。如果你删除了某行，该行的行号下将有一根小黑线，鼠标指向它时，删除的内容将被显示出来。
  * 自动完成：你可以在单词一部分后按Alt+/，Eclipse将自动完成未输完的部分。
  * 历史记录：你每次保存文件时，Eclipse就会记录下这你对文件的改动。这样你就可以方便地恢复到文件的以前版本。要打开历史记录，在“Project Explorer”中右键单击文件名选择“Compare With”,“Local History”
  * 文件比较：与历史记录类似，你也可以在两个文件的不同。
  * 书签：书签可以帮助你快速定位到程序的某行。要插入书签，右键单击插入的行的左侧选择“Add Boodmark”。在菜单栏中选择“Window”,“Show View”,“Other”,在里面选中“Bookmarks”可以打开书签视图。你也可以对整个文件都加个书签。
  * 任务标签(Task)：类似书签，你也可以在文件中加入任务标签。
  * 代码折叠。

# 3. StatET插件

## 3.1 配置交互环境

我们在前面编辑的R程序现在还不能运行。还要对StatET作一番配置才行。选择菜单栏中的“windows”，“Preferences”，打开配置窗口，展开StatET，如下图

![配置交互环境](https://uploads.cosx.org/2008/12/image12.png)

定位到“R Environments”,点右侧的按钮“Add”,将你计算机上安装的R的添加进去，如下图。

![设置路径](https://uploads.cosx.org/2008/12/image13.png)

关闭该对话框.

在Eclipse菜单栏中选择“Run”->“Run Configurations”, 在Main标签中按下图作出配置。

![运行配置](https://uploads.cosx.org/2010/03/runconf.png)

在工具栏中打开刚配置好的R控制台，如下图。

![运行](https://uploads.cosx.org/2010/03/run.jpg)

R控制台被打开。点红色按钮就可以关闭R控制台。

![控制台](https://uploads.cosx.org/2010/03/console.png)

在控制台的底部，你可以手动输入R的代码，提交给R执行。如下图。

![命令行](https://uploads.cosx.org/2010/03/commandline.png)

现在，我们就可以将前面在Eclipse中建立的文件prime.R提交给R运行。

将焦点设置到“prime.R”文件上，这时工具栏上就会出现R的运行命令，

![image](https://uploads.cosx.org/2008/12/image-thumb27.png)

，我们可以选择我们想要的方式运行文件prime.R中的代码。

也可以在文件中单击右键，在上下文菜单中选择所要的运行方式。这里，我们通过快捷键先按Ctrl+R,再按Ctrl+D,将整个文件直接提交给R执行。在R控制台中就出输出执行结果。如下图。

![运行代码](https://uploads.cosx.org/2010/03/runcode.png)

这样我们就成功地在Eclipse中编辑并运行R代码了。

在退出Eclipse时，应先关闭R控制台（按钮 ![image](https://uploads.cosx.org/2008/12/image-thumb29.png) ），再退出Eclipse.

注：下面的内容来自COS论坛（[https://cos.name/cn](https://cos.name/cn "https://cos.name/cn")）：

**Ihavenothing：**请教一个问题，我想把base里面一些常用的函数导入到StatET的语法库中，从而实现高亮，但它提供的窗口好像只能一个一个添加，这样工程量似乎太大了，不知道有没有办法实现批量导入？

谢谢了。

**Ihavenothing：**是这样的，先找到你设置的工作空间文件夹，然后依次打开\.metadata\.plugins\org.eclipse.core.runtime\.settings\，找到de.walware.statet.r.ui.prefs这个文件（如果没有这个文件，见最后），在里面找找看有没有以”text\_R\_rDefault.Custom2.items=”为开头的语句，如果有的话，只需把你准备实现高亮的词语加到等号后面就可以了。保存之后进入Eclipse，选择Winow菜单中的Preferences对话框，顺次展开StatET->Source Editors->R Identifier Groups，在右边的框中选中Custom 1（注意，配置文件中对应的是Custom2，可能是个bug），如果下面的列表框中出现了你刚才添加进去的词语，就说明配置成功了。接下来，只要在R Syntax Coloring对话框中找到Custom 1这一项，然后应用你自定义的高亮方式就可以了。

需要注意的是新加入的词语不能与StatET中已有的重复，否则可能会出错。

下面这个链接中是一个文本文件，里面是我写好的配置语句，包括了base包里面大部分的函数。打开之后把文本文件中的内容添加到上面说过的那个配置文件中就可以了（当然要把原来已经有的相应语句覆盖掉）。

<http://www.box.net/shared/p8rigr8yv7>

如果找不到上面提到的那个文件，可以先在R Identifier Groups对话框的Custom 1中随便添加一个函数，然后再进入那个文件夹，就可以发现de.walware.statet.r.ui.prefs这个文件了。

**cloud_wei**：

网上搜了一个函数，是搜索R中的函数的。

**CODE:**

```r
findfuns = function(x){
    if (require(x, character.only = TRUE)){
        env <- paste("package", x, sep = ":")
        nm <- ls(env, all = TRUE)
        nm[unlist(lapply(nm, function(n) exists(n, where = env,
            mode = "function", inherits = FALSE)))]
    }
    else character(0)
}

z = lapply(.packages(all.available = FALSE), findfuns)
z = unique(sort(unlist(z)))
cat(z, file = "out.txt", sep = ",")
```
