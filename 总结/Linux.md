# Linux

## 关闭提示音

*/etc/inputrc*：

```bash
# 把注释去掉
set bell-style none
```
## SSH 配置

*/etc/ssh/sshd_config*：

```ini
# 是否允许密码登录
PasswordAuthentication yes
# 是否允许 root 登录
PermitRootLogin yes
# 端口
Port 22
# 监听地址
ListenAddress 0.0.0.0
# 登陆慢
UseDNS no
```

## 离线安装 rpm

```bash
yum install nginx -y --downloadonly --downloaddir=/tmp/nginx
tar zcvf nginx.tgz /tmp/nginx
rpm -ivh --nodeps --force
```

## 自启动服务

```bash
vim /lib/systemd/system/sztc.service

[Unit]
Description=sztc
After=mysqld.target redis.target nginx.target

[Service]
Type=forking
ExecStart=/home/run/sztc-back/app.sh start prod
ExecReload=/home/run/sztc-back/app.sh restart
ExecStop=/home/run/sztc-back/app.sh stop
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

## 动态加载磁盘

```shell
echo "- - -" > /sys/class/scsi_host/host0/scan
echo "- - -" > /sys/class/scsi_host/host1/scan
echo "- - -" > /sys/class/scsi_host/host2/scan
fdisk -l
```

