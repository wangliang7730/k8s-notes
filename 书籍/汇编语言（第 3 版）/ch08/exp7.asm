; 【实验 7】Power idea 公司从 1975 年成立一直到 1995 年的基本情况如下。
; 年份  收入(千美元)  雇员(人)  人均收入(千美元)
; 1975           16        3          ?
; ...
; 1995      5937000    17800          ?
; 编程，将 data 段中的数据按如下格式写入到 table 段中，并计算 21 年中的人均收入（取整），
; 结果也按照下面的格式保存在table段中。
; | 年份 | |空格| | 收入 | |空格| |雇员数| |空格| |人均收入| |空格|
; 0 1 2 3    4    5 6 7 8   9      A B      C      D E       F
assume cs:code,ss:stacksg

stacksg segment stack
  dw 8 dup (0)
stacksg ends

data segment
  db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
  db '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
  db '1993', '1994', '1995'
  ; 以上是表示 21 年的 21 个字符串

  dd 16, 22, 382, 1356, 2390, 8000, 16000, 24486, 50065, 97479, 140417, 197514
  dd 345980, 590827, 803530, 1183000, 1843000, 2759000, 3753000, 4649000, 5937000
  ; 以上是表示 21 年公司总收入的 21 个 dword 型数据

  dw 3, 7, 9, 13, 28, 38, 130, 220, 476, 778, 1001, 1442, 2258, 2793, 4037, 5635, 8226
  dw 11542, 14430, 15257, 17800
  ; 以上是表示 21 年公司雇员人数的 21 个 word 型数据
data ends

table segment
  db 21 dup ('year summ ne ?? ')
table ends


code segment
start:
  ; 栈段
  mov ax,stacksg
  mov ss,ax
  mov sp,16

  ; 数据段
  mov ax,data
  mov ds,ax

  ; table 数据段
  mov ax,table
  mov es,ax

  ; 循环
  mov cx,21
  mov bx,0
lo:
  ; table 偏移
  mov ax,bx
  mov dx,16
  mul dx
  mov di,ax

  ; 年份
  push di
  mov ax,bx
  mov dx,4
  mul dx
  mov si,ax
  ; 前两个字节
  mov ax,[si]
  mov es:[di],ax
  ; 后两个字节
  mov ax,[si+2]
  mov es:[di+2],ax
  pop di

  ; 收入
  push di
  mov ax,bx
  mov dx,4
  mul dx
  mov si,ax
  ; 前两个字节
  mov ax,84[si]
  mov es:[di].5,ax
  ; 后两个字节
  mov ax,84[si+2]
  mov es:[di+2].5,ax
  pop di

  ; 雇员数
  push di
  mov ax,bx
  mov dx,2
  mul dx
  mov si,ax
  mov ax,168[si]
  mov es:[di].10,ax
  pop di

  ; 人均年收入
  mov ax,es:[di].5
  mov dx,es:[di+2].5
  div word ptr es:[di].10
  mov es:[di].13,ax

  inc bx
  loop lo

  mov ax,4c00h
  int 21h
code ends

end start