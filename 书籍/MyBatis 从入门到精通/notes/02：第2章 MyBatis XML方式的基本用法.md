---
title: 第2章 MyBatis XML方式的基本用法
hidden: true
date: 2021-09-26
updated: 2021-09-27
---

# 第2章 MyBatis XML方式的基本用法

## 2.1 一个简单的权限控制需求

### 2.1.1 创建数据库表

### 2.1.2 创建实体类

## 2.2 使用XML方式

## 2.3 select用法

## 2.4 insert用法

### 2.4.1 简单的insert方法

### 2.4.2 使用JDBC方式返回主键自增的值

| 💡 **返回主键** |
| -------------- |

```xml
<insert id="insert" useGeneratedKeys="true" keyProperty="id">
```

### 2.4.3 使用selectKey返回主键的值

```xml
<!-- MySQL -->
<selectKey keyColumn="id" resultType="long" keyProperty="id" order="AFTER">
  SELECT LAST_INSERT_ID()
</selectKey>

<!-- Oracle -->
<selectKey keyColumn="id" resultType="long" keyProperty="id" order="BEFORE">
  SELECT SEQ_USER.nextval from dual
</selectKey>
```

-   DB2 使用 `VALUES IDENTITY_VAL_LOCAL()`
-   MYSQL 使用 `SELECT LAST_INSERT_ID()`
-   SQLSERVER 使用 `SELECT SCOPE_IDENTITY()`
-   CLOUDSCAPE 使用 `VALUES IDENTITY_VAL_LOCAL()`
-   DERBY 使用 `VALUES IDENTITY_VAL_LOCAL()`
-   HSQLDB 使用 `CALL IDENTITY()`
-   SYBASE 使用 `SELECT @@IDENTITY`
-   DB2_MF 使用 `SELECT IDENTITY_VAL_LOCAL() FROM SYSIBM.SYSDUMMY1`
-   INFORMIX 使用 `select dbinfo('sqlca.sqlerrd1') from systables where tabid=1`

## 2.5 update用法

## 2.6 delete用法

## 2.7 多个接口参数的用法

## 2.8 Mapper接口动态代理实现原理

| 💡 **Mapper 接口代理原理** |
| ------------------------- |

`MyMapperProxy.java`：

```java
public class MyMapperProxy<T> implements InvocationHandler {
    private Class<T> mapperInterface;
    private SqlSession sqlSession;

    public MyMapperProxy(Class<T> mapperInterface, SqlSession sqlSession) {
        this.mapperInterface = mapperInterface;
        this.sqlSession = sqlSession;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        // 针对不同的sql类型，需要调用 sqlSession 不同的方法.
        // 接口方法中的参数也有很多情况，这里只考虑没有有参数的情况
        List<T> list = sqlSession.selectList(mapperInterface.getCanonicalName() + "." + method.getName());
        // 返回值也有很多情况，这里不做处理直接返回
        return list;
    }
}
```

测试：

```java
public class MyMapperProxyTest extends BaseMapperTest {
    @Test
    public void test() {
        SqlSession sqlSession = getSqlSession();
        try {
            MyMapperProxy<UserMapper> userMapperProxy =
                    new MyMapperProxy<>(UserMapper.class, sqlSession);
            UserMapper userMapper = (UserMapper) Proxy.newProxyInstance(
                    Thread.currentThread().getContextClassLoader(),
                    new Class[]{UserMapper.class},
                    userMapperProxy);
            List<SysUser> sysUsers = userMapper.selectAll();
            Assert.assertTrue(sysUsers.size() > 0);
        } finally {
            sqlSession.close();
        }
    }
}
```

## 2.9 本章小结
