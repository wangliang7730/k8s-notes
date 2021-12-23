---
hidden: true
---

# SpringCloud

## 版本

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-dependencies</artifactId>
      <version>https://mvnrepository.com/artifact/org.springframework.cloud/spring-cloud-dependencies</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
  <dependencies>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-dependencies</artifactId>
      <version>https://mvnrepository.com/artifact/org.springframework.boot/spring-boot-dependencies</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
    <dependency>
      <groupId>com.alibaba.cloud</groupId>
      <artifactId>spring-cloud-alibaba-dependencies</artifactId>
      <version>2.2.5.RELEASE</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>
```

版本相关资源：

- https://start.spring.io

- https://start.spring.io/actuator/info
- https://github.com/spring-cloud/spring-cloud-release/wiki/Spring-Cloud-Hoxton-Release-Notes

##  Eureka

### eureka-server

#### 快速开始

**依赖：**

```xml
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
</dependency>
<!-- deprecated: spring-cloud-starter-eureka-server -->
```

**配置：**

```yaml
spring:
  application:
    name: eureka-server
server:
  port: 8761
eureka:
  server:
    # 是否开启自我保护，默认true
    enable-self-preservation: true
  instance:
    hostname: localhost
    # 心跳间隔时间，默认30s
    lease-renewal-interval-in-seconds: 30
    # 心跳停止多长时间认为挂了，默认90s
    lease-expiration-duration-in-seconds: 90
    # 优先用ip作为主机名，默认false
    prefer-ip-address: false
  client:
    # 是否要注册到服务端，默认true
    register-with-eureka: false
    # 是否要从服务端获取注册信息，默认true
    fetch-registry: false
    # 从服务端获取注册信息间隔，默认30s
    registry-fetch-interval-seconds: 30
    service-url:
      defaultZone: http://${eureka.instance.hostname}:${server.port}/eureka/
```

**代码：**

```java
// Application.java
@EnableEurekaServer
```

#### 高可用

**配置：**

```yaml
spring:
  application:
    name: eureka-server
eureka:
  client:
    # 是否要注册到其他Eureka Server实例
    register-with-eureka: true
    # 是否要从其他Eureka Server实例获取数据
    fetch-registry: true
    service-url:
      defaultZone: http://peer1/eureka/,http://peer2/eureka/
---
spring:
  profiles: peer1
server:
  port: 8761
eureka:
  instance:
    hostname: peer1
---
spring:
  profiles: peer2
server:
  port: 8762
eureka:
  instance:
    hostname: peer2
```

>   **待确定：**Eureka Server 对端口是不敏感的，所以使用使用 host 测试

#### 自我保护

默认情况下（90秒），如果 Eureka Server 在一定时间内没有接收到某个微服务实例的心跳，Eureka Server 将会注销该实例，但此时可能是注册中心自己的问题，微服务并没有问题。通过下面配置开启自我保护模式，Eureka Server 因为异常进入自我保护模式后不会注销这些服务

```properties
eureka.server.enable-self-preservation = true
```

#### 安全

**依赖：**

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

**配置：**

```yaml
spring:
  security:
    user:
      name: user
      password: 123456
# defaultZone: http://user:password123@localhost:8761/eureka/
```

```java
/**
 * Spring Cloud Finchley及更高版本，必须添加如下代码，部分关闭掉Spring Security
 * 的CSRF保护功能，否则应用无法正常注册！
 * ref: http://cloud.spring.io/spring-cloud-netflix/single/spring-cloud-netflix.html#_securing_the_eureka_server
 * @author zhouli
 */
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {
  @Override
  protected void configure(HttpSecurity http) throws Exception {
    http.csrf().ignoringAntMatchers("/eureka/**");
    super.configure(http);
  }
}
```

### eureka-client

#### 快速开始

**依赖：**

```xml
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
<!-- deprecated: spring-cloud-starter-eureka -->
```

**配置：**

```yaml
server:
  port: 8001
spring:
  application:
    name: provider
eureka:
  client:
    service-url:
      defaultZone: http://localhost:8761/eureka/
```

**代码：**

```java
// Application.java
@EnableDiscoveryClient
```

### region 和 zone

region -> zone

### 注意

- 测试的时候把几个间隔时间调小一点，不然等半天
- 不能用 `random.int(8000,8199)`，实际与 Eureka 中显示的不一致
- 用 `0` 作为随机端口，两个实例只会被注册一个 

## Zookeeper

**依赖：**

```xml
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-zookeeper-discovery</artifactId>
</dependency>
```

**配置：**

```properties
spring.cloud.zookeeper.connect-string=192.168.100.101:2181
```

## Consul

```bash
consul agent -dev
```

- http://localhost:8500

```xml
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-consul-discovery</artifactId>
</dependency>
```

```properties
spring.cloud.consul.host=localhost
spring.cloud.consul.port=8500
```

## Nacos

### nacos-server

```bash
# 下载
https://github.com/alibaba/nacos/releases
# 启动
startup.cmd -m standalone
# 主页
http://localhost:8848/nacos/index.html
# 登录
nacos/nacos
```

### nacos-discovery

**依赖：**

```xml
<dependency>
  <groupId>com.alibaba.cloud</groupId>
  <artifactId>spring-cloud-starter-alibaba-nacos-discovery</artifactId>
</dependency>
```

**配置：**

```yaml
spring:
  application:
    name: app
  cloud:
    nacos:
      config:
        server-addr: 127.0.0.1:8848
