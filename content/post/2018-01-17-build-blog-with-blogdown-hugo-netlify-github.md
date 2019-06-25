---
title: 用R语言的blogdown+hugo+netlify+github建博客
author: 钟浩光
date: '2018-01-17'
slug: build-blog-with-blogdown-hugo-netlify-github
categories:
  - 推荐文章
  - R语言
tags:
  - R
  - blogdown
  - netlify
  - github
  - rstudio
forum_id: 419792
meta_extra: "编辑：钟浩光；审稿：何通、赵鹏"
---



## 目标

用R语言的blogdown + hugo + netlify + github搭建静态博客系统，用rstudio**专注于写作**。

![1-4swordsman](https://gitee.com/heavenzone/picturebed/raw/master/zhonghaoguang.com/2018/20180117-01-swordsman-800.png)

### 优点

- **个性域名**
- **免费**，无限流量
- 静态网页，**速度快**
- github保存内容，不需要搭建数据库，**不需要备份**

## 准备工作

### 软件准备

系统：本文以Windows操作系统为例来介绍安装和配置方法。其他操作系统是类似的。

- 安装R，[点此下载](https://www.r-project.org/)
- 安装rstudio，[点此下载](https://www.rstudio.com/products/rstudio/download/#download)
- 安装git，[点此下载](https://git-scm.com/download/win)

windows下安装很简单，就不描述了。

对于git，作为非程序猿的我，一直想学但是一直没学，直到打算用blogdown建个blog玩之后，就注册了github看看git是怎么玩的，不过我倒不是从命令行学起的（虽然我也玩linux），而是装了个[GitKraKen](https://www.gitkraken.com/)来摸git是怎么玩的，然后再对应的学一点命令行的。其实只需要会add、commit、push、pull、merge就足够对付blogdown了。如果想用github对blogdown的主题启用一个转移魔法的话，可以看这里：[git-submodule](https://yihui.name/cn/2017/03/git-submodule/)

我们这里并不需要安装GitKraKen，因为**rstudio**已经有git的gui功能了，所以上面提到的命令怎么打也不用学，直接在rstudio上点点点。

### rstudio配置

安装好上述软件后，需要对rstudio进行一下简单配置：

- Tools -> Global Options -> Sweave -> Weave Rnw files using:**knitr**
- Tools -> Global Options -> Sweave -> Typeset LaTex into PDF using:**XeLaTeX**
	- 这个是生成PDF文件用的，中文用户最好选择XeLaTeX
	
![2-sweave](https://gitee.com/heavenzone/picturebed/raw/master/zhonghaoguang.com/2018/20180117-02-sweave.png)	
	
- Tools -> Global Options -> Git/SVN -> Git executable:
	- 安装好git后，打开这里应该就可以看到git的路径了

![2-git](https://gitee.com/heavenzone/picturebed/raw/master/zhonghaoguang.com/2018/20180117-02-git.png)	

- Tools -> Global Options -> Packages -> CRAN mirror: 
	- 建议选择一个距离你比较近的镜像，速度会快点。例如，国内用户可以选择一个 China 的镜像。

![2-cran](https://gitee.com/heavenzone/picturebed/raw/master/zhonghaoguang.com/2018/20180117-02-cran.png)	

### 安装blogdown和hugo

安装blogdown：

```
install.packages('blogdown')
```

安装hugo

```
blogdown::install_hugo()
```

如果安装hugo的时候出现下面的错误(貌似有同志也有[这个问题](https://github.com/rstudio/blogdown/issues/244))：

```
> blogdown::install_hugo()
The latest hugo version is 0.32.4
trying URL 'https://github.com/gohugoio/hugo/releases/download/v0.32.4/hugo_0.32.4_Windows-64bit.zip'
trying URL 'https://github.com/gohugoio/hugo/releases/download/v0.32.4/hugo_0.32.4_Windows-64bit.zip'
Error in download.file(url, ..., method = method, extra = extra) : 
  cannot open URL 'https://github.com/gohugoio/hugo/releases/download/v0.32.4/hugo_0.32.4_Windows-64bit.zip'
In addition: Warning messages:
1: In download.file(url, ..., method = method, extra = extra) :
  InternetOpenUrl failed: ''
2: In download.file(url, ..., method = method, extra = extra) :
  InternetOpenUrl failed: ''
```

这个时候就直接安装开发版，就可以解决：

```
install.packages("devtools")
devtools::install_github("rstudio/blogdown")
```

如果安装了开发版的blogdown，还没有搞定，那么就把错误信息中的链接复制到浏览器直接下载，把文件解压发现里面就只有一个文件，Yihui选择hugo就是因为hugo只有一个文件，够简单，至于为什么我会知道Yihui选择hugo的原因？因为我读了[**blogdown故事**](https://yihui.name/en/2017/12/blogdown-book/)。


把解压好的hugo.exe文件放在`d:/`根目录下，然后输入下面代码安装hugo：

```
# 注意这里是三个冒号
blogdown:::install_hugo_bin("d:/hugo.exe")
```

安装成功。

不知道是不是网络国际出口的问题，最近从github下载文件都比较慢(浏览github网页倒没有问题)，经常用`devtools::install_github()`安装包都不成功，就算用浏览器下载hugo也经常出现错误，估计这就是用`blogdown::install_hugo()`安装不了的原因吧。

ok，我们来到这里，暂时离开一下rstudio，我们去弄弄github。

### 注册域名

虽然个人域名不是必须的（你可以直接使用netlify的二级域名，如yourname.netlify.com），但是为了彰显个性，当然是注册个人域名啦。

怎么注册域名就不详说了，国内的有万网等，国外有GoDaddy之类的，选择国内服务商的话，域名要备案，国外就可以省略这个步骤。

还有第三个选择就是到[**rbind.io**](https://support.rbind.io/about/)向**blogdown组织**申请一个二级域名**yourname.rbind.io**。

下面的内容是针对已经申请个人域名来展示的。

### 用github创建repository

![3-new-repo](https://gitee.com/heavenzone/picturebed/raw/master/zhonghaoguang.com/2018/20180117-03-new-repo.png)

如图所示填写好repository name、Description，默认选择Public，可以选择复选框Initialize this repository with a README，`add .gitignore`选择`R`吧，点击**Create repository**就可以创建好用于保存网站的repository。

这个repository name没有要求，随便起，不像github的pages服务要求名字和github的账号名称一样，建议起名**domainname.com**，当你有多个网站要管理的话，这样就可以一眼就可以看出是那个网站了，我自己当时就不知道可以用点，所以也不知道这样来起名字。


## blogdown建站

### 创建项目

现在回到rstudio，`File -> New Project -> Version Control -> Git`，然后填写Repository URL:`https://github.com/yourGithubName/domainname.com`，`Project directory name`应该自动就生成了，可以选择一个合适的文件夹存放，点击**Create Project**创建项目。

### 设置gitignore

打开rstudio右下角的`Files`标签，点击`.gitignore`文件，改成下面这样吧（copy Yihui的）：

```
.Rproj.user
.Rhistory
.RData
.Ruserdata
public
static/figures
blogdown
```

上面的文件或者目录就不会提交到github上。

如果对git命令不是很熟悉，建议在这个时候就把`.gitignore`文件修改好的，因为在生成public文件夹之后(后面的步骤会生成public)，再修改`.gitignore`文件添加`public`文件夹，那么`Git`标签那里**还是不会**把public文件夹忽略掉，要解决这个问题，可以按如下操作：

```
git rm -r --cached public

# 然后在.gitignore文件添加规则
public
```

这样下次的 git add .就不会把public加进去了。


### 初始化blogdown

打开：`File -> New Project -> New Directory -> Website using blogdown`

![4-init-blogdown](https://gitee.com/heavenzone/picturebed/raw/master/zhonghaoguang.com/2018/20180117-04-init-blogdown.png)

因为我们已经安装了hugo，所以去掉hugo选项，Yihui是建议用**hugo-xmin**主题开始我们的blogdown之旅的，所以这里就选择了hugo-xmin。点击`Create Project`创建项目。

有人会疑问为什么要两次新建项目？这并不是必须，其实可以不做**创建项目**这一步，不过就要另外一个步骤，把本地项目同步到github仓库，可以按下面步骤处理(详细解释可以看[这里](https://help.github.com/articles/adding-an-existing-project-to-github-using-the-command-line/))：

```
cd <本地项目目录>
git init
git add .
git commit -m "first comment"
git remote add origin https://github.com/<github帐号>/<仓库名称>
git remote -v
git pull origin master --allow-unrelated-histories
git push -u origin master
```


### 本地运行网站

到这里，博客已经可以在本地运行，我们试试看吧，点击菜单`Help`下面的`Addins`，如下图所示：

![6-Addins-serve-site](https://gitee.com/heavenzone/picturebed/raw/master/zhonghaoguang.com/2018/20180117-06-serve-site.png)

点击`Serve Site`，可能会提示安装几个包例如shiny、miniUI等，点击yes安装就行了，其实点击这个跟在console里面输入`blogdown::serve_site()`是一样的，如果你还没有安装[**写轮眼xaringan**](https://github.com/yihui/xaringan)，会有下面的warning信息：

```
Warning message:
In eval(quote({ :
  The xaringan package is not installed. LaTeX math may not work well.
```

我们乖乖的按照提示把**写轮眼**安装了吧（网页上的数学公式用的是**MathJax.js**实现）：

```
install.packages("xaringan")
```

这个时候，已经可以在右下角`Viewer`标签看到网站的美貌了：

> Keep it simple, but not simpler

![7-xmin](https://gitee.com/heavenzone/picturebed/raw/master/zhonghaoguang.com/2018/20180117-07-hugo-xmin.png)

我们也可以在浏览器输入`http://127.0.0.1:4321/`来浏览。


### 写博客

又来点击菜单`Help`下面的`Addins`，这次我们点击`New Post`，就会弹出下面这个画面：

![8-yihui-new-post](https://bookdown.org/yihui/blogdown/images/new-post.png)

`Filename`处会自动帮你填写为`Title`处的内容，`Filename`和`Slug`还是建议使用字母，尤其是`Filename`，如果博文里面不需要用到R语言的代码计算结果生成图表的话，`Format`处就选择`Markdown`格式，这可以省去一些系统生成的步骤，ok，点击`Done`，就会在`/content/post`文件夹下面生成一个文件名为`2000-01-01-my-first-blog.Rmd`这样的文件了，content文件夹下面的文件就是博客的文章了。

这个时候就可以用markdown格式**专注于写作**了。

### 关于修改主题

如果你想修改主题，可以到[这里](https://themes.gohugo.io/)找主题修改。

关于修改主题的**非技术TIPS**，可以看看下面两段话，引用自Yihui的blogdown使用文档**[1.6 Other themes](https://bookdown.org/yihui/blogdown/other-themes.html)**最下面引用的一段话**：[原出处](http://weibo.com/1406511850/Dhrb4toHc)**

>If you choose to dig a rather deep hole, someday you will have no choice but keep on digging, even with tears.
-— Liyun Chen13

Yihui是这样说的：

>Another thing to keep in mind is that the more effort you make in a complicated theme, the more difficult it is to switch to other themes in the future, because you may have customized a lot of things that are not straightforward to port to another theme.

所以呢，可以先把hugo官网上面的主题都浏览一下，看看哪个合眼缘，挑好再改吧。

学习怎么修改主题的另外一个好去处是hugo-xmin的[pull request](https://github.com/yihui/hugo-xmin/pulls)。如果你有好的改进，也可以在这里提交pull request让别人学习。

看看下面的pull request图：

![8-1-pull-request](https://gitee.com/heavenzone/picturebed/raw/master/zhonghaoguang.com/2018/20180117-08-1-pull-request.png)

## 设置netlify

### 注册netlify

打开[netlify主页](https://app.netlify.com/signup)就可以注册了，直接在 *Sign up with one of the following:* 下面选择**GitHub**就行了。


### 绑定github

登录进netlify后，点击导航栏`Sites`，再点击右上角`New site from Git`，再点击`Github`，如下图：

![11-netlify-github](https://gitee.com/heavenzone/picturebed/raw/master/zhonghaoguang.com/2018/20180117-11-netlify-github.png)

然后按照下面的图填写就可以了：

![12-deploy-site](https://gitee.com/heavenzone/picturebed/raw/master/zhonghaoguang.com/2018/20180117-12-deploy-site.png)

因为hugo生成的文件夹是`public`所以填public。

点击`deploy site`就可以生成网站了。

这个时候可以再去到一个叫`deploy settings`的地方（如下图所示），确保选项选中的是`none`，就是只deploy master分支。

![13-deploy-settings](https://gitee.com/heavenzone/picturebed/raw/master/zhonghaoguang.com/2018/20180117-13-deploy-settings.png)


### 设置个性二级域名

这个时候生成的网站网址是`<一串类似md5的字符串>.netlify.com`，点击导航栏的`Overview`，再点击`Site settings -> Change site name`，就可以输入你的英文名字，这时就得到一个netlify的二级域名`<Site Name>.netlify.com`。

### 绑定个人域名

如果你不满足于netlify的二级域名，还可以选择绑定个人域名。

点击左边导航栏的`Domain management -> Domains`，

![14-domains](https://gitee.com/heavenzone/picturebed/raw/master/zhonghaoguang.com/2018/20180117-14-domains.png)

然后点击`Add custom domain`，这个时候就可以输入你在域名提供商处注册的域名了。

### 修改域名服务器

添加域名后，点击如上图所示的小红点处，选择`Go to DNS panel`，然后就跳转到`DNS settings`页面，这里应该是不用做`Add new record`操作的（我忘记了，应该是自动添加了的），如果没有记录，就点它添加吧，如下图所示：

![15-record-setting](https://gitee.com/heavenzone/picturebed/raw/master/zhonghaoguang.com/2018/20180117-15-record-setting.png)

上图的**Nameservers**部分有四条netlify的dns服务器域名，把他们添加到你注册域名的Nameservers就可以了，我在域名服务商里面的设置如下图所示：

![16-nameservers-config](https://gitee.com/heavenzone/picturebed/raw/master/zhonghaoguang.com/2018/20180117-16-nameservers-config.png)

到此，所有的基本设置都已经完成。

### 更新博客内容

前面提到我们可以专注于写作，现在所有东西都准备好，就可以把写好的文章update到线上，点击右上角`Git`标签，点击`commit`（如下图所示），填写好commit message点击`commit -> push`，这样就已经更新线上的博客，大概不用1分钟的时间，打开你的个人主页`www.domainname.com`就可以看到最新的文章出现了。

![20180117-17-1-git-commit](https://gitee.com/heavenzone/picturebed/raw/master/zhonghaoguang.com/2018/20180117-17-1-git-commit.png)

至此，关于用R语言的blogdown + hugo + netlify + github搭建静态博客系统的介绍全部结束了，更多关于blogdown的魔法就等大家自己去挖掘了吧。

Go，用rstudio去写博客吧！

## 参考资料

1. [blogdown: Creating Websites with R Markdown](https://bookdown.org/yihui/blogdown/)
1. [Up and running with blogdown](https://alison.rbind.io/post/up-and-running-with-blogdown/)
1. [本站是如何建成的：R blogdown 简介](http://xuer.dapengde.com/post/hugo-blogdown/)
1. [R blogdown 科研网站的公式和参考文献](http://www.pzhao.org/zh/post/rblogdown-bib/)
1. [如何在 R markdown 里输出 r pi 并前后加上小撇\`](http://www.pzhao.org/zh/post/backticks-in-rmd/)
1. [Enable Code folding](https://github.com/statnmap/hugo-statnmap-theme/pull/1/files)
1. [Making a Website Using blogdown, hugo, and GitHub pages](https://proquestionasker.github.io/blog/Making_Site/)
1. [Getting Started With blogdown](https://www.znmeb.mobi/2017/05/12/getting-started-with-blogdown/)
1. [rbind support](https://support.rbind.io/)
