---
title: 一款新的 R Markdown 幻灯片制作工具：xaringan
date: '2017-02-13T13:17:47+00:00'
author: COS编辑部
categories:
  - 推荐文章
  - 统计之都
  - 统计软件
tags:
  - HTML5 幻灯片
  - R Markdown
  - xaringan
slug: a-new-r-markdown-ppt-tool
---

_作者：边蓓蕾      审校：郎大为      编辑：彭晨昱_

今天小编给大家介绍一款新的幻灯片神器：xaringan（中文名：幻灯忍者）。它基于大家都熟悉的 R Markdown 语法，幻灯片中能嵌入 R 代码动态生成输出结果，最后生成的是 HTML5 幻灯片，可以在网页浏览器里打开阅览，我们一起来探个究竟吧。对了，官方教程在这里：<https://slides.yihui.name/xaringan/zh-CN.html>{.uri}

在此声明一下本文适宜读者群：R码农，熟悉markdown语法，懂点前端的你们。当然如果以上你都不太熟悉但又有着求知欲，希望本文将是你成为幻灯忍者的起点。<img class="aligncenter size-medium wp-image-13624" src="https://cos.name/wp-content/uploads/2017/02/fig4-300x256.png" alt="" width="300" height="256" srcset="https://cos.name/wp-content/uploads/2017/02/fig4-300x256.png 300w, https://cos.name/wp-content/uploads/2017/02/fig4-768x656.png 768w, https://cos.name/wp-content/uploads/2017/02/fig4-500x427.png 500w, https://cos.name/wp-content/uploads/2017/02/fig4.png 1154w" sizes="(max-width: 300px) 100vw, 300px" />

&nbsp;

<!--more-->

# 出发！

首先，从 GitHub 上安装此包的开发版本（建议用 RStudio IDE），或者直接从 CRAN 安装也行。

<pre class="sourceCode r"><code class="sourceCode r">devtools::&lt;span class="kw">install_github&lt;/span>(&lt;span class="st">"yihui/xaringan"&lt;/span>)</code></pre>

下面会以一个进阶的过程给大家讲解。

# 下忍篇

请进行如下操作：

  * 点击菜单 **<span style="color: #ff0000;"><code>File -&gt; New File -&gt; R Markdown -&gt; From Template -&gt; Ninja Presentation (Simplified Chinese)</code> </span>**创建一个新文档。<img class="aligncenter size-medium wp-image-13629" src="https://cos.name/wp-content/uploads/2017/02/fig1-300x188.png" alt="" width="300" height="188" srcset="https://cos.name/wp-content/uploads/2017/02/fig1-300x188.png 300w, https://cos.name/wp-content/uploads/2017/02/fig1-768x480.png 768w, https://cos.name/wp-content/uploads/2017/02/fig1-500x313.png 500w" sizes="(max-width: 300px) 100vw, 300px" />
  * 点击 Knit 进行编译

<img class="aligncenter size-medium wp-image-13630" src="https://cos.name/wp-content/uploads/2017/02/fig2-300x188.png" alt="" width="300" height="188" srcset="https://cos.name/wp-content/uploads/2017/02/fig2-300x188.png 300w, https://cos.name/wp-content/uploads/2017/02/fig2-768x480.png 768w, https://cos.name/wp-content/uploads/2017/02/fig2-500x313.png 500w" sizes="(max-width: 300px) 100vw, 300px" />

此时你会看见一个默认模版，改改就可以开张了！在此之前，你需要了解一些基本魔法：

##### 魔法一：Markdown基本语法

  * 用三个短横线来开始一页新的幻灯片，可以用一个井号开始写标题（标题不是必须元素）

<pre># 引言

这是第一张片子

---

# PPT狗子们看过来

这是第二张片子</pre>

  * 可以用两个短横线分割当前页面，两短横线下面的内容会被接续上面的内容生成在下一页上，比如你有一个三个项目的列表，中间用两短横线分割，最后出来的效果就是先显示第一项，翻下一页继续显示下一项

