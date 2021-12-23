# Linux 命令

## 其他

***快捷键***

```bash
tab # 补全命令
ctrl+a # 行首
ctrl+e # 行尾
ctrl+c # 终止
ctrl+l # 清屏
ctrl+u # 剪切光标前
ctrl+y # 粘贴
ctrl+z # 暂停到后台
```

***history***

***alias***

- 永久：~/.bashrc

***echo***

```bash
-e # 反斜杠转义
-e "\033[背景色;前景色\033[0m" # 颜色
```

## 帮助

***man***

```bash
5 # 指定级别
-f # whatis
-k # aprops，相关
```

***info***

```bash
？ # 帮助
回车/u # 下/上一层
n/p # 下/上一节
```

***help***

- 查看内置命令

## 目录

***cd***

```bash
. .. - ~
```

***pwd***

***ls***

```bash
-a l h i d
```

> ***-l 内容***

```bash
lrwxrwxrwx.   1 root root    7 1月  10 06:21 bin -> usr/bin
# 权限   引用计数 所有者 所属组 大小 修改或访问时间  文件名    链接
```

***mkdir***

```bash
# 递归
-p
```

***rmdir***

```bash
# 只能删除空目录
# 递归
-p
```

***文件***

***stat***

```bash
# access：访问时间
# modify：数据修改时间，block 内容改变
# change：状态改变时间，block 内容或 inode 文件属性改变
```

***file***

***type***

***touch***

```bash
# 创建空文件或修改文件三个时间
```

***cat***

```bash
-n
# 显示回车 $，tab ^I
-E T
# 显示特殊字符
-v
# 所有隐藏字符，包括 vET
-A
```

***tail***

```bash
-n f
```

***head***

***more***

***less***

***ln***

```bash
ln 源文件 链接文件
# 软链接
-s
```

> ***软硬链接的区别***

- 硬链接不能链接目录，不能跨分区
- 软连接 inode 不会增加
- 软连接最好用绝对路径

***rm***

```bash
-r f i
```

***cp***

```bash
-i
# 递归
-r/R
# 保留源文件属性
-p
# 软链接复制，而不是复制源文件
-d
# -dpr
-a
```

***mv***

```bash
- i f v
```

## Vim

***输入模式***

```bash
# 字符前后
io
# 当前行前后
IO
# 插入行
oO
```

***命令模式***

```bash
# 撤销
u
# 反撤销
ctrl+r
```

***底线命令模式***

```bash

```

***可视模式***

```bash

```

## 搜索

***whereis***

- 位置

***which***

- 别名

***locate***

```bash
# 忽略大小写
-i
```

- updatedb：更新
- /etc/updatedb.conf：禁止搜索配置
- /var/lib/mlocate/mlocate.db：数据位置

***find***

```bash
位置 搜索条件
# 文件名，通配符匹配：*?[^]
-name/iname
# inode
-inum
# 大小，单位 b/c/w/k/M/G，默认为b
	# b 512 字节
	# c 1 字节
	# w 2 字节
-size +-2
# 时间：+5，5天前；5，第5天；-5,5天内
-atime/mtime/ctime 天
-amin/mmin/cmin -5
# 用户/组
-user/group
# 权限
-perm
# and/or/ i /not
-a/o/not
# 类型 f/d/l
-type
# 执行命令，{} 内为搜索结果
-exec 命令 {}\;
# 询问是否执行命令
-ok 命令 {}\;
```

***grep***

```bash
选项 搜索内容 文件
# 忽略大小写
-i
# 显示行号
-n
# 反选
-v
# 颜色
--color=auto
```

## 压缩

***zip***

```bash
选项 压缩文件.zip 源文件2 源文件3
unzip -d 目录
```

***gzip***

- 只压缩，不打包

```bash
# 解压
-d
# 压缩目录里的文件
-r
```

***bzip2***

```bash
# 解压
-d
# 保留源文件
-k
```

***tar***

```bash
-v
# 打包
-c
# 解压
-x
# 查看
-t
# 指定打包文件
-f
# gzip
-z
# bz2
-j
# 位置
-C
# 指定解压的文件
-C 解压到 解压的文件
```

## 关机重启

***shutdown***

```bash
# 重启
-r now
# 关机
-h
# 取消
-c
```

***reboot***

***halt***

***poweroff***

## 用户和组

***useradd***

默认值：

- /etc/default/useradd
- /etc/login.defs

```bash
-u # 指定uid
-g # 指定初始组
-G # 指定附加组
-c # 设置说明
-d # 设置家目录
-s # 设置bash
```

***usermod***

类似 useradd

***userdel***

```bash
-r # 删除家目录
```

***passwd***

```bash
-l # 锁
-u # 解锁
--stdin # echo 'pass' | passwd --stdin user
```

***chage***

```bash
-d 0 用户
```

***su***

```bash
- #  环境变量也切换
-c 命令 # 执行一次命令
```

***groupadd***

***groupdel***

***gpasswd***

```bash
-a 用户 # 添加用户
-d 用户 # 删除用户
```

## 权限

