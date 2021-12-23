---
title: 第8章 MyBatis插件开发
hidden: true
date: 2021-09-26
updated: 2021-09-26
---

# 第8章 MyBatis插件开发

| 💡 **拦截器可以拦截的方法** |
| -------------------------- |

MyBatis 允许使用插件来拦截的接口和方法包括以下几个：

-   `Executor(update、query、flushStatements、commit、rollback、getTransaction、close、isClosed)`
-   `ParameterHandler(getParameterObject、setParameters)`
-   `ResultSetHandler(handleResultSets、handleCursorResultSets、handleOutputParameters)`
-   `StatementHandler(prepare、parameterize、batchupdate、query)`

## 8.1 拦截器接口介绍

| 💡 **拦截器的使用** |
| ------------------ |

拦截器接口：

```java
public interface Interceptor {
    Object intercept(Invocation invocation) throws Throwable;
    Object plugin(Object target);
    void setProperties(Properties properties);
}
```

拦截器配置：

```xml
<plugins>
    <plugin interceptor="tk.mybatis.simple.plugin.XXXInterceptor">
        <property name="prop1" value="value1"/>
        <property name="prop2" value="value2"/>
    </plugin>
</plugins>
```

返回拦截对象：

```java
// target 就是拦截器要拦截的对象
public Object plugin(Object target) {
    // 只有匹配的情况下才会使用动态代理拦截目标对象
    return Plugin.wrap(target, this);
}
```

拦截方法：

```java
@Override
public Object intercept(Invocation invocation) throws Throwable {
    Object target = invocation.getTarget();
    Method method = invocation.getMethod();
    Object[] args = invocation.getArgs();
    Object result = invocation.proceed();
    return result;
}
```

执行顺序：C>B>A>target.proceed()>A>B>C 

## 8.2 拦截器签名介绍

以拦截 `ResultSetHandler` 接口的 `handleResultSets` 方法为例，配置签名如下：

```java
@Intercepts ({
    @Signature (
        type = ResultSetHandler.class,
        method = "handleResultSets",
        args = {Statement.class})
})
public class ResultSetInterceptor implements Interceptor
```

`@Signature` 注解包含以下三个属性：

-   type：设置拦截的接口，可选值是前面提到的 4 个接口。
-   method：设置拦截接口中的方法名，可选值是前面 4 个接口对应的方法，需要和接口匹配。
-   args：设置拦截方法的参数类型数组，通过方法名和参数类型可以确定唯一一个方法。

### 8.2.1 Executor接口

### 8.2.2 ParameterHandler接口

### 8.2.3 ResultSetHandler接口

### 8.2.4 StatementHandler接口

## 8.3 下画线键值转小写驼峰形式插件

| ⌨ **示例：下划线转驼峰插件** |
| ---------------------------- |

`CameHumpInterceptor`：

```java
@Intercepts(
    @Signature(type = ResultSetHandler.class, method = "handleResultSets", args = {Statement.class})
)
public class CameHumpInterceptor implements Interceptor {
    ...
}
```

配置 `mybatis-config.xml`：

```xml
<plugin interceptor="tk.mybatis.simple.plugin.CameHumpInterceptor"/>
```

## 8.4 分页插件

| ⌨ **PageInterceptor** ⏱ |
| ----------------------- |

### 8.4.1 PageInterceptor拦截器类

### 8.4.2 Dialect接口

### 8.4.3 MySqlDialect实现

## 8.5 本章小结
