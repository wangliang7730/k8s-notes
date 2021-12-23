---
date: 2021-11-03
updated: 2021-11-16
---

# 第六章 、Linux 文件与目录管理

## 6.1 目录与路径

### 6.1.1 相对路径与绝对路径

略。

### 6.1.2 目录的相关操作

**`pwd` - 打印工作目录：**

```shell
pwd 选项 
-P        # 真实路径，而非链接路径
```

**`mkdir` - 创建文件夹：**

```shell
mkdir 选项 目录名称
-p        # 递归
-m 644    # 设置权限，而不是用 umask 的默认权限
```

**`rmdir` - 删除目录：**

```shell
rmdir 选项 目录名称
-p        # 递归
```

### 6.1.3 关于执行文件路径的变量： $PATH

略。

## 6.2 文件与目录管理

### 6.2.1 文件与目录的检视： ls

**`ls` - 显示目录内容列表：**

```shell
ls 选项 文件名或目录名称..
-a  # 全部的文件，连同隐藏文件( 开头为 . 的文件) 一起列出来(常用)
-A  # 全部的文件，连同隐藏文件，但不包括 . 与 .. 这两个目录
-d  # 仅列出目录本身，而不是列出目录内的文件数据(常用)
-f  # 直接列出结果，而不进行排序
-F  # 根据文件、目录等信息，给予附加数据结构，例如：
    # *:代表可执行文件； /:代表目录； =:代表 socket 文件； |:代表 FIFO 文件
-h  # 将文件容量以人类较易读的方式(例如 GB, KB 等等)列出来；
-i  # 列出 inode 号码
-l  # 长数据串行出，包含文件的属性与权限等等数据(常用)
-n  # 列出 UID 与 GID 而非用户与组的名称
-r  # 将排序结果反向输出
-R  # 连同子目录内容一起列出来
-S  # 以文件容量大小排序
-t  # 依时间排序
--color=never   # 不要依据文件特性给予颜色显示
--color=always  # 显示颜色
--color=auto    # 让系统自行依据设定来判断是否给予颜色
--full-time             # 以完整时间模式 (包含年、月、日、时、分) 输出
--time={atime,ctime}    # 输出 access 时间或改变权限属性时间 (ctime)而非内容变更时间 (modification time)
```

### 6.2.2 复制、删除与移动： cp, rm, mv

**`cp` - 复制文件或目录：**

```shell
cp [options] source1 source2 source3 .... directory
-a  # 相当于 -dr --preserve=all 的意思(常用)
-d  # 若来源文件为链接文件(link file)，则复制链接文件而不是链接的文件
-f  # 为强制(force)的意思，若目标文件已经存在且无法开启，则移除后再尝试一次
-i  # 若目标文件(destination)已经存在时，在覆盖时会先询问动作的进行(常用)
-l  # 进行硬链接(hard link)文件建立，而非复制文件本身
-p  # 连同文件的属性(权限、用户、时间)一起复制过去，而非使用默认属性(备份常用)
-r  # 递归持续复制，用于目录的复制行为(常用)
-s  # 复制成为符号链接文件 (symbolic link)
-u  # destination 比 source 旧才更新 destination，或 destination 不存在的情况下才复制。
--preserve=all  # 除了 -p 的权限相关参数外，还加入 SELinux 的属性, links, xattr 等也复制了。
```

**`rm` - 移除文件或目录：**

```shell
rm 选项 文件或目录
-f  # 就是 force 的意思，忽略不存在的文件，不会出现警告讯息
-i  # 互动模式，在删除前会询问使用者是否动作
-r  # 递归删除
```

- 文件名最好不要用“-”开头，会与选项混淆，可以 `rm -- -a-`。

**`mv` - 移动文件与目录，或更名：**

```shell
mv [options] source1 source2 source3 .... directory
-f  # force 强制的意思，如果目标文件已经存在，不会询问而直接覆盖
-i  # 若目标文件 (destination) 已经存在时，就会询问是否覆盖
-u  # 若目标文件已经存在，且 source 比较新，才会更新 (update)
```

### 6.2.3 取得路径的文件名与目录名称

**`basename` - 取得路径的文件名：**

```shell
basename /etc/sysconfig/network
# 输出 network
```

**`dirname` - 取得路径的目录名：**

```shell
dirname /etc/sysconfig/network
# 输出 /etc/sysconfig
```

## 6.3 文件内容查阅

### 6.3.1 直接检视文件内容

**`cat` - concatenate：**

