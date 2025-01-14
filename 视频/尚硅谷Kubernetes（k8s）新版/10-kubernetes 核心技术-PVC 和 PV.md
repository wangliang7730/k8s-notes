# 十、 kubernetes 核心技术-PVC 和 PV

## 1 基本概念

管理存储是管理计算的一个明显问题。该 PersistentVolume 子系统为用户和管理员提供了一个 API，用于抽象如何根据消费方式提供存储的详细信息。为此，我们引入了两个新的API 资源：PersistentVolume 和 PersistentVolumeClaim

#### PersistentVolume（PV）
是集群中由管理员配置的一段网络存储。 它是集群中的资源，就像节点是集群资源一样。 PV 是容量插件，如 Volumes，但其生命周期独立于使用 PV 的任何单个 pod。 此 API 对象捕获存储实现的详细信息，包括 NFS，iSCSI 或特定于云提供程序的存储系统。

#### PersistentVolumeClaim（PVC）
是由用户进行存储的请求。 它类似于 pod。 Pod 消耗节点资源，PVC 消耗 PV 资源。Pod 可以请求特定级别的资源（CPU 和内存）。声明可以请求特定的大小和访问模式（例如，可以一次读/写或多次只读）。

虽然 PersistentVolumeClaims 允许用户使用抽象存储资源，但是 PersistentVolumes 对于不同的问题，用户通常需要具有不同属性（例如性能）。群集管理员需要能够提供各种PersistentVolumes 不同的方式，而不仅仅是大小和访问模式，而不会让用户了解这些卷的实现方式。对于这些需求，有 StorageClass 资源。

StorageClass 为管理员提供了一种描述他们提供的存储的“类”的方法。 不同的类可能映射到服务质量级别，或备份策略，或者由群集管理员确定的任意策略。 Kubernetes 本身对于什么类别代表是不言而喻的。 这个概念有时在其他存储系统中称为“配置文件”。

PVC 和 PV 是一一对应的。

## 2 生命周期

PV 是群集中的资源。PVC 是对这些资源的请求，并且还充当对资源的检查。PV 和 PVC 之间的相互作用遵循以下生命周期：

**Provisioning ——-> Binding ——–>Using——>Releasing——>Recycling**

- **供应准备 Provisioning：** 通过集群外的存储系统或者云平台来提供存储持久化支持。
  - 静态提供 Static： 集群管理员创建多个 PV。 它们携带可供集群用户使用的真实存储的详细信息。 它们存在于 Kubernetes API 中，可用于消费

  - 动态提供 Dynamic： 当管理员创建的静态 PV 都不匹配用户的 PersistentVolumeClaim 时，集群可能会尝试为 PVC 动态配置卷。 此配置基于 StorageClasses：PVC 必须请求一个类，并且管理员必须已创建并配置该类才能进行动态配置。 要求该类的声明有效地为自己禁用动态配置。
- **绑定 Binding：** 用户创建 pvc 并指定需要的资源和访问模式。在找到可用 pv 之前，pvc会保持未绑定状态。
- **使用 Using：** 用户可在 pod 中像 volume 一样使用 pvc。
- **释放 Releasing：** 用户删除 pvc 来回收存储资源，pv 将变成“released”状态。由于还保留着之前的数据，这些数据需要根据不同的策略来处理，否则这些存储资源无法被其他 pvc 使用。
- **回收 Recycling：** pv 可以设置三种回收策略：保留（Retain），回收（Recycle）和删除（Delete）。
    - 保留策略：允许人工处理保留的数据。
    - 删除策略：将删除 pv 和外部关联的存储资源，需要插件支持。
    - 回收策略：将执行清除操作，之后可以被新的 pvc 使用，需要插件支持

## 3 持久化卷声明的保护
PVC 保护的目的是**确保由 pod 正在使用的 PVC 不会从系统中移除，因为如果被移除的话可能会导致数据丢失**。

