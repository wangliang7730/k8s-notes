# Hexo 的使用

官方文档：https://hexo.io/zh-cn/docs/

## 快速开始

```bash
npm install -g hexo-cli
hexo init [folder]
cd [folder]
npm install
# 生成文档
hexo g
# 启动服务
hexo s
```

访问：http://localhost:4000

## 常用命令

```bash
# 初始化
hexo init [folder]
# 生成
hexo g|generate
# 启动服务
hexo s|server
# 发布
hexo d|deploy
# 清除
hexo clean
```

## 基本设置

配置文件为 `_config.yml`

```yml
# 博客标题
title: "SharonLee's Blog"
# 副标题
subtitle: 
#网站描述
description: 
#作者昵称
author: SharonLee
# 设置语言
language: zh-CN
# 时区
timezone: Asia/Shanghai

# 设置主题
theme: next
```

## 发布到 Git

安装依赖：

```bash
npm install hexo-deployer-git --save
```

配置：

```yml
deploy:
  type: git
  repo: <repository url>
  branch: [branch]
```

## NexT 主题

### 安装

github 地址：https://github.com/theme-next/hexo-theme-next

```bash
git clone https://github.com/theme-next/hexo-theme-next themes/next # 删除 .git 文件夹
# 或者下载解压到相应目录
```

`_config.yml` 中配置主题

```yaml
theme: next
```

### 常用配置

```
next/_config.yml
# 字体小一点
font:
  enable: true
  global:
    size: 0.8
    
# 样式
scheme: Gemini

# 展开所有目录
toc:
  expand_all: true
```

### 开启分类、标签和关于

```bash
hexo new page tags
hexo new page categories
hexo new page about
```

`source/xxx/index.md` 中分别添加

```yaml
type: tags
type: categories
type: about
```

配置 `next/_config.yml`：

```yaml
menu:
  about: /about/ || user
  tags: /tags/ || tags
  categories: /categories/ || th
```

### 开启搜索

安装依赖：

```bash
npm install hexo-generator-searchdb --save
```

配置 `next/_config.yml`：

```yaml
local_search:
  enable: true
```

## 文章头

```yaml
tag: 标签
category: 分类
description: 描述 # 有描述则首页显示描述，否则显示全部，或者显示到 <!-- more -->
```

## 截取

```bash
npm install hexo-excerpt --save
excerpt:
  depth: 10
  excerpt_excludes: []
  more_excludes: []
  hideWholePostExcerpts: true
```

## GitHub Actions 发布

```
.github/workflows/main.yml
name: Deploy GitHub Pages

# 触发条件：在 push 到 master 分支后
on:
  push:
    branches:
      - master

# 任务
jobs:
  build-and-deploy:
    # 服务器环境：最新版 Ubuntu
    runs-on: ubuntu-latest
    steps:
      # 拉取代码
      - name: Checkout
        uses: actions/checkout@v2.3.1
        with:
          persist-credentials: false

      # 1、生成静态文件
      - name: Build
        run: npm install && npm run build

      # 2、部署到 GitHub Pages
      - name: Deploy
        uses: JamesIves/github-pages-deploy-action@4.0.0
        with:
          branch: gh-pages
          folder: public
          #注意这里的 public 是仓库根目录下的 public，也就是 npm run build 生成静态资源的路径，比如有的人是 `docs/.vuepress/dist`

      # 3、同步到 gitee 的仓库
      - name: Sync to Gitee
        uses: wearerequired/git-mirror-action@v1
        env:
          # 注意在 Settings->Secrets 配置 GITEE_RSA_PRIVATE_KEY
          SSH_PRIVATE_KEY: ${{ secrets.GITEE_RSA_PRIVATE_KEY }}
        with:
          # 注意替换为你的 GitHub 源仓库地址
          source-repo: git@github.com:linception/linception.github.io.git
          # 注意替换为你的 Gitee 目标仓库地址
          destination-repo: git@gitee.com:sharonlee/sharonlee.git

      # 4、部署到 Gitee Pages
      - name: Build Gitee Pages
        uses: yanglbme/gitee-pages-action@main
        with:
          # 注意替换为你的 Gitee 用户名
          gitee-username: sharonlee
          # 注意在 Settings->Secrets 配置 GITEE_PASSWORD
          gitee-password: ${{ secrets.GITEE_PASSWORD }}
          # 注意替换为你的 Gitee 仓库，仓库名严格区分大小写，请准确填写，否则会出错
          gitee-repo: sharonlee/sharonlee
          # 要部署的分支，默认是 master，若是其他分支，则需要指定（指定的分支必须存在）
          branch: master
```

## 图片

### 方式一

图片全放在 `source/images` 下，以绝对路径方式引用 `/images/xxx.png`，同时 typora `格式->图像->设置图片根目录` 设置为 `source` 目录

### 方式二

设置 `post_asset_folder: true`，图片存放在 `filename` 文件夹下，这样图片会被拷贝到文件同级目录

再安装下面插件

```bash
npm install hexo-asset-link --save
```

### 方式三

```
{% asset_img image_name.jpg This is an image %}
```

>   不爽的地方：必须建立一个与文件名同名的文件夹存放资源，`post_asset_folder` 设置才会拷贝

## 参考

- [官方文档](https://hexo.io/zh-cn/docs/)
- [资源文件夹](https://hexo.io/zh-cn/docs/asset-folders.html)
- [Hexo博客NexT主题下添加分类、标签、关于菜单项](https://blog.csdn.net/mqdxiaoxiao/article/details/93644533)
- [GitHub Actions入门教程：自动化部署静态博客](https://jishuin.proginn.com/p/763bfbd38928)
- [hexo 图片显示问题及使用typora设置图片路径](https://cloud.tencent.com/developer/article/1702112)