<pre class="sourceCode markdown"><span style="color: #808080; font-family: monospace, serif;"># 忍者等级

- 上忍

--

- 中忍

--

- 下忍</span></pre>

<li class="sourceCode markdown">
  可以用三个问号添加片子的注释，注释不会直接显示在幻灯片中，而是在演讲者模式中才会出现（键盘上按 p 键）
</li>

<pre class="sourceCode markdown"># 影
只有五大国所属忍者村的首领才可以拥有的称号（动画原创剧情中增加了星影），
是“村子中最伟大的忍者”。

???

五影的称号分别是：火影、风影、水影、土影、雷影。</pre>

<p class="sourceCode markdown">
  若你不了解 Markdown 语法，可以用 RStudio 菜单 <strong><span style="color: #ff0000;"><code>Help -&gt; Markdown Quick Reference</code></span></strong> 打开一个参考页面。
</p>

##### 魔法二：片子属性的设置 {.sourceCode.markdown}

片子的最开头，你会看到有 key-value（键-值对）格式的写法，这就是片子的属性。

  * class

类属性用来设置 CSS 类，可用来调整片子里面文字的位置

<pre>class: center, middle

# 请水平垂直居中我</pre>

  * background-image

最后再介绍一个比较吸引人的自定义背景功能。你可以选择自己喜欢的图片（本地图片或网络图片）。

<pre><span style="font-family: monospace, serif;">background-image: url(chakra.svg)

# 查克拉</span></pre>

更多属性设置参见：<https://github.com/gnab/remark/wiki/Markdown>{.uri}

##### 魔法三：插入数学公式

一般情况下依旧是 LaTeX语法，写在一对美元符号中间，如：**<span style="color: #ff0000;"> <code>$\alpha + \beta$</code></span>**会显示 <span class="math inline"><span id="MathJax-Element-1-Frame" class="MathJax" tabindex="0" data-mathml="<math xmlns=&quot;http://www.w3.org/1998/Math/MathML&quot;><mi>&#x03B1;</mi><mo>+</mo><mi>&#x03B2;</mi></math>"><span id="MathJax-Span-1" class="math"><span id="MathJax-Span-2" class="mrow"><span id="MathJax-Span-3" class="mi">α</span></span></span><span class="MJX_Assistive_MathML">+β</span></span></span>。如果你要将公式显示成一个段落而不是嵌在行内，那要用一对双美元符号，如：

    $$\bar{X}=\frac{1}{n}\sum_{i=1}^nX_i$$

<img class="aligncenter size-full wp-image-13635" src="https://cos.name/wp-content/uploads/2017/02/屏幕快照-2017-02-12-下午10.52.33.png" alt="" width="298" height="138" />

&nbsp;

##### 魔法四：插入R代码及R图形

  * R代码

    ```{r comment='#'}
    # 一个无聊的回归模型
    fit = lm(dist ~ 1 + speed, data = cars)
    coef(summary(fit))
    dojutsu = c('地爆天星', '天照', '加具土命', '神威', '須佐能乎', '無限月読')
    grep('天', dojutsu, value = TRUE)
    ```

  * R图形

    ```{r cars, fig.height=3.5, dev='svg'}
    par(mar = c(4, 4, 1, .1))
    plot(cars, pch = 19, col = 'darkgray', las = 1)
    abline(fit, lwd = 2)
    ```

# 中忍篇

在以上四种魔法的基础上，可以再吃两颗兵粮丸。(设置幻灯片的各种行为)

