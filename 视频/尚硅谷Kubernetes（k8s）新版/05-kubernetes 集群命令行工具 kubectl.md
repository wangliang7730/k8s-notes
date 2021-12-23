# 五、kubernetes 集群命令行工具 kubectl

## 1 kubectl 概述

kubectl 是 Kubernetes 集群的命令行工具，通过 kubectl 能够对集群本身进行管理，并能够在集群上进行容器化应用的安装部署。

## 2 kubectl 命令的语法

```shell
$ kubectl [command] [TYPE] [NAME] [flags]
```

- comand：指定要对资源执行的操作，例如 create、get、describe 和 delete

- TYPE：指定资源类型，资源类型是大小写敏感的，开发者能够以单数、复数和缩略的形式。例如：
  
  ```shell
  $ kubectl get pod pod1
  $ kubectl get pods pod1
  $ kubectl get po pod1
  ```
  
- NAME：指定资源的名称，名称也大小写敏感的。如果省略名称，则会显示所有的资源，例如:
  
  ```shell
  $ kubectl get pods
  ```
  
- flags：指定可选的参数。例如，可用-s 或者–server 参数指定 Kubernetes API server 的地址和端口。

## 3 kubectl help 获取更多信息

获取 kubectl 帮助方法：

```shell
[root@master1 ~]# kubectl --help
Basic Commands (Beginner):
  create        Create a resource from a file or from stdin.
  expose        使用 replication controller, service, deployment 或者 pod 并暴露它作为一个 新的 Kubernetes
Service
  run           在集群中运行一个指定的镜像
  set           为 objects 设置一个指定的特征

Basic Commands (Intermediate):
  explain       查看资源的文档
  get           显示一个或更多 resources
  edit          在服务器上编辑一个资源
  delete        Delete resources by filenames, stdin, resources and names, or by resources and label selector

Deploy Commands:
  rollout       Manage the rollout of a resource
  scale         Set a new size for a Deployment, ReplicaSet or Replication Controller
  autoscale     自动调整一个 Deployment, ReplicaSet, 或者 ReplicationController 的副本数量

Cluster Management Commands:
  certificate   修改 certificate 资源.
  cluster-info  显示集群信息
  top           Display Resource (CPU/Memory/Storage) usage.
  cordon        标记 node 为 unschedulable
  uncordon      标记 node 为 schedulable
  drain         Drain node in preparation for maintenance
  taint         更新一个或者多个 node 上的 taints

Troubleshooting and Debugging Commands:
  describe      显示一个指定 resource 或者 group 的 resources 详情
  logs          输出容器在 pod 中的日志
  attach        Attach 到一个运行中的 container
  exec          在一个 container 中执行一个命令
  port-forward  Forward one or more local ports to a pod
  proxy         运行一个 proxy 到 Kubernetes API server
  cp            复制 files 和 directories 到 containers 和从容器中复制 files 和 directories.
  auth          Inspect authorization

Advanced Commands:
  diff          Diff live version against would-be applied version
  apply         通过文件名或标准输入流(stdin)对资源进行配置
  patch         使用 strategic merge patch 更新一个资源的 field(s)
  replace       通过 filename 或者 stdin替换一个资源
  wait          Experimental: Wait for a specific condition on one or many resources.
  convert       在不同的 API versions 转换配置文件
  kustomize     Build a kustomization target from a directory or a remote url.

Settings Commands:
  label         更新在这个资源上的 labels
  annotate      更新一个资源的注解
  completion    Output shell completion code for the specified shell (bash or zsh)

Other Commands:
  alpha         Commands for features in alpha
  api-resources Print the supported API resources on the server
  api-versions  Print the supported API versions on the server, in the form of "group/version"
  config        修改 kubeconfig 文件
  plugin        Provides utilities for interacting with plugins.
  version       输出 client 和 server 的版本信息
```

## 4 kubectl 子命令使用分类

### 4.1 基础命令

| 分类     | 命令    | 说明                                                   |
| -------- | ------- | ------------------------------------------------------ |
| 基础命令 | create  | 通过文件名或标准输入创建资源                           |
|          | expose  | 将一个资源公开为一个新的Service                        |
|          | run     | 在集群中运行一个特定的镜像                             |
|          | set     | 在对象上设置特定的功能                                 |
|          | get     | 显示一个或多个资源                                     |
|          | explain | 文档参考资料                                           |
|          | edit    | 使用默认的编辑器编辑一个资源。                         |
|          | delete  | 通过文件名、标准输入、资源名称或标签选择器来删除资源。 |

### 4.2 部署和集群管理命令

| 分类         | 命令           | 说明                                                 |
| ------------ | -------------- | ---------------------------------------------------- |
| 部署命令     | rollout        | 管理资源的发布                                       |
|              | rolling-update | 对给定的复制控制器滚动更新                           |
|              | scale          | 扩容或缩容Pod数量，Deployment、ReplicaSet、RC或Job   |
|              | autoscale      | 创建一个自动选择扩容或缩容并设置Pod数量              |
| 集群管理命令 | certificate    | 修改证书资源                                         |
|              | cluster-info   | 显示集群信息                                         |
|              | top            | 显示资源（CPU/Memory/Storage）使用。需要Heapster运行 |
|              | cordon         | 标记节点不可调度                                     |
|              | uncordon       | 标记节点可调度                                       |
|              | drain          | 驱逐节点上的应用，准备下线维护                       |
|              | taint          | 修改节点taint标记                                    |

### 4.3 故障和调试命令

| 分类               | 命令         | 说明                                                         |
| ------------------ | ------------ | ------------------------------------------------------------ |
| 故障诊断和调试命令 | describe     | 显示特定资源或资源组的详细信息                               |
|                    | logs         | 在一个Pod中打印一个容器日志。如果Pod只有一个容器，容器名称是可选的 |
|                    | attach       | 附加到一个运行的容器                                         |
|                    | exec         | 执行命令到容器                                               |
|                    | port-forward | 转发一个或多个本地端口到一个pod                              |
|                    | proxy        | 运行一个proxy到Kubernetes API server                         |
|                    | cp           | 拷贝文件或目录到容器中                                       |
|                    | auth         | 检查授权                                                     |

### 4.4 其他命令

| 分类     | 命令         | 说明                                                |
| -------- | ------------ | --------------------------------------------------- |
| 高级命令 | apply        | 通过文件名或标准输入对资源应用配置                  |
|          | patch        | 使用补丁修改、更新资源的字段                        |
|          | replace      | 通过文件名或标准输入替换一个资源                    |
|          | convert      | 不同的API版本之间转换配置文件                       |
| 设置命令 | label        | 更新资源上的标签                                    |
|          | annotate     | 更新资源上的注释                                    |
|          | completion   | 用于实现kubectl工具自动补全                         |
| 其他命令 | api-versions | 打印受支持的API版本                                 |
|          | config       | 修改kubeconfig文件（用于访问API，比如配置认证信息） |
|          | help         | 所有命令帮助                                        |
|          | plugin       | 运行一个命令行插件                                  |
|          | version      | 打印客户端和服务版本信息                            |

