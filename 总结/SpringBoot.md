---
hidden: true
---

# SpringBoot

## 起步

*`pom.xml`*

```xml
<parent>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-parent</artifactId>
  <version>2.1.3.RELEASE</version>
  <relativePath/>
</parent>
<modelVersion>4.0.0</modelVersion>

<artifactId>springboot01-starting</artifactId>

<!-- web -->
<dependencies>
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
  </dependency>
</dependencies>

<build>
  <plugins>
    <!-- springboot maven 插件 -->
    <plugin>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-maven-plugin</artifactId>
    </plugin>
  </plugins>
</build>
```

或者下面这样引入：

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <!-- Import dependency management from Spring Boot -->
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>2.2.5.RELEASE</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

***应用事件***

```java
public class MyApplicationListener implements ApplicationListener {
  @Override
  public void onApplicationEvent(ApplicationEvent event) {
    System.out.println(event);
  }
}
```

1. ContextRefreshedEvent
2. ServletWebServerInitializedEvent
3. ApplicationStartedEvent
4. ApplicationReadyEvent

## 启动后打印信息

### SpringBoot 1

```java
@SpringBootApplication
@Slf4j
public class Application implements ApplicationListener<EmbeddedServletContainerInitializedEvent> {
    public static void main(String[] args) {
        SpringApplication.run(Application.class);
    }

    @SneakyThrows
    @Override
    public void onApplicationEvent(EmbeddedServletContainerInitializedEvent event) {
        EmbeddedServletContainer servletContainer = event.getEmbeddedServletContainer();
        String ip = InetAddress.getLocalHost().getHostAddress();
        int port = servletContainer.getPort();
        String contextPath = event.getApplicationContext().getServletContext().getContextPath();
        if (contextPath == null) {
            contextPath = "";
        }
        log.info("\n---------------------------------------------------------\n" +
                "       Application is running! Access address:\n" +
                "       Local:      http://localhost:{}{}\n" +
                "       External:   http://{}:{}{}\n" +
                "---------------------------------------------------------\n", port, contextPath, ip, port, contextPath);
    }
}
```

### SpringBoot 2

```java
@Slf4j
@SpringBootApplication
public class MyApplication implements ApplicationListener<WebServerInitializedEvent> {
    public static void main(String[] args) {
        SpringApplication.run(ArrangingCoursesApplication.class, args);
    }

    @SneakyThrows
    @Override
    public void onApplicationEvent(WebServerInitializedEvent event) {
        WebServer server = event.getWebServer();
        WebServerApplicationContext context = event.getApplicationContext();
        Environment env = context.getEnvironment();
        String ip = InetAddress.getLocalHost().getHostAddress();
        int port = server.getPort();
        String contextPath = env.getProperty("server.servlet.context-path");
        if (contextPath == null) {
            contextPath = "";
        }
        log.info("\n---------------------------------------------------------\n" +
                "       Application is running! Access address:\n" +
                "       Local:      http://localhost:{}{}\n" +
                "       External:   http://{}:{}{}\n" +
                "---------------------------------------------------------\n", port, contextPath, ip, port, contextPath);
    }
}
```

## 配置

*`pom.xml`*

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-configuration-processor</artifactId>
</dependency>
```

```java
@PropertySource("classpath:xx.properties") // 指定配置文件
@ConfigurationProperties(prefix="xx") // 自动绑定配置，需要 @Component 加入到容器，
@EnableConfigurationProperties // 加载需要使用这个属性类上面，属性类不用手动加入容器了
```

### yaml

```yaml
# 双引号会转义
s: a\na
s1: "a\na"
s2: 'a\na'
# 对象和 map 两种方式
o1:
	p: 1
o2: {p:1}
# 数组两种方式
a1:
	- 1
	- 2
a2: [1, 2]
# 变量名可以 - 隔开
# 可以用 spel 表达式
# : 指定默认
--- # profle
spring:
	profiles: dev
```

### 配置文件加载顺序

部分，高到低：

- `file:./config/`
- `file:./`
- `classpath:/config/`
- `classpath:/`

## 测试

```java
@RunWith(SpringRunner.class)
@SpringBootTest
@AutoConfigureMockMvc
public class HelloControllerTest {

  @Autowired
  private MockMvc mockMvc;

