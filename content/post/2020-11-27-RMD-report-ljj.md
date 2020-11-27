---
title: "用 R Markdown 生成每周实验报告"
author: "李家郡"
date: "2020-11-27"
tags: [R Markdown, Beamer, LaTeX]
categories: ["统计软件"]
---

## 背景

本科时，我主要交作业的报告，写成 HTML 文件，再转 PDF ，追求“花里胡哨”，让别人看起来很“认真”、很“高端”的感觉。用 Prettydoc写完全没问题，网页很容易加入特效。但 HTML 打印输出结果时，相信很多人都会遇到打印不完整的情况。转变为研究生和博士之后，有时依然需要每周给导师写报告。这时候，还像交作业一样给导师交花里胡哨的 HTML 就有些没有必要了，这样会掩盖汇报的重点。我们得认识到报告实际上是为最终论文准备的。所有实验最终是需要放到论文上的。学术论文需要图表，图表往往需要直观、体现重点。如果是在赶一篇论文，并需要不断反馈实验进度时，那么就应该考虑是否能比较方便地将实验结果放置到最终的论文中。最终论文需要使用规定的 LaTeX 模板完成，所以每周的实验报告如果都用之前的方式写，必然会需要返工，而且效率也不高。

本科不怎么写 LaTeX，所以当时并没有对 LaTeX 的各种功能深入了解。虽然现在依然是半瓶水，但已经足够将 R Markdown 有机地与 LaTeX 结合起来。本文主要记录最近几周，对 R Markdown 与 LaTeX 结合生成 PDF 的一些经历和理解，本质还是一些搬运工作。虽然我本人并没有开发任何其中用到的任何工具和包，但网络上确实很少有系统地展示将这些功能综合起来能做到什么事的博客。希望能吸引更多人对其进行探索，之后也能方便我自己在未来写实验报告和展示，这是本文的目的。

## 从 yaml 开始

yaml是研究任何 R Markdown 模板的开始，研究 yaml 只需查看帮助即可，本文生成的 PDF 使用的引擎主要是 pdf_document ，也就是查看 pdf_document的帮助即可。

它的yaml有几个初学者容易止步的问题，有人使用 pdf_document 生成 PDF时，使用中文就会报错，那完全是对 LaTeX 的中文使用不熟悉导致的，解决 LaTeX 支持中文的方法有很多，我选择最简单，需要耗费最少代码的方式来举例说明。支持中文的要点在于正确使用包+正确使用编译引擎+正确使用编码格式。这里我的组合是 xelatex + ctex + utf8。此时yaml需要写为以下格式：

```
---
output: 
  pdf_document:
    latex_engine: "xelatex"
header-includes:
- \usepackage{ctex}
---
```

此外根据不同的系统，还需要解决可能存在的不同问题，这些对于熟悉 LaTeX 的选手来说都不是什么问题。比如有的mac系统下，会出现找不到中文字体的问题，此时需要把上面引用ctex包的命令改为 \usepackage[fontset=mac]{ctex}。

这里就是使用各种 LaTeX 包写报告的关键，引用包在header-includes 下，按照如上的格式书写。本文希望展示利用 LaTeX + R Markdown，我们到底可以将一个报告做到什么程度。本文展开的思路也就是根据不同 LaTeX 包，去说明不同的功能。

在开始对不同功能展开之前，还有两个值得一改的yaml参数，即keep_tex、keep_md，可以将它们都设置为 TRUE。原因在于，生成 PDF 主要有三个阶段，第一是将 .Rmd 转化为 .md ；第二是将 .md 转化为 .tex；最后才是将 tex 转化为 PDF。保留中间文件在调试和测试时有很关键的作用，可以根据生成的结果去研究到底需要在什么位置对输出结果进行修改。

## 引用其他方式生成的 pdf

