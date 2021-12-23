---
title: 服务器上的 Git
hidden: true
---

# 服务器上的 Git

- [x] 4.1 [协议](#协议)
  - [本地协议](#本地协议)
    - 优点
    - 缺点
  - [HTTP 协议](#HTTP-协议)
    - 智能 HTTP 协议
    
    - 哑（Dumb） HTTP 协议
    - 优点
    - 缺点
  - [SSH 协议](#SSH-协议)
    - 优势
    - 缺点
  - Git 协议
    - 优点
    - 缺点
- [ ] 4.2 [在服务器上搭建 Git](#在服务器上搭建-Git)
  - 把裸仓库放到服务器上
  - 小型安装
    - SSH 连接
- [ ] 4.3 生成 SSH 公钥
- [ ] 4.4 配置服务器
- [ ] 4.5 Git 守护进程
- [ ] 4.6 Smart HTTP
- [ ] 4.7 GitWeb
- [ ] 4.8 GitLab
  - 安装
  - 管理
    - 使用者
    - 组
    - 项目
    - 钩子
  - 基本用途
  - 一起工作
- [ ] 4.9 第三方托管的选择
- [ ] 4.10 总结

## 协议

### 本地协议

```shell
git clone /srv/git/project.git
git clone file:///srv/git/project.git # 网路传输进程，传输效率比上面低
```

### HTTP 协议

- 智能 HTTP 协议

- 哑（Dumb）HTTP 协议

```shell
cd /var/www/htdocs/
git clone --bare /path/to/git_project gitproject.git
cd gitproject.git
mv hooks/post-update.sample hooks/post-update
chmod a+x hooks/post-update
git clone https://example.com/gitproject.git
```

> 没有成功

### SSH 协议

```shell
git clone ssh://[user@]server/project.git
git clone [user@]server:project.git
```

## 在服务器上搭建 Git

```shell
# 放在相应目录就是
git clone --bare my_project my_project.git
scp -r my_project.git user@git.example.com:/srv/git
git clone user@git.example.com:/srv/git/my_project.git
# 组权限k
git init --bare --shared
```