  @Test
  public void testHello() throws Exception {
    mockMvc.perform(MockMvcRequestBuilders.get("/hello").accept(MediaType.APPLICATION_JSON))
        .andExpect(status().isOk())
        .andExpect(content().string(equalTo("foo")));
  }
}
```

## 日志

参考：

- https://blog.csdn.net/yangzl2008/article/details/81503579

- https://zhuanlan.zhihu.com/p/24272450
- https://zhuanlan.zhihu.com/p/24275518

![](http://www.slf4j.org/images/concrete-bindings.png)

slf4j-api 的实现：

- logback-classic -> logback-core：slf4j  的原生实现
- slf4j-log4j12：用 log4j 实现，12 指 log4j 的 1.2 版本
- slf4j-jdk14：用 jul 实现，14 指 jul 1.4 版本

- log4j-slf4j-impl：上图未画出，log4j 2 的实现

![](http://www.slf4j.org/images/legacy.png)

已有的日志框转换为 slf4j：

- jcl-over-slf4j：commons logging 转换，同样包名换实现
- log4j-over-slf4j：log4j 转换，同样包名换实现
- jul-to-slf4j：jul 转换，SLF4JBridgeHandler 实现 jul 的 root logger handler
- log4j-to-slf4j：log4j 2 转换， 使用 OSGI SPI 实现 slf4j

> log4j-over-slf4j 和 log4j-to-slf4j，一个是 log4j，一个是 log4j2，这名字取的

![](https://pic2.zhimg.com/v2-57092397ff9d7a69d359856ef19e769d_r.jpg)

***默认日志格式***

```bash
-%clr(%d{${LOG_DATEFORMAT_PATTERN:-yyyy-MM-dd HH:mm:ss.SSS}}){faint} %clr(${LOG_LEVEL_PATTERN:-%5p}) %clr(${PID:- }){magenta} %clr(---){faint} %clr([%15.15t]){faint} %clr(%-40.40logger{39}){cyan} %clr(:){faint} %m%n${LOG_EXCEPTION_CONVERSION_WORD:-%wEx
```

## Mybatis

```properties
# Mybatis
mybatis.mapper-locations=classpath:mapper/*.xml
mybatis.configuration.map-underscore-to-camel-case=true
mybatis.type-aliases-package=sharon.lee.atguigu.gmall.user.entity
```

```java
@MapperScan("sharon.lee.atguigu.gmall.user.mapper")
class ConfigurationCustomizer;
```

### 通用 Mapper

```java
@tk.mybatis.spring.annotation.MapperScan("sharon.lee.atguigu.gmall.user.mapper")
@Table(name = "ums_member")
@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
```

## Web

### 资源映射

```java
public class WebMvcAutoConfiguration {
  private final ResourceProperties resourceProperties;
  addResourceHandlers();
  welcomePageHandlerMapping();
}
public class ResourceProperties {

	private static final String[] CLASSPATH_RESOURCE_LOCATIONS = { "classpath:/META-INF/resources/",
			"classpath:/resources/", "classpath:/static/", "classpath:/public/" };
}
```

### 返回xml

- 实体类添加 @XmlRootElement

- 或者，使用 jackson-dataformat-xml，无需修改代码

### 自定义配置

- WebMvcConfigurerAdapter，spring 5 java 接口可以有默认实现，直接用 WebMvcConfigurer
- 不要加 @EnableMvc，否则 WebMvcAutoConfiguration 会失效，因为 @EnableMvc 会自动注入一个 DelegatingWebMvcConfiguration，继承自 WebMvcConfigurationSupport，而自动配置 @ConditionalOnMissingBean(WebMvcConfigurationSupport.class)

### 国际化

```java
class MessageSourceAutoConfiguration;
class MessageSourceProperties;
  String basename="messages";
  
```

### 错误处理

***错误页面***

```java
class ErrorMvcAutoConfiguration;
class DefaultErrorViewResolver;
class DefaultErrorAttributes;
```

- /error/状态码，或 4xx、5xx

***异常处理***

```java
@ExceptionHandler;
// 请求转发
request.setAttribute("javax.servlet.error.status_code", "500");
return "forward:/error";
// 设置自定义属性
extends DefaultErrorAttributes;
```

### 嵌入式 Servlet 容器

```java
// 注册
class ServletRegistrationBean;
class FilterRegistrationBean;
class ServletListenerRegistrationBean;

// 自定义配置
class ServerProperties;
class WebServerFactoryCustomizer<ConfigurableServletWebServerFactory>;
class WebServerFactoryCustomizerBeanPostProcessor;

// 自动配置
class ServletWebServerFactoryAutoConfiguration;
class ServletWebServerFactoryConfiguration;
class ServletWebServerFactory;
```

### war 包启动

```java
class SpringBootServletInitializer;
```

## Thymeleaf

- 模板里面就是代码

### 引入

```html
<html xmlns:th="http://www.thymeleaf.org">
```

### 配置

```yaml
spring:
  thymeleaf:
    cache: false
    mode: HTML # TemplateMode
```

### 基本

```ini
# 语法
${} # ognl
	 # 内置对象 #request，工具对象 #dates 等
*{} # 可以直接使用 th:object 的属性
#{} # 国际化
@{/url(name=${value},...)} # 方便 url
~{} # 插入片段

# 文本，html，超链接
th:text [[]]
th:utext [()] # 不转义
th:href

# 字符串拼接
a + ${b}
|a${b}|

# 循环
th:each="user:${userList}"

# 判断
th:if

# 引入
th:include="template::fname"
th:fragment="fname"
th:insert="~{template::fname}"
# include 会将 fragment 结点下的内容放在当前结点下
# replace 会将 fragment 整个替换为当前结点
```

***内置对象***

```bash
#ctx #vars #locale
#requst #response #session #servletContext
```

***工具对象***

```bash
#dates #calendars #numbers #objects #arrays #lists #sets #maps
```

## JDBC

```java
// 自动配置
class DataSourceConfiguration;
class DataSourceAutoConfiguration;
class DataSourceProperties;

// 自动执行 schema-*.sql、data-*.sql
class DataSourceInitializationConfiguration;
class DataSourceInitializerInvoker;
class DataSourceInitializer;

// 自定义数据源
@ConfigurationProperties(prefix= "spring.datasource")
@Bean
public DataSource druid() {
  return new DruidDataSource();
}
// StatViewServlet
// WebStatFilter
```

## 启动

```java
class ApplicationContextInitializer;
class SpringApplicationRunListener;
class ApplicationRunner;
class CommandLineRunner;
```

## 监控

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

- /mappings

- /health

  ```java
  class HealthIndicator;
  ```

- /autoconfig

- /beans

- /configprops

- /env

- /info

- /metrics/{name}

  ```java
  class CounterService;
  class GaugeService;
  ```

- /dump

- /shutdown

  ```properties
  endpoints.shutdown.enabled=true # 需要post
  ```

  