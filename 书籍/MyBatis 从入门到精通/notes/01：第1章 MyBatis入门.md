---
title: 第1章 MyBatis入门
hidden: true
date: 2021-09-26
updated: 2021-09-27
---

# 第1章 MyBatis入门

## 1.1 MyBatis简介

[MyBatis 官方 GitHub](https://www.github .com/mybatis ) 中有多个子项目：

-   [mybatis-3](https://github.com/mybatis/mybatis-3)：MyBatis 源码
-   [generator](https://github.com/mybatis/generator)：代码生成器
-   [ehcache-cache](https://github.com/mybatis/ehcache-cache)：默认集成 Ehcache 的缓存实现
-   [redis-cache](https://github.com/mybatis/redis-cache)：默认集成 Redi s 的缓存实现
-   [spring](https://github.com/mybatis/spring)：方便和 Spring 集成的工具类
-   [mybatis-spring-boot](https://github.com/mybatis/mybatis-spring-boot)：方便和 Spring Boot 集成的工具类

## 1.2 创建Maven项目

## 1.3 简单配置让MyBatis跑起来

| ⌨ **入门示例** |
| -------------- |

### 1.3.1 准备数据库

```shell
create database mybatis;
```

-   `数据库结构.sql`

### 1.3.2 配置MyBatis

`mybatis-config.xml`：

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <settings>
        <setting name="logImpl" value="SLF4J"/>
    </settings>
    
     <typeAliases>
        <package name="tk.mybatis.simple.model"/>
    </typeAliases>

    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC">
                <property name="" value=""/>
            </transactionManager>
            <dataSource type="UNPOOLED">
                <property name="driver" value="com.mysql.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://localhost:3306/mybatis?useSSL=false"/>
                <property name="username" value="root"/>
                <property name="password" value="root"/>
            </dataSource>
        </environment>
    </environments>

    <mappers>
        <mapper resource="tk/mybatis/simple/mapper/CountryMapper.xml"/>
    </mappers>
</configuration>
```

### 1.3.3 创建实体类和Mapper.xml文件

`CountryMapper.xml`：

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" 
					"http://mybatis.org/dtd/mybatis-3-mapper.dtd" >
<mapper namespace="tk.mybatis.simple.mapper.CountryMapper">
	<select id="selectAll" resultType="Country">
		select id,countryname,countrycode from country
	</select>
</mapper>
```

### 1.3.4 配置Log4j以便查看MyBatis操作数据库的过程

`log4j.properties`：

```properties
#全局配置
log4j.rootLogger=ERROR, stdout

#MyBatis 日志配置
log4j.logger.tk.mybatis.simple.mapper=TRACE

#控制台输出配置
log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%5p [%t] - %m%n
```

>   🙋‍♂️ **使用 LogBack：**
>
>   我改为了 `logback.xml`：
>
>   ```xml
>   <configuration>
>       <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
>           <withJansi>false</withJansi>
>           <encoder>
>               <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%magenta(%thread)] --- %highlight(%-5level) %cyan(%-40.40logger{39}) : %msg%n</pattern>
>           </encoder>
>       </appender>
>   
>       <root level="TRACE">
>           <appender-ref ref="STDOUT" />
>       </root>
>   </configuration>
>   ```

### 1.3.5 编写测试代码让MyBatis跑起来

```java
Reader reader = Resources.getResourceAsReader("mybatis-config.xml");
SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
reader.close();

SqlSession sqlSession = sqlSessionFactory.openSession();
try {
  List<Country> countryList = sqlSession.selectList("selectAll");
} finally {
  sqlSession.close();
}
```

## 1.4 本章小结