##### 丸子一：YAML(这也是一种标记语言，经常用来写一些配置)头文件设置整个幻灯片的选项

  * 定义输出格式：**<span style="color: #ff0000;"><code>xaringan::moon_reader</code></span>**
  * CSS 样式：如果你比较熟悉 CSS ，不妨在外部自定义一个 CSS 文件，以 **<span style="color: #ff0000;"><code>css: ['extra.css']</code> </span>**的形式引入。如果完全没听过css，请百度各种菜鸟教程，或者去了解一下W3C组织，同时恭喜你入坑。
  * nature下面设置 autoplay 选项，片子每隔一段时间自动播放，单位毫秒
  * 如果不想让无限月读锁死 R 进程，请设置：
  * <pre class="sourceCode r"><code class="sourceCode r">&lt;span class="kw">options&lt;/span>(&lt;span class="dt">servr.daemon =&lt;/span> &lt;span class="ot">TRUE&lt;/span>)</code></pre>

  * 累了还可以玩玩yolo大法

该选项默认的图片是 Karl Broman 的大头照。如果 **<span style="color: #ff0000;"><code>yolo: 3</code> </span>**你的幻灯片中将随机出现 3 次他的大头照，如果 <span style="color: #ff0000;"><strong><code>yolo: 0.3</code></strong></span> 你的幻灯片中将有 30% 的片子是他的大头照。当然你也可以把默认图片换掉。

  * &#8230;&#8230;

欲知所有可能的选项，请在console中输入 <span style="color: #ff0000;"><strong><code>?xaringan::moon_reader</code></strong></span>

##### 丸子二：幻灯片的播放

  * 请按下h键一键查看帮助
  * 按下 p 键进入播放模式，此时你会看到计时器以及之前三个问号为你留下的注释，可谓演讲者的好工具！

# 上忍篇

嗯，其实，有人想知道这个包是怎么来的嘛！如果你还有一颗好奇心，请坚持，它很宝贵。

remark.js 是一个用来做幻灯片的 JavaScript 库，好处是能随时随地在不同设备的浏览器里浏览，用的是简单的 Markdown 语法，如果你熟悉 HTML，CSS 还能把片子做的特酷炫，播放也是杠杠的……我们来创建一个片子。参考：<https://github.com/gnab/remark/wiki>{.uri}

<pre class="sourceCode html"><code class="sourceCode html">&lt;span class="dt">&lt;!DOCTYPE &lt;/span>html&lt;span class="dt">&gt;&lt;/span>
&lt;span class="kw">&lt;html&gt;&lt;/span>
  &lt;span class="kw">&lt;head&gt;&lt;/span>
    &lt;span class="kw">&lt;title&gt;&lt;/span>Title&lt;span class="kw">&lt;/title&gt;&lt;/span>
    &lt;span class="kw">&lt;meta&lt;/span>&lt;span class="ot"> charset=&lt;/span>&lt;span class="st">"utf-8"&lt;/span>&lt;span class="kw">&gt;&lt;/span>
    &lt;span class="kw">&lt;style&gt;&lt;/span>
    &lt;span class="fl">.red&lt;/span> &lt;span class="kw">{&lt;/span>
      &lt;span class="kw">color:&lt;/span> &lt;span class="dt">red&lt;/span>&lt;span class="kw">;&lt;/span>
    &lt;span class="kw">}&lt;/span>
    &lt;span class="kw">&lt;/style&gt;&lt;/span>
  &lt;span class="kw">&lt;/head&gt;&lt;/span>
  &lt;span class="kw">&lt;body&gt;&lt;/span>
    &lt;span class="kw">&lt;textarea&lt;/span>&lt;span class="ot"> id=&lt;/span>&lt;span class="st">"source"&lt;/span>&lt;span class="kw">&gt;&lt;/span>

class: center, middle

# Title

---

# Agenda

1. Introduction
2. Deep-dive
3. ...

---

