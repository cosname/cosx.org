---
title: 开发R程序包之忍者篇
date: '2011-05-29T13:04:26+00:00'
author: 谢益辉
categories:
  - 统计软件
tags:
  - Doxygen
  - Emacs
  - ESS
  - GIT
  - Rd2roxygen
  - roxygen
  - R包
  - R文档
  - R语言
  - SVN
  - Vignette
  - 创建R包
  - 命名空间
  - 版本控制工具
  - 环境变量
  - 软件文档
slug: write-r-packages-like-a-ninja
---

作为一个伪程序员，我在做与代码有关的事情时，总是抱以一个念头，即“简化手工劳动到极致”。在这篇文章里，我介绍一下目前我认为最简化的开发R包的流程。本站作者胡荣兴曾经在09年写过一篇开发R包的文章“[在Windows中创建R的包的步骤](/2009/02/create-r-packages-under-windows/ "在Windows中创建R的包的步骤")”，其中小部分内容随着R本身的更新已经过时，该文面向Windows，而且介绍的都是一些正统方法，这里我介绍一条“忍者”之路，希望对大家开发R程序包有所帮助。这篇文章本来是去年年底打算写的，时至今日[第四届中国R语言会议](/2011/04/chinar-2011/ "第四届中国R语言会议通知")正在人民大学轰轰隆隆召开，索性把它写完，算是一份不到场的报告吧。

在我看来，R的扩展性主要体现在R包中，利用附加包的形式，我们可以把一些常规的、模式化的工作打包起来供日常使用，在R包中我们还可以为函数编写文档和说明，这样可以避免将来忘记一个函数是做什么的以及怎么用的（忘记了就查帮助，`?function.name`），文档是程序的重要组成部分，我个人常常认为写文档的难度不亚于写代码；此外，R包还体现了R的另一点扩展性，即它能融合其它底层语言，典型的就是C语言、C++和Fortran，但一般用户可能用不到这些功能，下文仅简要介绍一下。

## 一、工具

