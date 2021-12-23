---
date: 2021-11-01
updated: 2021-11-05
---

# 第4章 客户端负载均衡Ribbon

## 4.1 Ribbon

### 4.1.1 Ribbon模块

- ribbon-loadbalancer：负载均衡模块，可独立使用，也可以和别的模块一起使 用。Ribbon 内置的负载均衡算法都实现在其中。
- ribbon-eureka：基于Eureka 封装的模块，能够快速、方便地集成 Eureka。
- ribbon-transport：基于 Netty 实现多协议的支持，比如 HTTP、Tcp、Udp 等。
- ribbon-httpclient：基于 Apache HttpClient 封装的 REST 客户端，集成了负载均衡模块，可以直接在项目中使用来调用接口。
- ribbon-example：Ribbon 使用代码示例，通过这些示例能够让你的学习事半功倍。
- ribbon-core：一些比较核心且具有通用性的代码，客户端 API 的一些配置和其他 API 的定义。

### 4.1.2 Ribbon使用

**示例 - 单独使用 Ribbon：** *ribbon-native-demo*

- 启动多个 *ch-3/eureka-client-user-service*。

- 依赖：

  ```xml
  <dependency>
      <groupId>com.netflix.ribbon</groupId>
      <artifactId>ribbon</artifactId>
  </dependency>
  <dependency>
      <groupId>com.netflix.ribbon</groupId>
      <artifactId>ribbon-loadbalancer</artifactId>
  </dependency>
  <!-- 下面会传递依赖 -->
  <dependency>
      <groupId>com.netflix.ribbon</groupId>
      <artifactId>ribbon-core</artifactId>
  </dependency>
  <dependency>
      <groupId>io.reactivex</groupId>
      <artifactId>rxjava</artifactId>
  </dependency>
  ```

- 调用 *RibbonTest#main*：

  ```java
  // 服务列表
  List<Server> serverList = Arrays.asList(new Server("localhost", 8081), new Server("localhost", 8083));
  // 构建负载实例
  BaseLoadBalancer loadBalancer = LoadBalancerBuilder.newBuilder().buildFixedServerListLoadBalancer(serverList);
  // 负载均衡策略
  loadBalancer.setRule(new RoundRobinRule());
  // 调用5次来测试效果
  for (int i = 0; i < 5; i++) {
      // 负载命令
      LoadBalancerCommand<String> loadBalancerCommand = LoadBalancerCommand<String>builder().withLoadBalancer(loadBalancer).build();
      // 调用
      String result = loadBalancerCommand.submit(server -> {
          String addr = "http://" + server.getHost() + ":" + server.getPort() + "/user/hello";
          ...
          return Observable.just(new String(data));
      }),toBlocking().first();
  }
  ```

## 4.2 RestTemplate结合Ribbon使用

### 4.2.1 使用RestTemplate与整合Ribbon

**示例：** *spring-rest-template*。

**RestTemplate：**

- GET：

  ```java
  <T> T getForObject(String url, Class<T> responseType, Object... uriVariables)
  <T> T getForObject(String url, Class<T> responseType, Map<String, ?> uriVariables);
  <T> T getForObject(URI url, Class<T> responseType);
  
  <T> ResponseEntity<T> getForEntity(String url, Class<T> responseType, Object... uriVariables);
  <T> ResponseEntity<T> getForEntity(String url, Class<T> responseType, Map<String, ?> uriVariables);
  <T> ResponseEntity<T> getForEntity(URI url, Class<T> responseType);
  ```
  - `url`：字符串或 URI。
  - `uriVariables`：PathVariable 参数，可变参数或 Map 两种形式。
  - `getForEntity` 可以返回状态码，请求头等信息，通过 `getBody` 获取响应内容。

- POST：除了类似的 `postForObject` 和 `postForEntity`，还有 `postForLocation`，各三种重载。

- PUT、DELETE：`put` 和 `delete` 各三种重载。

**Ribbon 依赖：**

```xml
<!-- 可以不用依赖，eureka 会传递引入 -->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-ribbon</artifactId>
</dependency>
```

### 4.2.2 RestTemplate负载均衡示例

- `RestTemplate` bean 上注解 `@LoadBalanced`。

### 4.2.3 ＠LoadBalanced注解原理

**示例 - 仿照源码自定义 @MyLoadBalanced：** *ribbon-eureka-demo*。

- `@LoadBalanced`：注解了 `@Qualifier`。

- `LoadBalancerAutoConfiguration`：

  - 注入注解了 `@LoadBalanced` 的 `List<RestTemplate>`。
  - loadBalancedRestTemplateInitializerDeprecated：通过 `RestTemplateCustomizer` 自定义每个 `RestTemplate`。
  - LoadBalancerInterceptorConfig：实际是通过 `ClientHttpRequestInterceptor` 添加拦截器 `restTemplate.setInterceptors`。

