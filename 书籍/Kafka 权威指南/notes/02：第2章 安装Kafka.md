---
title: 第2章 安装Kafka
hidden: true
---

# 第2章 安装Kafka

- [ ] 2.1 要事先行
  - 2.1.1 选择操作系统
  - 2.1.2 安装Java
  - 2.1.3 安装Zookeeper
- [ ] 2.2 [安装Kafka Broker](#安装Kafka-Broker)
- [ ] 2.3 [broker配置](#broker配置)
  - 2.3.1 常规配置
  - 2.3.2 主题的默认配置
- [ ] 2.4 硬件的选择
  - 2.4.1 磁盘吞吐量
  - 2.4.2 磁盘容量
  - 2.4.3 内存
  - 2.4.4 网络
  - 2.4.5 CPU
- [ ] 2.5 云端的Kafka
- [ ] 2.6 Kafka集群
  - 2.6.1 需要多少个broker
  - 2.6.2 broker配置
  - 2.6.3 操作系统调优
- [ ] 2.7 生产环境的注意事项
  - 2.7.1 垃圾回收器选项
  - 2.7.2 数据中心布局
  - 2.7.3 共享Zookeeper
- [ ] 2.8 总结

## 安装Kafka Broker

```shell
cd bin
# 启动 zookeeper
sh zookeeper-server-start.sh -daemon ../config/zookeeper.properties
# 启动 kafka
sh kafka-server-start.sh -daemon ../config/server.properties
# 创建主题
sh kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
# 验证主题
sh kafka-topics.sh --zookeeper localhost:2181 --describe --topic test
# 发布消息
sh kafka-console-producer.sh --broker-list localhost:9092 --topic test
> Test Message 1
> Test Message 2
>^D
# 读取消息
sh kafka-console-consumer.sh --zookeeper localhost:2181 --topic test --from-beginning
```

## broker配置

