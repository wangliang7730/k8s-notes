# MyBatis-Plus

## 日志

```properties
log4j.logger.sharonlee.learning.mybatisplus.mapper=DEBUG
```

## 整合 Spring

```xml
<bean class="com.baomidou.mybatisplus.extension.spring.MybatisSqlSessionFactoryBean">
  <property name="dataSource" ref="dataSource"/>
  <property name="typeAliasesPackage" value="sharonlee.learning.mybatisplus.entity"/>
  <!-- 全局配置 -->
  <property name="globalConfig"/>
</bean>

<bean class="org.mybatis.spring.mapper.MapperScannerConfigurer">
  <property name="basePackage" value="sharonlee.learning.mybatisplus.mapper"/>
</bean>
```

## 注解

```java
@TableName;

@TableId;
	type

@TableField;
	exist
```

## 条件构造器

## 代码生成器

## 源码

```java
class ISqlInjector;
```

## ActiveRecord

```java
class Employee extends Model<Employee>;
```

## 插件

- 逻辑删除

- 分页插件：PaginationInterceptor
- 性能分析插件：PerformanceInterceptor
- 乐观锁插件：OptimisticLockerInterceptor，@Version