---
title: makefile介绍
hidden: true
date: 2021-06-20
---

# makefile介绍

- [x] [makefile的规则](#makefile的规则)
- [x] 一个示例
- [x] make是如何工作的
- [x] [makefile中使用变量](#makefile中使用变量)
- [x] [让make自动推导](#让make自动推导)
- [x] 另类风格的makefiles
- [x] 清空目标文件的规则
- [x] Makefile里有什么？
- [x] [Makefile的文件名](#Makefile的文件名)
- [x] [引用其它的Makefile](#引用其它的Makefile)
- [x] [环境变量MAKEFILES](#环境变量MAKEFILES)
- [x] [make的工作方式](#make的工作方式)

## makefile的规则

```mak
target ... : prerequisites ...
<tab>command
<tab>...
<tab>...
```

## makefile中使用变量

```makefile
# 定义
foo = bar
# 使用
$(foo)
```

## 让make自动推导

```makefile
# foo.o 的依赖和命令会自动推导，类似下面
foo.o : foo.c
	cc -o foo.o -c foo.c
```

## Makefile的文件名

默认顺序：

1. *GNUmakefile*
2. *makefile*
3. *Makefile*

```shell
make -f|--file foo.make # 指定文件
```

## 引用其它的Makefile

```makefile
include <filename>
# 例如
include foo.make *.mk $(bar)
```

查找顺序：

1. 当前目录
2. `-I|--include-dir` 指定的目录
3. *\<prefix\>/include*，一般是：*/usr/local/bin* 或 */usr/include*

没有找到不会马上报错，最终还没找到报错，可以 `-include` 忽略

## 环境变量MAKEFILES

类似于 `include`，区别是其目标不会起作用，错误也不会理，不推荐使用

## make的工作方式

1. 读入所有的 Makefile。

2. 读入被 `include` 的其它 Makefile。
3. 初始化文件中的变量。
4. 推导隐晦规则，并分析所有规则。
5. 为所有的目标文件创建依赖关系链。
6. 根据依赖关系，决定哪些目标要重新生成。
7. 执行生成命令。

