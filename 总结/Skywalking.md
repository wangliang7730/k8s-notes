# Skywalking

## 快速安装

```shell
# 安装oap
docker run -d \
--name skywalking-oap \
-p 12800:12800 \
-p 11800:11800 \
-e TZ=Asia/Shanghai \
apache/skywalking-oap-server:6.5.0

# 安装ui
docker run -d \
--name skywalking-ui \
-p 8080:8080 \
--link skywalking-oap:skywalking-oap \
-e SW_OAP_ADDRESS=skywalking-oap:12800 \
apache/skywalking-ui:6.5.0

# 下载jar包，启动配置
-javaagent:/opt/apache-skywalking-apm-bin/agent/skywalking-agent.jar -Dskywalking.agent.service_name=应用名 -Dskywalking.collector.backend_service=192.168.100.101:11800
```

访问：http://192.168.100.101:8080

## 参考

- [Docker + Spring Boot 演示 SkyWalking Demo](https://www.jianshu.com/p/7181990e2a40)