```bash
lrwxrwxrwx.
# . SELinux 管理
```

> ***文件类型***

- -：普通文件
- d：目录
- l：软链接
- b：块设备
- c：字符设备
- p：管道符
- s：套接字

> ***目录的权限***

只能 0、5、7，即不能进去，进去不能增删文件，进去能增删文件

***chmod***

```bash
ugoa +-= rwx,...
777
```

***chown***

- 普通用户不能修改

```bash
# 用户名 文件名
# 组:用户
# 组.用户

# 递归
-R
```

***chgrp***

***umask***

```bash
# 默认临时修改，永久修改去 /etc/profile
if [ $UID -gt 199 ] && [ "`/usr/bin/id -gn`" = "`/usr/bin/id -un`" ]; then
    umask 002
else
    umask 022
fi

# 文件666，文件夹777

# 字符显示
-S
```

***setfacl***

```bash
# 设置
-m u:用户名:权限 文件名
-m g:组名:权限 文件名
# 删除
-x u:用户名
# 删除所有
-b
# 递归已存在的文件
-R
# 对新建的文件设置默认权限，u前加d:
-m d:u:...
-m d:g:...
# 设置mask
-m m:权限
```

***sudo***

```bash
# 列出可用命令
-l
```

***visudo***

```bash
root ALL=(ALL) ALL
# man 5 sudoers
# % 代表组
# 1st ALL：IP
# 2nd ALL：可切换的身份，不写就是 root
# 3rd ALL：命令，逗号隔开
```

***getfacl***

***特殊权限***

```bash
rwsrwsrwt
# SetUID：大S无执行权限，执行时有文件所属用户的权限
# SetGID：执行时组身份为文件所属组；对于文件夹，新建的文件为所有者的所属组
# Sticky BIT：针对目录，只能删除自己的文件
```

***chattr***

```bash
# 不能任何修改删除；对目录的话可以改文件本身内容
+i
# 只能加，不能vi，可以echo>>；对目录可以新建，不能删除
+a
```

***lsattr***

```bash
# 查看目录
-d
```

***getenforce***

***setenforce***

*`/etc/selinux/config`*

## 网络

***ifconfig***

***ping***

***netstat***

```bash
-a t u p
# 显示ip和端口，而不是域名与服务名
-n
# 只显示监听
-l
# 显示路由表
-r
```

> ***输出***

```text
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 localhost:smtp          0.0.0.0:*               LISTEN 
协议  接收队列 发送队列 本机IP端口               远程IP端口                状态
```

## 用户交互

***wirte***

```bash
用户名 终端号 ctrl+d发送
```

***wall***

***mail***

```bash
# 发送
用户名
# 指定标题
-s
# 接收后查看，直接 mail
h 列出邮件
d 删除
q 退出
```

## 登录日志

***w***

***who***

***last***

***lastlog***

***lastb***


## 软件安装

***rpm***

- 命名规则：软件包名-版本-发布次数.发行商-硬件平台

```bash
-i v h
# 卸载
-e
# 不检测依赖
--nodeps
# 强制
--force
# 升级或安装
-U
# 升级
-F
# 验证
-V
# 文件提取
-cpio
```

> ***查询*** -q

```bash
# 所有
-a
# 信息
-i
# 未安装的包
-p
# 文件
-l
# 文件属于
-f
```

***yum***

```bash
list
search
remove

grouplist
groupinfo
groupinstall
groupremove
```

## 磁盘管理

***free***

***df***

```bash
-h
# 类型
-T
```

***du***

```bash
-h
# 统计
-s
```

***mount***

```bash
设备名 挂载目录
# 卸载
unmount 设备名/目录名
# 类型
-t iso9660
# 光盘设备名
/dev/cdrom -> /dev/sr0
# 根据 /etc/fstab 文件自动挂载
-a
# 特殊选项
-o
```

***fdisk***

```bash
# 查看
-l
```

***mkfs***

```bash
# 格式
-t
```

***mkswap***

***swapon***

***dumpe2fs***

***xfs_info***

***查看uuid***

- /dev/disk/by-uuid
- blkid
- lsblk -f

***parted***

***mklabel***

***配额***

***lvm***

- pvcreate
- pvdisplay
- vgdisplay
- vgextend
- lvresize

- #resize2fs
- xfs_growfs

## 启动

***runlevel***

***init***

*`/etc/inittab`*

## 服务

***service***

```bash
--status-all
```

***chkconfig***

```bash
--list
[--level 2345] httpd on/off
--add
服务名 on/off
```

***systemctl***

```bash
start/stop/status/restart
list-units/list-unit-files
enable/disable
is-enabled/is-active
```



***ntsysv***

## 系统资源

***ps***

***top***

***uptime***

***jobs***

```bash
-l # 列出
```

***fg***

***bg***

***nohup***

***vmstat***

***ps***

***dmsg***

***free***

***uname***

***lsb_release***

## 定时任务

***at***

***atq***

***atrm***

***crontab***

***anacron***

## 远程交互

***scp***

***rsync***

```bash
-av
```

