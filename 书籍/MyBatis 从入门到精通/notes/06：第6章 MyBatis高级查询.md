---
title: 第6章 MyBatis高级查询
hidden: true
date: 2021-09-26
updated: 2021-09-27
---

# 第6章 MyBatis高级查询

## 6.1 高级结果映射

### 6.1.1 一对一映射

```xml
<resultMap id="userRoleMap" extends="userMap" type="tk.mybatis.simple.model.SysUser">
  <association property="role" columnPrefix="role_" resultMap="tk.mybatis.simple.mapper.RoleMapper.roleMap"/>
</resultMap>
```

嵌套查询：

```xml
<resultMap id="userRoleMapSelect" extends="userMap" type="tk.mybatis.simple.model.SysUser">
  <association property="role" 
               fetchType="lazy"
               select="tk.mybatis.simple.mapper.RoleMapper.selectRoleById" 
               column="{id=role_id,name=role_name}"/>
</resultMap>
```

| 💡 **延迟加载** |
| -------------- |

延迟加载相关配置：

```xml
<settings>
  <setting name="lazyLoadingEnabled" value="false"/>
  <setting name="aggressiveLazyLoading" value="3.4.1及之前为true"/>
  <setting name="lazyLoadTriggerMethods" value="equals,clone,hashCode,toString"/>
</settings>
```

### 6.1.2 一对多映射

```xml
<resultMap id="userRoleListMap" extends="userMap" type="tk.mybatis.simple.model.SysUser">
  <collection property="roleList" columnPrefix="role_" 
              resultMap="tk.mybatis.simple.mapper.RoleMapper.rolePrivilegeListMap"/>
</resultMap>
```

嵌套查询：

```xml
<resultMap id="userRoleListMapSelect" extends="userMap" type="tk.mybatis.simple.model.SysUser">
  <collection property="roleList"
              fetchType="lazy"
              select="tk.mybatis.simple.mapper.RoleMapper.selectRoleByUserId"
              column="{userId=id}"/>
</resultMap>
```

### 6.1.3 鉴别器映射

| 💡 **使用鉴别器** |
| ---------------- |

```xml
<resultMap id="rolePrivilegeListMapChoose" type="tk.mybatis.simple.model.SysRole">
  <discriminator column="enabled" javaType="int">
    <case value="1" resultMap="rolePrivilegeListMapSelect"/>
    <case value="0" resultMap="roleMap"/>
  </discriminator>
</resultMap>
```

## 6.2 存储过程

| 💡 **调用存储过程** |
| ------------------ |

```xml
<select id="selectUserPage" statementType="CALLABLE" useCache="false" resultMap="userMap">
  {call select_user_page(
  #{userName, mode=IN},
  #{offset, mode=IN},
  #{limit, mode=IN},
  #{total, mode=OUT, jdbcType=BIGINT}
  )}
</select>
```

### 6.2.1 第一个存储过程

### 6.2.2 第二个存储过程

### 6.2.3 第三个和第四个存储过程

### 6.2.4 在Oracle中使用游标参数的存储过程

## 6.3 使用枚举或其他对象

| 💡 **类型处理器** |
| ---------------- |

### 6.3.1 使用MyBatis提供的枚举处理器

```xml
<typeHandlers>
  <typeHandler 
               javaType="tk.mybatis.simple.type.Enabled" 
               handler="org.apache.ibatis.type.EnumOrdinalTypeHandler"/>
</typeHandlers>
```

### 6.3.2 使用自定义的类型处理器

```java
public class XxxTypeHandler implements TypeHandler<Xxx>;
```

### 6.3.3 对Java 8日期（JSR-310）的支持

```xml
<dependency>
  <groupId>org.mybatis</groupId>
  <artifactId>mybatis-typehandlers-jsr310</artifactId>
  <version>1.0.2</version>
</dependency>
```

## 6.4 本章小结
