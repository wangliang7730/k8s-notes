# JDBC

## 连接

```java
// com.mysql.jdbc.Driver 类静态代码块会调用下面
java.sql.DriverManager.registerDriver(new Driver());
// 所以加载 Driver 即可
Class.forName("com.mysql.jdbc.Driver");
// 又因为 META-INF/services/java.sql.Driver 服务注册了这个类，所以也不需要手动加载
```

## 事务

```java
Connection conn = DriverManager.getConnection();
// 开启事务
conn.setAutoCommit(false);
// 回滚
conn.rollback();
```

## 语句

- Statement

- PreparedStatement：索引 1 开始

- CallableStatement

## 执行

```java
// 增删改查
execute();
// 增删改
executeUpdate();
// 查
executeQuery();
```

## 结果

ResultSet：索引 1 开始