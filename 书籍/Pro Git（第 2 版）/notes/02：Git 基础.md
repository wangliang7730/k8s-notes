---
title: Git 基础
hidden: true
---

# Git 基础
- [x] 2.1 获取 Git 仓库
  - 在已存在目录中初始化仓库
  - 克隆现有的仓库
- [x] 2.2 [记录每次更新到仓库](#记录每次更新到仓库)
  - 检查当前文件状态
  - 跟踪新文件
  - 暂存已修改的文件
  - [状态简览](#状态简览)
  - [忽略文件](#忽略文件)
  - [查看已暂存和未暂存的修改](#查看已暂存和未暂存的修改)
  - [提交更新](#提交更新)
  - [跳过使用暂存区域](#跳过使用暂存区域)
  - [移除文件](#移除文件)
  - [移动文件](#移动文件)
- [x] 2.3 [查看提交历史](#查看提交历史)
  - [限制输出长度](#限制输出长度)
- [x] 2.4 [撤消操作](#撤消操作)
  - 取消暂存的文件
  - 撤消对文件的修改
- [x] 2.5 [远程仓库的使用](#远程仓库的使用)
  - 查看远程仓库
  - 添加远程仓库
  - 从远程仓库中抓取与拉取
  - 推送到远程仓库
  - 查看某个远程仓库
  - 远程仓库的重命名与移除
- [x] 2.6 [打标签](#打标签)
  - 列出标签
  - 创建标签
  - 附注标签
  - 轻量标签
  - 后期打标签
  - 共享标签
  - 删除标签
  - 检出标签
- [x] 2.7 [Git 别名](#Git-别名)
- [x] 2.8 [总结](#总结)

## 记录每次更新到仓库

### 状态简览

```shell
git status -s, --short
 M	# 工作区有修改
MM	# 暂存区和工作区有修改
A	  # 新加到暂存区
M	  # 暂存区有修改
??	# 未跟踪
```

### 忽略文件

文件 `.gitignore` 的格式规范如下：

- 所有空行或者以 `#` 开头的行都会被 Git 忽略
- 可以使用标准的 glob 模式匹配，它会递归地应用在整个工作区中
- 匹配模式可以以 `/` 开头防止递归
- 匹配模式可以以 `/` 结尾指定目录
- 要忽略指定模式以外的文件或目录，可以在模式前加上叹号 `!` 取反

glob 模式：

- `*` 匹配零个或多个任意字符
- `[abc]` 匹配任意一个方括号中的字符，也可以 `[a-z]`
- `?` 匹配一个任意字符
- `**` 表示任意中间目录

> gitignore 参考：https://github.com/github/gitignore 

### 查看已暂存和未暂存的修改

```shell
git diff # 工作区和暂存区的差异
	--staged, --cached # 暂存区和仓库的差异
```

> `git difftool --tool-help` 查看支持的 diff 工具

### 提交更新

```shell
git commit -m “提交信息”
```

### 跳过使用暂存区域

```shell
git commit -a
```

### 移除文件

```shell
rm # 直接删除会显示 Changes not staged for commit
git rm # 从工作区和暂存区中删除，如果工作区和暂存区中有未提交的修改，需要选择下面参数
	--cached    # 工作区保留
	-f, --force # 强制删除
```

可以使用 glob 模式匹配，如 `git rm log/\*.log`，反斜杠转义后不用 shell 帮忙展开。

### 移动文件

```shell
git mv <from> <to>
```

相当于：

```shell
mv <from> <to>
git rm <from>
git add <to>
```

## 查看提交历史

`git log` 的常用**显示**选项：

| 选项              | 说明                                                         |
| :---------------- | :----------------------------------------------------------- |
| `-p`, `--patch`   | 按补丁格式显示每个提交引入的差异。                           |
| `--stat`          | 显示每次提交的文件修改统计信息。                             |
| `--shortstat`     | 只显示 --stat 中最后的行数修改添加移除统计。                 |
| `--name-only`     | 仅在提交信息后显示已修改的文件清单。                         |
| `--name-status`   | 显示新增、修改、删除的文件清单。                             |
| `--abbrev-commit` | 仅显示 SHA-1 校验和所有 40 个字符中的前几个字符。            |
| `--relative-date` | 使用较短的相对时间而不是完整格式显示日期（比如“2 weeks ago”）。 |
| `--graph`         | 在日志旁以 ASCII 图形显示分支与合并历史。                    |
| `--pretty`        | 使用其他格式显示历史提交信息。可用的选项包括 `oneline`、`short`、`full`、`fuller` 和 `format`（用来定义自己的格式）。 |
| `--oneline`       | `--pretty=oneline --abbrev-commit` 合用的简写。              |

`git log --pretty=format` 常用的选项：

| 选项  | 说明                                          |
| :---- | :-------------------------------------------- |
| `%H`  | 提交的完整哈希值                              |
| `%h`  | 提交的简写哈希值                              |
| `%T`  | 树的完整哈希值                                |
| `%t`  | 树的简写哈希值                                |
| `%P`  | 父提交的完整哈希值                            |
| `%p`  | 父提交的简写哈希值                            |
| `%an` | 作者名字                                      |
| `%ae` | 作者的电子邮件地址                            |
| `%ad` | 作者修订日期（可以用 --date=选项 来定制格式） |
| `%ar` | 作者修订日期，按多久以前的方式显示            |
| `%cn` | 提交者的名字                                  |
| `%ce` | 提交者的电子邮件地址                          |
| `%cd` | 提交日期                                      |
| `%cr` | 提交日期（距今多长时间）                      |
| `%s`  | 提交说明                                      |

### 限制输出长度

**过滤** `git log` 输出的选项：

| 选项                  | 说明                                       |
| :-------------------- | :----------------------------------------- |
| `-<n>`                | 仅显示最近的 n 条提交。                    |
| `--since`, `--after`  | 仅显示指定时间之后的提交。                 |
| `--until`, `--before` | 仅显示指定时间之前的提交。                 |
| `--author`            | 仅显示作者匹配指定字符串的提交。           |
| `--committer`         | 仅显示提交者匹配指定字符串的提交。         |
| `--grep`              | 仅显示提交说明中包含指定字符串的提交。     |
| `-S`                  | 仅显示添加或删除内容匹配指定字符串的提交。 |
| `--all-match`         | 多个条件使用 and 而不是 or                 |
| `--`                  | 指定文件夹                                 |
| `--no-merges`         | 隐藏合并提交                               |

```shell
# since 可用的格式
git log --since=
  2.weeks
  2008-01-15
  2 years 1 day 3 minutes ago
# 只显示添加或删除内容中有 function_name 的提交
git log -S function_name
# Junio Hamano 在 2008 年 10 月期间， 除了合并提交之外的哪一个提交修改了测试文件
git log --pretty="%h - %s" --author='Junio C Hamano' --since="2008-10-01" --before="2008-11-01" --no-merges -- t/
```

## 撤消操作

```shell
# 修补最近一次提交
git commit --amend

# 取消暂存的文件
git reset HEAD -- <file>
# 丢弃所有更改
git reset --hard

# 撤消对文件的修改
git checkout -- <file>
```

## 远程仓库的使用

```shell
git remote # 列出远程仓库
	-v # 查看，origin 为远程仓库默认名字
	add <remote> <url> # 添加
	fetch <remote> # 拉取
	push <remote> <branch> # 推送
	show <remote> # 查看
	rename <from> <to> # 重命名
  remove, rm <remote> # 删除
```

## 打标签

Git 支持两种标签：

- 轻量标签（lightweight）：它只是某个特定提交的引用
- 附注标签（annotated）：是一次提交，包含提交信息、GNU Privacy Guard （GPG）签名并验证

推荐使用附注标签[^1]

```shell
# 查看标签
git tag # 列出标签，字母顺序
	-l, --list <wildcard> # 指定通配符

# 添加附注标签
git tag
	-a, --annotate <tagname>
	-m <message> # 描述
	<hash> # 指定提交

# 添加轻量标签，直接指定名称
git tag <tagname>

# 推送标签，push 默认不会推
git push <remote> <tagname> # 指定标签名
git push <remote> --tags # 所有

# 删除标签
git tag -d <tagname>
# 删除远程标签
git push <remote> :refs/tags/<tagname> # 将冒号前面的空值推送到远程标签名，相当于删除
git push <remote> --delete <tagname> # 直观的方式

# 检出标签
git checkout <tagname> # 分离头指针状态
git checkout -b <tagname> <branchname> # 检出为分支
```

## Git 别名

```shell
git config --global alias.<alias> <git command>
git config --global alias.<alias> !<command>
```

## 总结

- gitignore
- git log
- git remote
- git tag

## 参考

[^1]: [（Stack Overflow）Why should I care about lightweight vs. annotated tags?](https://stackoverflow.com/questions/4971746/why-should-i-care-about-lightweight-vs-annotated-tags)

