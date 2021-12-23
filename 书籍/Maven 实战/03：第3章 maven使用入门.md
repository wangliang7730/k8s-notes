---
date: 2021-09-29
updated: 2021-12-22
---

# 第3章 Maven 使用入门

## 3.1 编写 POM

`ch-3/hello-world/pom.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                             http://maven.apache.org/maven-v4_0_0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.juvenxu.mvnbook</groupId>
    <artifactId>hello-world</artifactId>
    <version>1.0-SNAPSHOT</version>
    <name>Maven Hello World Project</name>
</project>
```

推荐为每个 POM 声明 name。

## 3.2 编写主代码

使用 Maven 进行编译：

```shell
mvn clean compile
```

## 3.3 编写测试代码

添加 JUnit 依赖：

```xml
<dependencies>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>4.7</version>
        <scope>test</scope>
    </dependency>
</dependencies>
```

调用 Maven 执行测试：

```shell
mvn clean test
```

设置 Compiler 插件编译的版本：

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <configuration>
        <source>1.8</source>
        <target>1.8</target>
    </configuration>
</plugin>
```

## 3.4 打包和运行

打包，可以使用 finalName 定义 jar 包的名称：

```shell
mvn clean package
```

让其他项目引用这个 jar，需要安装：

```shell
mvn clean install
```

生成可执行 jar 包，借助 maven-shade-plugin：

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-shade-plugin</artifactId>
    <version>1.2.1</version>
    <executions>
        <execution>
            <phase>package</phase>
            <goals>
                <goal>shade</goal>
            </goals>
            <configuration>
                <transformers>
                    <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                        <mainClass>com.juvenxu.mvnbook.helloworld.HelloWorld</mainClass>
                    </transformer>
                </transformers>
            </configuration>
        </execution>
    </executions>
</plugin>
```

执行该 jar 文件：

```shell
ch-3\hello-world> java -jar target\hello-world-1.0-SNAPSHOT.jar
Hello Maven
```

## 3.5 使用 Archetype 生成项目骨架

```shell
mvn archetype:generate
```

## 3.6 m2eclipse 简单使用

### 3.6.1 导入 Maven 项目

略。

### 3.6.2 创建 Maven 项目

略。

### 3.6.3 运行 mvn 命令

略。

## 3.7 Netbeans Maven 插件简单使用

### 3.7.1 打开 Maven 项目

略。

### 3.7.2 创建 Maven 项目

略。

### 3.7.3 运行 mvn 命令

略。

## 3.8 小结

略。
