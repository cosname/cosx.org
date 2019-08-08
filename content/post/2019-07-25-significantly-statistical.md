---
title: 从统计地显著到显著地统计
author: 
  - 孟晓犁
date: '2019-08-08'
slug: significantly-statistical
categories:
  - 推荐文章
tags: 
  - 统计显著性
  - 显著地统计
  - 假设检验
  - P 值
meta_extra: "译者：任焱、黄湘云 审稿：杨洵默"
forum_id: 420838
---

> 文章翻译自孟晓犁在 IMS 主席专栏上的文章 <http://bulletin.imstat.org/2019/05/presidents-column-statistical-significance/> 翻译工作已经获得原作授权

我们统计学家已经成功地说服每个人：样本量越大，拒绝原假设的依据就愈加坚实有力。 然而，人们有时会过度而错误地理解这件事情。2017 年 70 多位学者联名在杂志《自然人类行为》上发表文章《重新定义统计显著性》[1]， 2019 年又有 800 多个署名的文章《停用统计显著性》[2] 在《自然》杂志上发表，这些都证实了如上的说法。对此，统计学界就身陷囹圄的 `$p$` 值做出了有组织的响应。美国统计协会在 2016 年发布《关于`$p$`值的声明》， 在 2017 年开展以“ `$p<0.05$` 以外的世界”为主题的座谈会，在 2019 年《美国统计学家》杂志上发表特刊，让统计学界对 `$p$` 值问题做出的响应走进公众的视野。在特刊中，43 篇文章都围绕着一个问题在讨论：我们究竟做了什么导致 `$p$` 值的作用在减弱。

实验的可重复性受到越来越多的关注，国际数理统计协会（IMS）可以对更广泛的学术讨论做什么呢？在前辈的启发下，我有一个有些不同寻常的观点，你得仔细思考才能得其精髓，请继续阅读下文。

如果 43 对你来说已经是一个相当大的样本量（因为别人反复告诉你，在正常情况下，`$n = 30$` 是 `$n = \infty$` 的一个好近似），那么 Ronald L. Wasserstein， Allen L. Schirm 和 Nicole A. Lazar 在《美国统计学家》上共同撰写的社论则温和而谦逊地为你指点迷津。总的来说，他们提出的建议是：“接受不确定性（**A**ccept uncertainty），深思熟虑（**T**houghtful），开放（**O**pen）和谦逊（**M**odest）”。事实上，很多统计学家支持放弃**统计显著性**这个术语，就已经反映了深思熟虑和谦逊。直至现在，我还没有发现别的学科有这么多的学者赞同放弃一个公认的概念。

对一个外行来说，说某件事是“统计学上显著的”就相当于说它是“数学证明的”或者“科学有效的”。事实上，正是这种口语化的关联促使人们呼吁放弃“统计显著性”，因为它背后的方法远没有数学上证明那么严格，并且，对于建立科学有效性来说也过于简单。同时我们也不应该忽视在认识论上，这种诱使人们产生信心的术语可以有效地促进、维持公众对某一门学科（比如数学）或一组学科（比如科学）社会相关性的认识和欣赏。正如亚里士多德所说，当事情涉及人们的观点和行动时，绝对正确性的预期是有限的。

那么问题来了，还有什么其他统计学概念可以在没有太多缺点的情况下，依旧可信地维持着“统计显著性”的概念优势呢？直接把“显著性”这个词去掉怎么样？正如我们质疑一个发现是否科学、一项研究是否合乎伦理、一个项目是否经济、一次行动是否合法、一项政策是否道德一样，我们可以，并且应该对任何研究提出这样的问题：“这统计吗？”。尽管科学性、道德性、经济性、合法性的概念存在着无休止的争论，但它们在普通和专业用语中都是衡量事物的重要标准。

专家和外行都会问：“这X吗？”，其中X表示某物是否具有该属性。对于这个问题，我们的重点不该是给出无可争议的定义，而是提出“怎样才算X”的问题。事实上，对于一个社会或者一段历史时期，没有提出这样的常规问题本身就是一个令人不安的迹象。

鉴于社会对数据科学的关注显著增加，我提议使用“统计（Statistical）”作为衡量标准。无论在短期还是长期，“不统计（Unstatistical）”的研究就像不道德的、不经济的研究一样都会对社会造成严重影响。“统计性”不会比上面提到的任何其他概念更令人困惑，它的简洁性也会增强自身在公共演讲、研究通讯以及私人对话中的有效性。IMS 作为世界基础思考和统计与概率构建学术团体的领头羊，可以在制定术语的核心修辞形式上发挥至关重要的作用。事实上据我所知，“这统计吗”是由 2000-2001 年 IMS 主席 Bernard Silverman 在一次私人谈话中首次提出的，他把这个问题与“这合法吗？”或者“这道德吗？”的问题相提并论。

