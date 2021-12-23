# RabbitMQ

## 安装

- 下载 rabbitmq：https://github.com/rabbitmq/rabbitmq-server/releases
- 下载 erlang：https://github.com/rabbitmq/erlang-rpm/releases
- 版本兼容：https://www.rabbitmq.com/which-erlang.html#compatibility-matrix

**安装：**

```shell
yum install esl-erlang_xxx.rpm
yum install rabbitmq-server-xxx.rpm
```

**启动：**

```shell
systemctl start rabbitmq-server
# 启用图形化界面
rabbitmq-plugins enable rabbitmq_management
```

访问：http://localhost:15672

用户名密码：guest/guest

>   默认只能 localhost 登录：
>
>   - 3.7 之前：`/usr/lib/rabbitmq/lib/rabbitmq_server-3.7.xx/ebin/rabbit.app`，配置 `{loopback_users, []}`
>   - 3.8 没有这个文件，可以修改配置文件 `/etc/rabbitmq/rabbitmq.conf`，配置 `loopback_users = none`

**常用命令：**

```bash
systemctl start rabbitmq-server
rabbitmq-server -detached
rabbitmqctl
	status
	stop
	list_usrs
	list
# 图形化界面
rabbitmq-plugins enable rabbitmq_management
# 只能localhost登录{loopback_users, [<<"guest">>]} 3.7之前
/usr/lib/rabbitmq/lib/rabbitmq_server-3.8.3/ebin/rabbit.app
{loopback_users, []}
# 3.8
/etc/rabbitmq/rabbitmq.conf
loopback_users = none
systemctl restart rabbitmq-server
# 端口：15672
# 用户名密码：guest guest
```

**Docker 安装：**

```shell
docker run -d --name rabbitmq -e RABBITMQ_DEFAULT_USER=admin -e RABBITMQ_DEFAULT_PASS=admin -p 15672:15672 -p 5672:5672 rabbitmq:3-management
```

## 常用命令

```shell
rabbitmqctl add_user admin admin # 添加用户
rabbitmqctl set_user_tags admin administrator # 设置角色
rabbitmqctl set_permissions -p / admin ".*" ".*" ".*" # 设置权限，管理员没必要设置了
rabbitmqctl change_password admin xxx
rabbitmqctl list_users
rabbitmqctl status # 状态
rabbitmqctl cluster_status # 集群状态
```



## 角色分类

- none
- management
- policymaker
- monitoring
- administrator

## 基本概念

- **Producer:** Application that sends the messages.
- **Consumer:** Application that receives the messages.
- **Queue:** Buffer that stores messages.
- **Message:** Information that is sent from the producer to a consumer through RabbitMQ.
- **Connection:** A TCP connection between your application and the RabbitMQ broker.
- **Channel:** A virtual connection inside a connection. When publishing or consuming messages from a queue - it's all done over a channel.
- **Exchange:** Receives messages from producers and pushes them to queues depending on rules defined by the exchange type. To receive messages, a queue needs to be bound to at least one exchange.
- **Binding:** A binding is a link between a queue and an exchange.
- **Routing key:** A key that the exchange looks at to decide how to route the message to queues. Think of the routing key like an *address for the message.*
- **AMQP:** Advanced Message Queuing Protocol is the protocol used by RabbitMQ for messaging.
- **Users:** It is possible to connect to RabbitMQ with a given username and password. Every user can be assigned permissions such as rights to read, write and configure privileges within the instance. Users can also be assigned permissions for specific virtual hosts.
- **Vhost, virtual host:** Provides a way to segregate applications using the same RabbitMQ instance. Different users can have different permissions to different vhost and queues and exchanges can be created, so they only exist in one vhost.

## 消息模式

https://www.rabbitmq.com/getstarted.html

- 简单
- 工作队列
- 发布订阅
- 路由
- 主题
- rpc
- 发布确认

![RabbitMQ Topic Exchange](assets/exchanges-topic-fanout-direct.png)

## Java 客户端

*`pom.xml`*

```xml
<dependency>
  <groupId>com.rabbitmq</groupId>
  <artifactId>amqp-client</artifactId>
  <version>5.8.0</version>
</dependency>
```

```java
class ConnectionFactory;
	setHost/Port/Username/Password/VirtualHost();
	newConnection();
class Connection;
	createChannel();
class Channel;
	exchangeDeclare();
	queueDeclare();
	queueBind();
	basicPublish();
	addComfirmListner();
	addReturnListener();
class DefaultConsumer;
class AMQP.BasicProperties;
```

## Exchange

- 默认 Exchange：隐式绑定到每个 Queue，RoutingKey 和 Queue Name 一样

类型：

- direct
- topic：* 一个词，# 一个或多个词
- fanout