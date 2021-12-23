---
title: 《汇编语言（第3版）》
categories: [书籍]
date: 2021-02-28
---

# 汇编语言（第3版）

## 第 2 章  寄存器

8086 CPU 有 14 个寄存器，分别是：`ax`、`bx`、`cx`、`dx`、`si`、`di`、`sp`、`bp`、`ip`、`cs`、`ss`、`ds`、`es`、`psw`

### 通用寄存器

通用 16 位寄存器：`ax`、`bx`、`cx`、`dx`，均可分为 `xh` 和 `xl`

### 寻址

8086 CPU 是 16 位结构的 CPU，但是有 20 位地址总线，所以寻址需要通过：
$$
物理地址 = 段地址 \times 16 + 偏移地址
$$

>   **理解：**
>
>   -   可以将起始地址为 16 倍数的一组内存单元定义为一个段
>   -   一个段最大的大小由偏移地址大小决定，即： $2^{16} = 64k$
>   -   同一个物理地址可以对应不同的段地址和偏移地址组合

### `cs` 和 `ip`

任意时刻，CPU 将 `cs:ip` 指向的内容当做指令执行

8086 CPU 的简要工作过程：

1.  从 `cs:ip` 指向的内存单元读取指令，读取的指令进入指令缓冲器
2.  `ip = ip + 读取的指令长度​`，指向下一条指令
3.  执行指令，转到步骤1，重复

### 修改 `cs`、`ip` 的指令

```assembly
jmp 段地址:偏移地址
jmp 某一合法寄存器 ; 只改变 ip 的值
```

## 第 3 章  寄存器（内存访问）

### `ds` 和 `[address]`

```assembly
mov ax,1000h
mov ds,ax
mov al,[0] ; 将 ds:1000h 的数据送入 al 中
```

>   8086CPU 不支持数据直接进入段寄存器

### `mov`、`add`、`sub` 指令

`mov`、`add`、`sub` 支持以下形式： 

```assembly
; 根据排列组合（可以自己和自己），一共 4x4=16 种
; 除去立即数作为目的的，剩 12 种
; 再除去下面 3 种，一共有 9 种形式
; mov 段寄存器，立即数
; mov 段寄存器，段寄存器
; mov 内存单元，内存单元
mov 寄存器,立即数
mov 内存单元,立即数
mov 寄存器,寄存器
mov 段寄存器,寄存器
mov 内存单元,寄存器
mov 寄存器,段寄存器
mov 内存单元,段寄存器
mov 寄存器,内存单元
mov 段寄存器,内存单元
```

<img src="assets/MOV 的形式.drawio.svg"/>

