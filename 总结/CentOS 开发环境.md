---
date: 2021-07-01
---

# CentOS 开发环境

## 设置静态IP

编辑 `/etc/sysconfig/network-scripts/ifcfg-ens33`：

```ini
BOOTPROTO=static
ONBOOT=yes

IPADDR=192.168.128.100
NETMASK=255.255.255.0
GATEWAY=192.168.128.2
DNS1=192.168.128.2
```

重启网络：

```shell
systemctl restart network
```

## 关闭防火墙、SELinux

```bash
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
sed -i s#SELINUX=enforcing#SELINUX=disabled# /etc/selinux/config
```

## [设置镜像](https://developer.aliyun.com/mirror/centos?spm=a2c6h.13651102.0.0.3e221b115iDFBn)

```bash
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo

mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

yum makecache
```

## 安装必要软件

```bash
yum -y install net-tools vim lrzsz
```

## 安装 Docker

### 安装 Docker

```shell
# 添加yum源
yum install -y yum-utils
# yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

sed -i 's#download.docker.com#mirrors.aliyun.com/docker-ce#g' /etc/yum.repos.d/docker-ce.repo

# 安装
yum -y install docker-ce docker-ce-cli containerd.io

# 启动
systemctl start docker

# 开机启动
systemctl enable docker
```

### 镜像加速

```shell
# 镜像加速
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<- 'EOF'
{
    "registry-mirrors": ["https://9siv5tg6.mirror.aliyuncs.com","https://06dabca96280264b0fb2c00ad053c440.mirror.swr.myhuaweicloud.com"]
}
EOF

systemctl daemon-reload
systemctl restart docker
```

### 安装 Docker Compose

```shell
curl -L https://get.daocloud.io/docker/compose/releases/download/1.28.5/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

## 安装 MySQL

```yaml
version: '3'
services:
  mysql:
    image: mysql:5.7
    container_name: mysql
    restart: always
    ports:
      - 3306:3306
    environment:
      TZ: Asia/Shanghai
      MYSQL_ROOT_PASSWORD: root
    command:
      --character-set-server=utf8mb4
      --collation-server=utf8mb4_bin
      --explicit_defaults_for_timestamp=true
      --lower_case_table_names=1
      --max_allowed_packet=128M
      --sql-mode="STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION,NO_AUTO_VALUE_ON_ZERO"
    volumes:
      - ./data:/var/lib/mysql
    network_mode: bridge
```

## 安装 Redis

```yaml
version: '3'
services:
  redis:
    restart: always
    image: redis
    container_name: redis
    command: redis-server --appendonly yes
    environment:
      - TZ=Asia/Shanghai
    ports:
     - 6379:6379
    network_mode: bridge
```

## 安装 Nginx

```yaml
version: '3'
services:
  nginx:
    image: nginx
    restart: always
    container_name: nginx
    ports:
      - 80:80
      - 443:443
    volumes:
      - ./conf.d:/etc/nginx/conf.d
      - ./html:/usr/share/nginx/html
      - ./log:/var/log/nginx
      - ./letsencrypt:/etc/letsencrypt
```

## Zookeeper

```yaml
version: '3'
services:
  zookeeper:
    restart: always
    image: zookeeper
    container_name: zookeeper
    volumes:
      - ./zookeeper/data:/data
    ports:
      - 2181:2181"
    network_mode: bridge
```

