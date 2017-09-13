---
title: "神经网络算法的优势与应用"
date: 2017-09-13
author: "Jahnavi Mahanta"
Translator: "陈浩"
categories: ["分类1", "分类2"]
tags: ["ANN","应用","初学者"]
slug: Introduction to NEURAL NETWORKS, Advantages and Applications
---

# 神经网络算法的优势与应用

- 原文链接：http://www.kdnuggets.com/2017/07/introduction-neural-networks-advantages-applications.html/2

人工神经网络（ANN）以大脑处理机制作为基础，开发用于建立复杂模式和预测问题的算法。
 
首先了解大脑如何处理信息：  
在大脑中，有数亿个神经元细胞，以电信号的形式处理信息。外部信息或者刺激被神经元的树突接收，在神经元细胞体中处理，转化成输出并通过轴突,传递到下一个神经元。下一个神经元可以选择接受它或拒绝它，这取决于信号的强度。

![neuron-4steps.jpg](http://www.kdnuggets.com/wp-content/uploads/neuron-4steps.jpg)

- - -

![neuron-4steps-caption.jpg](http://www.kdnuggets.com/wp-content/uploads/neuron-4steps-caption.jpg)

- - -
现在，让我们尝试了解 ANN 如何工作：

![how-neural-net-works.jpg](http://www.kdnuggets.com/wp-content/uploads/how-neural-net-works.jpg)

这里，w1，w2，w3 给出输入信号的强度
 
从上面可以看出，ANN 是一个非常简单的表示大脑神经元如何工作的结构。
 
为了使事情变得更清晰，用一个简单的例子来理解 ANN：一家银行想评估是否批准贷款申请给客户，所以，它想预测一个客户是否有可能违约贷款。它有如下数据：

![customer-table-1.jpg](http://www.kdnuggets.com/wp-content/uploads/customer-table-1.jpg)

所以，必须预测列 X。更接近 1 的预测值表明客户更可能违约。
 
基于如下例子的神经元结构，尝试创建人造神经网络结构：
 
![neural-net-architecture.jpg](http://www.kdnuggets.com/wp-content/uploads/neural-net-architecture.jpg)

通常，上述示例中的简单 ANN 结构可以是：
 
![neural-net-customer.jpg](http://www.kdnuggets.com/wp-content/uploads/neural-net-customer.jpg) 

## 与结构有关的要点：
 
1. 网络架构有一个输入层，隐藏层（1 个以上）和输出层。由于多层结构，它也被称为 MLP（多层感知机）。
 
2. 隐藏层可以被看作是一个「提炼层」，它从输入中提炼一些重要的模式，并将其传递到下一层。通过从省略冗余信息的输入中识别重要的信息，使网络更快速和高效。
 
3. 激活函数有两个明显的目的：  
 - 它捕获输入之间的非线性关系  
 - 它有助于将输入转换为更有用的输出。  
    在上面的例子中，所用的激活函数是 sigmoid：  
    `$$O_1=1+e^(-F)$$`  
    其中`$F=W_1*X_1+W_2*X_2+W_3*X_3$`  
    Sigmoid 激活函数创建一个在 0 和 1 之间的输出。还有其他激活函数，如：Tanh、softmax 和 RELU。  
 
4. 类似地，隐藏层导致输出层的最终预测：  
 
   `$$O_3=1+e^(-F_1)$$`   
   其中`$F_1=W_7*H_1+W_8*H_2$`   
   这里，输出值（O3）在 0 和 1 之间。接近 1（例如0.75）的值表示有较高的客户违约迹象。  
 
5. 权重 W 与输入有重要关联。如果 W1 是 0.56，W2 是 0.92，那么在预测 H1 时，X2：Debt Ratio 比 X1：Age 更重要。  
 
6. 上述网络架构称为「前馈网络」，可以看到输入信号只在一个方向传递（从输入到输出）。可以创建在两个方向上传递信号的「反馈网络」。
 
7. 一个高精度的模型给出了非常接近实际值的预测。因此，在上表中，列 X 值应该非常接近于列 W 值。预测误差是列 W 和列 X 之差：  

![customer-table-2.jpg](http://www.kdnuggets.com/wp-content/uploads/customer-table-2.jpg)  
 
8. 获得一个准确预测的好模型的关键是找到预测误差最小的「权重 W 的最优值」。这被称为「反向传播算法」，这使 ANN 成为一种学习算法，因为通过从错误中学习，模型得到改进。
 
9. 反向传播的最常见方法称为「梯度下降」，其中使用了迭代 W 不同的值，并对预测误差进行了评估。因此，为了得到最优的 W 值，W 值在小范围变化，并且评估预测误差的影响。最后，W 的这些值被选为最优的，随着W的进一步变化，误差不会进一步降低。要更详细地理解解梯度下降，请参考：
http://www.kdnuggets.com/2017/04/simple-understand-gradient-descent-algorithm.html 
 
 
## 神经网络的主要优点： 
 
ANN 有一些关键优势，使它们最适合某些问题和情况：

1. ANN 有能力学习和构建非线性的复杂关系的模型，这非常重要，因为在现实生活中，许多输入和输出之间的关系是非线性的、复杂的。  
2. ANN 可以推广，在从初始化输入及其关系学习之后，它也可以推断出从未知数据之间的未知关系，从而使得模型能够推广并且预测未知数据。  
3. 与许多其他预测技术不同，ANN 不会对输入变量施加任何限制（例如：如何分布）。此外，许多研究表明，ANN 可以更好地模拟异方差性，即具有高波动性和不稳定方差的数据，因为它具有学习数据中隐藏关系的能力，而不在数据中强加任何固定关系。这在数据波动非常大的金融时间序列预测（例如：股票价格）中非常有用。  
 
## 应用：  

1. 图像处理和字符识别：ANN 具有接收许多输入的能力，可以处理它们来推断隐蔽、复杂的非线性关系，ANN在图像和字符识别中起着重要的作用。手写字符识别在欺诈检测（例如：银行欺诈）甚至国家安全评估中有很多应用。图像识别是一个不断发展的领域，广泛应用于社交媒体中的面部识别，医学上的癌症治疗的停滞以及农业和国防用途的卫星图像处理。目前，ANN 的研究为深层神经网络铺平了道路，是「深度学习」的基础，现已在计算机视觉、语音识别、自然语言处理等方向开创了一系列令人激动的创新，比如，无人驾驶汽车。  
2. 预测：在经济和货币政策、金融和股票市场、日常业务决策（如：销售，产品之间的财务分配，产能利用率），广义上都需要进行预测。更常见的是，预测问题是复杂的，例如，预测股价是一个复杂的问题，有许多潜在因素（一些已知的，一些未知的）。在考虑到这些复杂的非线性关系方面，传统的预测模型出现了局限性。鉴于其能够建模和提取未知的特征和关系，以正确的方式应用的 ANN，可以提供强大的替代方案。此外，与这些传统模型不同，ANN 不对输入和残差分布施加任何限制。更多的研究正在进行中，例如，使用 LSTM 和 RNN 预测的研究进展。
 
ANN 是具有广泛应用的强大的模型。以上列举了几个突出的例子，但它们在医药，安全，银行/金融以及政府，农业和国防等领域有着广泛的应用。

**Bio:** Jahnavi Mahanta is a machine learning and deep learning enthusiast, having led multiple machine learning teams in American Express over the last 13 years. She is the co-founder of Deeplearningtrack, an online instructor led data science training platform. To learn ANNs in more detail, register for the 8 week Data science course on www.deeplearningtrack.com – next batch starting soon.