> 注意：**当 pod 状态为 Pending 并且 pod 已经分配给节点或 pod 为 Running 状态时，PVC 处于活动状态**。
## 4. 持久化卷类型
PersistentVolume 类型以插件形式实现。Kubernetes 目前支持以下插件类型：
```
GCEPersistentDisk
AWSElasticBlockStore
AzureFile
AzureDisk
FC (Fibre Channel)
FlexVolume
Flocker
NFS # 用它即可
iSCSI
RBD (Ceph Block Device)
CephFS
Cinder (OpenStack block storage)
Glusterfs
VsphereVolume
Quobyte Volumes
HostPath （仅限于但节点测试—— 不会以任何方式支持本地存储，也无法在多节点集群中工作）
VMware Photon
Portworx Volumes
ScaleIO Volumes
StorageOS
```
原始块支持仅适用于以上这些插件。
## 5.持久化卷
每个 PV 配置中都包含一个 sepc 规格字段和一个 status 卷状态字段。
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv0003
spec:
  capacity:
    storage: 5Gi  # 大小
  volumeMode: Filesystem # pv 的模型
  accessModes:
    - ReadWriteOnce  # 写的格式
  persistentVolumeReclaimPolicy: Recycle # 回收策略
  storageClassName: slow  # 存储的名词
  mountOptions:  # 其他信息，这里可以不制定，让他自己去判断，这个可以不指定。
    - hard
    - nfsvers=4.1
  nfs:
    path: /tmp
    server: 172.17.0.2
```
#### 5.1容量
通常，PV 将具有特定的存储容量。这是使用 PV 的容量属性设置的。查看 Kubernetes 资源模型 以了解 capacity 预期。

目前，存储大小是可以设置或请求的唯一资源。未来的属性可能包括 IOPS、吞吐量等。

### 5.2卷模式
在 v1.9 之前，所有卷插件的默认行为是在持久卷上创建一个文件系统。**在 v1.9 中，用户可以指定一个 volumeMode，除了文件系统之外，它现在将支持原始块设备**。 volumeMode 的有效值可以是 **“Filesystem”或“Block”** 。如果未指定，volumeMode 将默认为“Filesystem”。这是一个可选的 API 参数。

注意：该功能在 V1.9 中是 alpha的，未来可能会更改。

### 5.3访问模式
PersistentVolume 可以以资源提供者支持的任何方式挂载到主机上。如下表所示，供应商具有不同的功能，每个 PV 的访问模式都将被设置为该卷支持的特定模式。例如，NFS 可以支持多个读/写客户端，但特定的 NFS PV 可能以只读方式导出到服务器上。每个 PV 都有一套自己的用来描述特定功能的访问模式。

存储模式包括：
- ReadWriteOnce——该卷可以被单个节点以读/写模式挂载
- ReadOnlyMany——该卷可以被多个节点以只读模式挂载
- ReadWriteMany——该卷可以被多个节点以读/写模式挂载

在命令行中，访问模式缩写为：
- RWO - ReadWriteOnce
- ROX - ReadOnlyMany
- RWX - ReadWriteMany

> 不同的volume的插件支持的读写是不同的，[具体的请查阅文档](https://jimmysong.io/kubernetes-handbook/concepts/persistent-volume.html)
### 5.4 类
PV 可以具有一个类，通过将 storageClassName 属性设置为 [StorageClass](https://kubernetes.io/docs/concepts/storage/storage-classes/) 的名称来指定该类。**一个特定类别的 PV 只能绑定到请求该类别的 PVC。没有 storageClassName 的 PV 就没有类，它只能绑定到不需要特定类的 PVC**。

### 5.5 回收策略
> nfs 的回收策略  REcycle被废弃了
当前的回收策略包括：

- Retain（保留）——手动回收
- Recycle（回收）——基本擦除（rm -rf /thevolume/*）
- Delete（删除）——关联的存储资产（例如 AWS EBS、GCE PD、Azure Disk 和 OpenStack Cinder 卷）将被删除

当前，只有 NFS 和 HostPath 支持回收策略。AWS EBS、GCE PD、Azure Disk 和 Cinder 卷支持删除策略。

### 5.6 挂载选项  
Kubernetes 管理员可以指定在节点上为挂载持久卷指定挂载选项。

注意：不是所有的持久化卷类型都支持挂载选项。

### 5.7 状态
> ReadWriteMany 如果这中类型 则可以被挂载多次 
卷可以处于以下的某种状态：

- Available（可用）——一块空闲资源还没有被任何声明绑定
- Bound（已绑定）——卷已经被声明绑定
- Released（已释放）——声明被删除，但是资源还未被集群重新声明
- Failed（失败）——该卷的自动回收失败

命令行会显示绑定到 PV 的 PVC 的名称。

# 持久化演示说明 - NFS 

## Ⅰ、安装 NFS 服务器

```bash
yum install -y nfs-common nfs-utils  rpcbind
mkdir /nfsdata
chmod 666 /nfsdata
chown nfsnobody /nfsdata
vim /etc/exports
# 写入下面内容,表示该目录是挂在nfs挂在目录，后面是权限信息
/nfsdata *(rw,no_root_squash,no_all_squash,sync)
# 启动rpcbind
systemctl start rpcbind
# 启动nfs
systemctl start nfs
# 在每一个节点执行命令安装nfs客户端
yum -y install nfs-utils rpcbind
# 查看挂在环境
[root@master01 test]# showmount -e 192.168.1.105
Export list for 192.168.1.105:
/nfsdata *
# 挂在目录 将节点的/test/ 目录挂在到192.168.1.105:/nfsdata目录
[root@master01 test]# mount -t nfs 192.168.1.105:/nfsdata /test/
# 删除挂在目录
[root@master01 test]# umount /test/
```

![img](https://img-blog.csdnimg.cn/20200209204222455.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hlaWFuXzk5,size_16,color_FFFFFF,t_70)

NFS已经成功了
## Ⅱ、部署 PV 

```bash
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfspv1
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: nfs
  nfs:
    path: /nfsdata
    server: 192.168.116.131