R 语言是很好的胶水语言，直接使用别的方式生成的pdf文件或矢量图，将这点体现得非常到位。实际上，R 在报告中插入图片本质都是在引用chunk生成的 pdf 文件，当生成结束后，中间文件都会删除。使用这个功能需要在yaml中添加

```
- \usepackage{pdfpages}
```

引用某个 PDF 只需使用以下的include命令。
```
\includepdf[]{ PDF的路径 }
```
看起来这个功能平平无奇，但用的好了，可以将整个报告变得极为完整。例如，在其他设备上手推公式，又不想打字，那只需要转化为 PDF 附加到报告中即可。最近我需要从决策树去看一些统计量的物理意义，发现在python的决策树中可以直接生成树结构的结果，在python中生成 PDF之后 ，我可以很好地解释模型的意义。决策树可以生成结构不会是特例，网上有许多代码，生成网络结构图。特别是生成神经网络结构图，这时候往往都是利用 Python + Graphviz，这也就意味着我们可以很好的利用 R Markdown 将这些结果都整合到报告中。最最最重要的一点在于，这些PDF格式的结果都是矢量图，讲解时可以随意放大。

## tikz

说到可以利用高级语言生成图片，对于R来说，也可以利用 tikzDevice，这个包可以将R图片转化为tikz的代码。熟悉 LaTeX 也完全可以自己一点点写tikz的代码。要摸清一种数据结构，若不自己实现，感觉都差一点味道。在实现之后，如果能将其可视化，那将帮助别人更好理解。

我在学习跳表时体验了一下这个过程，实现跳表的数据结构很简单，但将其批量绘制为图片花费了我更多的时间。我在给别人讲解时，选择使用 Beamer 生成 slides。在设计完跳表的数据结构之后，我也设计了相应的绘图代码，这里不打算附上源码。

提到tikz最主要的原因在于它是利用 R Markdown 插入 LaTex最好的例子。使用tikz需要在yaml上添加
```
- \usepackage{tikz}
```
之后在写tikz代码时，只需要写	`\begin{tikzpicture}` 和	`\end{tikzpicture}` ,就可以在它们之间插入相应的绘图代码。

作为一个典型例子，在R Markdown中，无论使用任何 LaTeX 代码，都可以用引入包，写引用环境都可以解决。专业或许限制了我的想象，我在公式之外可能用到的环境除了 tikz 以外，还会需要写伪代码，需要的包为 algorithm2e，这里也就不需要赘述了。

## 流程化

到目前为止，主要介绍的都是 R Markdown 引用 LaTeX 的优点。对于熟悉 LaTeX 的人来说，这完全没有必要，换一个编译环境，还是在写一样的代码，节约的代码量也不多，完全没有使用 R Markdown的必要。 对于不熟悉 LaTeX 的人来说，似乎说的这些功能都离得好远，还是使用单纯的 R Markdown比较香。假如我不会R，确实没有必要为了写一份报告学习 R Markdown，这也是它面临的尴尬处境。但我比较希望从下面的例子中，阐明使用 R Markdown + LaTeX 可能达到的化学作用。

假定每几天就要开一次会，每次都可能需要运行新的模型，都要生成实验结果。老板不仅想看趋势图，也想看数值结果，且需要在每个数值结果中都要标注出满足某个条件的数据，例如最好的结果需要标为红色，而且数据集不止一个，最终还需要将实验转化为论文。一份有质量的报告当然不能仅仅只写成Excel，模型的架构图不画出来，又怎么能在最短的时间反应其内在的含义？

综上，实现以上的要求，确实需要几种语言的综合，将其流程化。要想快速运行新的模型，利用 C++ 和 Python 即可，要生成图文并茂的实验结果并方便别人打开查看，使用 R Markdown生成 PDF比较靠谱。需要将实验结果插入论文中时，就只需要保留中间的 tex 文件，倒是提取对应的代码即可。

## 数据框标注

将数据以表格的形式展示这一部分是我写这篇文章的主要原因，或许我的解决并非最优方案，但从我解决整个需求的过程中可以看到利用R Markdown + LaTeX 遇到问题时的解决思路。

