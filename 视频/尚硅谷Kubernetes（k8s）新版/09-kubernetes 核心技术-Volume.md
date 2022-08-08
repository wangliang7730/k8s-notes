# 九、kubernetes 核心技术-Volume

## 1 Volume 概述

Volume 是 Pod 中能够被多个容器访问的共享目录。Kubernetes 的 Volume 定义在 Pod 上，它被一个 Pod 中的多个容 器挂载到具体的文件目录下。Volume 与 Pod 的生命周期相同，但与容器的生命周期不相关，当容器终止或重启时，Volume 中的数据也不会丢失。要使用volume，pod 需要指定 volume 的类型和内容（ 字段），和映射到容器的位置（ 字段）。Kubernetes 支持多种类型的 Volume,包括：emptyDir、hostPath、gcePersistentDisk、awsElasticBlockStore、nfs、iscsi、flocker、glusterfs、rbd、cephfs、gitRepo、secret、persistentVolumeClaim、downwardAPI、azureFileVolume、azureDisk、vsphereVolume、Quobyte、PortworxVolume、ScaleIO。emptyDirEmptyDir 类型的 volume 创建于 pod 被调度到某个宿主机上的时候，而同一个 pod 内的容器都能读写 EmptyDir 中的同一个文件。一旦这个 pod 离开了这个宿主机，EmptyDir 中的数据就会被永久删除。所以目前 EmptyDir 类型的 volume 主要用作临时空间，比如 Web 服务器写日志或者 tmp 文件需要的临时目录。

## 2 yaml 示例如下

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pd
spec:
  containers:
  - image: docker.io/nazarpc/webserver
    name: test-container
    volumeMounts:
    - mountPath: /cache
      name: cache-volume
   volumes:
    - name: cache-volume
      emptyDir: {}
```

## 3 hostPath

HostPath 属性的 volume 使得对应的容器能够访问当前宿主机上的指定目录。例如，需要运行一个访问 Docker 系统目录的容器，那么就使用/var/lib/docker 目录作为一个HostDir 类型的 volume；或者要在一个容器内部运行 CAdvisor，那么就使用/dev/cgroups目录作为一个 HostDir 类型的 volume。一旦这个 pod 离开了这个宿主机，HostDir 中的数据虽然不会被永久删除，但数据也不会随 pod 迁移到其他宿主机上。因此，需要 注意的是，由于各个宿主机上的文件系统结构和内容并不一定完全相同，所以相同 pod 的 HostDir 可能会在不 同的宿主机上表现出不同的行为。yaml 示例如下：

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pd
spec:
  containers:
  - image: docker.io/nazarpc/webserver
    name: test-container
    # 指定在容器中挂接路径
    volumeMounts:
    - mountPath: /test-pd
      name: test-volume
  # 指定所提供的存储卷
  volumes:
  - name: test-volume
  # 宿主机上的目录
    hostPath:
      path: /data
      # directory location on host
```
type 字段支持以下值：

|值|	行为|
|---|---|
||空字符串（默认）用于向后兼容，这意味着在挂载 hostPath 卷之前不会执行任何检查。|
|DirectoryOrCreate|	如果在给定的路径上没有任何东西存在，那么将根据需要在那里创建一个空目录，权限设置为 0755，与 Kubelet 具有相同的组和所有权。|
|Directory|	给定的路径下必须存在目录|
|FileOrCreate|	如果在给定的路径上没有任何东西存在，那么会根据需要创建一个空文件，权限设置为 0644，与 Kubelet 具有相同的组和所有权。
|File|	给定的路径下必须存在文件
|Socket|	给定的路径下必须存在 UNIX 套接字
|CharDevice|	给定的路径下必须存在字符设备
|BlockDevice	|给定的路径下必须存在块设备

使用这种卷类型是请注意，因为：
- 由于每个节点上的文件都不同，具有相同配置（例如从 podTemplate 创建的）的 pod 在不同节点上的行为可能会有所不同
- 当 Kubernetes 按照计划添加资源感知调度时，将无法考虑 hostPath 使用的资源
- 在底层主机上创建的文件或目录只能由 root 写入。您需要在特权容器中以 root 身份运行进程，或修改主机上的文件权限以便写入 hostPath 卷


## 4 nfs

NFS 类型 volume。允许一块现有的网络硬盘在同一个 pod 内的容器间共享。yaml 示例如下：

```yaml
apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2
kind: Deployment
metadata:
  name: redis
spec:
  selector:
    matchLabels:
      app: redis
  revisionHistoryLimit: 2
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      # 应用的镜像
      - image: redis
        name: redis
        imagePullPolicy: IfNotPresent # 应用的内部端口
        ports:
        - containerPort: 6379
          name: redis6379
        env:
        - name: ALLOW_EMPTY_PASSWORD
          value: "yes"
        - name: REDIS_PASSWORD
          value: "redis"
        # 持久化挂接位置，在 docker 中
        volumeMounts:
        - name: redis-persistent-storage
          mountPath: /data
      volumes:
      # 宿主机上的目录
      - name: redis-persistent-storage
        nfs:
          path: /k8s-nfs/redis/data
          server: 192.168.126.112
```