> **参考：**
>
> - [汇编指令mov的几种形式](https://blog.csdn.net/tangdandang/article/details/5250368)

### 栈

任意时刻，`ss:sp` 指向栈顶元素。

`push ax` 由以下两步完成：

1. `sp = sp - 2`
2. 将 `ax` 中的内容送入 `ss:sp` 指向的内存单元 

`pop ax` 相反：

1. 将 `ss:sp` 指向的内存单元数据送入 `ax` 中
2. `sp = sp + 2`

>   **注意：**
>
>   -   **高地址为栈底**
>   -   一个栈元素占**两个字节**，`sp` 指向第二个（低地址）字节
>   -   栈为空时，`sp` 指向 `栈底地址 + 1`，所以栈段（0000-FFFF）为空时 `sp` 指向 `ffff + 1 = 0`

### `push`、`pop` 指令

`push`、`pop` 可以是如下形式：

```assembly
push 寄存器|段寄存器|内存单元
pop 寄存器|段寄存器|内存单元
```

## 第 4 章  第一个程序

### 源程序

```assembly
assume cs:codesg

codesg segment ; 段开始
	...
	...
	mov ax,4c00h
	int 21h ; 返回
codesg ends ; 段结束ends

end ; 程序结束end
```

> 不完整，完整的见 [程序结构](#程序结构)

### 编译链接

```shell
masm.exe foo.asm; # 可省略 asm，加分号省略中间文件，得到 foo.obj
link.exe foo.obj; # 可省略 obj，加分号省略中间文件，得到 foo.exe
```

### 程序执行过程的跟踪

<img src="assets/EXE 的加载过程.png"/>

- 程序加载后，`ds` 存放程序所在的段地址，偏移地址为 `0`
- 前 `256` 个字节存放的是 PSP，DOS 用来和程序通信
- `ds:0 + 256 = (ds + 10h):0`，所以 `cs = ds + 10h`

## 第 5 章  `[bx]` 和 `loop` 指令

> 为了描述上的简洁，作者使用 `()` 表示寄存器或内存单元的内容，如：
>
> - `(ax)` 表示 `ax` 中的内容
> - `(20000h)` 表示内存单元 `20000h` 中的内容
> - `((ds)*16+(bx))` 表示 `ds:bx` 中的内容
>
> 使用 `idata` 表示常量

### `loop` 指令

`loop 标号` 执行：

1. `(cx) = (cx) - 1`
2. 如果 `(cx)` 不为 `0`，则跳转至标号处

即 `CX` 存放了循环的次数

> 数据不能以字母开头，需要前面加0，如 `a000h` 需要写成 `0a000h`

### MASM 对 `[idata]` 的处理

MASM 处理 `idata` 为 `idata`，所以在汇编源程序中用 `[bx]` 或 `ds:[idata]`

### 一段安全的空间

DOS 和其他合法的程序一般不会使用 `0:200~0:2ff` 这段空间

## 第 7 章  更灵活的定位内存地址的方法

### 大小写转换问题

- 大写字母 `A - Z` 为 `41h - 5ah`，即二进制 `010x xxxx`
- 小写字母 `a - z` 为 `61h - 7ah`，即二进制 `011x xxxx`

所以：

```assembly
and al,1101 1111 ; 转大写
or  al,0010 0000 ; 转小写
```

### `[bx+si|+idata]`

```assembly
; 有以下几种形式
mov ax,[bx+si+200]
mov ax,200[bx][si]
mov ax,[bx].200[si]
mov ax,[bx][si].200
```

## 第 8 章  数据处理的两个基本问题

### `bx`、`si`、`di` 和 `bp`

- 只有这 4 个寄存器可以用在 `[x]` 中寻址
- `bx` 和 `bp` 不能同时使用
- `si` 和 `di` 不能同时使用
- `bp` 默认段地址在 `ss` 中

### 寻址方式

![寻址方式](assets/寻址方式.png)

### 数据长度

```assembly
# 通过寄存器指定
mov ax,0 ; 2 byte
mov al,0 ; 1 byte

# 通过 ptr 指定
mov word ptr [0],0 ; 2 byte
mov byte prt [0],0 ; 1 byte
```

### `DIV ` 指令

```assembly
div byte ptr x ; (ax)÷x=(al)...(ah)
div word ptr x ; ((dx*10000h+(ax))÷x=(ax)...(dx)
```

### 定义数据

```assembly
data segment
  db 1 ; 1 byte
  dw 1 ; 2 byte
  dd 1 ; 4 byte
  dx 重复次数 dup (重复数据) ; dx=db|dw|dd
data ends
```

## 第 9 章  转移指令的原理

可以修改 `ip`，或同时修改 `cs` 和 `ip` 的指令统称为转移指令。

```assembly
jump 1000:0 ; 段间转移
```

### 操作符 `offset`

取得标号的偏移地址

```assembly
start: mov ax,offset start ; 0
s: mov ax,offset s ; 3
```

### `jmp` 指令

```assembly
jmp short 标号 ; 短转移 -128 ~ 127 ，一个字节补码表示相对位移
jmp near ptr 标号 ; 近转移 -32768 ~ 32767，两个字节补码表示相对位移
jmp far ptr 标号 ; 段间转移、远转移，四个字节存段地址和偏移地址
jmp 16 位寄存器 ; IP=值
jmp word ptr 内存地址 ; IP=值
jmp dword ptr 内存地址 ; CS=高两位只，IP=低两位值
```

### `jcxz` 和 `loop` 指令

```assembly
jcxz 标号 ; 如果 cx=0，跳转到标号
loop 标号 ; cx-1，如果 cx!=0，跳转到标号
```

> 所有条件转移都是短转移，位移为：标号 - 指令后第一个字节

## 第 10 章  `call` 和 `ret` 指令

```assembly
ret ; 相当于 pop ip
retf ; 相当于 pop ip; pop cs
call 标号 ; 相当于 push ip; jmp near ptr 标号
call far ptr 标号 ; 相当于 push cs; push ip; jmp far prt 标号
call 16 位寄存器 ; 相当于 push ip; jmp 16 位寄存器
call word ptr 内存地址 ; 相当于 push ip; jmp word prt 内存地址
call dword ptr	 内存地址 ; 相当于 push cs; push ip; jmp dword ptr 内存地址
```

> `call` 不能实现短转移

## 第 11 章  标志寄存器

程序状态字：PSW

| 15   | 14   | 13   | 12   | 11                     | 10         | 9            | 8                    | 7                      | 6            | 5    | 4    | 3    | 2                              | 1    | 0                            |
| ---- | ---- | ---- | ---- | ---------------------- | ---------- | ------------ | -------------------- | ---------------------- | ------------ | ---- | ---- | ---- | ------------------------------ | ---- | ---------------------------- |
|      |      |      |      | of                     | df         | if           | tf                   | sf                     | zf           |      | af   |      | pf                             |      | cf                           |
|      |      |      |      | 溢出标志位             | 方向标志位 | 可屏蔽外中断 | 单步中断             | 符号标志位             | 零标志位     |      |      |      | 奇偶标志位                     |      | 进位、借位标志位             |
|      |      |      |      | **有符号**运算是否溢出 |            |              | 为  1 会触发单步中断 | **有符号**结果是否为负 | 结果是否为 0 |      |      |      | 结果 bit 为 1 的个数是否为偶数 |      | **无符号**运算是否进位或借位 |

### `adc` 指令

```assembly
; 带进位的加法
adc ax,bx ; ax+bx+cf
```

### `sbb` 指令

```assembly
; 带借位的减法
sbb ax,bx; ax-bx-cf
```

### `cmp` 指令

```assembly
; 相当于减法，不保存结果，只影响标志位
cmp ax,bx

; 通过 zf 可以判断是否相等
; zf   0   1
;      !=  =

; 通过无符号 cf 可以判断大小
; cf   0   1
;      >=  <

; 通过有符号 sf 和 of 可以判断大小
; of\sf   0   1
;  0     >=   <
;  1     <    >
```

### 条件转移指令

无符号条件转移指令：

| 指令  | 含义         | 标志位         |
| ----- | ------------ | -------------- |
| `je`  | 等于则转移   | `zf=1`         |
| `jne` | 不等于则转移 | `zf=0`         |
| `jb`  | 低于则转移   | `cf=1`         |
| `jnb` | 不低于则转移 | `cf=0`         |
| `ja`  | 高于则转移   | `cf=0 && zf=0` |
| `jna` | 不高于则转移 | `cf=1 || zf=1` |

> 字母含义：e=equal，n=not，b=below，a=above

### 串传送指令

```assembly
movsb ; 类似 mov es:[di],byte prr ds:[si]，如果 df=0，si++，di++；如果 df=1，si--，di--
movsw ; +2
rep movsb ; 配合 rep，重复执行，类似 loop 以 cx 判断
cld ; df=0，clear
std ; df=1，set
```

### `pushf` 和 `popf`

标志寄存器的值入栈和出栈，为访问标志寄存器提供了一种方法

### 标志寄存器在 DEBUG 中的表示

| 标志 | 值为 1 的标记 | 值为 0 的标记 |
| ---- | ------------- | ------------- |
| `of` | OV            | NV            |
| `sf` | NG            | PL            |
| `zf` | ZR            | NZ            |
| `pf` | PE            | PO            |
| `cf` | CY            | NC            |
| `df` | DN            | UP            |

## 第 12 章  内中断

### 内中断的产生

- 除法错误：0
- 单步执行：1
- 执行 `info` 命令：4
- 执行 `int` 命令：n

256 个中断码，内存 0:0 到 0:3ff 的 1024 个字节存放中断向量表，高地址存段地址，低地址存偏移地址。

### 中断过程

1. 获取中断码 `n`
2. `pushf`
3. `tf=0`，`if=0`
4. `push cs`
5. `push ip`
6. `ip=n*4`，`cs=n*4+2`

处理完成后用 `iret` 返回，类似：

```assembly
pop ip
pop cs
popf
```

> ```assembly
> mov ss,ax
> mov sp,0
> ```
>
> 不会响应中断

## 第 15 章  外中断

- 看屏蔽中断：`if`、`sti`、`cli`
- 不可屏蔽中断：中断码 2

## 附录

### 环境搭建

- 需要用到的工具在 [tool](./tool) 文件夹里

- 安装 [DOSBox](https://www.dosbox.com/)
- 配置 DOSBox Options，文件在 `%homedrive%%homepath%\AppData\Local\DOSBox`

为了方便学习，可以将项目根目录挂载到 C 盘，工具添加到环境变量

```ini
# 将项目挂载到C盘根目录
MOUNT C C:\Users\sharon\workspace\me\assembly-language-3e
# 工具加入到环境变量
SET PATH=%PATH%;C:\tool
# 切换到C盘
C:
```

> 用 VSCode 插件比较香

### DEBUG 的使用

```bash
# 指定地址有几种方式
不指定为当前
偏移地址
段地址:偏移地址
段地址:起始偏移地址 结束偏移地址

r # 查看寄存器内容
r ax # 改变寄存器内容

d 地址 # 查看内存中内容
d # 后续的内容

e 地址 # 修改内容
e 地址 内容 # 直接修改内容

a 地址 # 写入汇编指令

u 地址 # 查看对应汇编指令

### 调试
debug foo.exe
t # 单步执行
g 地址 # 执行到
p # 执行完循环，执行int 21h

q # 退出
```

### 程序结构

```assembly
assume cs:code,ds:data,ss:stack

data segment ; 数据段开始
  ...; 定义数据
data ends ; 数据段结束

stack segment stack ; 栈段开始
  ...; 定义数据
stack ends ; 栈段结束

code segment ; 代码段开始
  ... ; 定义数据
start: ; 程序入口
  ... ; 程序代码
  mov ax,4c00h
  int 21h ; 返回
code ends ; 代码段结束

end start ; 程序结束
```

### VSCode 中调试

下载 **MASM/TASM** 插件，右键 **打开DOS环境**

```shell
masm t; # 编译
link t; # 链接
debug t.exe # 调试
u # 查看汇编代码
g # 运行到
d 0 # 查看数据段
```

## 参考资料

- [FriendLey/assembly-language-learning](https://github.com/FriendLey/assembly-language-learning)
- [码龙黑曜/汇编](https://blackdragonf.github.io/all-tags/#%E6%B1%87%E7%BC%96-list)

