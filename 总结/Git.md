---
hidden: true
---

# Git

## 配置

```shell
git config --global user.name sharonlee
git config --global user.email 320019345@qq.com

git config --global alias.ca "!git add -A && git commit -a --allow-empty-message -m """""
git config --global alias.ca '!git add -A && git commit -a --allow-empty-message -m ""'

git config --global core.autocrlf false
```

## .gitignore

```ini
HELP.md
target/
!.mvn/wrapper/maven-wrapper.jar
!**/src/main/**
!**/src/test/**

### STS ###
.apt_generated
.classpath
.factorypath
.project
.settings
.springBeans
.sts4-cache

### IntelliJ IDEA ###
.idea
*.iws
*.iml
*.ipr

### NetBeans ###
/nbproject/private/
/nbbuild/
/dist/
/nbdist/
/.nb-gradle/
build/

### VS Code ###
.vscode/
```

## --depth 1

## 稀疏检出

```bash
mkdir xxx
cd xxx
git init
git config core.sparseCheckout true
echo /xxx >> .git/info/sparse-checkout
git remote add origin http://foo
git pull origin master --depth 1
git read-tree -mu HEAD
```

## submodule

## subtree

## 加速

https://hub.fastgit.org/

## 删除提交历史

```shell
1.Checkout
 
   git checkout --orphan latest_branch
 
2. Add all the files
 
   git add -A
 
3. Commit the changes
 
   git commit -am "commit message"
 
 
4. Delete the branch
 
   git branch -D master
 
5.Rename the current branch to master
 
   git branch -m master
 
6.Finally, force update your repository
 
   git push -f origin master
```

## 提交规范

- https://segmentfault.com/a/1190000009048911

## 自动提交所有

```shell
git config --global alias.ca "!git add -A && git commit -a --allow-empty-message -m """""
```

## 子树合并

- https://docs.github.com/cn/github/getting-started-with-github/using-git/about-git-subtree-merges

## 安装

- https://stackoverflow.com/questions/21820715/how-to-install-latest-version-of-git-on-centos-7-x-6-x

```shell
yum install http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-1.noarch.rpm
- or -
yum install http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm
```

## gitbook

[gitbook出现TypeError: cb.apply is not a function解决办法](https://www.cnblogs.com/cyxroot/p/13754475.html)

