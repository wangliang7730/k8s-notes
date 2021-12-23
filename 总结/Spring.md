# Spring

## 配置文件头

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:context="http://www.springframework.org/schema/context"
  xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd
		http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.3.xsd">
```

## 数据库配置

```properties
db.url=jdbc:mysql://mysql.host:3306?useSSL=false
db.username=root
db.password=root
db.driverClass=com.mysql.jdbc.Driver
```

> ***druid***

```xml
<context:property-placeholder location="classpath:db.properties" />

<!-- druid 数据源 -->
<bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource">
  <property name="url" value="${db.url}"></property>
  <property name="username" value="${db.username}"></property>
  <property name="password" value="${db.password}"></property>
  <property name="driverClassName" value="${db.driver}"></property>
</bean>
```

## 事务

```xml
<!-- 事务管理器 -->
<bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
  <property name="dataSource" ref="dataSource"></property>
</bean>

<!-- 事务属性 -->
<tx:advice id="txAdvice" transaction-manager="transactionManager">
  <tx:attributes>
    <tx:method name="get*" read-only="true" />
    <tx:method name="list*" read-only="true" />
    <tx:method name="count*" read-only="true" />
    <tx:method name="insert*" propagation="REQUIRES_NEW" rollback-for="java.lang.Exception" />
    <tx:method name="save*" propagation="REQUIRES_NEW" rollback-for="java.lang.Exception" />
    <tx:method name="update*" propagation="REQUIRES_NEW" rollback-for="java.lang.Exception" />
    <tx:method name="delete*" propagation="REQUIRES_NEW" rollback-for="java.lang.Exception" />
    <tx:method name="remove*" propagation="REQUIRES_NEW" rollback-for="java.lang.Exception" />
  </tx:attributes>
</tx:advice>

<!-- 事务切面 -->
<aop:config>
  <aop:pointcut expression="execution(* sharon.lee.atguigu.crowd.service.*Service.*(..))" id="txPointCut" />
  <aop:advisor advice-ref="txAdvice" pointcut-ref="txPointCut" />
</aop:config>

<!-- 注解事务 -->
<tx:annotation-driven transaction-manager="transactionManager" />
```

## 参考

- https://repo.spring.io