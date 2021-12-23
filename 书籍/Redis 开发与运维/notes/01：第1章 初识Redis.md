---
title: 第1章 初识Redis
hidden: true
date: 2021-09-21
updated: 2021-09-21
---

# 第1章 初识Redis

## 1.1 盛赞Redis

## 1.2 Redis特性

| 💡 **Redis 的特性** |
| ------------------ |

下面是关于 Redis 的8个重要特性：

1. 速度快
2. 基于键值对的数据结构服务器
3. 丰富的功能
4. 简单稳定
5. 客户端语言多
6. 持久化
7. 主从复制
8. 高可用和分布式

## 1.3 Redis使用场景

### 1.3.1 Redis可以做什么

### 1.3.2 Redis不可以做什么

## 1.4 用好Redis的建议

## 1.5 正确安装并启动Redis

### 1.5.1 安装Redis

| ⌨ **Redis 安装** |
| ---------------- |

以 3.0.7 为例：

```shell
wget https://download.redis.io/releases/redis-3.0.7.tar.gz
tar xzf redis-3.0.7.tar.gz
ln -s redis-3.0.7 redis
cd redis
make
make install
```

### 1.5.2 配置、启动、操作、关闭Redis

<center><i>表 1-2 Redis 可执行文件说明</i></center>

| 可执行文件       | 作  用                             |
| ---------------- | ---------------------------------- |
| redis-server     | 启动 Redis                         |
| redis-cli        | Redis 命令行客户端                 |
| redis-benchmark  | Redis 基准测试工具                 |
| redis-check-aof  | Redis AOF 持久化文件检测和修复工具 |
| redis-check-dump | Redis RDB 持久化文件检测和修复工具 |
| redis-sentinel   | 启动 Redis Sentinel                |

| 💡 **Redis 的启动方式** |
| ---------------------- |

- 默认配置

   ```shell
   redis-server
   ```

- 运行启动

   ```shell
   redis-server --configKey1 configValue1 --configKey2 configValue2
   # 例如
   redis-server --port 6380
   ```

- 配置文件启动

   ```shell
   redis-server /opt/redis/redis.conf
   ```

| 💡 **Redis命令行客户端** |
| ----------------------- |

- 交互方式

  ```shell
  redis-cli -h host -p port
  ```

- 命令方式

  ```shell
  redis-cli -h host -p port command
  ```

- 停止服务

  ```shell
  redis-cli shutdown [nosave|save]
  ```

## 1.6 Redis重大版本

| 💡 **Redis 的版本规则** |
| ---------------------- |

版本号第二位如果是**奇数**，则为**非稳定**版本（例如2.7、2.9、3.1），如果是**偶数**，则为**稳定**版本（例如2.6、2.8、3.0、3.2）

## 1.7 本章重点回顾

