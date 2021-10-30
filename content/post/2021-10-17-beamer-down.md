---
title: R Markdown 制作 beamer 幻灯片
author: 黄湘云
date: '2021-10-17'
slug: beamer-down
categories:
  - 统计软件
tags:
  - TinyTeX
  - LaTeX
  - beamer
  - R Markdown
toc: true
thumbnail: https://user-images.githubusercontent.com/12031874/116777926-a1722100-aaa1-11eb-92c7-034ebfb90922.png
description: "LaTeX 提供 beamer 文类主要用于学术报告，从面上来看，好多主题是大学开发的，大家不约而同地使用蓝调，看多了想睡觉。目前，现代风格的 beamer 主题已经陆续涌现出来，本文旨在介绍一条 R Markdown 制作 beamer 幻灯片的入坑路径，让 beamer 看起来更加清爽些！"
---

> 声明：本文引用的所有信息均为公开信息，仅代表作者本人观点，与就职单位无关。

故事还要从头开始讲起，6-7 年前，出于学术答辩和课程汇报需要，陆续学习和使用 LaTeX 来排版作业和论文，曾有一段时间深陷此坑不能自拔，以至于遍览 [TeXLive](https://tug.org/texlive/) 内置的幻灯片制作宏包，收集了大量 beamer 幻灯片的模版，藏于 Github 仓库 [awesome-beamers](https://github.com/XiangyunHuang/awesome-beamers)。

LaTeX 在国外是比较流行的学术写作工具，在国内部分学校的数学或统计系会用它来排版毕业论文，相关的学习材料有很多，推荐 CTeX 开发小组翻译的[一份（不太）简短的LaTeX介绍](https://github.com/CTeX-org/lshort-zh-cn)。吴康隆的 [《简单粗暴LaTeX》](https://github.com/wklchris/Note-by-LaTeX)，盛文博翻译的[《LaTeX2e 插图指南, 第三版》](https://github.com/WenboSheng/epslatex-cn)，吕荐瑞的[科技文档排版课程材料](https://lvjr.bitbucket.io/tutorial/learn-latex.pdf)，曾祥东的[现代 LaTeX 入门讲座](https://github.com/stone-zeng/latex-talk)，都非常适合从零开始学习的。进阶的部分，根据需要去看宏包手册，LaTeX 宏包文档的长度一般都吓死个人，[PGF](https://github.com/pgf-tikz/pgf) 绘图 **1300** 多页，[pgfplots](https://ctan.org/pkg/pgfplots) 3D 绘图 **573** 页， [beamer](https://github.com/josephwright/beamer) 幻灯片制作 **247** 页，[geometry](https://github.com/davidcarlisle/geometry) 版面设置 **42** 页，[tcolorbox](https://github.com/T-F-S/tcolorbox) 箱子定制 **539**页，通常不需要从头到尾的看，除非遇到难处或需要自定义了。在对基础的 LaTeX 排版工具有一些了解后，日常使用过程中必备数学公式[速记小抄](https://gitlab.com/jim.hefferon/undergradmath) ，搭好梯子随时放狗去搜。

去年 6 月份搬迁完[汉风主题](https://github.com/liantze/pgfornament-han)，在论坛开帖分享了[成果](https://d.cosx.org/d/421591-beamer)，又被撺掇着在主站[立了字句](https://github.com/cosname/cosx.org/issues/901)----要写一篇文章介绍 R Markdown 制作幻灯片模版的过程，一直囿于工作繁忙，难以抽身，前段时间在 WX 上和[楚新元](https://gitlab.com/chuxinyuan)又聊到模版，看到有人又要准备趟我之前踩过的坑，心中不忍，咬咬牙还是把这文债给还了。算起来，从起心动念到最终交付拖延了整整一年零三个月！！！

本文将介绍如何搬迁 beamer 主题到 R Markdown 生态里，涉及[谢益辉](https://yihui.org/)开发的轻量级 LaTeX 发行版 [TinyTeX](https://github.com/yihui/tinytex-releases)， LaTeX 幻灯片主题 [metropolis](https://github.com/matze/mtheme) 和 [beamer-verona](https://ctan.org/pkg/beamer-verona)，还有使用 Pandoc 内建 LaTeX 模版的经验。

## 安装 R 包

本文陆续会用到 R Markdown 生态的几个 R 包，复现需要安装下：

```r
install.packages(c("tinytex", "knitr", "rmarkdown", "bookdown", "rticles"))
```

默认大家已经安装了 R 和 RStudio IDE，这会让操作的过程变得更简单明了。


## 安装 TinyTeX

平时要是常用 R Markdown 相关扩展包，R 包 [**tinytex**](https://github.com/yihui/tinytex) 已经被安装上了，下面用它安装 TinyTeX 这个发行版，在 R 环境里，这一切会比较顺畅，讲真，配置环境什么的最烦了，一次两次三四次，五次六次七八次，但是学什么的时候最好从配置环境开始，记录从第一次安装开始，后面会越来越快！

```r
tinytex::install_tinytex()
```

遇到啥问题，先去益辉的网站瞅瞅 <https://yihui.org/tinytex/>，要还没找到解决方案，就来论坛 <https://d.cosx.org/> 发帖。



## 安装字体

为了后续介绍 metropolis 主题，先做些准备，安装和配置其所需字体，此过程分两步走：

1. 这里用 **tinytex** 安装 [**fira**](https://www.ctan.org/pkg/fira) 系列英文字体，[**firamath**](https://github.com/firamath/firamath) 和 [**xits**](https://www.ctan.org/pkg/xits) 数学字体，后续用作 beamer 幻灯片的主要字体，相信大家看惯了千篇一律的字体，也想换换口味吧！

    ```r
    # 顺道把 beamertheme-metropolis 宏包也安装下
    tinytex::tlmgr_install(c("beamertheme-metropolis", "fira", "firamath", "firamath-otf", "xits"))
    ```

2. 通过「人工智能」我们知道上面安装的字体都放在了 TinyTeX 的安装目录下，而且不能直接被调用，故而将它们拷贝到用户指定的字体目录，刷新字体目录后，通过 **fontspec** 宏包调用。为了加快复现的速度，我已经将这个复制粘贴的过程化作几行代码，如下：

    ```r
    # TinyTeX 字体目录
    basedir <- paste(tinytex::tinytex_root(), "texmf-dist/fonts/opentype/public", sep = "/")
    # MacOS 系统字体放在 ~/Library/Fonts/ 而 Linux 系统字体放在 ~/.fonts
    distdir <- if (xfun::is_macos()) "~/Library/Fonts/" else "~/.fonts"
    xfun::dir_create(distdir)
    # 获取字体文件的完整路径
    fontfiles <- list.files(path = paste(basedir, c("fira", "xits", "firamath"), sep = "/"), full.names = T)
    # 拷贝到字体目录下
    file.copy(from = fontfiles, to = distdir, overwrite = TRUE)
    ```

## 数学符号

在正式介绍后续的 beamer 主题之前，还要先介绍一点数学符号和数学字体的坑，学术型幻灯片毕竟很难离开数学公式。在遇到花体数学符号，如常用来表示域或空间的 `$\mathcal{A,S}, \mathscr{A}, \mathbb{A,R}$`，抑或是常见的损失函数符号 `$\mathcal{L}$`。
**unicode-math** 定义的数学样式有点怪，和通常见到的不一样，以前排版毕业论文的时候[坑过我一回](https://d.cosx.org/d/419931)，主要原因是 **unicode-math** 使用 Latin Modern Math 的 OpenType 字体。

````
---
title: "Untitled"
output: 
  pdf_document: 
    latex_engine: xelatex
    template: null
    extra_dependencies:
      ctex:
       - fontset=fandol
---

拿一些数学符号举个例子，如 `\mathcal{A},\mathscr{A}` 和 `\mathbb{A}`会被依次渲染成

$$
\mathcal{A},\mathscr{A},\mathbb{A}
$$
````

![unicode-math](https://user-images.githubusercontent.com/12031874/135603599-00602d32-c007-4eb1-a8bc-c5a5a17f19f0.png)

[^pandoc-template]: RStudio IDE 捆绑了 [Pandoc 软件](https://pandoc.org/)，安装完 RStudio IDE 就可以直接用它了。我平时喜欢用最新的稳定版，版本略高于它，如果你网络环境不佳，上 Github 有困难，可以执行如下命令获取 Pandoc 内置的 LaTeX 模版。

    ```bash
    pandoc -o custom-reference.tex --print-default-template latex
    ```
  
    获取其它文档格式的模版，稍用所不同，比如 DOCX 文档。
  
    ```bash
    pandoc -o custom-reference.docx --print-default-data-file reference.docx
    ```

Pandoc 内建的 LaTeX 模版[^pandoc-template]默认调用 **unicode-math** 宏包的，除非编译 R Markdown 的时候，启用[LaTeX 变量](https://pandoc.org/MANUAL.html#using-variables-in-templates)  `mathspec: yes`，加载 **amsfonts** 和 **mathrsfs** 宏包。目前，仅有的数学字体支持的数学符号还不太全，但未来是趋势，为啥？统一性，不需要调其它数学符号包，比如 `\mscrA` 和 `\BbbA` 分别等价于 `\mathscr{A}` 和 `\mathbb{A}`。

````
---
title: "Untitled"
mathspec: yes
output: 
  pdf_document: 
    latex_engine: xelatex
    template: null
    extra_dependencies:
      ctex:
       - fontset=fandol
      amsfonts: null
      mathrsfs: null
---

拿一些数学符号举个例子，如 `\mathcal{A},\mathscr{A}` 和 `\mathbb{A}`会被依次渲染成

$$
\mathcal{A},\mathscr{A},\mathbb{A}
$$
````

![mathspec](https://user-images.githubusercontent.com/12031874/135605483-1cfe1c86-1567-495e-b3a0-27ff12a72b7f.png)


> 注意
>
>  [fandol 字体](https://ctan.org/pkg/fandol)支持的汉字有限，比如[刘思喆](https://bjt.name/)的「喆」字就渲染成了 <img height="20" alt="fandol-font" src="https://user-images.githubusercontent.com/12031874/135615813-cde3464d-21d3-43e1-b951-c247a6215e5b.png">，更别说[许宝騄先生](https://zh.wikipedia.org/wiki/%E8%A8%B1%E5%AF%B6%E9%A8%84)的「騄」字了。


Fira 系列字体配 metropolis 主题是比较常见的，只是 Fira Math 提供的字符集有限，不得不借助 XITS Math 补位（比如矩阵转置的符号），后者支持是最广的。在 **unicode-math** 的世界里，公式环境里，加粗希腊字母，得用 `\symbf` 而不是 `\boldsymbol`。XITS Math、Fira Math 等字体数学符号的支持情况详见[unicode-math 宏包的官方文档](http://mirrors.ctan.org/macros/unicodetex/latex/unicode-math/unimath-symbols.pdf)。

<center>表1：不同的数学字体支持的符号数量不同 </center>

| 数学字体                                                     | 符号数量 |
| :------------------------------------------------------------ | :-------- |
| [Latin Modern Math](https://ctan.org/pkg/lm)                 | 1585     |
| [XITS Math](https://ctan.org/pkg/xits)                       | 2427     |
| [STIX Math Two](https://ctan.org/pkg/stix2-otf)              | 2422     |
| [TeX Gyre Pagella Math](https://ctan.org/pkg/tex-gyre-math-pagella) | 1638     |
| [DejaVu Math TeX Gyre](https://ctan.org/pkg/tex-gyre-math-dejavu) | 1640     |
| [Fira Math](https://ctan.org/pkg/firamath)                   | 1052     |


## 幻灯片主题

下面以 metropolis 主题为例介绍一个完整的 beamer 幻灯片。不记得初次见 metropolis 主题是什么时候，不过每次见都让我想到了 MCMC（**M**arkov **C**hain **M**onte **C**arlo，马尔科夫链蒙特卡洛，简称 MCMC）。学过 MCMC 算法的都知道 metropolis 是啥，我这半桶水的统计科班生就不在这献丑了，当年掉在 MCMC 的大坑里好多时间，以至于将 metropolis 和 MCMC 建立了极强的关联，可能这是我介绍 beamer 主题也拿它来举例的原因吧！

回到正题，Pandoc 内建的 LaTeX 模版功能已经很丰富了，通常用不着自己配置了，R Markdown 自从接入 **tinytex** 自动装缺失的 LaTeX 宏包的功能后，在产出 PDF 文档方面已经方便多了。

metropolis 主题的特点就是干净利索，简洁优雅！顺便一提，在之前的文章[可重复性数据分析](https://xiangyun.rbind.io/2021/01/reproducible-analysis/)介绍过[林莲枝](https://github.com/liantze/)开发的汉风主题幻灯片，它是 metropolis 主题的衍生品。算上空行，只有十几行代码哈哈！！[^font-setup]

```tex
\documentclass[169]{beamer}

\usefonttheme{professionalfonts}
\usetheme{metropolis}

\usepackage{fontspec}

\setsansfont[BoldFont={Fira Sans SemiBold}]{Fira Sans Book}

\usepackage{amsmath}
\usepackage{amssymb}

\usepackage[
  mathrm=sym,
  math-style=ISO,  % Greek letters also in italics
  bold-style=ISO,  % bold letters also in italics
]{unicode-math}

\setmathfont{Fira Math} % https://github.com/firamath/firamath
% top is still missing in Fira Math, get it from another font
\setmathfont[range={\top}]{XITS Math}

\begin{document}
  \begin{frame}[t]{Example}
    \begin{align}
      \symbf{\theta} &= (1, 2, 3)^\top \\
            \theta_0 &= 1
    \end{align}
  \end{frame}
\end{document}
```

[^font-setup]: 在 Windows 系统上，需要选中字体右键安装并刷新字体缓存或者像下面这样指定字体路径。

    ```tex
    \setsansfont[Path = {\string~/.fonts/}, BoldFont={Fira Sans SemiBold}]{Fira Sans Book}
    \setmathfont[Path = {\string~/.fonts/}]{Fira Math}
    \setmathfont[Path = {\string~/.fonts/}, range={\top}]{XITS Math}
    ```

注意看加载 **unicode-math** 宏包时的选项设置，关于 **unicode-math** 数学符号的样式（比如选择 ISO 还是 TeX？） 说明见[文档](https://www.latex-project.org/publications/2010-wspr-TUG-unicode-mathematics-in-LaTeX-slides.pdf)，对绝大多数的使用者来说，做个拿来主义就好，别看我洋洋洒洒写了这么多，我也不例外，喜欢哪个用哪个！

将上面的模版内容保存到文件 `slide-template.tex`，接下来，有两种编译 LaTeX 文件的方式，一种在 [RStudio IDE](https://github.com/rstudio/rstudio) 内打开，点击 **Compile PDF** 按钮，另一种是在 R 控制台里执行

```r
tinytex::xelatex(file = "slide-template.tex")
```

编译出来的效果如下：

![slide-template](https://user-images.githubusercontent.com/12031874/116777926-a1722100-aaa1-11eb-92c7-034ebfb90922.png)


用 Adobe Acrobat Reader DC 打开 `文件->属性->字体` 可以看到 PDF 文档中确切使用的字体，如下图所示。

![check-fonts](https://user-images.githubusercontent.com/12031874/135288310-4dad120c-a883-4732-9033-72be7b8ffe28.png)

## 一个永远填不满的坑

最近统计之都论坛里又有人陆续[踩](https://d.cosx.org/d/422613)到我以前[踩](https://d.cosx.org/d/419931)过的[坑 1](https://d.cosx.org/d/421770)、[坑 2](https://d.cosx.org/d/421834)、[坑 3](https://d.cosx.org/d/422087)、[坑 4](https://d.cosx.org/d/422343)，都是中文 R Markdown 文档相关， 这里不妨简单说一下。

````
---
title: "测试"
author:
  - 无
documentclass: ctexart
keywords:
  - 无
output:
  rticles::ctex:
    fig_caption: yes
    number_sections: yes
    toc: yes
geometry: tmargin=1.8cm,bmargin=1.8cm,lmargin=2.1cm,rmargin=2.1cm  
---

$\mathbf{\Sigma}$
````

这位坛友准备在公式环境里用 `\mathbf` 命令加粗希腊字母 `$\Sigma$`，这本身是不行的，它只能用来加粗普通的字母，如 `$A,B,C,a,b,c,X,Y,Z,x,y,z$`。加粗希腊字母，需要 `\boldsymbol` 命令，而 `rticles::ctex` 中文模版，在默认设置下，会使用 Pandoc 内建 LaTeX 模版，调用 XeLaTeX 编译，加载 **unicode-math** 宏包处理数学公式，此时，希腊字母对 `\boldsymbol` 命令免疫，要加粗特效，必须用 **unicode-math** 的专用命令 `\symbf`。

如果准备在文中统一采用 **unicode-math** 处理数学公式，那么，把 `\mathbf` 换成 `\symbf`，问题即告结束。但是，目前排版数学公式比较通用的方式不是 **unicode-math**，还是原来的 amsmath 及其扩展宏包。如何转过去呢？其实，很简单，在 YAML 里添加一行 `mathspec: yes` 即可，Pandoc 的 LaTeX 模版支持原先的方案，此时编译还是会报错，报错的主要信息如下：

```
! LaTeX Error: Option clash for package fontspec.
```

这是因为 ctexart 文类自动加载了 fontspec 宏包，而它与 mathspec 宏包冲突，所以要替换为原始的 article 文类，同时加载 ctex 宏包处理中文字符，这里采用 fandol 中文字体作为演示，所以目前最佳的解决方案如下：

````
---
title: "测试"
author:
  - 无
documentclass: article
mathspec: yes
keywords:
  - 无
output:
  rticles::ctex:
    fig_caption: yes
    number_sections: yes
    toc: yes
    template: null
    extra_dependencies:
      ctex:
       - fontset=fandol
geometry: tmargin=1.8cm,bmargin=1.8cm,lmargin=2.1cm,rmargin=2.1cm  
---

$\boldsymbol{\Sigma}$ 是希腊字母 $\Sigma$ 的加粗形式，
$\mathcal{A}$ 是普通字母 $A$ 的花体形式。
````

> 提示
>
> RStudio IDE 使用 [MathJaX](https://www.mathjax.org/) 来渲染 R Markdown 文档里的数学公式，MathJaX 不支持的数学符号命令是不能预览的。来自 **unicode-math** 的 `\symbf` 命令是不受支持的，会高亮成红色。那支持的有哪些呢？完整的支持列表见这个[文档](https://docs.mathjax.org/en/latest/input/tex/macros/index.html)，常见的 `\mathbb` 空心体 `$\mathbb{A}$` 和 `\mathfrak` 火星体 `$\mathfrak{A}$` 来自宏包 amsfonts，`\mathscr` 花体 `$\mathscr{A}$` 和 `\bm` 粗体 `$\bm{A}$` 命令分别来自 mathrsfs 和 bm。amsmath 相关的大都支持，较为精细地调整数学公式可以去看[amsmath 文档](https://www.latex-project.org/help/documentation/amsldoc.pdf)，此处仅摘抄一例 `$\sqrt{x} +\sqrt{y} + \sqrt{z}$` 和 `$\sqrt{x} +\sqrt{\smash[b]{y}} + \sqrt{z}$`，能看出来差别的一定有一双火眼金睛！
>
> ![rstudio-mathjax](https://i.loli.net/2021/09/27/42otHGvZDOuJIxi.png)


再次强行回到本文主题，上述巨坑在 article 普通文类下介绍，而不是在 beamer 幻灯片主题下介绍也是有重要原因的：其一，我见过的大部分坑的背景都是 article 文类。其二，这个坑并不会随文类切换到 beamer 而有所不同！其三，若大家再遇到类似坑不妨也切换到 article 文类，这个是最基础的，褪去尽可能多的外部依赖，方便去根因。


## R Markdown 模版（基础篇）

R Markdown 文档开头处为 YAML 元数据，它分两部分：其一是 Pandoc 变量值，其二是文档输出设置。下面是一份完整的 R Markdown 模版，有了前面关于中文 R Markdown 文档的介绍，想必已不再感到陌生。 ctexbeamer 和 ctexart 文类都来自 [ctex 宏包](https://ctan.org/pkg/ctex)，想汉化必须看看它的帮助文档。

````
---
title: "R Markdown 制作 beamer 幻灯片"
author: "黄湘云"
date: "2021年10月01日"
institute: "xx 学院"
documentclass: ctexbeamer
output: 
  beamer_presentation: 
    latex_engine: xelatex
    theme: metropolis
    template: null
classoption: "fontset=fandol"
---

## 介绍

> A Markdown-formatted document should be publishable as-is, as plain text, 
without looking like it’s been marked up with tags or formatting instructions.
> 
> --- John Gruber
>

Markdown 提供一种简洁的格式语法，用来编辑 HTML、PDF 和 MS Word 文档，
数学公式还是用 LaTeX 排版的好， 
$\boldsymbol{\Sigma}$ 是希腊字母 $\Sigma$ 的加粗形式，
$\mathcal{A}$ 是普通字母 $A$ 的花体形式。
````

编译后的效果如下[^pdf-to-gif]：

![beamer](https://user-images.githubusercontent.com/12031874/135646967-3d417a18-7d13-4bdd-951f-7d2176f5b0d9.gif)


至此，关于 「R Markdown 制作 beamer 幻灯片」的主题介绍可以告一段落了！眼力犀利的读者可能已经看出上面模版中还是使用 **unicode-math** 处理数学公式，导致符号样式怪怪的，`\boldsymbol` 也无法加粗希腊字母，这里留个疑问，希望读者看完本文后，自己能找到答案！
对于想要玩出花样的读者，不妨接着往下看。

[^pdf-to-gif]: 将PDF格式的多页幻灯片转为GIF动图可以借助 [ImageMagick](https://imagemagick.org) 一行命令搞定：
 
    ```bash
    convert -delay 250 -density 300x300 -geometry 960x720 beamer.pdf beamer.gif
    ```
    
    值得注意的是在 Ubuntu 20.04 LTS 系统环境下，安装完 ImageMagick 还需执行如下命令：
    
    ```bash
    sudo sed -i_bak \
    's/rights="none" pattern="PDF"/rights="read | write" pattern="PDF"/' \
    /etc/ImageMagick-6/policy.xml
    ```
    
    此外，还可以安装 [**magick**](https://github.com/ropensci/magick) 包，用 R 代码实现转化过程：
    
    ```r
    library(magick)
    img = image_read_pdf("beamer.pdf", density = 300)
    img %>% 
      image_resize(geometry_size_pixels(960, 720)) %>% 
      image_animate(delay = 250) %>% 
      image_write("beamer.gif")
    ```

## R Markdown 模版（高级篇）

下面是另一份完整的 R Markdown 模版，内容十分丰富：添加多个作者，动态日期，bookdown 交叉引用加持，参考文献支持，参考文献样式设置，更换 beamer 主题为 Verona，自定义导言区 `header-includes`，添加 Logo，R 绘图设备改为 `"cairo_pdf"`，设置幻灯片主题 Verona 的选项等[^theme-verona]。读者可以注释和编译交替进行，细节就不说了，可以看看后面的参考文献，边看边玩！

[^theme-verona]: 通过查看 Verona 主题 <https://ctan.org/pkg/beamer-verona> 的手册，知道它有一些额外的选项控制幻灯片样式，

````yaml
---
title: "R Markdown 制作 beamer 幻灯片"
author:
  - 黄湘云
  - 李四
institute: "xxx 大学学院"
date: "`r Sys.Date()`"
documentclass: ctexbeamer
output: 
  bookdown::pdf_book: 
    number_sections: yes
    toc: no
    base_format: rmarkdown::beamer_presentation
    latex_engine: xelatex
    citation_package: natbib
    keep_tex: no
    template: null
    dev: "cairo_pdf"
    theme: Verona
header-includes:
  - \logo{\includegraphics[height=0.8cm]{`r file.path(R.home("doc"), "html", "Rlogo")`}}
  - \usepackage{pifont}
  - \usepackage{iitem}
  - \setbeamertemplate{itemize item}{\ding{47}}
  - \setbeamertemplate{itemize subitem}{\ding{46}}
themeoptions: 
  - colorblocks
  - showheader
  - red
biblio-style: apalike
natbiboptions: "authoryear,round"
bibliography: 
  - packages.bib
classoption: "fontset=fandol"
link-citations: yes
section-titles: false
biblio-title: 参考文献
colorlinks: yes
---
````

`bookdown::pdf_book` 下的 `number_sections`、`toc` 等皆是其参数，详情可查看帮助文档 `?bookdown::pdf_book`。上面将 `rmarkdown::beamer_presentation` 作为 `bookdown::pdf_book` 的 `base_format` 而不是像默认的 beamer 模版那样直接引用，是为了获得交叉引用的能力。

结合 Pandoc 内建 LaTeX 模版，你会发现，除了 output 字段下的键值对，其它都在。结合位置来看 `header-includes` 相当于 premble （LaTeX 文档的导言区）。下面摘取设置 beamer 幻灯片的部分 LaTeX 模版内容加以说明。

```latex
$if(beamer)$
$if(theme)$
\usetheme[$for(themeoptions)$$themeoptions$$sep$,$endfor$]{$theme$}
$endif$
$if(colortheme)$
\usecolortheme{$colortheme$}
$endif$
$if(fonttheme)$
\usefonttheme{$fonttheme$}
$endif$
$if(mainfont)$
\usefonttheme{serif} % use mainfont rather than sansfont for slide text
$endif$
$if(innertheme)$
\useinnertheme{$innertheme$}
$endif$
$if(outertheme)$
\useoutertheme{$outertheme$}
$endif$
$endif$
```

beamer 默认的主题提供了一些 block 样式，比如 exampleblock、alertblock、block 等。

````
::: {.exampleblock data-latex="{提示}"}
提示
:::
````

当然，有些主题还有自定义的 block 样式，像引用名人名言

````
::: {.quotation data-latex="[John Gruber]"}
A Markdown-formatted document should be publishable as-is, as plain text, 
without looking like it’s been marked up with tags or formatting instructions.  
:::
````

此处，不一一介绍，详情见讨论贴[don't respect beamer theme's buildin theorem/proof block](https://github.com/rstudio/bookdown/issues/1143)。完整的 R Markdown 幻灯片模版如下：

````
---
title: "R Markdown 制作 beamer 幻灯片"
author:
  - 黄湘云
  - 李四
institute: "xxx 大学学院"
date: "`r Sys.Date()`"
documentclass: ctexbeamer
output: 
  bookdown::pdf_book: 
    number_sections: yes
    toc: no
    base_format: rmarkdown::beamer_presentation
    latex_engine: xelatex
    citation_package: natbib
    keep_tex: no
    template: null
    dev: "cairo_pdf"
    theme: Verona
header-includes:
  - \logo{\includegraphics[height=0.8cm]{`r file.path(R.home("doc"), "html", "Rlogo")`}}
  - \usepackage{pifont}
  - \usepackage{iitem}
  - \setbeamertemplate{itemize item}{\ding{47}}
  - \setbeamertemplate{itemize subitem}{\ding{46}}
themeoptions: 
  - colorblocks
  - showheader
  - red
biblio-style: apalike
natbiboptions: "authoryear,round"
bibliography: 
  - packages.bib
classoption: "fontset=fandol"
link-citations: yes
section-titles: false
biblio-title: 参考文献
colorlinks: yes
---

## 介绍

::: {.quotation data-latex="[John Gruber]"}
A Markdown-formatted document should be publishable as-is, as plain text, 
without looking like it’s been marked up with tags or formatting instructions.  
:::

Markdown 提供一种简洁的格式语法，用来编辑 HTML、PDF 和 MS Word 文档，数学公式还是用 LaTeX 排版的好， 
$\boldsymbol{\Sigma}$ 是希腊字母 $\Sigma$ 的加粗形式，
$\mathcal{A}$ 是普通字母 $A$ 的花体形式。

## 自定义 block

::: {.exampleblock data-latex="{提示}"}
记得安装一些 LaTeX 宏包，如果不记得也没关系，大多数情况下 tinytex [@tinytex] 会找齐依赖安装好，只是初次运行会有点慢！

```{r, eval=FALSE}
# 安装 LaTeX 宏包
tinytex::tlmgr_install(c("psnfss", "iitem", "beamer-verona"))
```
:::


```{r bib, include=FALSE, cache=FALSE}
bib <- knitr::write_bib(
  x = c(
    .packages(), "tinytex"
  ), file = NULL, prefix = ""
)
bib <- unlist(bib)
bib <- gsub("(\\\n)", " ", bib)
xfun::write_utf8(bib, "packages.bib")
```
````

编译出来的效果如下：

![rmarkdown-verona](https://user-images.githubusercontent.com/12031874/135652566-08f27f9b-c7a0-4bcf-810a-88859e6db6a7.gif)


---

此外，R 社区有几个 R 包专门打包了一些 R Markdown 幻灯片模版，比如 [binb](https://github.com/eddelbuettel/binb) 和 [uiucthemes](https://github.com/illinois-r/uiucthemes) 包，如何使用便不再赘述，掌握以上介绍的规律，beamer 主题任你玩[^custom-block]。

[^custom-block]: 想来想去，好像只剩一种情况还没有介绍，就是使用 Pandoc 支持的 [Lua 外挂](https://pandoc.org/lua-filters.html)，借助 LaTeX 宏包 [tcolorbox](https://ctan.org/pkg/tcolorbox) [自定义 block](https://bookdown.org/yihui/rmarkdown-cookbook/custom-blocks.html)，而这当属于忍者玩法了！

---

最后，贴出本文使用的 R 环境信息，供读者复现参考。

```r
xfun::session_info(c("tinytex", "knitr", "rmarkdown", "bookdown"))
```
```
R version 4.1.1 (2021-08-10)
Platform: x86_64-apple-darwin17.0 (64-bit)
Running under: macOS Big Sur 11.6, RStudio 2021.9.0.351

Locale: en_US.UTF-8 / en_US.UTF-8 / en_US.UTF-8 / C / en_US.UTF-8 / en_US.UTF-8

Package version:
  base64enc_0.1.3 bookdown_0.24   digest_0.6.28   evaluate_0.14   fastmap_1.1.0  
  glue_1.4.2      graphics_4.1.1  grDevices_4.1.1 highr_0.9       htmltools_0.5.2
  jquerylib_0.1.4 jsonlite_1.7.2  knitr_1.36      magrittr_2.0.1  methods_4.1.1  
  rlang_0.4.11    rmarkdown_2.11  stats_4.1.1     stringi_1.7.4   stringr_1.4.0  
  tinytex_0.34    tools_4.1.1     utils_4.1.1     xfun_0.26       yaml_2.2.1     

Pandoc version: 2.14.2
```

## 参考文献

1. LaTeX 数学符号合集. <https://www.ctan.org/pkg/comprehensive/>.

1. 谢益辉. 2020. 适用于 LaTeX 环境的 Pandoc 选项. <https://bookdown.org/yihui/rmarkdown-cookbook/latex-variables.html>

1. 谢益辉. 2018. R Markdown 制作 Beamer 幻灯片简介. <https://bookdown.org/yihui/rmarkdown/beamer-presentation.html>

1. 谢益辉. 2016. bookdown 交叉引用介绍. <https://bookdown.org/yihui/bookdown/cross-references.html>

1. 曾祥东. 2020. 在 LATEX 中使用 OpenType 字体（三）. <https://stone-zeng.github.io/2020-05-02-use-opentype-fonts-iii/>

1. Alison Hill, Christophe Dervieux, Yihui Xie. 2021. R Markdown 又提供一些新的特性.  <https://blog.rstudio.com/2021/04/15/2021-spring-rmd-news/>