# Introduction

    &lt;span class="kw">&lt;/textarea&gt;&lt;/span>
    &lt;span class="kw">&lt;script&lt;/span>&lt;span class="ot"> src=&lt;/span>&lt;span class="st">"https://remarkjs.com/downloads/remark-latest.min.js"&lt;/span>&lt;span class="kw">&gt;&lt;/span>
    &lt;span class="kw">&lt;/script&gt;&lt;/span>
    &lt;span class="kw">&lt;script&gt;&lt;/span>
      &lt;span class="kw">var&lt;/span> slideshow &lt;span class="op">=&lt;/span> &lt;span class="va">remark&lt;/span>.&lt;span class="at">create&lt;/span>()&lt;span class="op">;&lt;/span>
    &lt;span class="op">&lt;&lt;/span>&lt;span class="ss">/script&gt;&lt;/span>
&lt;span class="ss">  &lt;/body&lt;/span>&lt;span class="op">&gt;&lt;/span>
&lt;span class="op">&lt;&lt;/span>&lt;span class="ss">/html&gt;&lt;/span></code></pre>

好，就把这些复制上吧，在浏览器里打开该文件，你就看到了3张片子。

<img class="aligncenter size-medium wp-image-13631" src="https://cos.name/wp-content/uploads/2017/02/fig3-300x188.png" alt="" width="300" height="188" srcset="https://cos.name/wp-content/uploads/2017/02/fig3-300x188.png 300w, https://cos.name/wp-content/uploads/2017/02/fig3-768x480.png 768w, https://cos.name/wp-content/uploads/2017/02/fig3-500x313.png 500w" sizes="(max-width: 300px) 100vw, 300px" />

不熟悉 HTML 和 CSS 基本语法的可能需要补补（这里用到的不难～）你会看到 **<span style="color: #ff0000;"><code>&lt;head&gt;</code></span>** 标签里裹了个 <span style="color: #ff0000;"><strong><code>&lt;style&gt;</code></strong></span> 标签，它规定了你的 HTML 元素在浏览器里呈现的样式（比如字体，边距，颜色…），其实也就是 CSS 样式表，这里还是帮大家写了几个例子，比如用类的方式定义颜色，字体粗细等等。在片子里使用的时候，直接用 **<span style="color: #ff0000;"><code>.red[我红得像龙虾]</code></span>**。当然 CSS 可以以外部文件的形式引入。 好，下面来到关键的主体部分了。在这里，你需要用 Markdown 语法开始写你的片子，你的片子需要裹到一个文本区域里面：

<pre class="sourceCode html"><code class="sourceCode html">&lt;span class="kw">&lt;textarea&lt;/span>&lt;span class="ot"> id=&lt;/span>&lt;span class="st">'source'&lt;/span>&lt;span class="kw">&gt;&lt;/span>
  Markdown
&lt;span class="kw">&lt;/textarea&gt;&lt;/span></code></pre>

高高兴兴写完魔性的幻灯片，别忘了 remark.js 啊，建议你把压缩版的js文件下载到本地（这样可以不依赖于网络，随时随地看你的幻灯片了），然后乖乖引入(这里还是引的文件的网址，如果下载到本地了，请写好本地的路径)：

<pre class="sourceCode html"><code class="sourceCode html">&lt;span class="kw">&lt;script&lt;/span>&lt;span class="ot"> src=&lt;/span>&lt;span class="st">"https://remarkjs.com/downloads/remark-latest.min.js"&lt;/span>&lt;span class="kw">&gt;&lt;/script&gt;&lt;/span></code></pre>

当然，还没完，你要用下面一句 js 代码渲染你的幻灯片：

<pre class="sourceCode html"><code class="sourceCode html">&lt;span class="kw">&lt;script&gt;&lt;/span>
  &lt;span class="kw">var&lt;/span> slideshow &lt;span class="op">=&lt;/span> &lt;span class="va">remark&lt;/span>.&lt;span class="at">create&lt;/span>()&lt;span class="op">;&lt;/span>
&lt;span class="op">&lt;&lt;/span>&lt;span class="ss">/script&gt;&lt;/span></code></pre>

