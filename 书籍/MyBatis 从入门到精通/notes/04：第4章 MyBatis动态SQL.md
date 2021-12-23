---
title: 第4章 MyBatis动态SQL
hidden: true
date: 2021-09-26
updated: 2021-09-27
---

# 第4章 MyBatis动态SQL

## 4.1 if用法

### 4.1.1 在WHERE条件中使用if

### 4.1.2 在UPDATE更新列中使用if

### 4.1.3 在INSERT动态插入列中使用if

## 4.2 choose用法

## 4.3 where、set、trim用法

### 4.3.1 where用法

### 4.3.2 set用法

>   🔔 如果 set 元素中没有内容会出现 SQL 错误，为了避免错误产生，要加类似 id = #{id} 必然存在的赋值

### 4.3.3 trim用法

where 等价于：

```xml
<trim prefix="WHERE" prefixOverrides="AND |OR ">
    ...
</trim>
```

set 等价于：

```xml
<trim prefix="SET" suffixOverrides=",">
    ...
</trim>
```

## 4.4 foreach用法

| 💡 **collection 参数名称** |
| ------------------------- |

-   只有一个数组参数或集合参数：放在一个 map 中，默认 key 根据类型为 `collection`，或追加 `list`，数组为 `array`，@Param 可以指定
-   有多个参数：用 @Param 指定
-   参数是 Map 类型：Map 的 key。如果要循环 Map，可以使用默认名字 _parameter

### 4.4.1 foreach实现in集合

### 4.4.2 foreach实现批量插入

### 4.4.3 foreach实现动态UPDATE

## 4.5 bind用法

| 💡 **使用 bind 标签** |
| -------------------- |

```xml
<if test="userName != null and userName != ''">
    <bind name="userNameLike" value="'%' + userName + '%'"/>
    and user_name like #{userNameLike}
</if>
```

## 4.6 多数据库支持

| 💡 **多数据库支持** |
| ------------------ |

```xml
// 根据 DatabaseMetaData#getDatabaseProductName() 匹配 name，设置 _databaseId 为 value，匹配不到为 null
<databaseIdProvider type="DB_VENDOR">
    <property name="SQL Server" value="sqlserver"/>
    <property name="DB2" value="db2"/>
    <property name="Oracle" value="oracle" />
    <property name="MySQL" value="mysql" />
</databaseIdProvider>

// 使用
<if test="_databaseId == 'oracle'">
    ...
</if>
```

## 4.7 OGNL用法

| 💡 **OGNL 语法** |
| --------------- |

-   el[e2]：取数组或 Map 的值
-   @class@method(args)：调用静态方法
-   @class@field：静态字段
-   ...

## 4.8 本章小结
