---
title: 在Windows中创建R的包的步骤
date: '2009-02-20T10:51:52+00:00'
author: 胡荣兴
categories:
  - 统计软件
tags:
  - R语言
  - 包 package
slug: create-r-packages-under-windows
forum_id: 418771
---

本文将向你介绍在Windows下创建包的步骤。在Unix下的创建过程以及如何用R调用C语言代码，请参考Google Group中的[如何写R的程序包](http://r-forum.googlegroups.com/web/如何写R的程序包.pdf?hl=zh-CN&gsc=UkZ_EAsAAAAPPWk_9MdapAnGcC-3E6DA)一文。

在Windows下创建R的包(package)比较容易，但也需要十分小心。下面给出了创建一个R的包的步骤。如果需要了解创建包的更多细节，请参考相关的参考文献。<!--more-->

# 安装必要的软件：

* [R](http://www.r-project.org/) 软件
* Unix应用程序集[R tools](http://www.murdoch-sutherland.com/Rtools/installer.html)
* [Perl](http://www.perl.org/)
* GUN编译器 ([MinGW](http://prdownloads.sf.net/mingw/))

安装全部编译器

* [Microsoft html compiler](http://msdn2.microsoft.com/en-us/library/ms669985.aspx)
* [MikTex](http://www.miktex.org/)

# 设置环境变量

右键单击“我的电脑”，依次选择“属性”－“高级”－“环境变量”，编辑变量“Path”,在里面加入上面六个软件的目录。如下：

`C:\RTools\bin; C:\MinGW\bin; C:\Program Files\MiKTeX 2.5\miktex\bin; C:\Perl\bin\; C:\Program Files\R\R.2.8.0\bin; C:\Program Files\HTML Help Workshop; C:\WINDOWS\system32;  C:\WINDOWS; C:\WINDOWS\System32\Wbem;`

确认你将上述六个软件的目录正确地加入了环境变量Path。你可以在命令提示符窗口输入下列命令进行测试：

```bash
gcc –help
perl –help
TeX –help
R CMD –help
```

看是否能执行上述命令。

在完成了上面的工作后，你的Windows版本的R与Unix版本的R差别已经不大。

# 编译包

如何编写包,请参阅《Writing R Extensions》 I will not state the details about how to write a package, please see [Writing R Extensions](http://cran.us.r-project.org/doc/manuals/R-exts.pdf) instead.

编译帮助文件

进入包所在目录，执行下列命令：

```bash
cd man
R CMD Rd2txt xxxx.Rd
R CMD Rdconv -t=html -o=xxxx.html xxxx.Rd
```

对每一个Rd文件都要编译。编译好后，进入包的上层目录，检验包是否正确：

```bash
cd ../..
R CMD check test
```

为你的包创建一个PDF格式的手册：

```bash
R CMD Rd2dvi --pdf test
```

最后创建包：

```bash
R CMD build --binary --use-zip test
```

最后生成zip文件就R的安装包。

# 参考文献

1. [Writing R Extensions](http://cran.us.r-project.org/doc/manuals/R-exts.pdf)
1. [Making R Packages Under Windows](http://www1.appstate.edu/~arnholta/Software/MakingPackagesUnderWindows.pdf)
1. [Build R package for Win2000/XP](http://www.stat.nctu.edu.tw/MISG/SUmmer_Course/C_language/Ch14/BuildR/Build%20R%20package%20for%20Win2000_XP.htm)
1. [Building R for Windows](http://www.murdoch-sutherland.com/Rtools/)
1. [Creating R Packages (the idiot’s guide)](http://www.maths.bris.ac.uk/~maman/computerstuff/Rhelp/Rpackages.html)