```

![img](https://img-blog.csdnimg.cn/20200209211106596.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hlaWFuXzk5,size_16,color_FFFFFF,t_70)

## Ⅲ、创建服务并使用 PVC 

```bash
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None
  selector:
    app: nginx
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  selector:
    matchLabels:
      app: nginx
  serviceName: "nginx"
  replicas: 3
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: wangyanglinux/myapp:v1
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: "nfs"
      resources:
        requests:
          storage: 1Gi
```

![img](https://img-blog.csdnimg.cn/20200209212349469.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2hlaWFuXzk5,size_16,color_FFFFFF,t_70)


## 5 演示：创建 PV

### 5.1 第一步：编写 yaml 文件，并创建 pv

创建 5 个 pv，存储大小各不相同，是否可读也不相同

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv001
  labels:
    name: pv001
spec:
  nfs:
    path: /data/volumes/v1
    server: nfs
  accessModes: ["ReadWriteMany","ReadWriteOnce"]
  capacity:
    storage: 2Gi
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv002
  labels:
    name: pv002
spec:
  nfs:
    path: /data/volumes/v2
    server: nfs
  accessModes: ["ReadWriteOnce"]
  capacity:
    storage: 5Gi
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv003
  labels:
    name: pv003
spec:
  nfs:
    path: /data/volumes/v3
    server: nfs
  accessModes: ["ReadWriteMany","ReadWriteOnce"]
  capacity:
    storage: 20Gi
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv004
  labels:
    name: pv004
spec:
  nfs:
    path: /data/volumes/v4
    server: nfs
  accessModes: ["ReadWriteMany","ReadWriteOnce"]
  capacity:
    storage: 10Gi
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv005
  labels:
    name: pv005
spec:
  nfs:
    path: /data/volumes/v5
    server: nfs
  accessModes: ["ReadWriteMany","ReadWriteOnce"]
  capacity:
    storage: 15Gi
```

### 5.2 第二步：执行创建命令

```shell
[root@master volumes]# kubectl apply -f pv-demo.yaml
persistentvolume/pv001 created
persistentvolume/pv002 created
persistentvolume/pv003 created
persistentvolume/pv004 created
persistentvolume/pv005 created
```

