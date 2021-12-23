# Dubbo

资料：

- https://github.com/zonghaishang/dubbo-samples.git

## 管理控制台

- https://github.com/apache/dubbo-admin/tree/master

```bash
git clone https://github.com/apache/dubbo-admin.git -b master --depth 1
cd dubbo-admin
# 记得修改 zookeeper 地址
mvn package -Dmaven.test.skip=true
cd target
java -jar dubbo-admin-0.0.1-SNAPSHOT.jar
# 7001 root root
```

## 监控中心

```bash
cd dubbo-monitor-simple
# 记得修改 zookeeper 地址
mvn package -Dmaven.test.skip=true
cd target
# 解压 dubbo-monitor-simple-2.0.0-assembly.tar.gz
start
# 8080
```

## 示例：三种配置方式

依赖：

```xml
<properties>
    <dubbo.version>2.7.6</dubbo.version>
</properties>
    
<dependencies>
    <dependency>
        <groupId>org.apache.dubbo</groupId>
        <artifactId>dubbo</artifactId>
        <version>${dubbo.version}</version>
    </dependency>
    <dependency>
        <groupId>org.apache.dubbo</groupId>
        <artifactId>dubbo-dependencies-zookeeper</artifactId>
        <version>${dubbo.version}</version>
        <type>pom</type>
    </dependency>
</dependencies>
```

### 基于 XML 配置

提供方：

```xml
<dubbo:application name="xml-provider"/>
<dubbo:registry address="zookeeper://zookeeper.host:2181"/>
<bean id="helloService" class="sharonlee.learning.dubbo.service.impl.HelloServiceImpl"/>
<dubbo:service interface="sharonlee.dubbo.service.HelloService" ref="helloService"/>
```

```java
ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
context.start();
System.in.read();
```

消费方：

```xml
<dubbo:application name="xml-consumer"/>
<dubbo:registry address="zookeeper://zookeeper.host:2181"/>
<dubbo:reference id="helloService" interface="sharonlee.dubbo.service.HelloService"/>
```

```java
ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("spring.xml");
context.start();
HelloService helloService = context.getBean("helloService", HelloService.class);
System.out.println(helloService.hello());
```

### 基于注解配置

提供方：

```java
// 1. 配置
@Configuration
@EnableDubbo
public class SpringConfig {

  @Bean
  public ProviderConfig providerConfig() {
    return new ProviderConfig();
  }

  @Bean
  public ApplicationConfig applicationConfig() {
    ApplicationConfig applicationConfig = new ApplicationConfig();
    applicationConfig.setName("annotation-provider");
    return applicationConfig;
  }

  @Bean
  public RegistryConfig registryConfig() {
    RegistryConfig registryConfig = new RegistryConfig();
    registryConfig.setProtocol("zookeeper");
    registryConfig.setAddress("zookeeper.host");
    registryConfig.setPort(2181);
    return registryConfig;
  }
}

// 2. 服务实现
@org.apache.dubbo.config.annotation.Service
public class HelloServiceImpl implements HelloService;

// 3. 启动服务
AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(SpringConfig.class);
context.start();
System.in.read();
```

消费方：

```java
// 1. 配置
@Configuration
@EnableDubbo
@ComponentScan
public class SpringConfig {
  @Bean
  public ConsumerConfig consumerConfig() {
    return new ConsumerConfig();
  }

  @Bean
  public ApplicationConfig applicationConfig() {
    ApplicationConfig applicationConfig = new ApplicationConfig();
    applicationConfig.setName("annotation-consumer");
    return applicationConfig;
  }

  @Bean
  public RegistryConfig registryConfig() {
    RegistryConfig registryConfig = new RegistryConfig();
    registryConfig.setProtocol("zookeeper");
    registryConfig.setAddress("zookeeper.host");
    registryConfig.setPort(2181);
    return registryConfig;
  }
}

// 2. 获取引用
@Component
public class ConsumerComponent {
  @org.apache.dubbo.config.annotation.Reference
  public HelloService helloService;
}

// 3. 调用
AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(SpringConfig.class);
context.start();
ConsumerComponent consumerComponent = context.getBean(ConsumerComponent.class);
System.out.println(consumerComponent.helloService.hello());
```

### 基于 Java API 配置

提供方：

```java
ServiceConfig<HelloService> service = new ServiceConfig<>();
service.setApplication(new ApplicationConfig("java-provider"));
service.setRegistry(new RegistryConfig("zookeeper://zookeeper.host:2181"));
service.setInterface(HelloService.class);
service.setRef(new HelloServiceImpl());
service.export();
System.in.read();
```

消费方：

```java
ReferenceConfig<HelloService> reference = new ReferenceConfig<>();
reference.setApplication(new ApplicationConfig("java-consumer"));
reference.setRegistry(new RegistryConfig("zookeeper://zookeeper.host:2181"));
reference.setInterface(HelloService.class);
HelloService helloService = reference.get();
System.out.println(helloService.hello());
```

## 属性配置

- 默认加载 `dubbo.properties`
- 标签名[.id].属性名

优先级从高到低：

![](http://dubbo.apache.org/docs/zh-cn/user/sources/images/dubbo-properties-override.jpg)

## 注册中心

### Zookeeper 注册中心

![](http://dubbo.apache.org/docs/zh-cn/user/sources/images/zookeeper.jpg)

- /组名/服务名/providers|consumers|routers|configurators

### Redis 注册中心

![](http://dubbo.apache.org/docs/zh-cn/user/sources/images/dubbo-redis-registry.jpg)

## SPI

- META-INF/services|dubbo|internal 下放置配置文件
- 配置文件内容为 key=实现类

```java
ExtensionLoader<Robot> extensionLoader = ExtensionLoader.getExtensionLoader(Robot.class);
Robot optimusPrime = extensionLoader.getExtension("optimusPrime");
optimusPrime.sayHello();
Robot bumblebee = extensionLoader.getExtension("bumblebee");
bumblebee.sayHello();
```

### 扩展点特性

- 自动包装
- 自动加载
- 自适应：@Adaptive
- 自动激活：@Active

## 整合 SpringBoot

依赖：

```xml
<properties>
  <spring-boot.version>2.2.6.RELEASE</spring-boot.version>
  <dubbo.version>2.7.6</dubbo.version>
</properties>

<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-dependencies</artifactId>
      <version>${spring-boot.version}</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
    <dependency>
      <groupId>org.apache.dubbo</groupId>
      <artifactId>dubbo-dependencies-bom</artifactId>
      <version>${dubbo.version}</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>

<dependencies>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter</artifactId>
    </dependency>
    <dependency>
      <groupId>org.apache.dubbo</groupId>
      <artifactId>dubbo-spring-boot-starter</artifactId>
      <version>${dubbo.version}</version>
    </dependency>
    <dependency>
      <groupId>org.apache.dubbo</groupId>
      <artifactId>dubbo-dependencies-zookeeper</artifactId>
      <version>${dubbo.version}</version>
      <type>pom</type>
    </dependency>
</dependencies>
```

```properties
spring.application.name=springboot-provider
dubbo.application.name=${spring.application.name}
dubbo.registry.address=zookeeper://zookeeper.host:2181
```

```java
@EnableDubbo
```

## 启动时检查

```properties
dubbo.reference.check=false # 强制
dubbo.consumer.check=false # 缺省
dubbo.registry.check=false # 注册失败
```

