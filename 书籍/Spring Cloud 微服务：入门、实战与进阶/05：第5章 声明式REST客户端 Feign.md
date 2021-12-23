---
date: 2021-11-01
updated: 2021-11-05
---

# 第5章 声明式REST客户端 Feign

## 5.1 使用Feign调用服务接口

### 5.1.1 在Spring Cloud中集成Feign

- 依赖：

  ```xml
  <dependency>
      <groupId>org.springframework.cloud</groupId>
      <artifactId>spring-cloud-starter-openfeign</artifactId>
  </dependency>
  ```

- 启用：`@EnableFeignClients(basePackages = "")`。

### 5.1.2 使用Feign调用接口

- `@FeignClient("<service-name>")`

## 5.2 自定义Feign的配置

### 5.2.1 日志配置

**日志等级：**

- NONE：不输出日志。
- BASIC：只输出请求方法的 URL 和响应的状态码以及接口执行的时间。
- HEADERS：将 BASIC 信息和请求头信息输出。
- FULL：输出完整的请求信息。

```java
@Bean
Logger.Level feignLoggerLevel() {
    return Logger.Level.FULL;
}
```

- 在 Feign Client 中指定配置类：`@FeignClient(value="xxx", configuration=FeignConfiguration.class)`。
- 配置文件中设置日志级别：`logging.level.类地址=DEBUG`。

### 5.2.2 契约配置

- 原生的 Feign 不支持 Spring MVC 注解，不过 Spring Cloud 中默认配置了 SpringMVCContract。
- 配置类：FeignClientsConfiguration。

### 5.2.3 Basic认证配置

- `BasicAuthRequestInterceptor`。
- 自定义拦截器：`RequestInterceptor`。

### 5.2.4 超时时间配置

- `Request.Options(int connectTimeoutMillis, int readTimeoutMillis)`。

### 5.2.5 客户端组件配置

- 引入依赖。

- 配置是否启用：

  ```properties
  feign.httpclient.enabled=false 
  feign.okhttp.enabled=true
  ```

- 配置类：FeignAutoConfiguration。

### 5.2.6 GZIP压缩配置

- 配置：

  ```properties
  feign.compression.request.enabled=true
  feign.compression.response.enabled=true
  feign.compression.request.mime-types=text/xml,application/xml,application/json
  feign.compression.request.min-request-size=2048
  ```

- 配置类：FeignAcceptGzipEncodingAutoConfiguration：

  ```java
  // OKHttp3 不生效
  @ConditionalOnMissingBean(type = "okhttp3.OkHttpClient")
  ```

### 5.2.7 编码器解码器配置

- 配置类：FeignClientsConfiguration：

  ```java
  @Bean
  @ConditionalOnMissingBean
  public Decoder feignDecoder() {
      return new OptionalDecoder(new ResponseEntityDecoder(new SpringDecoder(this.messageConverters)));
  }
  
  @Bean
  @ConditionalOnMissingBean
  public Encoder feignEncoder() {
      return new SpringEncoder(this.messageConverters);
  }
  ```

### 5.2.8 使用配置自定义Feign的配置

**使用配置文件配置：**

```properties
# 链接超时时间
feign.client.config.feignName.connectTimeout=5000
# 读取超时时间
feign.client.config.feignName.readTimeout-5000
# 日志等级
feign.client.config.feignName.loggerLevel=fu11
# 重试
feign.client.config.feignName.retryer=com.example.SimpleRetryer
# 拦截器
feign.client.config.feignName.requestInterceptors[0]=com.example.FooRequestInterceptor
feign.client.config.feignName.requestInterceptors[1]=com.example.BarRequestInterceptor
# 编码器
feign.client.config.feignName.encoder=com.example.SimpleEncoder
# 解码器
feign.client.config.feignName.decoder=com.example.SimpleDecoder
# 契约
feign.client.config.feignName.contract=com.example.SimpleContract
```

### 5.2.9 继承特性

**示例：** *feign-inherit-provide*、*feign-inherit-consume*

- 服务提供者 Controller 实现 FeignClient，消费者调用 FeignClient。

### 5.2.10 多参数请求构造

- GET：`@RequestParam("name") String name` 或 `@RequestParam Map<String, Object> params`。
- POST：`@RequestBody`。

## 5.3 脱离Spring Cloud使用Feign

**示例：** *feign-native-demo*。

### 5.3.1 原生注解方式

- GET：

  ```java
  interface GitHub {
      @RequestLine("GET /repos/{owner}/{repo}/contributors")
      List<Contributor> contributors (@Param("owner") String owner, @Param("repo") String repo);
  }
  ```

- POST：

  ```java
  interface Bank {
      @RequestLine( "POST /account/{id}")
      Account getAccountInfo(@Param("id") String id);
  }
  ```

- 请求头：`@Header("Content-Type: application/json")`。

- 请求体：`@Body("...")`。

### 5.3.2 构建Feign对象

- 构建 Feign 客户端：

  ```java
  public static <T> T getRestClient(Class<T> apiType, String url) {
      return Feign.builder().target(apiType, url);
  }
  ```

### 5.3.3 其他配置

```java
Feign.builder().encoder(new JacksonEncoder())
    .decoder(new JacksonDecoder())
    .logger(new Logger.JavaLogger().appendToFile())
    .logLevel()
    .options(new Request.Options())
    .requestInterceptor()
    .client()
    .retryer()
```

## 5.4 本章小结

略。
