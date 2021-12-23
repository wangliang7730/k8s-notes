# Makefile

参考资料：

- [阮一峰 - Make 命令教程](http://www.ruanyifeng.com/blog/2015/02/make.html)

- [跟我一起写 Makefile](https://seisman.github.io/how-to-write-makefile/index.html)

## 基本规则

```makefile
target ... : prerequisites ...
    command
    ...
    ...
```

> prerequisites 中如果有一个以上的文件比 target 文件要新的话，command 所定义的命令就会被执行。

## 变量

```makefile
# 定义变量
foo = bar
# 使用变量
$(foo)
```