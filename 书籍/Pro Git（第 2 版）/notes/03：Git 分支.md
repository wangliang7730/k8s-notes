---
title: Git 分支
hidden: true
---

# Git 分支
- [x] 3.1 [分支简介](#分支简介)
  - 分支创建
  - 分支切换
- [x] 3.2 [分支的新建与合并](#分支的新建与合并)
  - 新建分支
  - 分支的合并
  - 遇到冲突时的分支合并
- [x] 3.3 [分支管理](#分支管理)
- [x] 3.4 分支开发工作流
  - 长期分支
  - 主题分支
- [x] 3.5 [远程分支](#远程分支)
  - 推送
  - 跟踪分支
  - 拉取
  - 删除远程分支
- [x] 3.6 [变基](#变基)
  - 变基的基本操作
  - 更有趣的变基例子
  - [变基的风险](#变基的风险)
  - 用变基解决变基
  - 变基 vs. 合并
- [x] 3.7 [总结](#总结)

## 分支简介

提交对象 -> 树对象 -> 文件快照：

![首次提交对象及其树结构](assets/commit-and-tree.png)

HEAD 指向当前分支：

![分支及其提交历史。](assets/branch-and-history.png)

```shell
# 创建分支
git branch <branchname>
# 切换分支
git checkout <branchname>
# log 查看
git log --oneline --decorate --graph --all
# 创建并切换
git checkout -b <branchname>
```

## 分支的新建与合并

```shell
# 合并指定分支到当前分支
git merge <branchname>
# 删除分支
git branch
	-d <branchname> # 删除分支
	-D <branchname> # 强制删除
```

> `git mergetool --tool-help` 查看支持的 merge 工具

## 分支管理

```shell
git branch # 查看所有分支
	-v # 显示最后一次提交
	--merged # 已经合并到当前分支，通常可以删除
	--no-merged # 尚未合并到当前分支
```

## 远程分支

```shell
# 列出远程分支
git ls-remote <remote>

# 远程分支
git remote show <remote> # 显示
	add <remote> <url> # 添加

# 克隆
git clone -o <remote> # 默认 origin

# 获取
git fetch <remote>
git fetch --all

# 推送
git push <remote> <branch>
git push <remote> <localbranch>:<remotebranch>

# 跟踪分支
git checkout -b <branch> <remote>/<branch>
git checkout --track <remote>/<branch>
git checkout <branch> # 不存在且有同名远程分支
git branch -u,--set-upstream-to <remote>/<branch> # 设置跟踪的远程分支
git branch -vv # 列出所有分支及跟踪分支

# 删除
git push <remote> --delete <branch>
```

> 可以通过简写 @{upstream} 或 @{u} 来引用它的上游分支，如：
>
> ```shell
> git merge @{u} # 在 maser 分支时，且跟踪 origin/master，等价于
> git merge origin/master
> ```

## 变基

```shell
# 对比 git merge <branch>
git rebase <branch> # 基于 branch 变基当前分支，即变基 <current> - <branch>
git rebase <basebranch> <topicbranch> # 基于 basebranch 变基 topicbranch，即变基 <topicbranch> - <basebranch>
git rebase --onto <basebranch> <nextbranch> <topicbranch> # 基于 basebranch 变基 topicbranch 分支基于 nextbranch 的变动，即变基 (<topicbranch> - <nextbranch>) - <basebranch>
```

### 变基的风险

如果提交存在于你的仓库之外，而别人可能基于这些提交进行开发，那么不要执行变基。

```shell
git pull --rebase
git config --global pull.rebase true
```

## 总结

- branch、clone、fetch、pull、merge、rebase，使用中体会

