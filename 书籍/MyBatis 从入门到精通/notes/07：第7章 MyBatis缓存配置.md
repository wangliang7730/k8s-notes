---
title: 第7章 MyBatis缓存配置
hidden: true
date: 2021-09-26
updated: 2021-09-26
---

# 第7章 MyBatis缓存配置

一般提到 MyBatis 缓存的时候，都是指二级缓存，一级缓存（也叫本地缓存）默认会启用，并且不能控制，因此很少会提到。

## 7.1 一级缓存

| 💡 **MyBatis 的一级缓存** |
| ------------------------ |

`CacheTest#testL1Cache`：

>   🙋‍♂️ 运行书上示例时把 cacheEnabled 设置为 false，否则二级缓存会影响结果

```java
SysUser user1 = userMapper.selectById(1L);
user1.setUserName("New Name");

// 【一级缓存】不会查询数据库
SysUser user2 = userMapper.selectById(1L);
Assert.assertEquals("New Name", user2.getUserName());
// user2 和 user1 完全就是同一个实例
Assert.assertSame(user1, user2);
```

一级缓存：存在于 **SqlSession 的生命周期中**，如果同一个 SqlSession 中执行的**方法和参数完全一致**，返回缓存中的对象

清空一级缓存：

-   `<select flushCache="true"/>`
-   关闭 SqlSession 重新获取
-   任何 INSERT、UPDATE、DELETE 操作会清空一级缓存

## 7.2 二级缓存

| 💡 **配置 MyBatis 的二级缓存** |
| ----------------------------- |

一级缓存只存在于 SqlSession 的生命周期中，二级缓存可以理解为存在于 SqlSessionFactory 的生命周期中

### 7.2.1 配置二级缓存

开启全局二级缓存：

```xml
<settings>
    <!-- 默认为 true -->
    <setting name="cacheEnabled" value="true"/>
</settings>
```

Mapper.xml 中配置二级缓存：

```xml
<cache
  eviction="FIFO"
  flushInterval="60000"
  size="512"
  readOnly="true"/>
<cache-ref namespace="tk.mybatis.simple.mapper.RoleMapper"/>
```

可用的清除策略有：

-   `LRU` – 最近最少使用：移除最长时间不被使用的对象。
-   `FIFO` – 先进先出：按对象进入缓存的顺序来移除它们。
-   `SOFT` – 软引用：基于垃圾回收器状态和软引用规则移除对象。
-   `WEAK` – 弱引用：更积极地基于垃圾收集器状态和弱引用规则移除对象。

注解配置：

```java
@CacheNamespace
@CacheNamespaceRef
```

### 7.2.2 使用二级缓存

| ⌨ **二级缓存示例** |
| ------------------ |

`CacheTest#testL2Cache`

## 7.3 集成EhCache缓存

| 💡 **集成第三方 Cache** |
| ---------------------- |

依赖：

```xml
<dependency>
    <groupId>org.mybatis.caches</groupId>
    <artifactId>mybatis-ehcache</artifactId>
    <version>1.0.3</version>
</dependency>
```

`ehcache.xml`：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ehcache xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:noNamespaceSchemaLocation="ehcache.xsd"
    updateCheck="false" monitoring="autodetect"
    dynamicConfig="true">
    
    <diskStore path="D:/cache" />
            
	<defaultCache      
		maxElementsInMemory="3000"      
		eternal="false"      
		copyOnRead="true"
		copyOnWrite="true"
		timeToIdleSeconds="3600"      
		timeToLiveSeconds="3600"      
		overflowToDisk="true"      
		diskPersistent="true"/> 

	<cache      
		name="tk.mybatis.simple.mapper.RoleMapper"
		maxElementsInMemory="3000"      
		eternal="false"      
		copyOnRead="true"
		copyOnWrite="true"
		timeToIdleSeconds="3600"      
		timeToLiveSeconds="3600"      
		overflowToDisk="true"      
		diskPersistent="true"/> 
</ehcache>
```

`Mapper.xml`：

```xml
<!-- 其他配置不生效，要在 ehcache.xml 中配置 -->
<cache type="org.mybatis.caches.ehcache.EhcacheCache"/>
```

## 7.4 集成Redis缓存

依赖：

```xml
<dependency>
    <groupId>org.mybatis.caches</groupId>
    <artifactId>mybatis-redis</artifactId>
    <version>1.0.0-beta2</version>
</dependency>
```

`redis.properties`：

```properties
host=192.168.16.142
port=6379
connectionTimeout=5000
soTimeout=5000
password=
database=0
clientName=
```

`Mapper.xml`：

```xml
<!-- 其他配置不生效，要在 ehcache.xml 中配置 -->
<cache type="org.mybatis.caches.redis.RedisCache"/>
```

## 7.5 脏数据的产生和避免

| 💡 **缓存脏数据** |
| ---------------- |

`CacheTest#testDirtyData`

关联查询容易出现脏数据

## 7.6 二级缓存适用场景

## 7.7 本章小结
