# Logging

## Log4j

参考：https://www.cnblogs.com/hy928302776/archive/2013/04/09/3010571.html

```properties
log4j.rootLogger=INFO, stdout
log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss.SSS} [%t] --- %-5p %-40.40C : %m%n
```

## Logback

*`logback.xml`*

```xml
<configuration>
  <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
    <withJansi>false</withJansi>
    <encoder>
      <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%magenta(%thread)] --- %highlight(%-5level) %cyan(%-40.40logger{39}) : %msg%n</pattern>
    </encoder>
  </appender>

  <root level="INFO">
    <appender-ref ref="STDOUT" />
  </root>
</configuration>
```