### 5.3 第三步：查询验证

```shell
[root@master ~]# kubectl get pv
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM
pv001   2Gi        RWO,RWX        Retain           Available
pv002   5Gi        RWO            Retain           Available
pv003   20Gi       RWO,RWX        Retain           Available
pv004   10Gi       RWO,RWX        Retain           Available
pv005   15Gi       RWO,RWX        Retain           Available
```

## 6 演示：创建 PVC，绑定 PV

### 6.1 第一步：编写 yaml 文件，并创建 pvc

创建一个 pvc，需要 6G 存储；所以不会匹配 pv001、pv002、pv003

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mypvc
  namespace: default
spec:
  accessModes: ["ReadWriteMany"]
  resources:
    requests:
      storage: 6Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: vol-pvc
  namespace: default
spec:
  volumes:
  - name: html
    persistentVolumeClaim:
      claimName: mypvc
  containers:
  - name: myapp
    image: ikubernetes/myapp:v1
    volumeMounts:
    - name: html
      mountPath: /usr/share/nginx/html/
```

### 6.2 第二步：执行命令创建

```shell
kubectl apply -f vol-pvc-demo.yaml
```

### 6.3 第三步：查询验证

```shell
[root@master ~]# kubectl get pvc
NAME    STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
mypvc   Bound    pv004    10Gi       RWO,RWX                       24s

[root@master ~]# kubectl get pv
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM
pv001   2Gi        RWO,RWX        Retain           Available
pv002   5Gi        RWO            Retain           Available 
pv003   20Gi       RWO,RWX        Retain           Available
pv004   10Gi       RWO,RWX        Retain           Bound       default/mypvc
pv005   15Gi       RWO,RWX        Retain           Available

[root@master ~]# kubectl get pods -o wide
NAME      READY   STATUS    RESTARTS   AGE     IP             NODE
vol-pvc   1/1     Running   0          59s     10.244.2.117   node2

[root@master ~]# curl 10.244.2.117
<h1>NFS stor 04</h1>
```
# 关于 StatefulSet 
- **匹配 Pod name ( 网络标识 ) 的模式为：$(statefulset名称)-$(序号)，比如上面的示例：web-0，web-1，web-2**
- **StatefulSet 为每个 Pod 副本创建了一个 DNS 域名，这个域名的格式为： $(podname).(headless server name)，也就意味着服务间是通过Pod域名来通信而非 Pod IP，因为当Pod所在Node发生故障时， Pod 会被飘移到其它 Node 上，Pod IP 会发生变化，但是 Pod 域名不会有变化**
- **StatefulSet 使用 Headless 服务来控制 Pod 的域名，这个域名的 FQDN 为：$(service name).$(namespace).svc.cluster.local，其中，“cluster.local” 指的是集群的域名**
- **根据 volumeClaimTemplates，为每个 Pod 创建一个 pvc，pvc 的命名规则匹配模式：(volumeClaimTemplates.name)-(pod_name)，比如上面的 volumeMounts.name=www， Pod name=web-[0-2]，因此创建出来的 PVC 是 www-web-0、www-web-1、www-web-2**
- **删除 Pod 不会删除其 pvc，手动删除 pvc 将自动释放 pv**
## Statefulset的启停顺序：
- **有序部署：部署StatefulSet时，如果有多个Pod副本，它们会被顺序地创建（从0到N-1）并且，在下一个Pod运行之前所有之前的Pod必须都是Running和Ready状态。**
- **有序删除：当Pod被删除时，它们被终止的顺序是从N-1到0。**
- **有序扩展：当对Pod执行扩展操作时，与部署一样，它前面的Pod必须都处于Running和Ready状态。**
## StatefulSet使用场景：
- **稳定的持久化存储，即Pod重新调度后还是能访问到相同的持久化数据，基于 PVC 来实现。**
- **稳定的网络标识符，即 Pod 重新调度后其 PodName 和 HostName 不变。**
- **有序部署，有序扩展，基于 init containers 来实现。**
- **有序收缩。**
