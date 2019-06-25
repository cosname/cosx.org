---
title: Julia 中的分布式计算
date: '2017-08-18'
author: 张驰原
categories:
  - 统计计算
  - 统计软件
tags:
  - Julia
  - 分布式计算
slug: distributed-learning-in-julia
meta_extra: 审稿：谢益辉，邱怡轩，潘岚锋；编辑：王健桥
forum_id: 419330
---

![julia_prog_language](https://user-images.githubusercontent.com/19310150/28401762-c5576c4a-6d4e-11e7-9427-4186e8653f00.png)

# 引子

[Julia](https://julialang.org/) 是一门相对比较新的着眼于科学计算的语言，语法上看起来有点类似于 Matlab 的脚本语言，但是实际上从 Ruby、Python、Lisp 之类的语言里吸收了许多有趣的特性。在这篇文章中，我想介绍一下 Julia 的分布式计算机制，它方便的并行和分布式计算的能力，结合优质的数值计算能力，其实让它非常方便用于做分布式数据处理——比如 distributed optimization、learning 之类的任务。虽然 Julia 这些年一直在稳步发展并且每个版本都会不兼容旧版本中的一些东西，让人需要不断地维护和修改代码有点心累，同时社区里的第三方库也还不够强大，不过最近在做一点点 distributed optimization 相关的东西中体会到它在这方面的好处，在这里简单分享一下。一方面因为 Julia 的文档虽然比较全，但是似乎还是比较难找到一个完整的例子。本文相关的完整代码会放在[这里](https://github.com/pluskid/DistLearn.jl)。

<!--more-->

# 入门

在 Julia 里分布式编程主要是通过 Remote Procedure Call (RPC) 的方式来完成。但是 RPC 并不需要用户显式地启动一个服务器来监听调用，然后做 message passing 之类的传输结果，而是有更加上层的 API 可以直接实现“在某个节点上执行某段代码”这类的语义。这里提到的 API 如果在将来改变或者改名之类的，主要可以参考 Julia 文档的 [Parallel Computing](https://docs.julialang.org/en/stable/manual/parallel-computing/) 一章查看最新的接口。

要进行分布式编程，首先要做的是启动计算节点。在 Julia 里非常简单地可以通过 `julia -p 2` 来启动两个 worker 进程，利用 `nprocs()` 函数可以看到当前有 3 个进程，`myid()` 会返回每个进程的 id （和系统里的 pid 并不一样，而是从 1 开始的数字），其中主进程的 id 总是 1，然后其余的是 worker。在这个例子中，`nworkers()` 会返回 2，表示一个主进程两个 worker 进程。默认情况下（不加 `-p` 参数启动 Julia 的时候）只有一个进程，`nprocs()` 和 `nworkers()` 都返回 1，这时主进程自己同时也是 worker。除了在启动的时候用 `-p` 参数之外，还可以在启动之后通过调用 `addprocs(...)` 函数来添加 worker 进程。

当然 `-p` 只是启动单机多进程，要实现真正的分布式，可以通过给定一个 hostname 列表的方式，Julia 会尝试通过 SSH 启动远程节点进程，或者如果你的集群已经有一个集群或者调度管理器的话，可以通过实现 Julia 里的 `ClusterManager` 接口来进行对接，在专用集群里启动任务。方便的是单机多进程和真正的分布式对于在 Julia 的上层 API 来说大部分情况下并没有区别。除非实现具体的计算中需要专门考虑多机通讯比本地更慢这些方面的问题，否则可以直接在本机写代码和小范围调试，再部署到集群上去。

启动 worker 进程之后，就可以进行 RPC 来调度任务了。Julia 里 RPC 的接口非常简单，最基本的一个函数是 `remotecall(func, wid, args...)`，其中 `func` 是要调用的函数，`wid` 是对应的 worker 的 ID，而 `args...` 则是需要传给函数的参数，参数会被自动传输到对应的 worker 那里。`remotecall` 函数是立即返回的，它返回的结果是一个 `Future`，这相当于对于 RPC 执行结果的一个 handle，对于这个 handle 调用 `fetch` 会拿到对应的结果，如果对应的 RPC 计算还没有完成，则 block 等待完成，同时 `fetch` 还会自动把结果传输到当前调用 `fetch` 的这个节点上来，当然如果结果已经在同一个节点上了，`fetch` 则不需要额外的数据传输开销。下面是一个例子：

```julia
data_ref = remotecall(rand, 2, (20, 30))
ret = remotecall_fetch(x -> norm(fetch(x)), 2, data_ref)
```

在 worker 2 上调用了 `rand` 生成一个随机矩阵，注意这里参数传输的代价只是 `(20, 30)` 这个 tuple，并且 `data_ref` 只是作为一个 handle 返回到当前进程，这个 handle 直接被传回 worker 2 上计算其 `norm`，而在 worker 2 上调用 `fetch` 的时候会发现生成出来的矩阵已经在该节点上了，所以最终结果并没有太大的数据传输代价。这里的 `remotecall_fetch` 有点类似于嵌套调用 `fetch(remotecall(...))`，但是由于它自己本身是一个基础函数（primitive），所以更加高效，也不会出现隐藏的竞态条件（race condition）问题。除了这些基础函数之外，还有一些更上层的 API 和宏，比如 `@spawn` 和 `@spawnat` 可以很方便地在 worker 上执行任意代码，例如：

```julia
julia> ref = @spawnat 2 begin
         x = rand(2, 2)
         norm(x)
       end
Future(2, 1, 12, Nullable{Any}())

julia> fetch(ref)
1.2147872352524431
```
# 进阶

Julia 还提供一些更加高级的函数，诸如 `pmap` 之类的可以很自动地把计算分配到当前可用的 worker 上执行，并收集结果之类的。但是如果我们需要实现非常具体和细致的算法调度——哪个 worker 执行那一段代码等等，则需要直接使用比较底层一点的 API。

假设我们现在要实现一个 ASGD，也就是 Asynchronized Stochastic Gradient Descent，算法的基本思想是每一个 worker 有自己的一份数据，算法执行的时候每个 worker 并行地从参数服务器（parameter server）里拿到当前最新的参数，然后在本地数据的一个 mini-batch 上计算梯度，再把梯度传回参数服务器，后者再根据传回的梯度更新参数。之所以是不同步的是因为每个 worker 是并行并且独立地工作的，因此会有许多可能的不一致的情况，比如当一个 worker 拿到参数，计算了梯度并传回去的时候，最新的参数已经由其他 worker 传回的结果更新过了，因此参数和梯度的对应关系出现了不一致。在一些给定的条件下，一定程度的不一致是可以允许的，并且能够证明最终收敛性，因为 SGD 本身就是带有噪音的，并且优化算法只要保证前进的方向和梯度有足够的相关性，而不一定要求完全重合。不过这些并不是本文要讨论的主要问题。

总而言之，要保证分布式和单进程计算的 SGD 结果一样，我们需要在每个 mini-batch 的计算中等待所有 worker 算完，把结果梯度求一个平均值，再更新参数，然后进行下一个 mini-batch 的计算。但是这样会导致很大的等待延迟，特别是如果其中有一个 worker 计算速度或者网速很慢的话，就会直接拖慢其他所有节点。ASGD 则选择直接无视同步从而获得更好的可扩展性，并且在实际中通常收敛得也很好（有时候可能需要使用更小的步长）。假设我么想要实现 ASGD，大致可以写成这个样子：

```julia
function asgd_step(w :: Vector{Float64})
  grad = compute_grad(w)
  return grad
end

for wid in worker_ids
  grad_ref = remotecall(asgd_step, wid, w)
  # should we do this here?
  w -= step_size * fetch(grad_ref)
end
```

看起来没有什么问题，但是实际上并不能实现我们想要的效果：问题在于第 9 行的 `fetch` 会卡住等待结果算完并传回当前进程（也就是主进程），所以这个 `for` 循环会在第一个迭代就停住，直到第一个 worker 算完之后才会继续第二个迭代，并且再次等待停住，最终结果就是每个 worker 依次执行，并没有任何并行可言。

为了解决这个问题，我们不能够调用 `fetch` 来阻塞住主进程的执行，但是我们逻辑上我们又必须要等到每个 worker 算完之后拿到结果，然后再用那个结果来更新参数。如何将异步程序逻辑串起来这几乎是所有异步编程中都会碰到的问题。有两种比较常见的解决方案，一种是使用回调函数，在 Javascript 里这是非常常见的做法，并且有很方便的 `then` 函数可以把一个一个的回调函数串起来，例如下面这个没有什么意义的例子：

```javascript
var p = new Promise(function(resolve, reject) {
    // a promise that will be fulfilled after
    // sleeping for 1 second
    setTimeout( () => { resolve(1); }, 1000);
});

// chain callbacks that will be executed
// upon the fulfillment of the promise above
p.then(function(value) {
    // heavy computation of gradient
    grad = value + 1;
    return grad;
}).then(function(grad) {
    // update parameter
    console.log('grad = ', grad);
});
```

这里的做法就是把整个程序的逻辑分成一个一个的区块，分别包装在一些函数里，然后通过把一堆回调函数按顺序串起来的方式来实现异步操作。另一种解决办法是用不同的调度线程，这样我们在调用 `fetch`进行阻止等待的时候只是卡住了那个 worker 对应的调度线程，而主线程则可以继续运行，大致可以用下面的伪代码来表示：

```julia
# pseudo code for thread-based scheduling
threads = []
for wid in worker_ids
  thread = new_thread() do 
    # now we are blocking the worker-scheduler
    # thread, instead of the main thread
    grad = remotecall_fetch(asgd_step, wid, w)
    w -= step_size * grad
  end
  push!(threads, thread)
end

# now all the jobs are scheduled, block
# the main thread to wait until all scheduler
# threads finish
wait_all(threads)
```

由于每个 worker 有自己的调度器线程，所以我们可以直接调用 `remotecall_fetch` 来卡掉它的线程，但是由于主线程还在继续执行，所以这里并不会导致其他 worker 也被阻塞住。使用一个独立的线程对应一个远端的 worker ——其本身可能是一个独立的进程或者甚至是网络上另一台机器——的好处是在每个线程里可以自由地阻塞等待，代码风格基本上就变成了简单的同步执行逻辑，而不需要切成一块一块地用回调函数串联起来。

当然，多线程也有它自己的问题，就是线程之间现在有了同步和竞争等各种问题，比如上面的伪代码中第 7 行更新 `w` 的那一步，通常就需要通过加锁来保证不会有多个线程同时写入 `w` 导致严重的数据不一致情况等等。并且 Julia 自己的多线程支持其实还在比较早期的开发阶段。

幸运的是在 Julia 里有更简单有效的解决方案，比较类似于多线程，但是这里的执行单元是一个一个的 [coroutine](https://www.wikiwand.com/en/Coroutine)，或者在早期有时会被称为“纤程 (Fiber)”——以区别于“线程 (Thread)”。coroutine 非常像线程，但是不同的是 coroutine 的 context switch 比较轻量级，并且最重要的是所有 coroutine 全部都在当前的一个线程中执行，每一个时刻只会有一个 coroutine 在运行，因此不会像使用线程那样出现竞争或者需要加锁的情况。由于本质上只有一个执行单元在执行，因此 coroutine 并不像线程那样能起到加速的作用，其主要功能在于提供方便的调度功能，特别是在需要等待外部资源，比如 IO，或者远程的计算节点的时候能够方便地切换调度。

在 Julia 里有很多方式可以创建 coroutine，我们这里使用 `@async` 宏来方便地在一个 coroutine 里直接一个代码段。和之前的远程 RPC 一样的，该代码段立即返回，其内部的代码实际在什么时候被执行是未知的，当我们通过 `@async` 把所有的工作 coroutine 都调度好了之后，可以通过一个 `@sync` 调用来停住当前进程，直到所有 coroutine 都执行完毕为止。下面是一个简单的例子：

```julia
@sync begin
  for i = 1:3
    @async begin
      sleep(rand(1:5))
      println(i)
    end
  end
end
```

在 Julia 中执行这段代码，会按照随机顺序打印出 1, 2, 3 这三个数字。这里我们创建了 3 个 coroutine，每个 coroutine 在执行的时候碰到 `sleep` 函数就会放弃自己的执行权，导致另一个 coroutine 被调度。在 coroutine 内部可以有很多这样的阻塞点，比如是 IO 读写的等待，或者是调用 `fetch` 来等待 `Future` 的结果甚至是显式地调用 `yield` 来交还执行权等等，效果上这有点类似于自动地在这些阻塞点把代码逻辑切割成了一个一个的小回调函数来执行。

弄清了这个基本概念之后，我们可以写一个如下的基本的工具函数，来将一个任务分配到所有 worker 上执行，并等待所有 worker 执行完毕，拿到最终结果（其实和系统自带的 `pmap` 很像），只额外再加了一点点异常处理的代码。这段代码可以在我们提供的[样例项目](https://github.com/pluskid/DistLearn.jl) 中的 `src/worker.jl` 找到。

```julia
"""
    invoke_on_workers(f, workers, args...)

Invoke `f` on each workers in parallel, with `f(worker_ref, args...)`.
This function blocks until all workers finishes, and return a list
of results from each worker.
"""
function invoke_on_workers(f :: Function, workers, args...)
  rets = Array{Any}(length(workers))
  @sync begin
    for (i, (pid, worker_ref)) in enumerate(workers)
      @async begin
        rets[i] = remotecall_fetch(f, pid, worker_ref, args...)
      end
    end
  end

  # propagate remote exceptions
  for obj in rets
    if obj isa RemoteException
      throw(obj)
    end
  end
  return rets
end
```

有了这段代码作为基石，我们就可以把分布式算法的基本框架写出来（这里我们用了 Julia 的 “do block” 来方便地构建匿名函数传入 `invoke_on_workers` 的第一个参数）：

```julia
# create workers
workers = spawn_workers(...)

# load data
invoke_on_workers(workers) do w_ref
  # the code here are executed on remote 
  # worker node
  worker = fetch(w_ref)
  worker.dataset = load_data(worker.data_partition)
  return true
end

# accumulate data statistics
stats_all = invoke_on_workers(workers) do w_ref
  worker = fetch(w_ref)
  stats = Dict(:n_tr => num_samples(worker.dataset),
               ...)
  return stats
end
n_tr_total = sum(stats[:n_tr] for stats in stats_all)

# prepare for running
hp = HyperParameter(step_size=args["step-size"], ...)
invoke_on_workers(workers, hp) do w_ref, hp
  worker = fetch(w_ref)
  worker.hp = hp
  worker.tr_idx = random_tr_smp_order()
  ...
  return true
end

# start training
for epoch = 1:args["n-epoch"]
  # schedule algorithm on workers
  ...
end
```

这里的 `worker` 对象是我们自己定义的一个结构体，它并不是一个进程或者工作节点，而是我们定义的用于方便存储所有工作节点本地需要维护的状态和临时变量的一个容器。在实际的代码中它长这个样子：

```julia
"""
A `Worker` object holds the necessary local states for a learner worker:

 - dset_tr: the local partition of the training dataset
 - dset_tt: the local partition of the test dataset
 - hp: hyper parameters specific to each algorithm (e.g. batch size)
 - lp: local parameters specific to each algorithm (e.g. algorithms in the
   dual might store dual variables locally)
"""
mutable struct Worker{HPType, LPType}
  dset_tr   :: Dataset # training set
  dset_tt   :: Dataset # test / validation set

  hp        :: HPType  # hyper parameters
  lp        :: LPType  # worker local parameters

  Worker{HPType, LPType}() where {HPType, LPType} = new()
end
```

可以看到为了要让实际的算法跑起来，除了调度计算之外，还有许多准备工作需要做，比如让每个 worker 把自己的数据加载进来，计算一些统计量，方便做一些全局的标准化等等，并且中央调度器还需要把一些超参数，比如 batch size 之类的告诉每个 worker。准备工作做完之后就可以开始计算了。

理论上我们也可以用 `invoke_on_workers` 这个辅助函数来调度 ASGD 的计算逻辑。但是 ASGD 这个算法在每个 worker 上其实有一个内层循环（关于 mini-batch 的迭代），其中内层循环的每一次迭代都要同中央进程交换信息——获取最新的 w，并返回计算的梯度。如果你尝试去写这个算法，你会发现似乎 worker 并不能很方便地**主动**和中央进程通信。到目前为止的通信模式都是中央进程通过 RPC 调用的方式将信息以函数参数发送到 worker 上，然后 worker 通过函数返回值把应答返回给中央进程。但是 worker 并不能在计算的过程中**主动**请求中央进程传回目前最新的 w。

有这样的限制的原因是分布式编程逻辑处理起来比较复杂，如果 worker 和调度器都是独立自主的节点，同时有自己的主线逻辑，以及在监听外部节点发过来的请求的话，整个逻辑线就会变得复杂起来。通常我们会把主要逻辑放在某一方，而让另一方以纯监听事件触发任务的被动方式执行。我们这里选择的是将主线逻辑放在调度器这一方，另一种比较常见的做法是将主线逻辑放在 worker 上，而中央进程此时退化成一个参数服务器，它只实现简单的 pull 和 push 事件（或者说 RPC 接口），当 worker 请求 pull 最新参数的时候它发送 w，当 worker 调用 push 回传梯度的时候它通过传回的梯度来更新 w，其他时间则处于等待状态。然后每个 worker 自己处理自己的逻辑，类似于这样子：

```julia
# on worker
data = load_data(my_data_partition)

for epoch in n_epochs
  for batch in n_batches
    w = pull(param_server)
    grad = compute_grad(w)
    push(param_server, grad)
  end
end
```

看起来似乎很简单。这种参数服务器的模式在每个 worker 能够比较独立自主地工作的时候就会比较方便，反过来如果中央服务器需要做一些调度，就会比较麻烦。比如我们希望每个 worker 把数据加载完之后算一下均值和方差，然后把所有 worker 上的统计量合并一下，最后再统一标准化一下数据。这个时候每个 worker 就没法很独立地执行，因为必须等所有其他的 worker 都把数据加载完毕，计算完统计量之后才能进入下一步，而这个同步点需要以某种方式与参数服务器进行通信来实现，就变得稍微有点麻烦。

总之对于调度逻辑比较多的情况下，似乎把主线逻辑放在中央节点会让程序写起来更自然一点。回到刚才的 ASGD 的问题，虽然 worker 节点只能被动地与中央节点通信，但是这并不是非常大的一个问题。一个比较简单的解决办法就是把 ASGD 的内层循环写开来，大概像这个样子：

```julia
for epoch = 1:n_epoch
  for batch = 1:n_batch
    grad_all = invoke_on_workers(worker, w) do w_ref, w
      worker = fetch(w_ref)
      grad = compute_gradient(w)
      return grad
    end
    
    # now on central node
    w += -step_size * mean(grad_all)
  end
end
```

当然这个其实并不是 ASGD，而是同步SGD，因为我们等待所有 worker 把梯度算出来之后求了平均，然后统一加到 w 上。这是由于我们之前写的 `invoke_on_workers` 这个辅助函数的逻辑导致的，正确的做法可以通过写开来：

```julia
function asgd_step(w_ref :: Future, w :: Vector{Float64})
  worker = fetch(w_ref)
  ...
  return compute_gradient(w)
end

for epoch = 1:n_epoch
  for batch = 1:n_batch
    @sync begin
      for (wid, w_ref) in workers
        @async begin
          grad = remotecall_fetch(asgd_step, wid, w_ref, w)
          w += -step_size * grad
        end
      end
    end
  end
end
```

这个看上去似乎是正确的，因为现在我们让每个 worker 的 coroutine 单独去更新 `w` 了。不过实际上还是没有达到我们想要的效果，因为我们的 `@sync` 阻塞点被放在了 mini-batch 循环的内部，所以每个 mini-batch 结束 worker 都会停下来等其他所有 worker执行完，还是没有达到异步的效果。幸运的是 Julia 的 coroutine 和 RPC 的接口非常灵活，要实现这里想要的逻辑，我们只要把 mini-batch 和 `@sync`阻塞点交换一下顺序即可。下面是我们示例代码里 ASGD.jl 中的实际代码：

```julia
function run_epoch(workers, params :: Parameters)
  @sync begin
    for (pid, worker_ref) in workers
      @async begin
        while true
          Δw = remotecall_fetch(compute_delta, pid, worker_ref, params.w)
          if Δw === nothing
            # this worker finishes its epoch
            break
          end
          params.w .+= Δw
        end
      end
    end
  end
end

"""
    compute_delta(worker_ref, w)

To be run on remote workers. Compute the updates for the weights. We have
applied step sizes locally on each worker.
"""
function compute_delta(worker_ref :: Future, w :: Vector{Float64})
  worker = try_fetch(worker_ref)
  idx1 = (worker.lp.i_batch-1) * worker.hp.batch_size + 1
  if idx1 > length(worker.lp.tr_idx)
    return nothing  # end of epoch
  end

  idx2 = min(worker.lp.i_batch * worker.hp.batch_size,
             length(worker.lp.tr_idx))

  data_idx = worker.lp.tr_idx[idx1:idx2]
  X = worker.dset_tr.data[:, data_idx]
  y = worker.dset_tr.labels[data_idx]

  pred = X' * w
  ∇w = (X * hinge_gradient(pred, y)) / size(X, 2)
  ∇w += worker.hp.λ * w  # gradient from the regularizer

  Δw = -worker.lp.ηₜ * ∇w
  worker.lp.i_batch += 1

  return Δw
end
```

这里的 `@sync` 和 `@async` 的组合可能一开始有一点费解，概念明白之后就会非常清晰。由于 coroutine 的缘故，第 11 行的参数更新不需要任何加锁之类的操作。每个 coroutine 通过一个 `while` 循环来连续地调度 worker 进行计算，最外层的 `@sync` 阻塞保证在一个 epoch 结束之后等待所有 worker 停下来。在 ASGD 中这个同步操作其实也可以去掉，不过如果是更加复杂的优化算法，比如如果有方差缩减相关的操作之类的，需要在这个时刻停下来做一些维护操作等等。

# 总结

总结一下：我们主要使用 Julia 的 RPC 功能来实现多机并行计算，同时利用 coroutine 的功能来实现算法的具体调度。中央调度节点同时作为调度器和参数服务器的角色存在。我把完整的示例代码放在 [DistLearn.jl](https://github.com/pluskid/DistLearn.jl) 里，除了这里提到的 ASGD 算法之外，还提供了一个 COCOA 的实现，这是一个对偶算法，在每个节点本地需要维护和训练样本数目同样多的对偶变量。当然这个代码库并不是试图提供一个完整的 Julia 的分布式学习的算法实现，而主要是作为一个如何在 Julia 里实现自己的分布式系统的示例。