```shell
cat 选项 文件
-A  # 相当于 -vET 的整合选项，可列出一些特殊字符而不是空白而已
-b  # 列出行号，仅针对非空白行做行号显示，空白行不标行号
-E  # 将结尾的断行字符 $ 显示出来
-n  # 打印出行号，连同空白行也会有行号，与 -b 的选项不同
-T  # 将 [tab] 按键以 ^I 显示出来
-v  # 列出一些看不出来的特殊字符
```

**`tac` - 最后一行到第一行**

**`nl` - 添加行号打印：**

```shell
nl 选项 文件
-b  # 指定行号指定的方式，主要有两种：
    a   # 表示不论是否为空行，也同样列出行号(类似 cat -n)
    t   # 如果有空行，空的那一行不要列出行号(默认值)
-n # 列出行号表示的方法，主要有三种：
    ln  # 行号在屏幕的最左方显示
    rn  # 行号在自己字段的最右方显示，且不加 0
    rz  # 行号在自己字段的最右方显示，且加 0
-w # 行号字段的占用的字符数
```

### 6.3.2 可翻页检视

**`more`：**

```shell
[Space] # 下一页
[Enter] # 下一行
/string # 向下搜索
:f      # 显示文件名以及目前显示的行数
q       # 退出
b       # 上一页
```

**`less`：**

```shell
/string # 向下搜索
?string # 向上搜索
n       # 重复前一个/搜索
N       # 重复前一个?搜索
g       # 第一行
G       # 最后一行
q       # 退出
```

### 6.3.3 资料撷取

**`head` - 取出前面几行：**

```shell
head 选项 文件
-n  # 后面接数字，代表显示几行的意思
```

**`tail` - 取出后面几行：**

```shell
tail 选项 文件
-n  # 后面接数字，代表显示几行的意思
-f  # 跟踪，要等到按下 [ctrl+c] 才会结束
```

### 6.3.4 非纯文本档： od

**`od` - 八进制十六进制查看：**

```shell
od [-t TYPE] 文件
-t      # 后面接类型：
    a       # 利用默认的字符来输出
    c       # 使用 ASCII 字符来输出
    d[size] # 利用十进制(decimal)来输出数据，每个整数占用 size bytes
    f[size] # 利用浮点数(floating)来输出数据，每个数占用 size bytes
    o[size] # 利用八进制(octal)来输出数据，每个整数占用 size bytes
    x[size] # 利用十六进制(hexadecimal)来输出数据，每个整数占用 size bytes
-t xCc  # 十六进制和字符对照
```

### 6.3.5 修改文件时间或建置新档： touch

**文件的时间：**

- mtime，modification time（默认）：内容修改。
- ctime，status time：属性更改。
- atime，access time：读取时间。

**`touch` - 修改文件时间或创建文件：**

```shell
touch 选项 文件
-a  # 仅修订 access time
-c  # 仅修改文件的时间，若该文件不存在则不建立新文件
-d  # 后面可以接欲修订的日期而不用目前的日期，也可以使用 --date="日期或时间"
-m  # 仅修改 mtime 
-t  # 后面可以接欲修订的时间而不用目前的时间，格式为[YYYYMMDDhhmm]
```

## 6.4 文件与目录的默认权限与隐藏权限

### 6.4.1 文件预设权限：umask

**`umask` - 文件预设权限：**

```shell
umask [002]
-s  # 以符号方式显示
```

- 文件为 `666(rw-rw-rw-)` 去除 `umask` 掩码。
- 目录为 `777(rwxrwxrwx)` 去除 `umask` 掩码。
- `umask` 默认 root 为 022，去除组合其他用户写权限；一般用户为 002，去除其他用户写权限。

### 6.4.2 文件隐藏属性

**`chattr` - 设置文件属性：**

```shell
chattr [+-=]选项 文件或目录名称
A   # 访问时间 atime 将不会被修改
S   # 进行文件的修改会同步写入到磁盘中
a   # 将只能增加数据，不能删除也不能修改数据，只有 root 才能设定这属性
c   # 存储时自动压缩，读取时自动解压缩
d   # dump 程序被执行的时候，不会被 dump 备份
i   # 不能被删除、改名、设置链接也无法写入或新增数据，只有 root 能设定此属性
s   # 如果文件被删除，会完全移除硬盘空间，如果误删了，完全无法恢复
u   # 与 s 相反，如果文件被删除，数据内容还存在磁盘中，可以恢复

# 【注意】xfs 文件系统仅支援 AadiS
```

**`lsattr` - 显示文件属性：**

```shell
lsattr 选项 文件或目录
-a  # 包括隐藏文
-d  # 目录本身
-R  # 递归
```

### 6.4.3 文件特殊权限： SUID, SGID, SBIT

**Set UID：**

