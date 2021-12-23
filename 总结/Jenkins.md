# Jenkins

参考：

- [基于Jenkins实现持续集成【持续更新中】](https://www.cnblogs.com/luchuangao/p/7748575.html)
- [Jenkins安装插件提速](https://www.cnblogs.com/hellxz/p/jenkins_install_plugins_faster.html)

## 安装

下载地址：

https://mirrors.tuna.tsinghua.edu.cn/jenkins/redhat-stable/

```bash
systemctl start jenkins
```

配置更新地址：

```bash
https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json

cd /var/lib/jenkins/updates
vi default.json
:1,$s/http:\/\/updates.jenkins-ci.org\/download/https:\/\/mirrors.tuna.tsinghua.edu.cn\/jenkins/g
:1,$s/http:\/\/www.google.com/https:\/\/www.baidu.com/g
# 或者
sed -i 's/http:\/\/updates.jenkins-ci.org\/download/https:\/\/mirrors.tuna.tsinghua.edu.cn\/jenkins/g' default.json && sed -i 's/http:\/\/www.google.com/https:\/\/www.baidu.com/g' default.json
systemctl restart jenkins
```

重启：url:8080/restat

### docker-compose

```yaml
version: '3'
services:
  jenkins:
    image: 'jenkins/jenkins:lts'
    container_name: jenkins
    restart: always
    privileged: true
    user: root
    network_mode: bridge
    ports:
      - 8080:8080
      - 50000:50000
    volumes:
      - ~/docker/jenkins:/var/jenkins_home
```

> 密码在 `/var/jenkins_home/secrets/initialAdminPassword`

## 插件

```bash
Localization: Chinese (Simplified)
git
Maven Integration
Role-based Authorization Strategy
```

## 脚本

```bash
#BUILD_ID=dontKillMe
```

```shell
cd $WORKSPACE
export PATH=/usr/local/node-v14.4.0-linux-x64/bin:$PATH
export NODE_ENV=development
yarn build
```

## jenkins用户

```bash
sudo su -s /bin/bash jenkins
sudo -u jenkins bash
```

## docker

```shell
usermod -a -G docker jenkins
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```

