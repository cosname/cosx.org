---
title: "Rmarkdown 入门教程"
date: 2021-04-10
author: "庄亮亮"
categories: ["R 语言 ", "R 包", "Rmarkdown"]
tags: ["文档沟通"]
slug: Rmarkdown_introduction
---


# Rmarkdown入门教程


## 第一章：Rmarkdown 简介  

Rmarkdown 是 R 语言环境中提供的 markdown 编辑工具，运用 rmarkdown 撰写文章，既可以像一般的 markdown 编辑器一样编辑文本，也可以在 rmarkdown 中插入代码块，并将代码运行结果输出在 markdown 里。R Markdown 格式，简称为 Rmd 格式， 相应的源文件扩展名为 .Rmd。输出格式可以是 HTML、docx、pdf、beamer 等。

> 介绍参考：李东风老师的[《R 语言教程》](https://www.math.pku.edu.cn/teachers/lidf/docs/Rbook/html/_Rbook/rmarkdown.html "《R 语言教程》")。

对于专注于用 R 语言写报告的数据分析师来说，rmarkdown 既提高了数据分析工作的便捷性，也提高了数据分析报告的复用性。 markdown 的教程以及对应的编辑器介绍可见：[R沟通｜markdown编辑器—Typora](http://mp.weixin.qq.com/s?__biz=MzI1NjUwMjQxMQ==&mid=2247491318&idx=1&sn=47128737582a34677926a9f64f03e4ed&chksm=ea24e112dd53680478ac90151554ebdde72ab122fcc84bae4da6e87e9c97b020275ecabc846c&scene=21#wechat_redirect)。

### 1.1官网视频介绍

先通过[官方视频](https://rmarkdown.rstudio.com/lesson-1.html "官方视频")来看看 Rmarkdown 的介绍。

> **注**：该视频来自官网，一般不一定打得开，所以小编为大家着想就下载下来了，以便大家更好地学习，可见这篇[推送](https://mp.weixin.qq.com/s/aPqjLILQvnRaM6S7j7zsLQ)。

视频已经非常清楚的介绍了 Rmarkdown 如何使用，内部构造、不同的输出类型，以及其他拓展（发布，与 github 相连）等。我们先对此进行简单了解即可，之后几期我会详细介绍。当然，官网也有一套 Rmarkdown 的入门教程，欢迎大家前去学习，官网截图如下：  

![](https://mmbiz.qpic.cn/mmbiz_jpg/MIcgkkEyTHgQIt6ob17tBZRRISiczGtKzz9ueTpfO198ZUvH00ibGDajbYgdhADwuDekjn7w2dKU0HAPEhhlNqYA/640?wx_fmt=jpeg)

其他参考资料可见这一期推文：[R分享｜Rmarkdown参考资料分享和自制视频教程预告](http://mp.weixin.qq.com/s?__biz=MzI1NjUwMjQxMQ==&mid=2247490959&idx=1&sn=2374d35aa12a64bd00caea0bf424bbd0&chksm=ea24e26bdd536b7d2263b6e779a00f072f2e42f29346ab13a9ed4252144dc6d7e964c7ef7d52&scene=21#wechat_redirect)。关于 RMarkdown 可参考专著([Xie, Allaire, and Grolemund 2019](https://www.math.pku.edu.cn/teachers/lidf/docs/Rbook/html/_Rbook/rmarkdown.html#ref-Xie2019:rmarkdown "Xie, Allaire, and Grolemund"))和([Xie, Dervieux, and Riederer 2020](https://www.math.pku.edu.cn/teachers/lidf/docs/Rbook/html/_Rbook/rmarkdown.html#ref-Xie2020:rmd-cook "Xie, Dervieux, and Riederer"))。 RStudio 网站提供了一个 R Markdown 使用小抄的下载链接：( rmarkdown-2.0.pdf )[rmarkdown-2.0.pdf]。 Pandoc 的文档见[pandoc 网站](https://www.pandoc.org/ "pandoc 网站")，knitr 的详细文档参见网站[ knitr 文档](http://yihui.name/knitr/ "knitr 文档")。

## 第二章：Rmarkdown流程演示

### 2.1. 安装

假设你已经安装了 [R](https://www.r-project.org "R")（R Core Team 2020）和 [RStudio IDE](https://www.rstudio.com "RStudio IDE")。

> 不需要 RStudio，但建议使用 RStudio，因为它可使普通用户更轻松地使用 R Markdown。如果未安装 RStudio IDE，则必须安装 [Pandoc](http://pandoc.org)， 否则不需要单独安装 Pandoc，因为 RStudio 已将其捆绑在一起。

接下来， Rstudio 中安装 rmarkdown 软件包，可以通过下面任意一种方式：

```
#Install from CRAN  
install.packages('rmarkdown')  
  
# Or if you want to test the development version,  
#install from GitHub  
if(!requireNamespace("devtools"))  
install.packages('devtools')  
devtools::install_github('rstudio/rmarkdown')  
```

如果要生成 PDF 输出，则需要安装 LaTeX。对于从未安装过 LaTeX 的 R Markdown 用户，建议安装 [TinyTeX](https://yihui.name/tinytex/ "TinyTeX")：

```
install.packages('tinytex')  
tinytex::install_tinytex() # install TinyTeX  
```

TinyTeX 是一种轻便，可移植，跨平台，易于维护的 LaTeX 发行版。 R 配套软件包 tinytex 可以帮助你在将 LaTeX 或 R Markdown 文档编译为 PDF 时自动安装缺少的 LaTeX 软件包，并确保将 LaTeX 文档编译正确的次数以解决所有交叉引用。

> **注：** 如果 TinyTex 通过上面代码无法正常安装，可以参考张敬信老师的知乎文章：[搭建 Latex 环境：TinyTex+RStudio](https://zhuanlan.zhihu.com/p/328585804) 如果编译 .rmd 格式时出现缺失某些 Latex 包，可以参考[这节](https://bookdown.org/yihui/rmarkdown-cookbook/install-latex-pkgs.html)内容。

### 2.2. 新建Rmarkdown项目

1.  点击 Rstudio 左上角的新建项目，选择 Rmarkdown 文件格式，即可建立一个 rmarkdown 编辑文件 。

![](https://mmbiz.qpic.cn/mmbiz_png/MIcgkkEyTHiayicgGYwRzibR9sxwM8TDrHOnC8OiaxaEFicQwBYuFDAhREDzrHzf77ZzHONpFueanjvemwM8BzxZnOQ/640?wx_fmt=png)

2.  在弹出的选项框里，可以申明 rmarkdown 的 Title、 Author 以及默认的输出文件格式，一般可以选择 HTML、PDF、Word 格式，具体见下图。

![](https://mmbiz.qpic.cn/mmbiz_png/MIcgkkEyTHiayicgGYwRzibR9sxwM8TDrHONCibWGssENl6uFM7X9oCR1D1dnalEY02U0GH1n287RlXuwMZcWYaY1w/640?wx_fmt=png)

3.  在新建的 markdown 文件里，主要包含三块内容：1. YAML、2. markdown 文本、3.代码块。

![](https://mmbiz.qpic.cn/mmbiz_png/MIcgkkEyTHiayicgGYwRzibR9sxwM8TDrHO1icK35EBlzW6IGic1A50UPInShxrMEoqKm5SszNgW4rY6f5pP40rXicHw/640?wx_fmt=png)

**1）YAML**： Rmarkdown 的头部文件(上图1位置)， YAML 定义了 rmarkdwon 的性质，比如 title、author、date、 指定 output 文件类型等。

**2）markdown文本**： rmarkdown 里的主要内容(上图3位置)，由编辑人员按照 markdown 语法自行编写文本内容，

**3）代码块**： rmarkdown 的一个主要功能是可以执行文件内的代码块(上图2位置)，并将代码执行结果展示在 markdown 里。这对撰写数据分析报告带来了极大的便利。 Rmd 文件中除了 R 代码段以外， 还可以插入 Rcpp、Python、Julia、SQL 等许多编程语言的代码段， 常用编程语言还可以与R代码段进行信息交换。

> 这三个部分会在以后做详细介绍。

### 2.3. Rmarkdown的导出

rmarkdown的导出方法有两种，一种是依靠 Rstudio 手动导出，另一种是基于命令行的导出方式。

#### 手动导出

![手动导出](https://mmbiz.qpic.cn/mmbiz_png/MIcgkkEyTHiayicgGYwRzibR9sxwM8TDrHOLrG8D4fZfNIhXf2xaVhK8A1XcRqoRLcSKPC9vXQtUGvY6q2Ur9Zsjw/640?wx_fmt=png)

手动导出方法很简单，在完成 markdown 编辑后，手动点击上图红圈内 knit 按钮，选择导出格式类型即可， Rstudio 支持导出 PDF、html、word 三种类型。

#### 命令行导出

命令行导出主要依靠 `rmarkdown::render` 实现， render 函数主要包含如下几个参数：

 -    **input*： 指定需要导出的rmarkdwon文件地址
 -    **output_format**： 指定需要导出的文件类型，同样支持 pdf、word、html 等多种文件格式。若未指定 `output_format` 格式，则输出 rmarkdown 文件中 output 指定的格式类型。

```
rmarkdown::render("test.Rmd")
```

![](https://mmbiz.qpic.cn/mmbiz_png/MIcgkkEyTHiayicgGYwRzibR9sxwM8TDrHOHREqDRxNrDKxVThbUuqusJ3icTDklw3STPKwb9BHNLFLMGR9G5bKnicQ/640?wx_fmt=png)

### 2.4. Rstudio界面介绍

若界面打开了rmd格式的文件时， Rstudio 的界面发生了一些变化（多了一些按钮），如下图所示。

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210414130134283.png)


这里我们对界面做一些介绍，视频介绍在[这](https://mp.weixin.qq.com/s/Dl1a36omEVI1QGP0HgbuyA)。

> **注**：演示的 Rstudio 版本为1.4.1，老版本的界面可能有所不同。

## 第三章：图、表和代码输出

### 3.1代码输出

#### 1.行内代码

```
`r sin(pi/2)` 
```

有趣的案例：

1）自动更新日期

```
date: "`r Sys.Date()`"
date: "`r format(Sys.time(), '%d %B, %Y')`"
date: "Last compiled on `r format(Sys.time(), '%d %B, %Y')`"
```

具体细节可参考：https://bookdown.org/yihui/rmarkdown-cookbook/update-date.html

2）文本结合代码

```
这里一共有`r sum(x)`个人。
```

#### 2. 代码块
```
​```{r}
set.seed(1)
x <- round(rnorm(10), 2)
print(x)
​```
```


R 代码块一般通过 ```{R}``` 来插入，插入代码段的**快捷键**：win[Ctrl+Alt+I] / mac[option + cmd + I]。

默认情况下代码和结果会在输出文件中呈现。如果通过参数来控制代码块运行结果的输出情况可以在{r }中设置。一般包括代码及运行结果的输出、图片表格格式定义等。关于代码段选项，详见https://yihui.name/knitr/options。

这里小编给出一些常用的选项，文字版本较难理解的话，请配合我的[b站视频教程](https://www.bilibili.com/video/BV1ib4y1X7r9/ "b站视频教程")。


1. eval和include选项

  加选项 `eval=FALSE` , 可以使得代码仅显示而不实际运行。 这样的代码段如果有标签， 可以在后续代码段中被引用。

  加选项 `include=FALSE` ， 则本代码段仅运行， 但是代码和结果都不写入到生成的文档中。

2. echo选项

  echo 参数控制了 markdown 是否显示代码块。若 echo=TRUE， 则表示代码块显示在 markdown 文档显示代码块；反之，代码块不出现在输出结果中。 

```
​```{r echo=FALSE}
print(1:5)
​```
```

结果为:

```
## [1] 1 2 3 4 5
```

3. collapse 选项
  一个代码块的代码、输出通常被分解为多个原样文本块中， 如果一个代码块希望所有的代码、输出都写到同一个原样文本块中， 加选项 `collapse=TRUE`。 例如：

```
​```{r collapse=TRUE}
sin(pi/2)
cos(pi/2)
​```
```

结果为：

```
sin(pi/2)
## [1] 1
cos(pi/2)
## [1] 6.123032e-17
```

代码和结果都在一个原样文本块中。

4. prompt 和 comment 选项

  `prompt=TRUE` 代码用 R 的大于号提示符开始。如果希望结果不用井号保护， 使用选项 `comment=''`。

  ```
  ​```{r prompt=TRUE, comment=''}
  sum(1:5)
  ​```
  ```

结果为:

```
> sum(1:5)
[1] 15
```

5. results 选项

用选项 `results=` 选择文本型结果的类型。 取值有：

	- `markup`, 这是缺省选项， 会把文本型结果变成HTML的原样文本格式。
	- `hide`, 运行了代码后不显示运行结果。
	- `hold`, 一个代码块所有的代码都显示完， 才显示所有的结果。
	- `asis`, 文本型输出直接进入到 HTML 文件中， 这需要 R 代码直接生成HTML标签， knitr 包的 `kable()` 函数可以把数据框转换为 HTML 代码的表格。

例如， `results='hold'` 的示例:

```
​```{r collapse=TRUE, results='hold'}
sin(pi/2)
cos(pi/2)
​```
```

结果为:

```
sin(pi/2)
cos(pi/2)
## [1] 1
## [1] 6.123032e-17
```

6. 错误信息选项

	- `warning=FALSE` 使得代码段的警告信息不进入编译结果， 而是在控制台( console )中显示。 有一些扩展包的载入警告可以用这种办法屏蔽。

	- `error=FALSE` 可以使得错误信息不进入编译结果， 而是出错停止并将错误信息在控制台中显示。

	- `message=FALSE` 可以使得 message 级别的信息不进入编译结果， 而是在控制台中显示。

> 还有关于图片的设置，这个我们放到下面来说

当然你也可以通过 Rstudio 界面进行部分参数的设置（更加便捷）：

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/WeChatd2107f6cf1d1088d22c97e4b3e09f344.png)

具体演示可见[b站](https://www.bilibili.com/video/BV1ib4y1X7r9)视频。

7. 全局设置

若 markdown 内的代码块存在一样的参数设置，则可以提前设计好全局的代码块参数。全局代码块通过 `knitr::opts_chunk$set` 函数进行设置，一般设置在 YAML 文件下方。 

```
​```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
​```
```


### 3.2.图片输出

#### 1.插入 R 代码生成的图形

```
​```{r, fig.height = 8,fig.with = 6}
plot(1:10)
​```
```

1. `fig.show`：设置了图片输出方式 

   - `fig.show=‘asis’`：表示 plot 在产生他们的代码后面

   - `fig.show=‘hold’`：所有代码产生的图片都放在一个完整的代码块之后

   - `fig.show=‘animate’`：表示将所有生成的图片合成一个动画图片

   - `fig.show=‘hide’`：表示产生所有图片,但是并不展示

```
​```{r, fig.show='animate'}
for (i in 1:2) {
  pie(c(i %% 2, 6), col = c('red', 'yellow'), labels = NA)
}
​```
```

2. `fig.width`： 设置图片输出的宽度 
3. `fig.height`： 设置图片输出的高度 
4. `fig.align`： 设置图片位置排版格式，默认为 "left", 可以为 "right" 或者 "center"。 
5. `fig.cap`： 设置图片的标题
6. `fig.subcap`： 设置图片的副标题 
7. `out.width` 和 `out.height` 选项指定在输出中实际显示的宽和高，如果使用如 "90%" 这样的百分数单位则可以自动适应输出的大小。

#### 2.插入外部图形文件

  如果一个图不是由一个 R 代码块生成的，你可以用两种方式包含它:

  - **方法一**

  使用 Markdown 语法 `![caption](path/to/image)`， 你可以使用 `width` 和 `height` 属性来设置图像的大小，例如:

  ```
  ![图的标题](xxx.png){width=50%}
  ```

  > 注意：图片文件放的位置（如果和 rmd 同一目录，则可以直接 xxx.png； 如果在其他位置记得加上相对路径）。


  ![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210403211033682.png)

  - **方式二**

  在 source editor 情况下，直接外部拉入图形即可，会自动保存在相对文件夹的 images 中，或者点击图形按钮导入。


![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210403211101185.png)


  - **方式三**

   在代码块中使用 knitr 函数 `knitr::include_graphics()`。 图片尺寸更改与**插入R代码生成的图形**的情况相同。

```
​```{r, echo=FALSE , out.width="50%"}
knitr::include_graphics("xxx.png")
​```
```

### 3.3.表格输出

#### 1. 外部表格输入

- markdown格式

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210403210427161.png)

- Typora格式

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210403211149020.png)

#### 2. 内部代码输出的表格

例子：计算线性回归后， `summary()` 函数的输出中有 coefficients 一项，是一个矩阵， 如果直接文本显示比较难看：

```
x <- 1:10; y <- x^2; lmr <- lm(y ~ x)
co <- summary(lmr)$coefficients
print(co)
```

- **knitr包的 `kable()`** 

knitr包提供了一个 `kable()` 函数可以用来把数据框或矩阵转化成有格式的表格， 支持 HTML、docx、LaTeX 等格式。

可以用 knitr 包的 `kable` 函数来显示:

```
knitr::kable(co)
```

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210403211210045.png)


`kable()` 函数的 `digits=` 选项可以控制小数点后数字位数， `caption=` 选项可以指定表的标题内容。

- **pander包的pander函数**

其 `pander()` 函数可以将多种R输出格式转换成 knitr 需要的表格形式。 如

```
pander::pander(lmr)
```

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210403211229254.png)

但是，经过试验发现， 表中中有中文时 pander 包会出错，这里参考公众号[R 友舍](https://mp.weixin.qq.com/s/MKvRoyCyEHqHNzC9DRfVWQ)。

- 其他包

**tables** ([Murdoch 2020](https://bookdown.org/yihui/rmarkdown-cookbook/table-other.html#ref-R-tables "Murdoch 2020")), **pander** ([Daróczi and Tsegelskyi 2018](https://bookdown.org/yihui/rmarkdown-cookbook/table-other.html#ref-R-pander "Daróczi and Tsegelskyi 2018")), **tangram** ([Garbett 2020](https://bookdown.org/yihui/rmarkdown-cookbook/table-other.html#ref-R-tangram "Garbett 2020")), **ztable** ([Moon 2020](https://bookdown.org/yihui/rmarkdown-cookbook/table-other.html#ref-R-ztable "Moon 2020")), 和 **condformat** ([Oller Moreno 2020](https://bookdown.org/yihui/rmarkdown-cookbook/table-other.html#ref-R-condformat "Oller Moreno 2020"))等。


### 3.4.表格渲染

通过前面可以看到：用 `knitr::kable()` 输出表格结果其实不是非常美观，并且很多功能都不能实现。这时我们可以用 kableExtra([Zhu 2020](https://bookdown.org/yihui/rmarkdown-cookbook/kableextra.html#ref-R-kableExtra "Zhu 2020"))、huxtable ([Hugh-Jones 2020](https://bookdown.org/yihui/rmarkdown-cookbook/table-other.html#ref-R-huxtable "Hugh-Jones 2020")) 等扩展包来美化表格。

> 其他拓展包可以参考：https://bookdown.org/yihui/rmarkdown-cookbook/table-other.html

- **kableExtra包**

本文以 kableExtra 包为例，介绍 rmarkdown 中渲染表格的相关函数。 它在 https://haozhu233.github.io/kableExtra/ 上有大量文档，其中提供了许多示例，说明如何针对 HTML 或 LaTeX 输出自定义 `kable()` 输出。 建议阅读其文档，本节中仅介绍一些示例介绍。

kableExtra 包可以使用管道符号 `%>%` 操作，例如

```
library(knitr)
library(kableExtra)
kable(iris) %>%
  kable_styling(latex_options = "striped")
```

#### 安装

```
# install from CRAN
install.packages("kableExtra")

# install the development version
remotes::install_github("haozhu233/kableExtra")
```



#### 1. 表格外框设置

`bootstrap_options = "bordered"` 构建有边框的表格，其他可调节的名称可通过帮助文档获取。

```
x_html <- knitr:: kable(head(rock), "html")
kableExtra::kable_styling(x_html,bootstrap_options = "bordered")
```


#### 2. 设置表格的宽度

使用 `full_width = F` 使得表格横向不会填满整个页面，默认情况下 `full_width = T`。

```
x_html <- knitr:: kable(head(rock), "html")
kableExtra::kable_styling(x_html,bootstrap_options = "striped",
                          full_width = F)
```


![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210403211332249.png)

> 注意：上面例子 `knitr:: kable` 制定了 `kable` 函数来自 knitr 包，目的是方式和其他包内同名函数冲突。

另一种写法，如果想使用管道函数，需要加载 kableExtra 。其他代码也类似，大家要学会举一反三噢！
```
library(knitr)
library(kableExtra)
kable(head(rock), "html") %>% 
		kable_styling(x_html,bootstrap_options = "striped",
                          full_width = F)
```

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210403211413207.png)


#### 3. 设置表格的对齐方式

使用 `position = "left"` 使得整个表格像左对齐，当然也可以中心对齐和右对齐，视情况而定。
```
x_html <- knitr:: kable(head(rock), "html")
kableExtra::kable_styling(x_html,bootstrap_options = "striped",
                          full_width = F,
                          position = "left")
```

![](https://static01.imgkr.com/temp/3c0e46ee46cd42698cc578153b09e682.png)

#### 4. 设置表格的字体大小

使用 `font_size = 20` 可以将字体大小改为20。

```
x_html <- knitr:: kable(head(rock), "html")
kableExtra::kable_styling(x_html,bootstrap_options = "striped",
                          full_width = T,
                          font_size = 20
```

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210403211439668.png)


#### 5.设置表格的行与列

这里使用的函数是 `column_spec()`， 其中以下代码含义为：制定前两列数据，字体加粗、颜色为白色，表格填充为 `"#D7261E"`。 而行的设置与列类似，使用函数名为 `row_spec()`。
```
x_html <- knitr:: kable(head(rock), "html")
x_html <- kableExtra::kable_styling(x_html,
                                    bootstrap_options = "striped",
                                    full_width = T)
kableExtra::column_spec(x_html,1:2,
                        bold = T,
                        color = "white",
                        background = "#D7261E")
```


![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210403211506891.png)

```
x_html <- knitr:: kable(head(rock), "html")
x_html <- kableExtra::kable_styling(x_html,
                                    bootstrap_options = "striped",
                                    full_width = T)
kableExtra::row_spec(x_html,1:2,
                        bold = T,
                        color = "white",
                        background = "#D7261E")
```

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210403211527153.png)

#### 6.其它表格渲染

这里给出一个有趣的例子，具体内部不做过多解释， b 站视频给出解释。文字真的很难说明。
```
library(kableExtra)
data =  plyr::mutate(rock[1:10, ],
                   perm = cell_spec(perm,"html",
                   color = "white",
                   bold = T,
                   background = spec_color(1:10,
                   end = 0.9,
                   option = "A",
                   direction = -1)),
  shape = ifelse(shape > 0.15,
                 cell_spec(shape,
                           "html",
                           color = "white",
                           background = "#D7261E",
                           bold = T),
                 cell_spec(shape, "html",
                          color = "green",
                           bold = T)))
x_html <-knitr::kable(data,"html", escape = F, align = "c")
x_html <-row_spec(x_html,0, color = "white", background = "#696969" )
kable_styling(x_html,"striped")
```


![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210403211552162.png)



## 第四章： Rmarkdown 的主题格式

Rmarkdowm 作为可复用报告的优秀工具，除了提供文档编辑、图表输出外，还有许多主题格式供使用者选择。除了默认的主题外，还可以通过加载 rticles、prettydoc、rmdformats、tufte 等包获取更多主题格式。下面我们看看几类扩展包里的主题样式。 

> **注：** 接下来的教程我是已经安装这些包了，没安装的记得提前安装好！不然运行会出错。

### 4.1. rticles 包

官网：<https://github.com/rstudio/rticles>；

具体教程：<https://bookdown.org/yihui/rmarkdown/rticles-templates.html>

rticles 软件包提供了各种期刊和出版商的模板：

- JSS articles (Journal of Statistical Software)
- R Journal articles
- CTeX documents(**中文 pdf， 强烈推荐！**)
- ACM articles (Association of Computing Machinery)
- ACS articles (American Chemical Society)
- AMS articles (American Meteorological Society)
- PeerJ articles
- Elsevier journal submissions
- AEA journal submissions (American Meteorological Society)
- IEEE Transaction journal submissions
- Statistics in Medicine journal submissions
- Royal Society Open Science journal submissions
- Bulletin de l’AMQ journal submissions
- MDPI journal submissions
- Springer journal submissions


> 在此只对下面一个模板进行演示，其他模板操作类似，但是一般模板是不能包含中文字体的哦！

- CTeX Documents（中文版本）

下载完对应的包之后，找到对应模板打开即可。输出 pdf 是需要配置 tex 环境的哦！建议安装 Tinytex， 具体安装教程见前面。

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210315195440875.png)

编译后得到的结果，这是他模板原始的样子，如果想调整页面行间距，字体颜色等，请见下面一章。

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210315195456780.png)

### 4.2. rmdformats 包

之后的这几个包，内部都包含了挺多模板的，下面 yaml 文件只是其中一个，如果想尝试该包内部其他模板，请根据上述操作进行，选择好模板，编译之后看看是不是你想要的模板。

> 接下来我对部分相对不错的模板进行展示，你可以直接复制我的头部文件到 .rmd 格式中，或者打开模板窗口进行选择（操作在下面）。

- **方法一**

```
---
title: "Rmarkdown入门教程"
author: "庄闪闪的R语言手册"
date: "2/18/2021"
output:
  rmdformats::readthedown:
    self_contained: true
    thumbnails: true
    lightbox: true
    gallery: false
    highlight: tango
---
```

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210315195508990.png)

**方法二：**

在你安装完该包之后你可以使用通过按钮新建该模版（其实他有很多类似的模板，我这里只展现了一种）：

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210315195516091.png)

> 以下模板也可以通过这种方式构建，前提是你安装了这个包，这样你就可以在 From Template 中找到该包对应的模板了。

### 4.3. prettydoc 包

```
---
title: "Rmarkdown入门教程"
author: "庄闪闪的R语言手册"
date: "2/18/2021"
output:
  prettydoc::html_pretty:
    theme: cayman
    highlight: github
---
```

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210315195521796.png)

### 4.4. tufte 包

```
---
title: "Rmarkdown入门教程"
author: "庄闪闪的R语言手册"
date: "2/18/2021"
output:
  tufte::tufte_html: default
---
```

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210315195528253.png)

### 4.5. cerulean 包

```
---
title: "Rmarkdown入门教程"
author: "庄闪闪的R语言手册"
date: "2/18/2021"
output:
  html_document:
    theme: cerulean
    highlight: tango
---
```

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210315195535713.png)



## 第五章：总结一些常用技巧


关于RMarkdown使用时，小编日常会使用的一些有用技巧，当然我也是通过学习谢大大的[Rmarkdown-cookbook](https://bookdown.org/yihui/rmarkdown-cookbook/ "Rmarkdown-cookbook")以及日常使用需求上网搜的解决方案，在此分享给大家。如果大家还有其他什么需求，可以在留言板留言。或者有其他实用技巧也欢迎分享！

### 5.1.修改某些字体颜色

Markdown 语法没有用于更改文本颜色的内置方法。我们可以使用 HTML 和 LaTeX 语法来更改单词的格式

- 对于 HTML， 我们可以将文本包装在 <span> 标记中，并使用CSS设置颜色，例如`<span style =“ color：red;”> text </ span>`。
- 对于 PDF， 我们可以使用 LaTeX 命令 `\textcolor{}{}` 。 这需要使用 LaTeX 软件包 xcolor， 该软件包已包含在 Pandoc 的默认 LaTeX 模板中。

** 作为更改 PDF 文本颜色的示例：**

```
我是\textcolor{blue}{庄闪闪}呀！欢迎关注我的\textcolor{red}{公众号}：\textcolor{blue}{庄闪闪的R语言手册}。
```

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210318124743606.png)

在上面的示例中，第一组花括号包含所需的文本颜色，第二组花括号包含应将此颜色应用到的文本。

### 5.2.更改全文页边距等

  在top-level中加入`geometry`命令，例如

```
---
title: "RMarkdown常用技巧"
author:
  - 庄闪闪
documentclass: ctexart
geometry: "left=2cm,right=2cm,top=2cm,bottom=2cm"
output:
  rticles::ctex:
    keep_tex: true
    includes:
      in_header: columns.tex
    fig_caption: yes
    number_sections: yes
    toc: yes
---
```

这时的页边距就变成下面这样了：

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210318132951265.png)

当然全文字体大小等操作也是这样操作的，在 geometry 操作即可：

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210318123645722.png)

### 5.3. 缩进文本 

默认情况下， Markdown 还将忽略用于缩进的空格。 但是在某些情况下，例如在经文和地址中，我们可能希望保留缩进。 在这些情况下，我们可以通过以竖线 （|） 开头的线来使用线块。 换行符和所有前导空格将保留在输出中。 例如：

```
| When dollars appear it's a sign
|   that your code does not quite align  
| Ensure that your math  
|   in xaringan hath  
|   been placed on a single long line
```

输出为：

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210318125239921.png)

### 5.4.分页

如果想要分页，可以使用 `\newpage`。 例如：如果想把目录和正文内容分开，可以在在正文前面加入这个代码

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210319193017798.png)

这时输出的结果，目录一个界面，正文另起一页。

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210319193045376.png)

### 5.5.控制文本输出的宽度

有时从R代码输出的文本可能太宽。如果输出文档具有固定的页面宽度(例如， PDF 文档)，则文本输出可能会超过页面的页边距。

R 全局选项宽度可用于控制R函数输出的文本宽度，如果默认值太大，则可以尝试使用较小的值。此选项通常表示每行字符的粗略数目。例如：

```
​```{r}
options(width = 300)
matrix(runif(100), ncol = 20)
​```
```

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210318125512209.png)

```
​```{r}
options(width = 60)
matrix(runif(100), ncol = 20)
​```
```


![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210318125542194.png)

但是这种方式不一定对所有函数都适用，这是你可以使用其他方式，对于 Html （这里不做解释，主要将 pdf）， 可以参见[教程](https://bookdown.org/yihui/rmarkdown-cookbook/text-width.html "教程")。

对于 PDF 输出，换行比较困难。 一种解决方案是使用 LaTeX 软件包清单，可以通过 Pandoc 参数 --listings 启用它。 然后，您必须为此软件包设置一个选项，并且可以从外部 LaTeX 文件中包含设置代码（有关详细信息，请参见第[6.1](https://bookdown.org/yihui/rmarkdown-cookbook/latex-preamble.html#latex-preamble "6.1")节），例如，

```
---
output:
  pdf_document:
    pandoc_args: --listings
    includes:
      in_header: preamble.tex
---
```

在 preamble.tex 中（建议放到和rmd同一个文件夹），我们设置了 Listings 包的一个选项：

```
\lstset{
  breaklines=true
}
```

这是输出的结果，但是其实不是很美观

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210318130218480.png)



### 5.6.控制图片输出大小

这个我在文稿和教程中说的挺清楚了。一共有两种方式：

**方法一：**

```
​```{r, echo=FALSE, out.width="50%", fig.cap="A nice image."}
knitr::include_graphics("foo/bar.png")
​```
```

**方法二：**

```
![A nice image.](foo/bar.png){width=50%}
```

### 5.7.图片对齐

这个我也说过啦！可见：[ R沟通｜Rmarkdown教程（3）](http://mp.weixin.qq.com/s?__biz=MzI1NjUwMjQxMQ==&mid=2247491844&idx=1&sn=36decacb06ca6ce1fc689141174bb98f&chksm=ea271ee0dd5097f615b87c27151200635a9e5ff3c3072864bcf8fe6e8fbc41c0cffc6c95148f&scene=21#wechat_redirect)，[ R沟通｜Rmarkdown教程（2）](http://mp.weixin.qq.com/s?__biz=MzI1NjUwMjQxMQ==&mid=2247491546&idx=1&sn=00f8dea8903dbf4ec6e683ab5061a7a5&chksm=ea24e03edd536928ff6c5a3600c8fbbd87cafbf9286ad47bfe4c084032cada9bf6ee7dfddcd9&scene=21#wechat_redirect)。如果使用R代码导入图片的话，使用 `knitr::include_graphics()` 并结合 R chunk 中 `fig.align = 'center'` 参数进行居中。如果结果不想显示代码块，可在chunck中加入： `echo=FALSE`。

> 任何输出形式都适用，推荐使用

```
knitr::include_graphics()
```

当然还有另一种方法，不使用代码形式。对于输出为 html， 你可以使用 html 语法（不适用于 pdf/word）

```
<center> ![](image.png) </center>
```

对于输出 pdf/word 可以使用以下方式

```
\center
![](image.png)
\center
```

> 当然想要文字居中的话，也是这样使用。

### 5.8.代码块的行号

通过块选项 `attr.source =“ .numberLines”` 将行号添加到源代码块中，或者通过 `attr.output =“ .numberLines”` 将文本输出块添加到文本中，例如，

```
​```{r, attr.source='.numberLines'}
if (TRUE) {
  x = 1:10
  x + 1
}
​```
```


输出结果为：

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210318131400399.png)

### 5.9.多列输出

这个特别好用！虽然学起来有那么一点困难，具体我再出一期推文，把这个讲清楚。具体可以见这里的[教程](https://bookdown.org/yihui/rmarkdown-cookbook/multi-column.html "教程")。类似于排版成这种形式：
  
![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/image-20210319195033178.png)


## 小编有话说

- 当然 Rmarkdown 还可以做各种拓展，比如 presentation（ioslides、 Beamer、 slidy、 PowerPoint），Documents（Html、 Notebook、 PDF、 word） 及其他拓展 （Dashboards、Tufte Handouts、 xaringan Presentations、 Websites） 等。有部分我已经整理好了，可以在下面窗口的拓展教程中找到。

![](https://gitee.com/zhuang_liang_liang0825/other/raw/master/9601618034106_.pic_hd.jpg)