- `LoadBalancerInterceptor`：

  ```java
  public ClientHttpResponse intercept(final HttpRequest request, final byte[] body, final ClientHttpRequestExecution execution) {
      String serviceName = originalUri.getHost();
      this.loadBalancer.execute(serviceName, requestFactory.createRequest(request, body, execution));
  }
  ```

### 4.2.4 Ribbon API使用

- `loadBalancerClient.choose("ribbon-eureka-demo")`。

### 4.2.5 Ribbon饥饿加载

**饥饿加载：** 一定程度解决第一次调用超时问题

- `ribbon.eager-load.enabled=true`：开启 Ribbon 饥饿加载模式。
- `ribbon.eager-load.clients=ribbon-eureka-demo`：指定饥饿加载要调用的服务名，多个逗号隔开。

## 4.3 负载均衡策略介绍

- `BestAvailabl`：选择一个最小的并发请求的 Server，逐个考察 Server，如果 Server 被标记为错误，则跳过，然后再选择ActiveRequestCount 中最小的 Server。
- `AvailabilityFilteringRule`：过滤掉那些一直连接失败的且被标记为 circuit tripped 的后端 Server，并过滤掉那些高并发的后端 Server 或者使用一个 AvailabilityPredicate 来包含过滤 Server 的逻辑。其实就是检查 Status 里记录的各个 Server 的运行状态。
- `ZoneAvoidanceRule`：使用 ZoneAvoidancePredicate 和 AvailabilityPredicate 来判断是否选择某个 Server，前一个判断判定一个 Zone 的运行性能是否可用，剔除不可用的 Zone（的所有Server），AvailabilityPredicate 用于过滤掉连接数过多的 Server。
- `RandomRule`：随机选择一个Server。
- `RoundRobinRule`：轮询选择，轮询 index，选择 index 对应位置的 Server。
- `RetryRule`：对选定的负载均衡策略机上重试机制，也就是说当选定了某个策略进行请求负载时在一个配置时间段内若选择 Server 不成功，则一直尝试使用 subRule 的方式选择一个可用的 Server。
- `ResponseTimeWeightedRule`：作用同 WeightedResponseTimeRule，ResponseTimeWeightedRule 后来改名为 WeightedResponseTimeRule。
- `WeightedResponseTimeRule`：根据响应时间分配一个Weight（权重），响应时间越长，Weight 越小，被选中的可能性越低。

## 4.4 自定义负载策略

- 实现 `IRule` 接口。

## 4.5 配置详解

### 4.5.1 常用配置

- 禁用 Eureka：

  ```properties
  ribbon.eureka.enabled=false
  # 禁用 eureka 后不能用服务名，只能手动配置服务地址
  ribbon-config-demo.ribbon.listOfServers=localhost:8081,localhost:8082
  ```

- 配置负载均衡策略：

  ```properties
  ribbon-config-demo.ribbon.NFLoadBalancerRuleClassName=com.cxytiandi.ribbon_eureka_demo.rule.MyRule
  ```

- 超时时间：

  ```properties
  # 请求连接的超时时间
  ribbon.ConnectTimeout=1000
  # 请求处理的超时时间
  ribbon.ReadTimeout=1000
  # 也可以为每个 Ribbon 客户端设置不同的超时时间，前面加上 <clientName>
  ```

- 并发参数：

  ```properties
  # 最大连接数
  ribbon.MaxTotalConnections=500
  # 每个 host 最大连接数
  ribbon.MaxConnectionsPerHost=500
  ```

### 4.5.2 代码配置Ribbon

- 配置负载均衡策略：

  ```java
  @Configuration
  public class BeanConfiguration {
      @Bean     
      public MyRule rule() { 	    
          return new MyRule();     
      }
  }
  ```

- 单独为某个 Ribbon 客户端配置：

  ```java
  @RibbonClient(name = "ribbon-config-demo", configuration = BeanConfiguration.class) 
  public class RibbonClientConfig {
  }
  ```

### 4.5.3 配置文件方式配置Ribbon

略。

## 4.6 重试机制

```properties
# 对当前实例的重试次数
ribbon.maxAutoRetries=1
# 切换实例的重试次数
ribbon.maxAutoRetriesNextServer=3
# 对所有操作请求都进行重试
ribbon.okToRetryOnAll0perations-true
# 对Http响应码进行重试
ribbon.retryableStatusCodes=500,404,502
```

## 4.7 本章小结

略。
