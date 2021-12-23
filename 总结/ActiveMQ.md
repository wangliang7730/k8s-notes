# ActiveMQ

## 为什么要用 MQ

- 解耦
- 削峰
- 异步

## 安装使用

```bash
./bin/activemq start # 网页：8161，tcp：61616
./bin/acrivemq stop # 默认密码 admin:admin
```

*`/etc/init.d/acrivemq`*

```bash
#!/bin/bash
# chkconfig:2345 10 90
# description:service activemq
ACTIVEMQ_HOME=/usr/local/apache-activemq-5.15.11
case "$1" in
     start)   ${ACTIVEMQ_HOME}/bin/activemq start;;
     stop)    ${ACTIVEMQ_HOME}/bin/activemq stop;;
     status)  ${ACTIVEMQ_HOME}/bin/activemq status;;
     *)  echo "require start|stop|status";;
esac
```

## 消息

- 队列：默认平均消费
- 主题：实时
- 主题订阅：离线主题也能接受，需要设置 clientId

***消息头***

- destination
- deliveryMode：是否持久化，默认持久
- expiration
- priority：0-9
- messageId

***消息体***

- text
- map
- bytes
- stream
- object

***属性***

- setXxxProperty

## 事务和消息确认

- 生产者事务
- 消费者事务
- 消费者消息确认以事务为准

## 协议

***添加 nio***

- http://activemq.apache.org/configuring-version-5-transports

*`conf/activemq.xml`*

```xml
<transportConnectors>
  <transportConnector name="nio" uri="nio://0.0.0.0:61616"/>  
</transportConnectors>
```

***auto***

- http://activemq.apache.org/auto

```xml
<!-- auto over tcp -->
<transportConnector name="auto" uri="auto://localhost:5671"/>
<!-- auto over nio -->
<transportConnector name="auto+nio" uri="auto+nio://localhost:5671"/>
<!-- auto over ssl -->
<transportConnector name="auto+ssl" uri="auto+ssl://localhost:5671"/>
<!-- ... -->
```

## [持久化](http://activemq.apache.org/persistence)

### [AMQ Message Store](http://activemq.apache.org/amq-message-store)

- 5 之前默认

```xml
<persistenceAdapter>
  <amqPersistenceAdapter directory="${activemq.base}/activemq-data" maxFileLength="32mb"/>
</persistenceAdapter>
```

### [KahaDB](http://activemq.apache.org/kahadb)

- 5.4 之后默认

```xml
<persistenceAdapter>
  <kahaDB directory="${activemq.data}/kahadb" journalMaxFileLength="32mb"/>
</persistenceAdapter>
```

### [JDBC](http://activemq.apache.org/jdbc-support)

- 导入数据库驱动包到 *`lib`*

```xml
<persistenceAdapter> 
  <jdbcPersistenceAdapter dataSource="#mysql-ds" createTablesOnStartup="true"/> 
</persistenceAdapter>

<bean id="mysql-ds" class="org.apache.commons.dbcp2.BasicDataSource" destroy-method="close">
  <property name="driverClassName" value="com.mysql.jdbc.Driver"/>
  <property name="url" value="jdbc:mysql://localhost/activemq?relaxAutoCommit=true"/>
  <property name="username" value="activemq"/>
  <property name="password" value="activemq"/>
  <property name="poolPreparedStatements" value="true"/>
</bean>
```

***with journal***

- 不会实时写入数据库，必要时才写入

```xml
<!-- <persistenceAdapter> -->
<!-- <jdbcPersistenceAdapter dataSource="#mysql-ds"/>  -->
<!-- </persistenceAdapter> -->
<persistenceFactory>
  <journalPersistenceAdapterFactory journalLogFiles="5" dataDirectory="${activemq.data}" dataSource="#mysql-ds"/> 
</persistenceFactory> 
```

> 订阅的 topic 消费完了不会删除，那什么时候会删除？

## [集群](http://activemq.apache.org/clustering)