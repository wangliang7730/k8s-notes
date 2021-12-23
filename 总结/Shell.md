# Shell

```bash
#!/bin/bash
```

## 符号

```bash
'' # 不解析
"" # 解析
`` # 调用命令
$() # 调用命令
() # 子 shell 执行
(()) # 算数运算
{} # 空格，分号结束
[] # 变量测试
```

## 子shell

- SHLVL
- BASH_SUBSHELL

## 变量

```bash
set # 显示自定义变量和环境变量
set -u # 不存在变量打印错误
env # 显示环境变量
unset
export
```

***预定义变量***

```bash
$n # $1 ${10}，$0 命令本身
$# # 个数
$* # 所有，整体
$@ # 所有，循环
$? # 上一条命令返回
$$ # 当前进程号
$! # 最后一个后台进程号
```

***数组***

```bash
${a[*]} # 所有
```

***变量测试***

> TODO

```bash
x=${y-默认值}
x=${y:+默认值}
x=${y-默认值}
x=${y:+默认值}
x=${y=默认值}
x=${y:=默认值}
x=${y?默认值}
x=${y:?默认值}
```

## 常用命令

***read***

```bash
-p # 提示
-t # 等待时间
-s # 隐藏
```

***declare***

```bash
-i # 整数
-a # 数组
-p # 打印
-x # 环境变量
-r # 只读
+ # 取消
```

***expr***

```bash
$(expr $a + $b) # 空格必须
```

***cut***

```bash
# 默认 tab 隔开
-f # 第几列
-d # 指定分隔符
-c m-n # 字符范围
```

***awk***

```bash
awk '条件1{动作1} 条件2{动作2}'
BEGIN{FS=":"}
$n # 0 整行，1 开始
~ /r/ # 包含r
FS # 分隔符
NR # 行号
NF # 字段数
```

***sed***

```bash
-n "2p" # 打印第二行
-i # 直接修改文件
-e # 多个动作，分号隔开
"2,4d" # 删除2-4行
a # 增加
i # 插入
c # 替换行
s # 替换字符
```

***sort***

***uniq***

**wc**

***test***

## 语法

```bash
if []; then
	...
elif []; then
	...
else
	...
fi

case v in
 "foo")
 		...
 		;;
 "bar")
 		...
 		;;
 *)
 		;;
esac

for i in 1 2; do
	...
done

for ((i=1;i<=100;i=i+1)); do
	...
done

while []; do
	...
done

until []; do
	...
done
```

