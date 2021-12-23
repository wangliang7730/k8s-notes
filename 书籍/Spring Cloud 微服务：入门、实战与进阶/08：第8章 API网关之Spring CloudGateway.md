---
date: 2021-11-01
updated: 2021-11-11
---

# 第8章 API网关之Spring CloudGateway

## 8.1 Spring Cloud Gateway介绍

略。

## 8.2 Spring Cloud Gateway工作原理

略。

## 8.3 Spring Cloud Gateway快速上手

### 8.3.1 创建Gateway项目

- 依赖：不要添加注解

  ```xml
  <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-gateway</artifactId>
  </dependency>
  ```

### 8.3.2 路由转发示例

```yaml
spring:
  cloud:
    gateway:
      - id: path_route
        uri: http://cxytiandi.com
        predicates:
        - Path=/course
      - id: path_route2
        uri: http://cxytiandi.com
        predicates:
        - Path=/blog/**
```

### 8.3.3 整合Eureka路由

```yaml
- id: user-service
  uri: lb://eureka-client-user-service
  predicates:
  - Path=/user-service/**
  filters:
  - StripPrefix=1
```

### 8.3.4 整合Eureka的默认路由

**服务默认路由：**

```yaml
spring:
  cloud:
    gateway:
      discovery:
        locator:
          enabled: true
          # 默认大写，大小写只能选一个
          lowerCaseServiceId: true
```

## 8.4 Spring Cloud Gateway路由断言工厂

### 8.4.1 路由断言工厂使用

- Path、Query、Method、Header。

### 8.4.2 自定义路由断言工厂

**示例：** `CheckAuthRoutePredicateFactory`

- 继承 `AbstractRoutePredicateFactory`，名称以 RoutePredicateFactory 结尾，配置用除去这部分的名称。

## 8.5 Spring Cloud Gateway过滤器工厂

### 8.5.1 Spring Cloud Gateway过滤器工厂使用

- AddRequestHeader、RemoveRequestHeader、SetStatus、RedirectTo。

### 8.5.2 自定义Spring Cloud Gateway过滤器工厂

**示例：** `CheckAuth2GatewayFilterFactory`、`CheckAuthGatewayFilterFactory`

- 继承 `AbstractGatewayFilterFactory`。
- keyvalue 配置可以继承 `AbstractNameValueGatewayFilterFactory`。

## 8.6 全局过滤器

- 实现 `GlobalFilter`。

## 8.7 实战案例

### 8.7.1 限流实战

- 依赖：

  ```xml
  <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-data-redis-reactive</artifactId>
  </dependency>
  ```

- 实现 `KeyResolver`。

- 配置：

  ```yaml
  filters:
  - name: RequestRateLimiter
    args:
      redis-rate-limiter.replenishRate: 10
      redis-rate-limiter.burstCapacity: 20
      key-resolver: "#{@ipKeyResolver}"
  ```

### 8.7.2 熔断回退实战

- 配置：

  ```yaml
  filters:
  - name: Hystrix
    args:
      name: fallbackcmd
      fallbackUri: forward:/fallback
  ```

### 8.7.3 跨域实战

- 代码方式：`CorsConfig`。

- 配置方式：

  ```yaml
  spring:
    cloud:
      gateway:
        globalcors:
          corsConfigurations:
            '[/**]':
              allowedOrigins: "*"
              exposedHeaders:
              - content-type
              allowedHeaders:
              - content-type
              allowCredentials: true
              allowedMethods:
              - GET
              - OPTIONS
              - PUT
              - DELETE
              - POST
  ```


### 8.7.4 统一异常处理

**示例：** `ErrorHandlerConfiguration`

- 不能直接使用 `@ControllerAdvice`，需要自定义。
- `JsonExceptionHandler` 继承自 `DefaultErrorWebExceptionHandler`。
- 返回 JSON 而不是 HTML，覆盖方法 `getRoutingFunction`。

### 8.7.5 重试机制

```yaml
filters:
- name: Retry
  args:
    retries: 3
    series: SERVER_ERROR
    statuses: 500
    methods: GET
    exceptions: java.io.IOException
```

## 8.8 本章小结

略。