对Linux和Mac用户来说，只要装好了R，开发R包的工具就已经具备，可跳过本节。Windows用户除了安装R之外，还需要[Rtools](http://www.murdoch-sutherland.com/Rtools/)和一套LaTeX程序，典型的如[MikTeX](http://www.miktex.org)。安装Rtools的过程中有一步需要注意，就是修改环境变量PATH，这个选项是需要选上的。对于R本身，还需要把它的bin路径放到环境变量PATH中去。说了半天，什么是PATH？这是个让明白的人抓狂、不明白的人迷茫的问题，不过找它比找拉登可能还是稍微容易一点：

<p style="text-align: center;">
  “我的电脑”（右键）–>“属性”–>“高级”–>“环境变量”–>“系统变量”–>PATH
</p>

这里我们可以看到一连串路径。为什么系统要有个PATH变量？原因就是为了能够脱离程序的绝对路径以命令行方式来运行程序，这样使得程序员不必担心你的程序装在什么位置。当你在命令行窗口（*nix系统下叫终端，Terminal）中敲入一个命令时，系统就会从这一系列的PATH路径中去找你敲的这个程序是否存在，如果存在就运行它。“开始”–>“运行”（或者快捷键Win + R），输入`cmd`回车运行，就会打开一个命令行窗口。如果你从来没用过这玩意儿，那你肯定是Windows深度中毒者，不妨先玩玩`dir`、`cd ..`等命令。

前面说要把R的bin路径加入PATH，这个路径在哪儿？如果你记不住自己的R装在哪儿，没关系，打开R，输入`R.home('bin')`就知道了。通常是类似于C:\Program Files\R\R-2.xx.x\bin\这样一个路径。说到这里，我还得绕道再说一句：安装R的时候尽量装在一个不带版本号的目录下，否则将来更新很麻烦，而且每次装新版本的R还得再修改PATH变量，因为bin路径变了。关于这一点，我只能说R core们都太严谨了，上次我在R-devel邮件列表里被一群人打了个落花流水，他们死活都不能接受把R的安装路径改成默认不带版本号的。

设置好R的路径之后，为了测试各种设置是否齐备，可以打开命令行窗口，输入一些常用命令看看能否执行：

<pre class="brush: plain">R --version
ls
gcc --version</pre>

如果这些都没问题，就可以进入下一节了。这里敲R对命令行来说，就是看看PATH中那些路径里有没有一个路径下包含R.exe或者R.bat之类的可执行文件，这就是所谓的“脱离绝对路径运行程序”。由于*nix系统的程序管理方式和Windows不同（可执行文件通常统一放在/bin/或者/usr/bin/目录下），所以通常没有这些痛苦。

## 二、R包结构

写R包最好的参考莫过于R自身的手册“[Writing R Extensions](http://cran.r-project.org/doc/manuals/R-exts.html)”（下文简称R-exts）。在R中打开HTML帮助（`help.start()`），就可以看见这本手册，内容很长，不过大部分都是普通用户不必关心的。我的建议如下：对新手而言，必须要了解R包的结构，所以[1.1.1节](http://cran.r-project.org/doc/manuals/R-exts.html#The-DESCRIPTION-file)和[1.1.3节](http://cran.r-project.org/doc/manuals/R-exts.html#Package-subdirectories)必读，而整个[第2节](http://cran.r-project.org/doc/manuals/R-exts.html#Writing-R-documentation-files)可能是将来需要反复参考的（除非你记性很好）；已经上路的用户可以接着看一些高级话题，如命名空间（[1.6节](http://cran.r-project.org/doc/manuals/R-exts.html#Package-name-spaces)）和底层语言的使用（[第5节](http://cran.r-project.org/doc/manuals/R-exts.html#System-and-foreign-language-interfaces)）等。

一个最简单的包结构如下（括号中为相应解释）：

<pre class="brush: plain">pkg (包的名字，请使用一个有意义的名字，不要照抄这里的pkg三个字母)
|
|--DESCRIPTION (描述文件，包括包名、版本号、标题、描述、依赖关系等)
|--R (函数源文件)
   |--function1.R
   |--function2.R
   |--...
|--man (帮助文档)
   |--function1.Rd
   |--function2.Rd
   |--...
|--...</pre>

DESCRIPTION文件是一个纯文本文件（没有扩展名，Windows用户可以用记事本或其它文本编辑器打开），其内容参考R-exts就明白了，注意只有几个字段是必须的，其它都可选。如果你的包依赖于别的包中的函数，那么可以在Depends一行中写上那些包的名字（逗号分隔）。如果这个包只需要引入（Imports）别的包中的函数，那么就在Imports中写那些包的名字。Depends和Imports有细微差别：前者将导致加载你的包时，依赖包也被明确加载进来，用户可以直接使用这些包中的函数；后者不会导致那些包被明确加载，只有你的包在调用那些函数，但那些函数对用户是不可见的（除非用户明确加载之）。这里涉及到命名空间问题，后文详述。

除了R和man文件夹之外，还有一些可能有用的文件夹，如demo下面可以放一些演示R代码，这样用户可以使用`demo()`函数调用这些演示，通常这是除了示例之外的最好的展示包功能的方式；data文件夹下可以放数据，这些数据通常是通过`save()`函数保存成\*.rda文件放到这里；src文件夹下可以放其它语言的源代码，编译安装的时候这些代码会被编译为动态链接库文件（pkg.dll或pkg.so）；inst文件夹下的任何文件在安装包的时候都将被复制到包的根目录下，例如这里可以放NEWS文件（包更新的消息）或CHANGELOG文件，inst下通常还有一个重要的子文件夹就是doc，这里可以放一个Sweave文件（\*.Rnw），编译安装包的时候这个文件会被Sweave编译生成LaTeX文件继而生成PDF文档，这也是关于一个包的很重要的介绍文档，称为Vignette。

对于心急的看官，到这里可以先忽略所有介绍，直接写一个DESCRIPTION文件外加一个R文件夹，底下放一个*.R脚本文件，里面包含一个函数，然后其实就可以安装使用了。但这种粗略的办法不是长久之计，如前面所说，文档很重要，提醒自己也方便他人。

## 三、安装R包

装包很简单，一句`R CMD INSTALL pkg`就可以。例如你的包文件夹路径为/a/b/c/pkg/，那么先在命令行窗口中切换到这个pkg的上层目录下，然后用前面的命令安装：

<pre class="brush: plain">cd /a/b/c/
R CMD INSTALL pkg</pre>

这样就装好了，在R中可以通过`library(pkg)`加载进来使用。

## 四、忍者神龟

至此，似乎听起来很简单：写两个函数，扔在R文件夹下，然后`R CMD INSTALL`一下，完事。不写文档、觉得命名空间神马的最讨厌了的人现在的确可以退场了，接下来我们深入一些话题。

### 4.1 R文档与roxygen2

R-exts手册[第2.1节](http://cran.r-project.org/doc/manuals/R-exts.html#Rd-format)给了一个简单的文档示例，我们可以看到R文档的语法和LaTeX很像，都是一些宏命令，如`\title{我是标题}`或者`\description{我是描述}`。当然，这些玩意儿你都可以手写，如果要稍微偷懒一下，也可以用`package.skeleton()`或者`prompt()`等函数来辅助生成Rd文件，这些函数都可以为你生成一些空模板，你自己往里面填充内容。若你的包只有一两个函数，倒也无妨，轻松写写完事，要是你想维护30个函数，那你就会觉得这种做法完全是坑爹。坑爹之处不仅在于你要么手敲这些命令要么绕道用函数生成文档模板自己填充，更在于你得在man文件夹下维护R文件夹下的函数的文档！你每次更新R函数，都得战战兢兢记住了：还有man文件夹下的某个*.Rd文件也许需要更新。

这并不是什么新鲜问题，所有的程序开发都面临这样的问题，于是有人发明了Doxygen，大意是把文档融入到源文件中，通常采取的方式就是把文档写成一种特殊的注释，这样不会影响源文件的执行（因为注释会被忽略），同时也可以从注释中动态抽取文本生成文档（如HTML或LaTeX/PDF等），这个主意相当妙。开发程序的时候只需要在同一个文件内操作即可：举头望文档，低头思函数。

[roxygen2](http://cran.r-project.org/package=roxygen2)是一个R包（它的前任是[roxygen](http://cran.r-project.org/package=roxygen)，但已经停止更新了），它实现了把特定注释“翻译”为R文档的工作，例如：

<pre class="brush: r">##' @author Yihui Xie
##' @source \url{https://cos.name}</pre>

会被翻译为：

<pre class="brush: plain">\author{Yihui Xie}
\source{\url{https://cos.name}}</pre>

你可能会说，嗨，介有嘛啊！！注意这些注释是直接写在函数定义上方的，当然，这么说你还是不信。所以下面必须介绍另一门暗器，也就是传说中的编辑器Emacs。

### 4.2 roxygen与Emacs

如果你得手敲那些`##'` 注释，那我当然不会写这篇文章。曾经有两个软件我觉得我永远都学不会，一个是Emacs，另一个是Photoshop；如今只剩下一个（我也不打算学了）。Emacs是我装了卸、卸了装超过10次的软件，终于在第11次搞明白了六指琴魔是怎么个练法。如果你也是新手，那么建议安装[Vincent Goulet维护的修改过的Emacs](http://vgoulet.act.ulaval.ca/en/emacs/)。修改之一就在于直接加入了[ESS](http://ess.r-project.org/)（Emacs Speaks Statistics），ESS是Emacs的一个插件，它提供了编辑器与其它统计软件（如SAS、S-Plus、R）的交互，例如可以通过快捷键把R代码发送到R里执行。

ESS本身我觉得也没啥，但ESS加上了roxygen的支持之后我就觉得这是个忍者工具了。在Emacs中，光标放在R函数上，快捷键C-c C-o一按，就如同发出一把暗器，一个roxygen注释模板立刻生成了。这一点让开发R包不知道快了多少倍。也许有读者知道我在维护一个叫[animation](http://cran.r-project.org/package=animation)的R包，说实话，曾经有一段时间我实在不想维护了，因为写函数写文档太麻烦，直到打通了Emacs和roxygen关。

好嘛！听起来好像不错，咋用？装好Emacs之后，先去找个[参考卡片](http://home.uchicago.edu/~gan/file/emacs.pdf)，练习两天一些基本操作（打开文件、保存文件之类的），熟悉一些基本概念（有些相当坑爹，例如剪切不叫剪切，叫杀，粘贴不叫粘贴，叫拉），当然首先得知道C代表Ctrl键、M代表Alt键。再找个[ESS参考卡片](http://ess.r-project.org/refcard.pdf)，看看基本的代码发送操作。总而言之，常用的快捷键不多，不需要真的变成六指琴魔。要是陷入了快捷键连锁陷阱（自己不知道按到哪里去了），就以万能的C-g退出再来。

假设你已经装好了Emacs，现在可以任意打开一个R文件：C-x C-f，输入文件名，回车，如果存在则会打开它，如果不存在，则会新建一个文件，注意作为一个（伪）程序员，你必须永远牢记：不要老老实实打字！能用Tab键的时候尽量用，它在很多情况下都能自动补全（如路径、对象名称等）。这里的文件名应该以.R或.r为后缀，这样Emacs才知道应该用ESS来处理它，例如abc.R。现在在编辑器界面内输入一个任意函数，如

<pre class="brush: r">stupid_f = function(a, b){
    a + b
}</pre>

然后把光标放在`stupid_f`这一行上，按C-c C-o，你就会发现你的文件变成了类似这样一个东西（根据ESS不同的配置，以下结果也许不完全相同）：

<pre class="brush: r">##' title...
##'
##' description...
##'
##' details here
##' @param a
##' @param b
##' @return
##' @author Yihui Xie &lt;\url{http://yihui.name}&gt;
##' @examples
stupid_f = function(a, b){
    a + b
}</pre>

接下来你的任务就是把该填的文档填上。roxygen2的常规是，第一段是标题（将来翻译为`\title{}`），段落之间以空行分开，第二段是描述（`\description{}`），然后接着是这个函数的详细描述（`\details{}`），它可以是若干段落，你愿意写多长就写多长。剩下的`@`字段就不必多解释了，参数、返回值、作者、示例等，我们可以通过`M-x customize-group`，回车，`ess`，回车，来配置ESS中这些roxygen的默认字段。一个自然而然的问题就是，哪些字段是可用的？参见roxygen2包的帮助`?rd_roclet```。为了完全理解Rd文档和roxygen2字段的对应关系，你最好还是读一下手册R-exts和这两个帮助页面。注意ESS有很多方便的功能，比如你在roxygen注释之后回车，下一行会自动以`##'` 开头；在任意一个`@`标签后按M-q则可以把该段落自动折叠为短行，使得文本更整齐（这是我经常用的一个功能）；如果函数中有新增加或者减少参数，那么只需要再次C-c C-o就可以自动更新上面的注释了，新增加的参数会自动加上新的`@param`，减少的参数会被自动删掉注释。

roxygen2还实现了一些自动功能，比较重要的就是对命名空间文件NAMESPACE和描述文件DESCRIPTION的自动更新，这些我们第五节再说。先说如何从roxygen注释翻译到Rd文档，很简单：如果一个包已经按第二节的结构写好（不需要有man文件夹），函数和相应的roxygen注释都已经存在，那么用函数`roxygenize()`就可以把这样一个初级包翻译为一个完整R包了：

<pre class="brush: r">setwd('/a/b/c/')  # 先把工作目录切换到pkg之上
library(roxygen2)
roxygenize('pkg')</pre>

默认情况下新生成的R文档以及更新的NAMESPACE和DESCRIPTION都生成在包的目录下，现在pkg就是一个完整的R包，包含自动生成的man文件夹，可以直接用`R CMD INSTALL pkg`安装。

<del datetime="2011-08-12T17:53:42+00:00">天有不测风云，事情到这里还没完全结束，roxygen包也有些坑爹的地方，它本来是2008年Google编程夏令营的产物，但作者自夏令营结束之后投入维护的精力似乎就越来越少，导致很多问题都一直没有修正。我在使用过程中实在忍不了，于是动手写了个基于roxygen之上的包Rd2roxygen</del>（更新：roxygen包现在已经被roxygen2取代了，后者在更新维护中）

### 4.3 后悔药包Rd2roxygen

后悔药的意思是，有人看见roxygen是如此的方便，大为后悔，因为维护原始R包太费精力了，可是爹已经被坑了，已经按照R-exts的要求老老实实写了那一大把*.Rd文件，肿么办？[Rd2roxygen包](http://cran.r-project.org/package=Rd2roxygen)诞生的目的就是为了解决这个问题：roxygen是把注释翻译为Rd，而这个包倒过来，把Rd重新翻译回注释！给你后悔药吃。如果你是后悔的人中的一员，不妨参考这个包中的`Rd2roxygen()`函数；如果是新手，那么这个包的rab()函数可能是roxygen中的`roxygenize()`函数的一个很好的替代，其中我比较自豪的一个功能是它能自动整理示例代码，很多R包的示例代码都不够整齐（无空格无缩进等）。详情参见帮助文件及其介绍文档（Vignette）。简言之，现在我们使用：

<pre class="brush: r">library(Rd2roxygen)
rab('pkg')
## 如果要直接安装，那么rab('pkg', install=TRUE)</pre>

所有工具至此大概介绍完毕。如果你还没昏死过去，请接着读第五节。

## 五、九霄云外

上面的东西刚上手时可能是有点晕，熟悉之后写包就立刻风驰电掣了。下面我们再介绍几个略微高级的概念。

### 5.1 命名空间

命名空间（NAMESPACE）是R包管理包内对象的一个途径，它可以控制哪些R对象是对用户可见的，哪些对象是从别的包导入（import），哪些对象从本包导出（export）。为什么要有这么个玩意儿存在？主要是为了更好管理你的一堆对象。写R包时，有时候可能会遇到某些函数只是为了另外的函数的代码更短而从中抽象、独立出来的，这些小函数仅仅供你自己使用，对用户没什么帮助，他们不需要看见这些函数，这样你就可以在包的根目录下创建一个NAMESPACE文件，里面写上`export(函数名)`来导出那些需要对用户可见的函数。自R 2.14.0开始，命名空间是R包的强制组成部分，所有的包必须有命名空间，如果没有的话，R会自动创建。

前面我们也提到DESCRIPTION文件中有Imports一栏，这里设置的包通常是你只需要其部分功能的包，例如我只想在我的包中使用foo包中的`bar()`函数，那么Imports中就需要填foo，而NAMESPACE中则需要写`importFrom(foo, bar)`，在自己的包的源代码中则可以直接调用`bar()`函数，R会从NAMESPACE看出这个`bar()`对象是从哪里来的。

roxygen注释对这一类命名空间有一系列标签，如一个函数的文档中若标记了`##' @export`，那么这个函数将来就会出现在命名空间文件中（被导出），若写了`##' @importFrom foo bar`，那么foo包的`bar`对象也会被写在命名空间中。这些内容参见R-exts的[1.6节](http://cran.r-project.org/doc/manuals/R-exts.html#Package-name-spaces)和roxygen2的`?export`帮助。

### 5.2 介绍文档（Vignette）

前面我们提到了inst/doc/目录，下面可以放一个Sweave文件，在`R CMD INSTALL`过程中这个Sweave文件会被执行并生成PDF文档，若Sweave文件中有一句注释：

<pre class="brush: plain">%\VignetteIndexEntry{An Introduction to XXX}</pre>

那么这句话将来会出现在HTML帮助页面中（点开链接“Overview of user guides and package vignettes”），例如Rd2roxygen包或者formatR包的帮助页面中就有介绍文档的链接。

### 5.3 其它语言

在src目录下我们可以放置一些其它语言的源代码，里面可能包含一些函数，这些函数在被编译之后，（以C语言为例）可以在R代码中以`.C('routine_name', ..., package = 'pkg')`的形式调用，但要注意，如果需要用这个功能，在R目录下需要有一个zzz.R文件（这个特殊文件是用来在加载包之前加载运行的代码），里面写上：

<pre class="brush: r">.onLoad &lt;- function(lib, pkg) {
    library.dynam("pkg_name", pkg, lib)  # pkg_name是你的包的名字
}</pre>

这些东西我并不在行，只介绍到这里，详细内容还请深挖R-exts。另注意[楼下Rtist的评论](#comment-2604)。

## 六、发布

等你的包写好之后，还不能立刻发布，因为还有很重要的一步要做，就是看它是否能通过`R CMD check`的检查，这是你的包能发布到CRAN上的前提。在命令行界面中输入（请确保pkg文件夹是一个完整的R包，即：如果你用roxygen2，那么这里要检查的是运行过roxygen2之后的产物）：

<pre class="brush: plain">R CMD check pkg</pre>

R就会开始检查这个包是否有语法错误以及是否符合规范。或者如果你用Rd2roxygen包的话，也可以在R里面调用：

<pre class="brush: r">library(Rd2roxgyen)
rab('pkg', check = TRUE)  # 确保pkg文件夹在当前工作目录下：getwd()</pre>

检查过程会告诉你详细的日志信息，如果有错，你立刻就能知道。这里每个函数的例子（如果有的话）都会被运行，如果例子代码有错，这里也会报错，所以这个过程也是一个很好的检查自己的示例代码能否正确运行的测试。如果没有任何错误，那么就可以向CRAN提交了。提交的内容是一个压缩包，名为pkg_x.x-x.tar.gz，它是通过`R CMD build pkg`生成的。提交方式是通过FTP，参见[CRAN首页说明](http://cran.r-project.org)。注意上传完之后需要向CRAN管理员发一封邮件，通知他们你提交了一个包，以后每次更新时的流程也一样：FTP上传+邮件通知。目前Kurt Hornik管理Linux包的编译，Uwe Ligges负责Windows包的编译，都是人工管理，要是碰上Kurt度假去了，你就得等着了（概率很小，不过我碰到过）。

## 七、后话

现在CRAN上的附加包数目已经超过三千，充分体现出R的良好扩展性和社区合作，要不然不会有这么多人去写R包（尽管这三千号包肯定是良莠不齐）。我个人是07年底从动画包animation开始写起的（想当年，R包里面还有微软的CHM帮助）……过了几年又陆续写了自动整理R代码的formatR包、把Rd转化为roxygen注释的Rd2roxygen包、把R图形转化为Flash动画的R2SWF包（与邱怡轩合作）、纯粹为了搞笑好玩的fun包（未发布）、为我的《现代统计图形》书稿配备的MSG包、用图形界面调用WinBUGS或者OpenBUGS的iBUGS包等。用麦兜的歌唱就是：

> 大包再来两笼
  
> 大包再来两笼
  
> 大包再来两笼不怕撑
  
> ……

扯远了。

写了这么些包，有些感受。首先，写代码有两样一般人不能理解的困难，一样前面已说，就是写文档，你得解释清楚参数的含义、得给出有用的示例代码、写演示写介绍文档等等，工作量其实很大；另外一样就是对象命名，我认为从对象的命名可以看出一个程序员的成熟程度，好的程序员，给的函数名既精炼又直观，这一点上必须佩服R core团队，要是我写几千个函数，光是想名字都能把脑袋想爆了，这里顺便提一下我推荐的命名方式，要么用驼峰（`someFunction`），要么用下划线（`some_function`），尽量不要用点（`some.function`），因为点在R语言中有一层特殊含义（S3方法的类匹配），这也是我对animation包比较后悔的一点。其次，你最好学会一样版本控制工具，如SVN或者GIT，不仅是管理包，它在管理任何文本文件时都非常有用，也利于多人合作，我现在倾向于GIT，主要是因为一个好网站的存在（GitHub），我的所有R包都已经从原来以SVN为基础的R-Forge上[搬家到了GitHub](https://github.com/yihui)，可以在那里参考我的包是怎么写的；不会版本控制工具的人的一个典型特征就是，电脑里存在一系列这样的文件：领导汇报20100101.doc、领导汇报20100102.doc……，版本控制工具可以让你很方便回到文件的历史状态，也方便多人合作（例如将A的更新和B的更新自动合并）。最后，写包不仅是对自己工作的一个不断总结，不至于做完一件事就永远尘封之，而且也是很好的自我宣传途径，你在简历上写得天花乱坠，可能不如以一件作品更能深入人心。

又及，写完一个包之后，你可能就不会再对别人的包问：这是哪个狗日的写的文档？

又又及，也许你就或多或少能理解自由软件为嘛还没死掉。
