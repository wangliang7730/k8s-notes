# RocketMQ

## 安装

```bash
unzip rocketmq-all-xxx -d /usr/local

# 启动之前设置 JVM 内存大小
vim bin/runserver.sh
vim bin/runbroker.sh
-Xms256m -Xmx256m -Xmn128m

# 启动 Name Server
nohup sh bin/mqnamesrv &
tail -f ~/logs/rocketmqlogs/namesrv.log

# 启动 Broker
nohup sh bin/mqbroker -n localhost:9876 &
tail -f ~/logs/rocketmqlogs/broker.log

# 测试
export NAMESRV_ADDR=localhost:9876
sh bin/tools.sh org.apache.rocketmq.example.quickstart.Consumer
sh bin/tools.sh org.apache.rocketmq.example.quickstart.Producer

# 关闭
sh bin/mqshutdown broker
sh bin/mqshutdown namesrv
```

## 架构

技术架构：

![](https://gitee.com/mirrors/rocketmq/raw/master/docs/cn/image/rocketmq_architecture_1.png)

部署架构：

![](https://gitee.com/mirrors/rocketmq/raw/master/docs/cn/image/rocketmq_architecture_3.png)

- NameServer 无状态，节点之间无数据同步
- Broker 分主从，BrokerName 同一组，BrokerId = 0 Master，1 Slave

## 集群

NameServer 集群，直接每个机器启动一个就行，Broker 指定时分号隔开。

Broker 部署方式分为：

- 单 Master

- 多 Master

- 多 Master 多 Slave 异步复制

- 多 Master 多 Slave 同步双写

主要是指定配置文件：

```properties
namesrvAddr=192.168.100.131:9876;192.168.100.132:9876 
brokerClusterName=DefaultCluster 
brokerName=broker-a 
brokerid=O 
deleteWhen=04 
fileReservedTime=48
brokerRole=SYNC_MASTER
flushDiskType=ASYNC_FLUSH
listenPort=10911
storePathRootDir=/home/rocketmq/store-a
```

## mqadmin

## rocketmq-console

```bash
mkdir rocketmq-externals
cd rocketmq-externals
git init
git config core.sparseCheckout true
echo /rocketmq-console >> .git/info/sparse-checkout
git remote add origin https://gitee.com/mirrors/RocketMQ-Externals
git pull origin master --depth 1

# 设置 NameServer 地址
mvn clean package -Dmaven.test.skip=true
```

## 消息

生产者：

- 同步
- 异步
- 单向

消费方式：

```java
// 广播和负载均衡（默认）
consumer.setMessageModel(MessageModel.BROADCASTING|MessageModel.CLUSTERING);
```

### 消息的顺序

```java
// 发送到同一个队列，保证局部有序
producer.send(msg, new MessageQueueSelector() { 根据参数选择用哪个 mq}, arg);
// 同一个线程消费同一个队列
consumer.registerMessageListener(new MessageListenerOrderly());
```

### 延时消息

```java
message.setDelayTimeLevel();
private String messageDelayLevel = "1s 5s 10s 30s 1m 2m 3m 4m 5m 6m 7m 8m 9m 10m 20m 30m 1h 2h";
```

### 批量消息

```java
List<Message> messages;
// 大小限制（4MB），分割消息列表
```

### 过滤消息

```java
consumer.subscribe("TOPIC", "TAGA || TAGB || TAGC");
msg.putUserProperty("a", String.valueOf(i));
consumer.subscribe("TopicTest", MessageSelector.bySql("a between 0 and 3");
```

### 事务消息

```java
class TransactionMQProducer;
interface TransactionListener {
  // 执行本地事务，提交、回滚或未知
  public LocalTransactionState executeLocalTransaction(Message msg, Object arg);
  // 未知状态回查
  public LocalTransactionState checkLocalTransaction(MessageExt msg);
}
```

