# Nacos

## 安装

`docker-compose.yml`：

```y
version: "3"
services:
  nacos:
    image: nacos/nacos-server:${NACOS_VERSION}
    restart: always
    container_name: nacos
    environment:
      - PREFER_HOST_MODE=hostname
      - MODE=standalone
      - SPRING_DATASOURCE_PLATFORM=mysql
      - MYSQL_SERVICE_HOST=${MYSQL_SERVICE_HOST}
      - MYSQL_SERVICE_DB_NAME=${MYSQL_SERVICE_DB_NAME}
      - MYSQL_SERVICE_PORT=3306
      - MYSQL_SERVICE_USER=${MYSQL_SERVICE_USER}
      - MYSQL_SERVICE_PASSWORD=${MYSQL_SERVICE_PASSWORD}
      - MYSQL_SERVICE_DB_PARAM=characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useSSL=false&serverTimezone=GMT%2B8
    volumes:
      - ./logs/:/home/nacos/logs
    ports:
      - 8848:8848
    networks:
      bridge:
      
```

`.env`：

```properties
NACOS_VERSION=2.0.1
MYSQL_SERVICE_HOST=
MYSQL_SERVICE_DB_NAME=
MYSQL_SERVICE_USER=
MYSQL_SERVICE_PASSWORD=
```

新建数据库 `nacos`，执行数据库初始化脚本 [nacos-mysql.sql](https://github.com/alibaba/nacos/blob/2.0.1/distribution/conf/nacos-mysql.sql)

## nginx 转发

```nginx
server {
    listen      80;
    server_name nacos.test.novapaas.local;

    location ~ /nacos/console-ui/ {
        proxy_pass http://10.10.120.38:8848;
    }

    location / {
        proxy_pass http://10.10.120.38:8848/nacos/;
    }
}
```

