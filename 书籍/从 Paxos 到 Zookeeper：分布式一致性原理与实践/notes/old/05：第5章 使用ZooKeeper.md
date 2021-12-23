---
title: 第5章 使用ZooKeeper
hidden: true
---

# 第5章 使用ZooKeeper

- [ ] 5.1 部署与运行
  - 5.1.1 系统环境
  - 5.1.2 集群与单机
  - 5.1.3 运行服务
- [x] 5.2 [客户端脚本](#客户端脚本)
  - 5.2.1 [创建](#创建)
  - 5.2.2 [读取](#读取)
  - 5.2.3 [更新](#更新)
  - 5.2.4 [删除](#删除)
- [x] 5.3 [Java客户端API使用](#Java客户端API使用)
  - 5.3.1 [创建会话](#创建会话)
  - 5.3.2 [创建节点](#创建节点)
  - 5.3.3 [删除节点](#删除节点)
  - 5.3.4 [读取数据](#读取数据)
  - 5.3.5 [更新数据](#更新数据)
  - 5.3.6 [检测节点是否存在](#检测节点是否存在)
  - 5.3.7 [权限控制](#权限控制)
- [x] 5.4 [开源客户端](#开源客户端)
  - 5.4.1 [ZkClient](#ZkClient)
  - 5.4.2 [Curator](#Curator)
- [curator-recipes](#curator-recipes)
- [x] 小结

## Java客户端API使用

代码下载：http://www.broadview.com.cn/file/resource/046057135169134240001110183147127169154058027179

依赖：

```xml
<!-- https://mvnrepository.com/artifact/org.apache.zookeeper/zookeeper -->
<dependency>
  <groupId>org.apache.zookeeper</groupId>
  <artifactId>zookeeper</artifactId>
  <version>3.4.3</version>
</dependency>
```

### 创建会话

```java
/*
 * @param connectString           多个逗号隔开，可以指定/Chroot
 * @paramsessionTimeout           毫秒
 * @paramwatcher                  默认监听器
 * @paramsessionId/sessionPasswd  复用 session
 */
ZooKeeper(String connectString, int sessionTimeout, Watcher watcher, long sessionId, byte[] sessionPasswd, boolean canBeReadOnly);

// 监听器
public interface Watcher {
  public void process(WatchedEvent event) {
    // 已连接
    if (KeeperState.SyncConnected == event.getState()) {
      // 先判断 KeeperState
      // 再判断 EventType
    }
  }
}
```

### 创建节点

```java
/*
 * 同步创建
 * @param acl         Ids.OPEN_ACL_UNSAFE
 * @param createMode  CreateMode.EPHEMERAL
 */
String create(final String path, byte data[], List<ACL> acl, CreateMode createMode);

// 异步创建
void create(final String path, byte data[], List<ACL> acl, CreateMode createMode, StringCallback cb, Object ctx);

/*
 * 异步回调
 * @param rc     KeeperException，0:成功，-4:连接断开，-100:节点已存在，-112:会话过期
 * @param ctx    调用接口时传入的 ctx
 * @param name   实际路径，临时节点会后数字后缀
 */ 
interface StringCallback extends AsyncCallback {
  void processResult(int rc,String path, Object ctx, String name);
}
```

### 删除节点

```java
// version    -1 代表任意
void delete(final String path, int version);
void delete(final String path, int version, VoidCallback cb, Object ctx);
```

### 读取数据

获取子节点：

```java
/**
 * 同步
 *
 * @param watch/watcher  互斥参数，true 使用默认 watcher，一次性
 * @param stat           通过参数方式返回 stat
 * @return               返回相对路径
 */
List<String> getChildren(String path, boolean watch / Watcher watcher,Stat stat);

/**
 * 异步
 * @param cb             Children2Callback 多了 Stat
 */
void getChildren(String path, boolean watch / Watcher watcher, ChildrenCallback cb / Children2Callback cb, Object ctx);

// 事件
EventType.NodeChildrenChanged
```

获取数据：

```java
byte[] getData(String path, boolean watch / Watcher watcher, Stat stat);
void getData(String path, boolean watch / Watcher watcher, DataCallback cb, Object ctx);

// 事件
EventType.NodeDataChanged;
```

### 更新数据

```java
Stat setData(final String path, byte data[], int version);
void setData(final String path, byte data[], int version, StatCallback cb, Object ctx);
```

### 检测节点是否存在

```java
Stat exists(String path, boolean watch / Watcher watcher);
void exists(String path, boolean watch / Watcher watcher, StatCallback cb, Object ctx);
```

- 无论指定节点是否存在，通过调用 exists 接口都可以注册 Watcher。
- exists 接口中注册的 Watcher，能够对节点创建、节点删除和节点数据更新事件进行监听。
- 对于指定节点的子节点的各种变化，都不会通知客户端。

### 权限控制

```java
/**
 * @param scheme   world、auth、digest、ip、super
 * @param auth     具体权限信息
 */
void addAuthInfo(String scheme, byte auth[]);
// 例
zookeeper.addAuthInfo("digest", "foo:true".getBytes());
zookeeper.create( PATH, "init".getBytes(), Ids.CREATOR_ALL_ACL, CreateMode.EPHEMERAL);
```

> **？**
>
> 节点添加了权限信息后，对于删除操作而言，其作用范围是其子节点。也就是说，当我们对一个数据节点添加权限信息后，依然可以自由地删除这个节点，但是对于这个节点的子节点，就必须使用相应的权限信息才能够删除掉它。

## 开源客户端

### ZkClient

依赖：

```xml
<!-- https://mvnrepository.com/artifact/com.101tec/zkclient -->
<dependency>
  <groupId>com.101tec</groupId>
  <artifactId>zkclient</artifactId>
  <version>0.11</version>
</dependency>
```

创建连接：

```java
/**
 * 同步接口
 *
 * @param zkSerializer  序列化器
 * @param zkServers,sessionTimeout  转换为 IZkConnection 实现类 ZkConnection，
 *                                  可以直接传入 InMemoryConnection
 */
ZkClient(final String zkServers, final int sessionTimeout, final int connectionTimeout, final ZkSerializer zkSerializer, final long operationRetryTimeout);
```

创建节点：

```java
String create(final String path, Object data, final List<ACL> acl, final CreateMode mode);
// 递归
void createPersistent(String path, boolean createParents, List<ACL> acl);
```

删除节点：

```java
boolean delete(final String path, final int version);
// 递归
boolean deleteRecursive(String path);
```

读取节点数据：

```java
List<String> getChildren(final String path, final boolean watch);
// 监听
List<String> subscribeChildChanges(String path, IZkChildListener listener);

public interface IZkChildListener {
  // currentChilds  相对路径，null 父节点没了
  void handleChildChange(String parentPath, List<String> currentChilds) throws Exception;
}
```

- 客户端可以对一个不存在的节点进行子节点变更的监听
- 一旦客户端对一个节点注册了子节点列表变更监听之后，那么当该节点的子节点列表发生变更的时候，服务端都会通知客户端，并将最新的子节点列表发送给客户端
- 该节点本身的创建或删除也会通知到客户端
- 不是一次性的

读取数据：

```java
<T extends Object> T readData(final String path, final Stat stat, final boolean watch);
// 监听
void subscribeDataChanges(String path, IZkDataListener listener);

public interface IZkDataListener {
  void handleDataChange(String dataPath, Object data) throws Exception;
  void handleDataDeleted(String dataPath) throws Exception;
}
```

更新数据：

```java
void writeData(final String path, Object datat, final int expectedVersion);
Stat writeDataReturnStat(final String path, Object datat, final int expectedVersion);
```

节点是否存在：

```java
boolean exists(final String path, final boolean watch);
boolean waitUntilExists(String path, TimeUnit timeUnit, long time);
```

### Curator

依赖：

```xml
<!-- https://mvnrepository.com/artifact/org.apache.curator/curator-framework -->
<dependency>
  <groupId>org.apache.curator</groupId>
  <artifactId>curator-framework</artifactId>
  <version>2.4.2</version>
</dependency>
```

创建会话：

```java
RetryPolicy retryPolicy = new ExponentialBackoffRetry(1000, 3);
CuratorFramework client = CuratorFrameworkFactory.newClient("domain1.book.zookeeper:2181", 5000, 3000, retryPolicy);
// 链式，指定命名空间
CuratorFrameworkFactory.builder().namespace();
client.start();
```

创建节点：

```java
client.create().creatingParentsIfNeeded().withMode(CreateMode.EPHEMERAL).forPath(path, "init".getBytes());
```

删除节点：

```java
client.delete().deletingChildrenIfNeeded().withVersion(stat.getVersion()).forPath(path)
  // 失败重试
  .guaranteed();
```

读取数据：

```java
client.getData().storingStatIn(stat).forPath(path))
```

更新数据：

```java
client.setData().withVersion(stat.getVersion()).forPath(path)
```

异步：

```java
inBackground(BackgroundCallback callback);
```

## curator-recipes

依赖：

```xml
<!-- https://mvnrepository.com/artifact/org.apache.curator/curator-recipes -->
<dependency>
  <groupId>org.apache.curator</groupId>
  <artifactId>curator-recipes</artifactId>
  <version>2.4.2</version>
</dependency>
```

### 事件监听

- NodeCache
- PathChildrenCache

