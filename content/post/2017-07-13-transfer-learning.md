---
title: 基于深度学习和迁移学习的识花实践
date: '2017-10-16'
author: 罗大钧
categories:
  - 机器学习
tags:
  - 深度学习
  - 迁移学习
  - VGG
  - CNN
slug: transfer-learning
meta_extra: "编辑：王佳；审稿：张源源、黄俊文、边蓓蕾"
forum_id: 419228
---

深度学习是人工智能领域近年来最火热的话题之一，但是对于个人来说，以往想要玩转深度学习除了要具备高超的编程技巧，还需要有海量的数据和强劲的硬件。不过TensorFlow和Keras等框架的出现大大降低了编程的复杂度，而迁移学习的思想也允许我们利用现有的模型加上少量数据和训练时间，取得不俗的效果。

这篇文章将示范如何利用迁移学习训练一个能从图片中分类不同种类的花的模型，它在五种花中能达到80%以上的准确度（比瞎蒙高了60%哦），而且只需要普通的家用电脑就可以完成训练过程。

![flower](https://user-images.githubusercontent.com/18478302/28164663-f7a00906-6802-11e7-8808-cbc23c810772.jpg)

# 什么是迁移学习

人类的思维可以将一个领域学习到的知识和经验，应用到其他相似的领域中去。所以当面临新的情景时，如果该情景与之前的经验越相似，那么人就能越快掌握该领域的知识。而传统的机器学习方法则会把不同的任务看成是完全独立的，比如一个识别猫的模型，如果训练集中的图片都是白天的，那么训练出来的模型对于识别夜晚的猫这个任务就可能表现得非常差。迁移学习便是受此启发，试图将模型从**源任务**上训练到的知识迁移到**目标任务**的应用上。

举例说，源任务可以是识别图片中车辆，而目标任务可以是识别卡车，识别轿车，识别公交车等。合理的使用迁移学习可以避免针对每个目标任务单独训练模型，从而极大的节约了计算资源。

![autopilot_car](https://user-images.githubusercontent.com/18478302/28164453-07775722-6802-11e7-8625-accff072b88b.png)

此外，迁移学习并不是一种特定的机器学习模型，它更像是一种优化技巧。通常来说，机器学习任务要求测试集和训练集有相同的概率分布，然而在一些情况下往往会缺乏足够大的有针对性的数据集来满足一个特定的训练任务。迁移学习提出我们可以在一个通用的大数据集上进行一定量的训练后，再用针对性的小数据集进一步强化训练。

接下来的例子中将示范如何将一个图像识别的深度卷积网络，VGG，迁移到识别花朵类型的新任务上，在原先的任务中，VGG只能识别花，但是迁移学习可以让模型不但能识别花，还能识别花的具体品种。

# VGG介绍

VGG是视觉领域竞赛ILSVRC在2014年的获胜模型，以7.3%的错误率在ImageNet数据集上大幅刷新了前一年11.7%的世界纪录。VGG16基本上继承了AlexNet**深**的思想，并且发扬光大，做到了**更深**。AlexNet只用到了8层网络，而VGG的两个版本分别是16层网络版和19层网络版。在接下来的迁移学习实践中，我们会采用稍微简单的一些的VGG16，他和VGG19有几乎完全一样的准确度，但是运算起来更快一些。

VGG的结构图如下：

![vgg_architecture](https://user-images.githubusercontent.com/18478302/28164680-0aa03a12-6803-11e7-968a-30eab96dd7fe.jpg)

VGG的输入数据格式是244 * 224 * 3的像素数据，经过一系列的卷积神经网络和池化网络处理之后，输出的是一个4096维的特征数据，然后再通过3层全连接的神经网络处理，最终由softmax规范化得到分类结果。

![softmax_demo](https://user-images.githubusercontent.com/18478302/28164677-0362c8fa-6803-11e7-83e2-16a62dc68884.jpg)

VGG16模型可以通过[这里下载](https://pan.baidu.com/s/1eSnKB1S)（密码78g9），模型是一个.npy文件，本质上是一个巨大的numpy对象，包含了VGG16模型中的所有参数，该文件大约有500M，所以可见如果是从头训练这样一个模型是非常耗时的，借助于迁移学习的思想，我们可以直接在这个模型的基础上进行训练。

接下来我们稍微解释一下卷积神经网络和池化网络:

# 卷积神经网络

卷积神经网络在图像数据中使用得尤其多，不同于一般的全连接的神经网络需要对上下两层网络中的任意两个节点之间训练权值，每层卷积网络仅仅训练若干个卷积核，下一层的网络的输入即是前一个层的输出的卷积，因此，多层卷积神经网络会把一个薄薄的图片数据，转化为更小但是也更厚的数组，如下图所示

![convolutional nn](https://user-images.githubusercontent.com/18478302/28164629-d62feb1a-6802-11e7-8915-93f46f508170.png)

卷积神经网络具有良好的统计不变性，而且每个层可以学习到不同层次的知识。比如第一层会学习到识别图片中的简单形状，例如直线和纯色块等。而之后的层将会上升到更高的抽象层次，比如例如形状，物体的组成部分，直到能够识别整个物体。

如果我们将卷积神经网络中激活神经元的图像可视化出来，那么会得到如下的结果，首先第一层能识别出一些对角线和颜色的分界。

![layer1](https://user-images.githubusercontent.com/18478302/28164544-7688dd66-6802-11e7-9136-c34bd8005af3.png)

然后第二层网络可以学习到了一些稍微复杂的概念，比如圈和条纹。

![layer2](https://user-images.githubusercontent.com/18478302/28164552-86728b28-6802-11e7-97af-a3c18b1a9353.png)

第三层学习到了一些简单的物体，比如轮胎和脸。

![layer3](https://user-images.githubusercontent.com/18478302/28164576-a2b80038-6802-11e7-8ad0-d9d41c8be26f.png)

到了更高的层数，卷积神经网络能够识别出越来越复杂的物体，这个过程也非常符合人类识别物体的过程，即从简单模式越来越复杂的模式。

![layer5](https://user-images.githubusercontent.com/18478302/28164612-c219e7b6-6802-11e7-8b43-4b7958db57c0.png)


# Max Pooling和Drop out

最大池化和Drop out都是卷积神经网络中常用的技巧，他们的原理都非常简单，最大池化是一个滤波器，该滤波器按照一定的步长把一个区域内的值选出一个最大值作为这个区域的代表值。如下图所示：

![pooling](https://user-images.githubusercontent.com/18478302/28164669-fdffd150-6802-11e7-98d1-24603f1a1383.png)

这样的做的一个好处是可以使神经网络专注于最重要的元素，减少输入元素的大小。

而Drop out则是按照一个概率随机丢弃输入特征中的值，这样做的目的是迫使神经网络在学习过程中保持一定程度的冗余度，这样训练出来的模型会更加稳定，而且不容易过拟合。


# 识花数据集

我们要使用的花数据集可以在这里[下载](https://pan.baidu.com/s/1jIMOc1S)。

该数据集有包含如下数据：

花的种类  | 图片数量（张）
------------- | -------------
daisy  | 633
dandelion  | 898
roses  | 641
sunflowers  | 699
tulips  | 799

# 迁移学习实践

有了预备知识之后，我们可以开始搭建属于自己的识花网络了。

首先我们会将所有的图片交给VGG16，利用VGG16的深度网络结构中的五轮卷积网络层和池化层，对每张图片得到一个4096维的特征向量，然后我们直接用这个特征向量替代原来的图片，再加若干层全连接的神经网络，对花朵数据集进行训练。

因此本质上，我们是将VGG16作为一个图片特征提取器，然后在此基础上再进行一次普通的神经网络学习，这样就将原先的244 * 224 * 3维度的数据转化为了4096维的，而每一维度的信息量大大提高，从而大大降低了计算资源的消耗，实现了把学习物体识别中得到的知识应用到特殊的花朵分类问题上。

## 文件结构

为了更加方便的使用VGG网络，我们可以直接使用tensorflow提供的VGG加载模块，该模块可以在[这里下载](https://github.com/machrisaa/tensorflow-vgg)。

首先保证代码或者jupyter notebook运行的工作目录下有flower_photos，tensorflow_vgg这两个文件夹，分别是花朵数据集和tensorflow_vgg，然后将之前下载的VGG16拷贝到tensorflow_vgg文件夹中。

	├── transfer_learning.py（运行代码）
	├── flower_phtots
	│   ├── daisy
	│   ├── dandelion
	│   ├── roses
	│   └── ...
	└── tensorflow_vgg
    	├── vgg16.py
    	├── vgg16.npy
    	└── ...

然后导入需要用的python模块

```python
import os
import numpy as np
import tensorflow as tf

from tensorflow_vgg import vgg16
from tensorflow_vgg import utils
```

## 加载识花数据集

接下来我们将flower_photos文件夹中的花朵图片都载入到进来，并且用图片所在的子文件夹作为标签值。

```
data_dir = 'flower_photos/'
contents = os.listdir(data_dir)
classes = [each for each in contents if os.path.isdir(data_dir + each)]
```

## 利用VGG16计算得到特征值

```python
# 首先设置计算batch的值，如果运算平台的内存越大，这个值可以设置得越高
batch_size = 10
# 用codes_list来存储特征值
codes_list = []
# 用labels来存储花的类别
labels = []
# batch数组用来临时存储图片数据
batch = []

codes = None

with tf.Session() as sess:
    # 构建VGG16模型对象
    vgg = vgg16.Vgg16()
    input_ = tf.placeholder(tf.float32, [None, 224, 224, 3])
    with tf.name_scope("content_vgg"):
        # 载入VGG16模型
        vgg.build(input_)
    
    # 对每个不同种类的花分别用VGG16计算特征值
    for each in classes:
        print("Starting {} images".format(each))
        class_path = data_dir + each
        files = os.listdir(class_path)
        for ii, file in enumerate(files, 1):
            # 载入图片并放入batch数组中
            img = utils.load_image(os.path.join(class_path, file))
            batch.append(img.reshape((1, 224, 224, 3)))
            labels.append(each)
            
            # 如果图片数量到了batch_size则开始具体的运算
            if ii % batch_size == 0 or ii == len(files):
                images = np.concatenate(batch)

                feed_dict = {input_: images}
                # 计算特征值
                codes_batch = sess.run(vgg.relu6, feed_dict=feed_dict)
                
                # 将结果放入到codes数组中
                if codes is None:
                    codes = codes_batch
                else:
                    codes = np.concatenate((codes, codes_batch))
                
                # 清空数组准备下一个batch的计算
                batch = []
                print('{} images processed'.format(ii))
```

这样我们就可以得到一个codes数组，和一个labels数组，分别存储了所有花朵的特征值和类别。

可以用如下的代码将这两个数组保存到硬盘上：

```python
with open('codes', 'w') as f:
    codes.tofile(f)
    
import csv
with open('labels', 'w') as f:
    writer = csv.writer(f, delimiter='\n')
    writer.writerow(labels)
```

## 准备训练集，验证集和测试集

一次严谨的模型训练一定是要包含验证和测试这两个部分的。首先我把labels数组中的分类标签用One Hot Encode的方式替换。

```python
from sklearn.preprocessing import LabelBinarizer

lb = LabelBinarizer()
lb.fit(labels)

labels_vecs = lb.transform(labels)
```

接下来就是抽取数据，因为不同类型的花的数据数量并不是完全一样的，而且labels数组中的数据也还没有被打乱，所以最合适的方法是使用StratifiedShuffleSplit方法来进行分层随机划分。假设我们使用训练集：验证集：测试集=8:1:1，那么代码如下：

```python
from sklearn.model_selection import StratifiedShuffleSplit

ss = StratifiedShuffleSplit(n_splits=1, test_size=0.2)

train_idx, val_idx = next(ss.split(codes, labels))

half_val_len = int(len(val_idx)/2)
val_idx, test_idx = val_idx[:half_val_len], val_idx[half_val_len:]

train_x, train_y = codes[train_idx], labels_vecs[train_idx]
val_x, val_y = codes[val_idx], labels_vecs[val_idx]
test_x, test_y = codes[test_idx], labels_vecs[test_idx]

print("Train shapes (x, y):", train_x.shape, train_y.shape)
print("Validation shapes (x, y):", val_x.shape, val_y.shape)
print("Test shapes (x, y):", test_x.shape, test_y.shape)
```

这时如果我们输出数据的维度，应该会得到如下结果：

```
Train shapes (x, y): (2936, 4096) (2936, 5)
Validation shapes (x, y): (367, 4096) (367, 5)
Test shapes (x, y): (367, 4096) (367, 5)
```

## 训练网络

分好了数据集之后，就可以开始对数据集进行训练了，假设我们使用一个256维的全连接层，一个5维的全连接层（因为我们要分类五种不同类的花朵），和一个softmax层。当然，这里的网络结构可以任意修改，你可以不断尝试其他的结构以找到合适的结构。

```python
# 输入数据的维度
inputs_ = tf.placeholder(tf.float32, shape=[None, codes.shape[1]])
# 标签数据的维度
labels_ = tf.placeholder(tf.int64, shape=[None, labels_vecs.shape[1]])

# 加入一个256维的全连接的层
fc = tf.contrib.layers.fully_connected(inputs_, 256)

# 加入一个5维的全连接层
logits = tf.contrib.layers.fully_connected(fc, labels_vecs.shape[1], activation_fn=None)

# 计算cross entropy值
cross_entropy = tf.nn.softmax_cross_entropy_with_logits(labels=labels_, logits=logits)

# 计算损失函数
cost = tf.reduce_mean(cross_entropy)

# 采用用得最广泛的AdamOptimizer优化器
optimizer = tf.train.AdamOptimizer().minimize(cost)

# 得到最后的预测分布
predicted = tf.nn.softmax(logits)

# 计算准确度
correct_pred = tf.equal(tf.argmax(predicted, 1), tf.argmax(labels_, 1))
accuracy = tf.reduce_mean(tf.cast(correct_pred, tf.float32))
```

为了方便把数据分成一个个batch以降低内存的使用，还可以再用一个函数专门用来生成batch。

```python
def get_batches(x, y, n_batches=10):
    """ 这是一个生成器函数，按照n_batches的大小将数据划分了小块 """
    batch_size = len(x)//n_batches
    
    for ii in range(0, n_batches*batch_size, batch_size):
        # 如果不是最后一个batch，那么这个batch中应该有batch_size个数据
        if ii != (n_batches-1)*batch_size:
            X, Y = x[ii: ii+batch_size], y[ii: ii+batch_size] 
        # 否则的话，那剩余的不够batch_size的数据都凑入到一个batch中
        else:
            X, Y = x[ii:], y[ii:]
        # 生成器语法，返回X和Y
        yield X, Y
```

现在可以运行训练了，

```python
# 运行多少轮次
epochs = 20
# 统计训练效果的频率
iteration = 0
# 保存模型的保存器
saver = tf.train.Saver()
with tf.Session() as sess:
    sess.run(tf.global_variables_initializer())
    for e in range(epochs):
        for x, y in get_batches(train_x, train_y):
            feed = {inputs_: x,
                    labels_: y}
            # 训练模型
            loss, _ = sess.run([cost, optimizer], feed_dict=feed)
            print("Epoch: {}/{}".format(e+1, epochs),
                  "Iteration: {}".format(iteration),
                  "Training loss: {:.5f}".format(loss))
            iteration += 1
            
            if iteration % 5 == 0:
                feed = {inputs_: val_x,
                        labels_: val_y}
                val_acc = sess.run(accuracy, feed_dict=feed)
                # 输出用验证机验证训练进度
                print("Epoch: {}/{}".format(e, epochs),
                      "Iteration: {}".format(iteration),
                      "Validation Acc: {:.4f}".format(val_acc))
    # 保存模型
    saver.save(sess, "checkpoints/flowers.ckpt")
```

## 测试网络

接下来就是用测试集来测试模型效果

```python
with tf.Session() as sess:
    saver.restore(sess, tf.train.latest_checkpoint('checkpoints'))
    
    feed = {inputs_: test_x,
            labels_: test_y}
    test_acc = sess.run(accuracy, feed_dict=feed)
    print("Test accuracy: {:.4f}".format(test_acc))
```

最终我在自己电脑上得到了88.83%的准确度，你可以继续调整batch的大小，或者模型的结构以得到一个更好的结果。

对这张有一个七星瓢虫的蒲公英图

![dadelion_test](https://user-images.githubusercontent.com/18478302/28164645-e5edb564-6802-11e7-8a23-358f8318afc1.png)

模型给出的预测值如下

![dadelion_test_result](https://user-images.githubusercontent.com/18478302/28164657-f0b4280c-6802-11e7-9400-2daf0938873f.png)

可以看出模型的效果还是相当稳定的，而且整个过程中我们的计算时间不过超过30分钟，这就是迁移学习的魅力。

## P.S

当然，其他的深度学习框架也可以很方便的实现迁移学习，比如这里的[Keras代码](https://github.com/udacity/aind2-cnn/blob/master/transfer-learning/transfer_learning.ipynb)用大约20行实现了一个VGG迁移识别狗的品种的分类器。

# 参考资料

* A Survey on Transfer Learning[http://ieeexplore.ieee.org/document/5288526/]
* Tensorflow的识花迁移学习[https://www.tensorflow.org/tutorials/image_retraining](https://www.tensorflow.org/tutorials/image_retraining)
* VGG网络[https://arxiv.org/pdf/1409.1556.pdf](https://arxiv.org/pdf/1409.1556.pdf)
* 卷积神经网络的可视化[http://www.matthewzeiler.com/pubs/arxive2013/eccv2014.pdf](http://www.matthewzeiler.com/pubs/arxive2013/eccv2014.pdf)
* Udaicty深度学习[https://cn.udacity.com/course/deep-learning-nanodegree-foundation--nd101](https://cn.udacity.com/course/deep-learning-nanodegree-foundation--nd101)