<p class="sourceCode html">
  觉得麻烦吗？觉得麻烦就对了，这就是 xaringan 包的价值所在：你不必管这些背后的 HTML/JavaScript 细节，只需要创建一个 R Markdown 文档，点一下无限月读插件（<strong><span style="color: #ff0000;"><code>Addins -&gt; Infinite Moon Reader</code></span></strong>），剩下的事情都交给 xaringan，你只需要敲你的幻灯片正文就够了，预览会自动显示在 RStudio 右栏中。
</p>

## 与 ioslides/Slidy 的对比

remark.js 有几大显著优势：可以很方便设置一张片子的背景图片、可以创建一张模板幻灯片让其它幻灯片继承它的属性、可以设置单张片子的属性，这样只要你懂 CSS 便可以无限扩展任意页面的样式、可以用两横线分割任意页面中的任意元素、有演讲者模式（可以写只给自己看的注释）、可以一键 m 把当前页面倒过来（所以叫幻灯忍者）或者 b 拉黑（比如你的当前页面上有测验答案暂时不想给观众看）。

## 与 slidify 的对比

最后简单聊聊与Slidify的不同。[slidify](http://slidify.org/) 也是一款用 R Markdown 生成幻灯片的 R 包，作者是 [Ramnath Vaidyanathan](https://github.com/ramnathv)。这个包只能使用开发版（作者掉了两年链子）:

<pre class="sourceCode r"><code class="sourceCode r">devtools::&lt;span class="kw">install_github&lt;/span>(&lt;span class="st">"ramnathv/slidify"&lt;/span>)
devtools::&lt;span class="kw">install_github&lt;/span>(&lt;span class="st">"ramnathv/slidifyLibraries"&lt;/span>)</code></pre>

如果 xaringan 是一把忍刀的话，slidify 更像是一把瑞士军刀，功能多得令人发指（这句话是褒是贬请自行判断），单纯支持的幻灯片库就有七八个，io2012，reveal，impress，……与之对应的是复杂的参数设置以及需要自己定义的模板. 如果对 slidify 进行深入的设计与开发，可以让自己的幻灯片变得很炫，如果没有，默认的样式能把自己丑哭。

对了，slidify 还有两个没法回避的问题，一个是作者 Ramnath 大大已经有一年半没有更新这个包了，同时你也别想在 CRAN 上找到它; 第二个问题是，到目前为止，在 Windows下，还没有一个完美的中文解决方案。与之比较，如果你遇到这类问题了，可以去 xaringan 的 Github 库里提问（<https://github.com/yihui/xaringan/issues>{.uri}），相信谢大大会尽力让你的幻灯片说一屏流利的中文的。

原创文章，版权所有。<section class=""></section> 

敬告各位友媒，如需转载，请与统计之都小编联系（直接留言或发至邮箱：editor@cos.name ），获准转载的请在显著位置注明作者和出处（转载自：统计之都），并在文章结尾处附上统计之都二维码。

<img class="size-medium wp-image-13650 alignleft" src="https://cos.name/wp-content/uploads/2017/02/qrcode_for_gh_946beec24de4_1280-300x300.jpg" alt="" width="300" height="300" srcset="https://cos.name/wp-content/uploads/2017/02/qrcode_for_gh_946beec24de4_1280-300x300.jpg 300w, https://cos.name/wp-content/uploads/2017/02/qrcode_for_gh_946beec24de4_1280-150x150.jpg 150w, https://cos.name/wp-content/uploads/2017/02/qrcode_for_gh_946beec24de4_1280-768x768.jpg 768w, https://cos.name/wp-content/uploads/2017/02/qrcode_for_gh_946beec24de4_1280-500x500.jpg 500w, https://cos.name/wp-content/uploads/2017/02/qrcode_for_gh_946beec24de4_1280.jpg 1280w" sizes="(max-width: 300px) 100vw, 300px" />
