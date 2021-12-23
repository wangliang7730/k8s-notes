---
title: make 的运行
hidden: true
date: 2021-06-24
---

# make 的运行

- [x] make的退出码
- [x] 指定Makefile
- [x] [指定目标](#指定目标)
- [x] [检查规则](#检查规则)
- [x] [make的参数](#make的参数)

## 指定目标

- `all`: 这个伪目标是所有目标的目标，其功能一般是编译所有的目标。
- `clean`: 这个伪目标功能是删除所有被 make 创建的文件。
- `install`: 这个伪目标功能是安装已编译好的程序，其实就是把目标执行文件拷贝到指定的目标中去。
- `print`: 这个伪目标的功能是例出改变过的源文件。
- `tar`: 这个伪目标功能是把源程序打包备份。也就是一个 tar 文件。
- `dist`: 这个伪目标功能是创建一个压缩文件，一般是把 tar 文件压成 Z 文件。或是 gz 文件。
- `TAGS`: 这个伪目标功能是更新所有的目标，以备完整地重编译使用。
- `check` 和 `test`: 这两个伪目标一般用来测试 makefile 的流程。

## 检查规则

```shell
# 打印命令不执行
-n, --just-print, --dry-run, --recon
# touch 目标文件，不编译
-t, --touch
# 
-q, --question
#
-W <file>, --what-if=<file>, --assume-new=<file>, --new-file=<file>
```

## make的参数

> ℹ️ 参考：http://www.gnu.org/software/make/manual/make.html#Options-Summary