- 仅对二进制程序有效，shell 脚本无效。
- 执行者对于该程序需要具有 `x` 的可执行权限。
- 仅在执行该程序的过程中有效。
- 执行者将具有该程序拥有者的权限。
- 例如：`ll /usr/bin/passwd -> -rwsr-xr-x`。

**Set GID：**

- 仅对二进制程序有用，shell 脚本无效。
- 程序执行者对于该程序来说，需具备 `x` 的权限。
- 执行者在执行的过程中将会获得该程序群组的支持。
- 例如：`ll /usr/bin/mlocate -> -rwxr-sr-x`。

**Sticky Bit：**

- 当用户对于此目录具有 `w`、`x` 权限。
- 当用户在该目录下建立文件或目录时，仅有自己与 root 才有权力删除该文件。
- 例如：`ll -d /tmp -> drwxrwxrwt`。

**设置 SUID/SGUI/SBIT：**

- 使用 `chmod`， SUID、SGUI、SBIT 分别对应 421，加在权限最前面，如 7777；也可以使用符号，如 `u+s`、`g+s` 和 `o+t`。
- 查看时在可执行位，不可执行为大写 `S` 或 `T`。

### 6.4.4 观察文件类型：file

**`file` - 查看文件类型**

## 6.5 指令与文件的搜寻

### 6.5.1 脚本文件名的搜寻

**`witch` - 寻找执行文件：**

```shell
witch 选项 命令
-a  # 将所有由 PATH 目录中可以找到的指令均列出，而不止第一个被找到的指令名称
```

### 6.5.2 文件档名的搜寻

**`whereis` - 在一些特定的目录中寻找文件名：**

```shell
whereis 选项 文件或目录名
-l  # 可以列出 whereis 会去查询的几个主要目录
-b  # 只找 binary 格式的文件
-m  # 只找在说明文件 manual 路径下的文件
-s  # 只找 source 来源文件
-u  # 搜寻不在上述三个项目当中的其他特殊文件
```

**`locate` - 快速搜索文件名：**

```shell
locate 选项 关键词
-i  # 忽略大小写的差异
-c  # 不输出文件名，仅计算找到的文件数量
-l  # 仅输出几行的意思，例如输出五行则是 -l 5
-S  # 输出 locate 所使用的数据库文件的相关信息，包括该数据库纪录的文件/目录数量等
-r  # 后面可接正规表示法的显示方式
```

**`updatedb` - 更新 `locate` 需要的数据库：**

- 根据 */etc/updatedb.conf* 的设置更新 */var/lib/mlocate* 的数据库文件。

**`find` - 查找文件名：**

```shell
find [PATH] [option] [action]

# 【与时间相关】-atime、-ctime 和 -mtime，以 -mtime 为例
-mtime n 	  # n 为数字，意义为在 n 天之前的一天之内被改动过内容的文件
-mtime +n   # 列出在 n 天之前（不含 n 天本身）被改动过内容的文件名
-mtime -n   # 列出在 n 天之内（含 n 天本身）被改动过内容的文件名
-newer file # file 为一个存在的文件，列出比 file 还要新的文件名

# 【与用户或组相关】
-uid n      # 所属用户的 UID
-gid n      # 所属组的 GID
-user name  # 所属的用户名
-group name # 所属的组名
-nouser     # 拥有者不存在 /etc/passwd 的文件
-nogroup    # 拥有群组不存在 /etc/group 的文件

# 【与文件权限及名称有关】
-name filename  # 搜寻文件名为 filename 的文件，* 匹配任意字符
-size [+-]SIZE  # 搜寻比 SIZE 还要大（+）或小（-）的文件
                # c：代表 byte，k：代表 1024bytes。例如 50KB 大：-size +50k
-type TYPE      # 搜寻文件的类型为 TYPE 的，类型主要有：
                # 一般文件（f），装置文件（b，c），目录（d），链接文件（l），socket（s），FIFO（p）等
-perm mode      # 件权限等于 mode 的文件
-perm -mode     # 文件权限包含 mode 的文件
-perm /mode     # 文件权限包含任意 mode 的文件

# 【额外可进行的动作】
-exec command   # 额外的指令来处理搜寻到的结果
-print          # 将结果打印到屏幕上，这是预设动作
```

- 例，列出 SUID 和 SGUID 文件：

  ```shell
  find /usr/bin /usr/sbin -perm /7000 -exec ls -ld {} \;
  # {} 为 find 的内容，\; 转义分割符
  ```

## 6.6 极重要的复习！权限与指令间的关系

略。

## 6.7 重点回顾

略。

## 6.8 本章习题：

略。

## 6.9 参考数据与延伸阅读

略。