```

**使用：**

```java
// 不加也能注册
@EnableDiscoveryClient
```

### nacos-config

**依赖：**

```xml
<dependency>
  <groupId>com.alibaba.cloud</groupId>
  <artifactId>spring-cloud-starter-alibaba-nacos-config</artifactId>
</dependency>
```

***bootstrap.properties*：**

```properties
spring.application.name=foo
spring.cloud.nacos.config.server-addr=127.0.0.1:8848
```

**使用：**

```java
// @value 的类上面添加
@RefreshScope
```

**修改：**

新建 Data Id 为 `${spring.application.name}.properties` 的配置，修改即可

#### 更灵活地配置

```properties
# 使用yaml
spring.cloud.nacos.config.file-extension=yaml
# 命名空间
spring.cloud.nacos.config.namespace=b3404bc0-d7dc-4855-b519-570ed34b62d7
# 分组
spring.cloud.nacos.config.group=DEVELOP_GROUP

# 扩展id
# 1、Data Id 在默认的组 DEFAULT_GROUP,不支持配置的动态刷新
spring.cloud.nacos.config.extension-configs[0].data-id=ext-config-common01.properties
# 2、Data Id 不在默认的组，不支持动态刷新
spring.cloud.nacos.config.extension-configs[1].data-id=ext-config-common02.properties
spring.cloud.nacos.config.extension-configs[1].group=GLOBALE_GROUP
# 3、Data Id 既不在默认的组，也支持动态刷新
spring.cloud.nacos.config.extension-configs[2].data-id=ext-config-common03.properties
spring.cloud.nacos.config.extension-configs[2].group=REFRESH_GROUP
spring.cloud.nacos.config.extension-configs[2].refresh=true
```

## Ribbon

**依赖：**

```xml
<!-- spring-cloud-starter-netflix-eureka-client 中已存在，可不引入 -->
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-netflix-ribbon</artifactId>
</dependency>
```

**使用：**

```java
@Bean
@LoadBalanced
public RestTemplate restTemplate() {
  return new RestTemplate();
}

// 调用时自动负载均衡，http不能少
@GetMapping("hello")
public String hello() {
  return restTemplate.getForObject("http://provider/hello", String.class);
}
```

### 负载均衡策略

```java
@RibbonClient(name = "服务名", configuration = RibbonConfiguration.class)

@Configuration
public class RibbonConfiguration {
  @Bean
  public IRule ribbonRule() {
    // 负载均衡规则，改为随机
    return new RandomRule();
  }
}
```

## OpenFeign

**依赖：**

```xml
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>
```

**使用：**

```java
@EnableFeignClients(basePackages = "包名")

@FeignClient("服务名")
public interface FooFeignService {
    @RequestMapping("url")
    Foo bar();
}
```

### 打印日志

https://stackoverflow.com/questions/55624692/feign-client-request-and-response-and-url-logging

```text
feign:
  client:
    config:
      default:
        loggerLevel: f
```



### data form

https://stackoverflow.com/questions/35803093/how-to-post-form-url-encoded-data-with-spring-cloud-feign

## Hystrix

### 快速开始

**依赖：**

```xml
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
</dependency>
```

**开启：**

```java
@EnableHystrix
// 老板
@EnableCircuitBreaker
// 或则直接
@SpringCloudApplication
```

**指定回调：**

```java
@HystrixCommand(fallbackMethod="回调方法")
```

### 整合 feign

```yaml
feign:
  hystrix:
    enabled: true
```

```java
@FeignClient(name = "服务名", fallback = FOO.class);
```

### 超时

### 异常

### 限流

### 监控

**依赖：**

```xml
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-netflix-hystrix-dashboard</artifactId>
</dependency>
```

```java
@EnableHystrixDashboard
```

**监控的服务需要设置：**

```properties
management.endpoints.web.exposure.include=hystrix.stream
```

访问：http://localhost:8989/hystrix

填写路径：访问：http://监控的服务/actuator/hystrix.stream

## Zuul

**依赖：**

```xml
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-netflix-zuul</artifactId>
</dependency>
```

**使用：**

```java
@EnableZuulProxy
```

**配置**

```yaml
zuul:
  prefix:
  routes:
    # 转发时会忽略前面
    eureka-service-1.path: /eureka-service-1/**
    eureka-service-1.serviceId: eureka-service-1
```

## Config

*`bootstrap.yml`*

```yaml
spring:
  cloud:
      config:
        discovery:
          enabled:
          service-id:
        profile:
```

- /分支/应用名-环境

## Gateway

**依赖：**

```xml
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-gateway</artifactId>
</dependency>
```

**配置：**

```yaml
spring:
  application:
    name: gateway
  cloud:
    nacos:
      config:
        server-addr: 127.0.0.1:8848
    gateway:
    # 跨域
      globalcors:
        corsConfigurations:
          '[/**]':
            allowedHeaders: "*"
            allowedOrigins: "*"
            allowCredentials: true
            allowedMethods:
              - GET
              - POST
              - DELETE
              - PUT
              - OPTION
      discovery:
        locator:
          # 开启服务名查找
          enabled: true
          # 服务名转小写
          lower-case-service-id: true
      routes:
        - id: foo
          uri: lb://foo
          predicates:
            - Path=/foo/**
          filters:
        		- RewritePath=/foo/var/(?<segment>.*), /foo/$\{segment}
```

## 参考

- [周立 - Spring Cloud系列教程](http://www.itmuch.com/spring-cloud/spring-cloud-index/)
- [Spring Cloud Eureka 自我保护机制](https://www.cnblogs.com/xishuai/p/spring-cloud-eureka-safe.html)
- [spring-cloud-alibaba](https://github.com/alibaba/spring-cloud-alibaba/wiki)

