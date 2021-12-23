# Docker

## CentOS 安装 Docker

**卸载：**

```shell
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
```

**添加源：**

```shell
# 使用 yum 工具添加源
yum install -y yum-utils
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 或者直接下载
curl -o /etc/yum.repos.d/docker-ce.repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 查看版本
yum list docker-ce --showduplicates
```

**安装：**

```shell
# 安装最新版本
yum -y install docker-ce docker-ce-cli containerd.io

# 安装指定版本
yum -y install --setopt=obsoletes=0 docker-ce-18.06.3.ce-3.el7

# 开机启动并立即启动
systemctl enable docker --now
```

**镜像加速：** [阿里云 - 镜像加速](https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors)

```shell
mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://xxx.mirror.aliyuncs.com"]
}
EOF
systemctl daemon-reload
systemctl restart docker
```

**参考：**

- [官方文档 - Install Docker Engine on CentOS](https://docs.docker.com/engine/install/centos/)

## 安装

### yum

参考：[官方文档](https://docs.docker.com/engine/install/centos/)

```bash
# 卸载
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
    # yum list installed|grep docker
    # rpm -qa|grep docker
    # yum remove docker-*
    # yum remove containerd.io
    # rm -rf /var/lib/docker/

# 添加yum源
yum install -y yum-utils
# yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

sed -i 's#download.docker.com#mirrors.aliyun.com/docker-ce#g' /etc/yum.repos.d/docker-ce.repo

# 安装
yum -y install docker-ce docker-ce-cli containerd.io

# 启动
systemctl start docker
```

### rpm

***下载***

- [docker-ce-17.03.3.ce-1.el7.x86_64.rpm](https://mirrors.huaweicloud.com/docker-ce/linux/centos/7/x86_64/stable/Packages/docker-ce-17.03.3.ce-1.el7.x86_64.rpm)
- [docker-ce-selinux-17.03.3.ce-1.el7.noarch.rpm](https://mirrors.huaweicloud.com/docker-ce/linux/centos/7/x86_64/stable/Packages/docker-ce-selinux-17.03.3.ce-1.el7.noarch.rpm)

```bsh
yum install docker-*
```

### apt

参考：https://developer.aliyun.com/mirror/docker-ce?spm=a2c6h.13651102.0.0.3e221b11T1iUC9

```bash
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get -y install docker-ce

service docker start

```

### 镜像加速

参考：https://cr.console.aliyun.com/cn-hangzhou/instances/mirrors

```bash
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<- 'EOF'
{
    "registry-mirrors": ["https://9siv5tg6.mirror.aliyuncs.com","https://06dabca96280264b0fb2c00ad053c440.mirror.swr.myhuaweicloud.com"]
}
EOF

systemctl daemon-reload
systemctl restart docker
systemctl enable docker
```

网易镜像中心：https://c.163yun.com/hub#/home

## 基本命令

>   `ctrl+p+q` 可以不停止容器退出

```shell
docker version # 查看版本
docker info # 查看信息
docker 命令 --help # 查看帮助

# 镜像
docker images
	-a # all，包含中间层
	-q # quite，只显示 id
docker search # 搜索镜像
docker pull # 下载镜像
docker rmi # 删除镜像
docker rmi -f $(docker images -qa) # 删除所有镜像

# 容器
docker run # 启动
  --name # 指定名称
  --env
  -e # 环境变量
  -d # 后台运行
  -p 主机:容器 # 端口映射
  --link 容器:别名
  --restart=always # docker 启动容器就启动
  --rm # 停止自动删除
  -v 主机路径:容器路径 # 指定路径挂载
     卷名:容器路径 # 具名挂载，/var/lib/docker/volumes/xxx/_data
     容器路径 # 匿名挂载
     :ro|rw # 容器内权限
  --volumes-from 容器 # 容器间共享数据卷
  -it # 交互式
      # ctrl+p+q 容器不停止退出
docker start # 开始容器
docker stop # 停止容器
docker rm # 删除容器
docker rm -f $(docker ps -qa) # 删除所有容器

# 交互
docker exec -it /bash/bin # 新开一个终端
docker attach # 正在执行的终端

# 容器信息
docker ps # 查看运行的容器
	-a # 所有
	-q # 只显示 id
	--no-trunc # 完整 id
docker top # 容器进程信息

# 日志
docker logs
	-f # follow
	-t # 显示时间
	--tail n
docker inspect # 查看容器信息
docker stats # 统计信息

# 拷贝
docker cp 容器:容器路径 主机路径

# 提交镜像
docker commit 容器名 镜像名:版本号
	-m # 描述
	-a # 作者

# 数据卷
docker volume
	ls # 列出所有卷
	inspect 卷名 # 查看详细信息

docker history # 容器历史
docker port 容器名 # 查看端口映射关系

docker container update --restart=always 容器名 # 自动启动

docker tag 镜像名 新镜像名:tag
```

## Dockerfile

```dockerfile
FROM
MAINTAINER
RUN
WORKDIR
COPY
ADD # COPY并解压
ENV
EXPOSE
VOLUME
ENTRYPOINT # 指定启动容器时执行的命令，可追加，多用于指定参数
CMD # 指定启动容器时执行的命令，只有最后一个生效，可被替代
ONBUILD 
```

### 构建发布

```bash
# 构建
docker build 选项 上下文路径 # 上下文的文件会被发送到docker服务
	-f Dockerfile 文件
	-t 镜像名:版本
# 发布
docker login -u 用户名 -P 密码
docker push 用户名/镜像名:版本号
# 保存
docker save
docker load
```

### CMD 和 ENTRYPOINT 区别

- [【docker】CMD ENTRYPOINT 区别 终极解读！](https://blog.csdn.net/u010900754/article/details/78526443)

## 网络

- veth-pair 技术，容器之间可以ping通

### --link

```shell
# 不建议使用
docker run --link 容器名:别名 # 在hosts中添加了映射
```

### network

```shell
docker run --net # 指定网络，默认 bridge，即 docker0
docker network ls # 列出所有网络
docker network rm # 删除网络
docker network create 参数 网络名 # 创建网络
  --driver bridge # 默认桥接
  --subnet 192.168.0.1/16 # 子网
  --gateway 192.168.0.1 # 网关
docker network inspect # 查看网络
docker network connect 网络 容器 # 容器连接网络
```

## Docker Compose

- https://get.daocloud.io/#install-compose

```bash
# curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
curl -L https://get.daocloud.io/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

```bash
docker-compose
	version
  -f # 指定 yaml
  config -q # 验证 yaml
  up -d
  rm
start stop pause unpause restart logs ps
```

## Docker Swarm

```shell
docker swarm init --advertise-addr ip
docker swarm join-token manager|worker
docker swarm join --token token ip:port
docker node ls
```



## 从镜像拷贝文件

参考：https://stackoverflow.com/questions/25292198/docker-how-can-i-copy-a-file-from-an-image-to-a-host

```shell
id=$(docker create image-name)
docker cp $id:path - > local-tar-file
docker rm -v $id
```

## 安装

### Portainer

```shell
docker pull portainer/portainer
docker run -d -p 9000:9000 --name portainer -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer
```



### MySQL

```bash
docker pull mysql:5.7
# 简单启动
docker run --restart=always -p 3306:3306 --name mysql -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7

# 拷贝配置
docker run --name tmp-mysql -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7
mkdir -p ~/docker/mysql
docker cp tmp-mysql:/etc/mysql/mysql.conf.d ~/docker/mysql/
docker rm -f tmp-mysql

# 配置
[client]
default-character-set=utf8mb4
[mysql]
default-character-set=utf8mb4
[mysqld]
character-set-server=utf8mb4
lower_case_table_names=1
sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION,NO_AUTO_VALUE_ON_ZERO

# 启动
docker run --restart=always -p 3306:3306 --name mysql \
-v ~/docker/mysql/log:/var/log/mysql \
-v ~/docker/mysql/data:/var/lib/mysql \
-v ~/docker/mysql/mysql.conf.d:/etc/mysql/mysql.conf.d \
-e MYSQL_ROOT_PASSWORD=root \
-d mysql:5.7
```

### Redis

```bash
docker pull redis
# 简单启动
docker run --restart=always -p 6379:6379 --name redis -d redis

# 启动
# 容器中没有配置文件
mkdir -p ~/docker/redis
touch ~/docker/redis/redis.conf
docker run -p 6379:6379 --name redis \
-v ~/docker/redis/redis.conf:/etc/redis/redis.conf \
-v ~/docker/redis/data:/data \
-d redis redis-server /etc/redis/redis.conf --appendonly yes
```

### MongoDB

```bash
docker run --name mongo -p 27017:27017 -d mongo
```

### ElasticSearch

```bash
docker pull elasticsearch:7.3.2
docker run -d --name es -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:7.3.2
docker pull kibana:7.3.2
docker run -d --name kibana --link es:elasticsearch -p 5601:5601 kibana:7.3.2
```

### SQL Server

```bash
docker pull microsoft/mssql-server-linux
docker run --name mssql -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=1qaz!QAZ' -p 1433:1433 -d microsoft/mssql-server-linux
```

### Zookeeper

```bash
docker run -d \
-p 2181:2181 \
--name=zookeeper  \
--privileged zookeeper
```

### Nginx

```shell
# 拷贝文件
mkdir -p ~/docker/nginx
docker run -d --name tmp-nginx nginx
docker cp tmp-nginx:/etc/nginx/nginx.conf ~/docker/nginx/
docker cp tmp-nginx:/etc/nginx/conf.d ~/docker/nginx/
docker cp tmp-nginx:/usr/share/nginx/html ~/docker/nginx/
docker rm -f tmp-nginx

# 运行容器
docker run -d --name nginx -p 80:80 \
  -e TZ=Asia/Shanghai \
  -v ~/docker/nginx/nginx.conf:/etc/nginx/nginx.conf \
  -v ~/docker/nginx/conf.d:/etc/nginx/conf.d \
  -v ~/docker/nginx/html:/usr/share/nginx/html \
  -v ~/docker/nginx/logs:/var/log/nginx \
  --restart=always \
  nginx
```

参考：https://blog.csdn.net/networken/article/details/107775171

## 怎么查看远端仓库标签

https://registry.hub.docker.com/v1/repositories/【镜像名】/tags

参考：https://www.liaoyongfu.com/2018/11/d0d9ca71-85b1-4976-8291-3f0efb8f7a8c/

## 开启远程访问

```shell
vim /lib/systemd/system/docker.service
ExecStart=... -H tcp://0.0.0.0:2375
systemctl daemon-reload
systemctl restart docker
curl http://localhost:2375/version
```

## 镜像仓库

### 服务器

docker-compose.yml：

```yaml
version: '3'
services:
  registry:
    image: registry
    restart: always
    container_name: registry
    ports:
      - 5000:5000
    volumes:
      - ./data:/var/lib/registry
```

查看：

```shell
curl http://localhost:5000/v2/_catalog
curl http://localhost:5000/v2/<
```

打标签：

```shell
docker tag xxx localhost:5000/xxx
```

推送：

```shell
docker push localhost:5000/xxx
```

### 客户端

/etc/docker/daemon.json：

```shell
{ 
    "insecure-registries" : [ "xxx:5000" ] 
}
```

## 热加载配置

```shell
docker info |grep -i live
vim /etc/docker/daemon.json
"live-restore": true
docker info |grep -i live
systemctl reload docker
systemctl restart docker
```

## JDK

- https://github.com/oracle/docker-images/tree/main/OracleJava

## 清理

删除 tag 为 none 的镜像：

```shell
docker rmi $(docker images | grep "<none>" | awk '{print $3}')
```

删除日志：

```shell
#!/bin/bash
echo "==================== start clean docker containers logs =========================="
logs=$(find /var/lib/docker/containers/ -name *-json.log)
for log in $logs; do
 echo "clean logs : $log"
  cat /dev/null > $log
done
echo "==================== end clean docker containers logs   =========================="
```