按照R语言查看数据的习惯来说，一般是将 dataframe 打印出来查看。但随着数据量的增加，我需要标注出数据中满足某些条件的数值。例如论文中，我们需要标注出最优和次优的实验结果。打印 dataframe 的原理是通过 R 将其转变为对齐的数据，再用 verbatim 环境将数据展示，这是通过保留 markdown 文件和 tex 文件看出来的。那么我们要将其上色，则需要寻找查找关于verbatim环境上色的方案。有一个包 [fancyvrb](https://www.ctan.org/pkg/fancyvrb) 提供了解决的思路，通过查找它的[文档](https://mirrors.bfsu.edu.cn/CTAN/macros/latex/contrib/fancyvrb/doc/fancyvrb-doc.pdf)可以发现，改变verbatim环境颜色并不是很难，只需做到三件事。第一、将 `\begin{verbatim}`的环境设置转变为`\begin{Verbatim}`。第二、在`\begin{Verbatim}`后添加
```
[commandchars=\\\{\}]
```
第三、在需要转变颜色的位置插入 `\textcolor{颜色名}{文本}` 。这三件事都不太难，比较难的是找到这样的解决方案。经过我的尝试，可以在引用R代码的三个反引号前后，直接写`\begin{Verbatim}`就可以让 pandoc 转换代码时不将三个反引号转变为`\begin{verbatim}`。第二件事和第一件事是同一件事，只需要在`\begin{Verbatim}` 后将`[commandchars=\\\{\}]`加上即可。

举个例子，最终代码如下：

``````
\begin{Verbatim}[commandchars=\\\{\}]
```{r echo=FALSE,results='asis',comment=''}
data(iris)
iris$Species<-paste0("\textcolor{red}{",iris$Species,"}")
colnames(iris)[5]<-"\textcolor{black} Species"
print(head(iris))
```
\end{Verbatim}
``````

感兴趣的朋友可以尝试一下，大致能满足需求，但解决的并不算完美。由于print的局限性，会自己填充一些空格，使得列对齐，也就意味着如果增加一行`\textcolor{red}{}`这样的代码，就会使得这一列变长。要使得整体不被拉长，就需要对这列的所有元素都插入差不多长的变色代码。也就是为什么第五行还需要将列名设置为黑色。

这里还有两点小细节是我在探索过程中，寻找材料时才发现我过去都没意识到的控制指令。在 R Markdown 中可以通过控制chunk做到省略一些不重要的输出。`result='asis'`时，可以控制生成的 Markdown代码不产生三个反引号。 pandoc在处理Markdown文件时，遇到反引号且前面没有环境控制时，应该会自动将其转化为verbatim环境。但在我们开始尝试深入结合 R Markdown 的代码和 LaTeX 时，反引号则会累赘。`comment=''` 则是将dataframe前面的双井号给替代掉。页宽不够时，不妨将其删除。

研究到这里，在数据框上标注数据已经不是一件困难的事，虽然我还没有解决数据对齐的问题。虽然最终的代码确实简单，但这个过程绝不是一蹴而就的。在没发现在反引号前加引用包的环境时，会替换原有的verbatim环境前，我的方案甚至是保留生成的.tex文件，然后改环境代码，再去LaTeX环境中编译生成。

当然由于直接打印数据框最后的问题实在找不到方案解决，不能止步于将就。多亏发现了一个包[xtable](http://xtable.r-forge.r-project.org/)，改变的方案就是将数据框转变为 LaTeX 表格。

## 表格标注

虽然不太了解开发xtable作者初心是什么样子的，我猜测或许起初目的只是为了方便将结果转化为 LaTeX 代码，然后粘贴到.tex文件中写论文而已，但还是要谢谢他。我应该是没有精力和时间去弄一个这样的包，只是为了写报告。为了方便读者，我直接给出解决方案：

``````
```{r echo=FALSE,results='asis',comment=''}
writeLines("```{=latex}\n")
library(xtable)
data(iris)
iris$Species<-paste0("\\color{red}{",iris$Species,"}")
for(i in 1:10){
  print(xtable(head(iris),caption ="iris"),sanitize.text.function = identity)
}
writeLines("\\clearpage\n```")
```
``````

假使你仅是想使用我摸索出的结果，对其背后的原理并不想了解的话，那么可以直接套上面的框架即可实现需求。下面将对这段代码给出我自己的理解：

如果需要批量输出，直接使用xtable是不可行的，还是需要print，否则for循环中的内容不会输出到文件中。xtable函数返回的其实是一个变量实例，print则会调用它的方法，将其转变为特定格式的输出。LaTeX 改变字体颜色的代码不需要多讲，同时也可以改变格子背景颜色等等，这些都完全属于单纯 LaTeX 和 R 的问题。读者不妨尝试将 ``````writeLines("```{=latex}\n")`````` 、``````sanitize.text.function = identity`````` 等代码删除以后，仅保留for循环和`print(xtable(head(iris)`看看会出现什么结果。那么不仅不会变色，而且还会输出许多看不明白的错误信息。

首先我们需要解决的是产生奇怪注释的问题。还是要回到文章的一开头，我们需要保留 .md 文件和 .tex 文件，才能定位错误。在 .md 文件中，一切如常，而在 .md 转化为 .tex 文件时，pandoc将 % 看成了普通字符，在转化为 LaTeX 的过程中，加了转义符号，将其保留。这也导致了注释后的字符也显现了出来。在我又反复查看xtable的源码之后，发现作者挺nice，为我留下了后门。一种解决思路时，加一条全局控制命令`options(xtable.comment=F)`，它则不会输出注释。就在我洋洋自喜时，pandoc又给了我一棒槌。在我自己的实验报告中发现（给的例子不会出现这个bug），当输入的表比较多的时候，pandoc会将一些`\begin{table}`的命令转变为`\\begin\{table\}`。也就是说R代码中无法完全解决这个问题，好在pandoc中也给我留了后门，只要在`````` ```{=latex}`````` 中的代码，它就会直接将其转化为LaTeX 代码。在我调试的过程中，想在print中输出换行符，发现做不到，于是又发现了一个宝藏命令`writeLine("\n")`。这个问题就一下子迎刃而解了。也就在上面代码的开头中，从md文件中多输出一行`````` ```{=latex}``````，结尾再增加上它的结束符。

其次是解决颜色的问题。这也是在反复阅读 xtable 的帮助和源代码时发现的。首先是发现了print中有一个属性`sanitize.text.function = function(x){x}` 这看起来可以给所有元素加判断和改颜色。通过对这个属性的搜索，终于在stack overflow 中找到了上面的解决方案。`sanitize.text.function = identity` 这应该是xtable作者留下的又一个后门，即当添加了这个属性后，它不会将表中的元素修饰为LaTeX的形式输出，而是保留原始的形态。

最后解释一下``````writeLines("\\clearpage\n```")``````。后半部分的反引号是为了响应前面的`````` ```{=latex}``````,而`\clearpage`则是当表特别多时，LaTeX 无法支持超过一定数量的浮动元素，所以加一个clearpage则可以避免这个错误，或是增加一些文字。

值得注意的是，在利用print往文件输出时，需要注意反斜杠有时需要转义。相信书写时，稍微注意不会是什么大问题。

## Beamer

使用 PPT 做展示报告其实也可以，单纯使用 LaTeX 写 Beamer 也很正常，但鲜有人会考虑使用 R Markdown。我认为它非常具有潜力，但可惜愿意探索的人太少，导致可以参考的资料会比较少。接下来，我将尝试将我的探索和理解写下来，希望有人能循着这个路线，写更多的教程。

在知晓利用 R Markdown 结合 LaTeX 做报告面临种种困境的解决之道后，那么写一个精彩的slides也不会是什么问题。大部分 R Markdown的语法都要么是R的语法，要么是Markdown的语法，少部分人会插入一些 LaTeX 的语法。

首先beamer的yaml相信看过我之前文章的都比较清楚,例如：
```
output: 
  beamer_presentation:
    latex_engine: "xelatex"
    theme: "Berlin"
    colortheme: "beaver"
```

要查看不同的beamer主题，只需要搜 beamer theme matrix 就可以找到不同组合的效果。

值得一提的是如何控制每页slides。在Beamer中，有些属性在单页调整可以不受干扰。虽然可以在yaml中利用fontsize定义整体的字号。但有些特殊页太挤时，不可避免需要用单页的字体大小控制。此时命令为`\fontsize{10pt}{1pt}\selectfont`这里的10pt是字体大小，1pt为行间距的大小，不加selectfont时，有些公式不会一起改变。

一般的slides可以分两页展示内容，所以这里给出一个“左手画圆，右手画方”的例子，以展示R Markdown的优越性。

``````
```{=latex}
\begin{figure}
\begin{minipage}[htbp]{.4\textwidth}
\centering
```

```{r echo=FALSE, fig.height=7, fig.width=6, result="asis"}
curve(sqrt(1-x^2),xlim=c(-1,1),ylim=c(-1,1),xaxt = "n", yaxt = "n",xlab="",ylab="")
curve(-sqrt(1-x^2),xlim=c(-1,1),add=TRUE)
```

```{=latex}
\end{minipage}
\hfill
\begin{minipage}{.2\textwidth}
\usetikzlibrary{fit}
\small
\begin{tikzpicture}[cube1/.style = {rectangle,draw=red!50,fill=red!20,
		inner sep=0pt, minimum height=5cm, minimum width=5cm},scale=.9]
    	\node at(0, 0)[cube1]{};
\end{tikzpicture}
\end{minipage}
\quad\quad\quad\quad\quad\quad\quad\quad
\end{figure}
```
``````

“左手画圆”指的是可以使用R语言绘制特定的统计图形。“右手画方”则指的是利用 LaTeX 绘制tikz包下的模型示意图。利用的主要是 minipage的环境，利用minipage也可以单独为每个图片加caption。当然，每个minipage中可以加的内容并不限于图片，还可以是文本、公式等。有时候需要将输入的 LaTeX 代码用环境框起来，避免被 Markdown 找不到上下匹配，而被视作需要转义的字符。`\hfill` 的作用是使的两侧内容尽可能分开，而`\quad`则是一个“推进器”，可以将不太正的图片推到中心，这些都是可以自己调整的。

最后，可以附加一些定制的主题。例如套用一下五年前别人写的 RUC 的[模板](https://github.com/andelf/ruc-beamer-template)。使用比较简单，将ruc.sty、png图片等文件，都放在RMD的文件目录下。引用时，加入yaml的包引用即可：

```
- \usepackage{ruc}
```

我还能想到挺多改变它风格和样式的可能，但并不打算再耗费时间尝试，希望可以有更多人去开发其他有意思的功能。例如现在RUC的背景图片是png，如果存成矢量图，再重新绘图，可以将其改为渐变log。


## 总结

本文给出了一些 R Markdown 和 LaTeX 结合生成报告的，主要解决了表格批量插入的问题。我相信在这个基础之上，用 R Markdown 结合更多 LaTeX 其他包相信还能做到更多惊人的事。此外，在 R Markdown 中，插入一些python的代码也并不是什么难事，无非就是对数据流的控制。以上的功能应该也完全能通过内嵌python代码实现。

就我整个探索过程而言，不难发现，现有的 R 包可能已经有了许许多多的功能与环境。比较可惜的是，他们资料并不多，使用的人也并不多，这就导致探索中所能参考的资料比较少。因此，我写此文也是希望能有更多有精力的人，尝试书写更多有意思的报告和展示。


