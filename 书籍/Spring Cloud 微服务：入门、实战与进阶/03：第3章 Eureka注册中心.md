---
date: 2021-11-01
updated: 2021-11-04
---

# 第3章 Eureka注册中心

## 3.1 Eureka

略。

## 3.2 使用Eureka编写注册中心服务

**示例：** *ch-3/eureka-server*

- 依赖：

  ```xml
  <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
  </dependency>
  ```

- 启用：`@EnableEurekaServer`。

- 配置：

  ```properties
  spring.application.name=eureka-server
  # 默认端口 8761
  server.port=8761
  # 由于该应用为注册中心，所以设置为false，代表不向注册中心注册自已
  eureka.client.register-with-eureka=false
  # 由于注册中心的职责就是维护服务实例，它并不需要去检索服务，所以也设置为false
  eureka.client.fetch-registry=false
  ```

- 访问：http://localhost:8761/。

## 3.3 编写服务提供者

### 3.3.1 创建项目注册到Eureka

**示例：** *ch-3/eureka-client-user-service*

- 依赖：

  ```xml
  <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
  </dependency>
  ```

- 启用：`@EnableDiscoveryClient`。

- 配置：

  ```properties
  spring.application.name=eureka-client-user-service
  server.port=8081
  eureka.client.serviceUrl.defaultZone=http://localhost:8761/eureka/
  # 采用 IP 注册
  eureka.instance.preferIpAddress=true
  # 定义实例 ID 格式
  eureka.instance.instance-id=${spring.application.name}:${spring.cloud.client.ip-address}:${server.port}
  ```

### 3.3.2 编写提供接口

略。

## 3.4 编写服务消费者

**示例：** *ch3/eureka-client-article-service*

### 3.4.1 直接调用接口

- *ArticleController#callHello*，访问 http://localhost:8082/article/callHello

> **报错：** java.lang.IllegalStateException: No instances available for localhost
>
> `RestTemplate` 添加了 `@LoadBalanced` 后只支持服务名。这里可以 `new` 一个 `RestTemplate`。

### 3.4.2 通过Eureka来消费接口

- `RestTemplate` 添加 `@LoadBalanced`。

## 3.5 开启Eureka认证

- 依赖：

  ```xml
  <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-security</artifactId>
  </dependency>
  ```

- 认证信息：

  ```properties
  spring.security.user.name=yinjihuan
  spring.security.user.password=123456
  ```

- 配置：

  ```java
  //关闭csrf
  http.csrf().disable();
  // 支持httpBasic
  http.authorizeRequests().anyRequest().authenticated().and().httpBasic();
  ```

- 客户端：

  ```properties
  eureka.client.serviceUrl.defaultZone=http://yinjihuan:123456@localhost:8761/eureka/
  ```

## 3.6 Eureka高可用搭建

### 3.6.1 高可用原理

略。

### 3.6.2 搭建步骤

- 配置其他节点路径：`eureka.client.serviceUrl.defaultZone=http://localhost:8762/eureka/,http://localhost:8763/eureka/`。

## 3.7 常用配置讲解

### 3.7.1 关闭自我保护

```properties
eureka.server.enableSelfPreservation=false
```

### 3.7.2 自定义Eureka的InstanceID

```properties
eureka.instance.instance-id=${spring.application.name}:${spring.cloud.client.ip-address}:${server.port}
eureka.instance.preferIpAddress=true
```

### 3.7.3 自定义实例跳转链接

```properties
eureka.instance.status-page-url=http://cxytiandi.com
```

### 3.7.4 快速移除已经失效的服务信息

```properties
# 【服务端】
eureka.server.enable-self-preservation=false
# 默认60000毫秒
eureka.server.eviction-interval-timer-in-ms=5000

# 【客户端】
eureka.client.healthcheck.enabled=true
# 默认30秒。client 发送心跳给 server 的频率
eureka.instance.lease-renewal-interval-in-seconds=5
# 默认90秒。server 至上一次收到 client 心跳后，等待下一次心跳超时的时间，超时后移除
eureka.instance.lease-expiration-duration-in-seconds=5
```

## 3.8 扩展使用

### 3.8.1 Eureka REST API

- 官方文档：https://github.com/Netflix/eureka/wiki/Eureka-REST-operations。
- 查看服务：http://localhost:8761/eureka/apps/eureka-client-user-service。默认返回 xml，可以加上 `Accept: application/json` 请求头返回 json。

### 3.8.2 元数据使用

- `eureka.instance.metadataMap`。

### 3.8.3 EurekaClient使用

- `EurekaClient`、`DiscoveryClient`。

### 3.8.4 健康检查

- `eureka.client.healthcheck.enabled=true`。

- 模拟下线：

  ```java
  @Component
  public class CustomHealthIndicator extends AbstractHealthIndicator {
      @Override
      protected void doHealthCheck(Builder builder) throws Exception {
          builder.down().withDetail("status", false);
      }
  }
  ```

### 3.8.5 服务上下线监控

```java
@EventListener
public void listen(EurekaInstanceCanceledEvent event) {}
```

- `EurekaInstanceCanceledEvent`：服务下线事件
- `EurekaInstanceRegisteredEvent`：服务注册事件。
- `EurekaInstanceRenewedEvent`：服务续约事件。
- `EurekaRegistryAvailableEventEureka`：注册中心启动事件。
- `EurekaServerStartedEventEurekaServer`：启动事件。

## 3.9 本章小结

略。
