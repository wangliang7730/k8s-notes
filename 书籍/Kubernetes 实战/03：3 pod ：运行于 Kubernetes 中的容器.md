---
date: 2021-12-08
updated: 2021-12-13
---

# 3 pod ：运行于 Kubernetes 中的容器

## 3.1 介绍 pod

### 3.1.1 为何需要 pod

- 容器被设计为每个容器只运行一个进程（除非进程本身产生子进程）。

### 3.1.2 了解 pod

- 由于不能将多个进程聚集在一个单独的容器中，我们需要另一种更高级的结构来将容器绑定在一起，并将它们作为一个单元进行管理，这就是 pod 背后的根本原理。
- 同一 pod 中容器之间的部分隔离：Kubemetes 通过配置 Docker 来让一个 pod 内的所有容器共享相同的 Linux 命名空间， 而不是每个容器都有自己的一组命名空间。
- 在最新的 Kubernetes 和 Docker 版本中， pod 中的容器也能够共享相同的 PID 命名空间， 但是该特征默认是未激活的。
- 默认情况下， 每个容器的文件系统与其他容器完全隔离。

### 3.1.3 通过 pod 合理管理容器

- 基于扩缩容考虑而分割到多个 pod 中。
- 我们总是应该倾向于在单独的 pod 中运行容器，除非有特定的原因要求它们是同一 pod 的一部分。

## 3.2 以 YAML 或 JSON 描述文件创建 pod

### 3.2.1 检查现有 pod 的 YAML 描述文件

```shell
kubectl get po kubia-xxx -o yaml
```

### 3.2.2 为 pod 创建一个简单的 YAML 描述文件

`kubia-manual.yaml`：

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kubia-manual
spec:
  containers:
  - image: luksa/kubia
    name: kubia
    ports:
    - containerPort: 8080
      protocol: TCP
```

**获取帮助：**

```shell
# 获取所有对象
kubectl api-resources
# 获取对象配置
kubectl explain pods.xxx.xxx
```

### 3.2.3 使用 kubectl create 来创建 pod

```shell
kubectl create -f kubia-manual.yaml
```

### 3.2.4 查看应用程序日志

```shell
kubectl logs kubia-manual

# 多个镜像
kubectl logs kubia-manual -c kubia
```

### 3.2.5 向 pod 发送请求

**将本地网络端口转发到 pod 中的端口：**

```shell
kubectl port-forward kubia-manual 8888:8080
curl localhost:8888
```

> 🙋‍♂️**报错：**
>
> unable to do port forwarding: socat not found：
>
> ```shell
> yum -y install socat
> ```

## 3.3 使用标签组织 pod

### 3.3.1 介绍标签

略。

### 3.3.2 创建 pod 时指定标签

`kubia-manual-with-labels.yaml`：

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kubia-manual-v2
  labels:
    creation_method: manual
    env: prod
spec:
  containers:
  - image: luksa/kubia
    name: kubia
    ports:
    - containerPort: 8080
      protocol: TCP
```

**标签命令：**

```shell
# 查看所有标签
kubectl get po --show-labels

# 查看指定标签
kubectl get po -L creation_method,env
```

### 3.3.3 修改现有 pod 的标签

```shell
# 新增标签
kubectl label po kubia-manual creation_method=manual

# 修改现有标签
kubectl label po kubia-manual-v2 env=debug --overwrite

# 删除标签
kubectl label po kubia-manual-v2 creation_method-
```

## 3.4 通过标签选择器列出 pod 子集

### 3.4.1 使用标签选择器列出 pod

```shell
kubectl get po -l creation_method=manual
kubectl get po -l env
kubectl get po -l '!env'
```

标签选择还有以下形式：

- `creation_method!=manual`。
- `env in (prod,devel)`。
- `env not in (prod,devel)`。

### 3.4.2 在标签选择器中使用多个条件

- 可以使用逗号隔开使用多个条件，需要全部匹配。

## 3.5 使用标签和选择器来约束 pod 调度

### 3.5.1 使用标签分类工作节点

```shell
kubectl label node gke-kubia-85f6-node-0rrx gpu=true
kubectl get node -l gpu=true
```

### 3.5.2 将 pod 调度到特定节点

`kubia-gpu.yaml`：

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kubia-gpu
spec:
  nodeSelector:
    gpu: "true"
  containers:
  - image: luksa/kubia
    name: kubia
```

### 3.5.3 调度到一个特定节点

略。

## 3.6 注解 pod

### 3.6.1 查找对象的注解

```shell
kubectl get po kubia-zxzij -o yaml
```

### 3.6.2 添加和修改注解

```shell
kubectl annotate pod kubia-manual mycompany.com/someannotation="foo bar"
kubectl describe pod kubia-manual
```

## 3.7 使用命名空间对资源进行分组

### 3.7.1 了解对命名空间的需求

略。

### 3.7.2 发现其他命名空间及其 pod

```shell
kubectl get ns
# 可以使用 -n 代替 --namespace
kubectl get po --namespace kube-system
```

### 3.7.3 创建一个命名空间

`custom-namespace.yaml`：

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: custom-namespace
```

命令行创建：

```shell
kubectl create namespace custom-namespace
```

### 3.7.4 管理其他命名空间中的对象

```shell
kubectl create -f kubia-manual.yaml -n custom-namespace
```

### 3.7.5 命名空间提供的隔离

略。

## 3.8 停止和移除 pod

### 3.8.1 按名称删除 pod

```shell
kubectl delete po kubia-gpu
```

### 3.8.2 使用标签选择器删除 pod

```shell
kubectl delete po -l creation_method=manual
```

### 3.8.3 通过删除整个命名空间来删除 pod

```shell
kubectl delete ns custom-namespace
```

### 3.8.4 删除命名空间中的所有 pod，但保留命名空间

```shell
kubectl delete po --all
```

### 3.8.5 删除命名空间中的（几乎）所有资源

```shell
kubectl delete all --all
```

## 3.9 本章小结

略。
