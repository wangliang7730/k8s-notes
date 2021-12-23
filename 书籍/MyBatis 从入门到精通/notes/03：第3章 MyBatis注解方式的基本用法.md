---
title: 第3章 MyBatis注解方式的基本用法
hidden: true
date: 2021-09-26
updated: 2021-09-27
---

# 第3章 MyBatis注解方式的基本用法

| 💡 **注解使用** |
| -------------- |

## 3.1 @Select注解

### 3.1.1 使用mapUnderscoreToCamelCase配置

### 3.1.2 使用resultMap方式

| 💡 **注解声明和使用 resultMap** |
| ------------------------------ |

```java
@Results(id = "roleResultMap", value = {
    @Result(property = "id", column = "id", id = true),
    ...
})
@Select("select ... where id = #{id}")
SysRole selectById2(Long id);
```

引用上面的 @Results：

```java
// 可以是 xml 中的 <resultMap>
@ResultMap("roleResultMap")
@Select("select * from sys_role")
List<SysRole> selectAll();
```

## 3.2 @Insert注解

### 3.2.1 不需要返回主键

### 3.2.2 返回自增主键

| 💡 **注解返回主键** |
| ------------------ |

```java
@Insert({"insert into ...", "values(...)"})
@Options(useGeneratedKeys = true, keyProperty = "id")
int insert2(SysRole sysRole);
```

### 3.2.3 返回非自增主键

```java
@Insert({"insert into ...", "values(...)"})
@SelectKey(statement = "SELECT LAST_INSERT_ID()", keyProperty = "id", resultType = Long.class, before = false)
int insert3(SysRole sysRole);
```

## 3.3 @Update注解和@Delete注解

## 3.4 Provider注解

| 💡 **使用 Provider** |
| ------------------- |

```java
@SelectProvider(type = PrivilegeProvider.class, method = "selectById")
SysPrivilege selectById(Long id);

public class PrivilegeProvider {
    public String selectById(final Long id){
        return new SQL(){
            {
                // 块初始化。链式调用更容易理解。
                SELECT("id, privilege_name, privilege_url");
                FROM("sys_privilege");
                WHERE("id = #{id}");
            }
        }.toString();
    }
}
```

## 3.5 本章小结