本着“抛砖引玉”的精神，下面我会列出关于“统计”的做法，这对缓解不可重复的调查研究发现的泛滥问题应该会有所帮助。我故意将“统计”的门槛设置的很高，以便激发人们的兴趣。因此，正如研究的目的与设计所有要求的那样，如果有一项研究足够努力的表现出以下特点，那么我将赞扬其为“显著地统计”：

- [x] 讨论数据的收集、预处理、质量、限制以及这些因素的影响；
- [x] 阐明、评估并讨论数据分析和建模的假设及其结果；
- [x] 进行调查，并且表现出对选择偏差、混淆因素、何时/是否可以得到因果关系的结论的深刻理解；
- [x] 对多元关系及分布表现出一致的概论意义上的思考和处理；
- [x] 合理运用统计学方法并且承认它们的不足之处；
- [x] 对不确定性进行适当的传播分析、量化及表示；
- [x] 表现出对统计学原理的深入理解，比如统计推断与偏差--方差权衡。

还有很多好做法也是“统计的”，此外，还有一些好的分析方法对数据科学很重要，但它们并不是纯粹或主要不是出于统计学上的考虑，例如，理解统计性与计算效率之间的权衡问题、确保计算的稳定性与可拓展性、仔细考虑政策含义与描述重要的科学背景等等。


## 集思广益

我在这里列出的表单旨在邀请 IMS 成员去思考什么才是“统计”或者“显著地统计”的核心。我非常期待您的见解，请在本文评论区添加评论或者将你的想法发送到[meng@stat.harvard.edu](mailto:meng@stat.harvard.edu)，因为我准备在 2019年 JSM 大会上发表 IMS 主席演讲。

当然，如果不断地反思自己“我的研究具有统计性吗？”，并将我们宣扬的想法付诸实践，那会是再好不过的事情了。

## 参考文献

[1]: Benjamin, Daniel J. and Berger, James O. and Johannesson, Magnus and Nosek, Brian A. and Wagenmakers, E.-J. and Berk, Richard and Bollen, Kenneth A. and Brembs, Björn and Brown, Lawrence and Camerer, Colin and Cesarini, David and Chambers, Christopher D. and Clyde, Merlise and Cook, Thomas D. and De Boeck, Paul and Dienes, Zoltan and Dreber, Anna and Easwaran, Kenny and Efferson, Charles and Fehr, Ernst and Fidler, Fiona and Field, Andy P. and Forster, Malcolm and George, Edward I. and Gonzalez, Richard and Goodman, Steven and Green, Edwin and Green, Donald P. and Greenwald, Anthony G. and Hadfield, Jarrod D. and Hedges, Larry V. and Held, Leonhard and Hua Ho, Teck and Hoijtink, Herbert and Hruschka, Daniel J. and Imai, Kosuke and Imbens, Guido and Ioannidis, John P. A. and Jeon, Minjeong and Jones, James Holland and Kirchler, Michael and Laibson, David and List, John and Little, Roderick and Lupia, Arthur and Machery, Edouard and Maxwell, Scott E. and McCarthy, Michael and Moore, Don A. and Morgan, Stephen L. and Munafó, Marcus and Nakagawa, Shinichi and Nyhan, Brendan and Parker, Timothy H. and Pericchi, Luis and Perugini, Marco and Rouder, Jeff and Rousseau, Judith and Savalei, Victoria and Schönbrodt, Felix D. and Sellke, Thomas and Sinclair, Betsy and Tingley, Dustin and Van Zandt, Trisha and Vazire, Simine and Watts, Duncan J. and Winship, Christopher and Wolpert, Robert L. and Xie, Yu and Young, Cristobal and Zinman, Jonathan and Johnson, Valen E. 2018. Redefine statistical significance. Nature Human Behaviour. 2(1): 6--10. <https://doi.org/10.1038/s41562-017-0189-z>

[2]: Valentin Amrhein, Sander Greenland, Blake McShane and more than 800 signatories. 2019. Nature. Scientists rise up against statistical significance. 567:305--307. <https://doi.org/10.1038/d41586-019-00857-9>

[3]: Ronald L. Wasserstein and Allen L. Schirm and Nicole A. Lazar. 2019. Moving to a World Beyond `$p< 0.05$`. The American Statistician. 73(sup1):1--19. <https://doi.org/10.1080/00031305.2019.1583913>
