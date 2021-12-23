---
date: 2021-11-01
updated: 2021-11-12
---

# 第10章 分布式配置中心Apollo

## 10.1 Apollo简介

- Github 地址：<https://github.com/apolloconfig/apollo/>。

## 10.2 Apollo的核心功能点

略。

## 10.3 Apollo核心概念

- 应用、环境、集群、命名空间、权限控制。

## 10.4 Apollo本地部署

- <https://github.com/nobodyiam/apollo-build-scripts>。
- 'hibernate.dialect' not set：`useSSL=false`。
- `apollo`/`admin`。

## 10.5 Apollo Portal管理后台使用

略。

## 10.6 Java中使用Apollo

### 10.6.1 普通Java项目中使用

**示例：** *apollo-java*

- 依赖：

  ```xml
  <dependency>
      <groupId>com.ctrip.framework.apollo</groupId>
      <artifactId>apollo-client</artifactId>
      <version>1.1.0</version>
  </dependency>
  ```

- 在 `META-INF/app.properties` 配置：

  ```properties
  apollo.meta=http://localhost:8080
  app.id=SampleApp
  ```

- 设置环境：

  ```java
  System.setProperty("env", "DEV");
  ```

- 配置类：

  ```java
  Config config = ConfigService.getAppConfig();
  config.addChangeListener;
  config.getProperty;
  ```

### 10.6.2 Spring Boot中使用

**示例：** *apollo-springboot*

- 依赖：和普通 Java 项目一样。

- 配置：*application.properties*

  ```properties
  app.id=SampleApp
  apollo.meta=http://localhost:8080
  apollo.bootstrap.enabled=true
  apollo.bootstrap.namespaces=application
  ```

- `@Value` 会更新，`@ConfigurationProperties` 不会更新。

- 注入 Config：

  ```java
  @ApolloConfig
  private Config config;
  ```

- 监听：

  ```java
  @ApolloConfigChangeListener
  private void someOnChange(ConfigChangeEvent changeEvent);
  ```

- Json 属性：

  ```java
  @ApolloJsonValue("${stus:[]}")
  private List<Student> stus;
  ```

## 10.7 Apollo的架构设计

### 10.7.1 Apollo架构设计介绍

略。

### 10.7.2 Apollo服务端设计

略。

### 10.7.3 Apollo客户端设计

略。

### 10.7.4 Apollo高可用设计

略。

## 10.8 本章小结

略。
