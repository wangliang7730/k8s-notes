; 【实验 6.2】编程，完成问题 7.9 中的程序
; 【问题 7.9】将 datasg 段中每个单词的前 4 个字母改为大写字母。

assume cs:codesg,ss:stacksg,ds:datasg

stacksg segment stack
  dw 0,0,0,0,0,0,0,0
stacksg ends

datasg segment
  db '1. display      '
  db '2. brows        '
  db '3. replace      '
  db '4. modify       '
datasg ends

codesg segment
start:
  ; 初始化栈段
  mov ax,stacksg
  mov ss,ax
  mov sp,16

  ; 初始化数据段
  mov ax,datasg
  mov ds,ax

  ; 外层循环
  mov cx,4
  mov bx,0
s1:
  ; 保存外层循环计数
  push cx
  ; 内层循环
  mov cx,2
  mov si,3
s2:
  ;mov al,[bx+si]
  ;and al,11011111b
  ;mov [bx+si],al
  ; 上面是书上操作，下面是骚操作，一次两个字节内层循环cx 4 改为 2，si 每次加 2
  and [bx+si],1101111111011111b
  add si,2
  loop s2

  add bx,16
  pop cx
  loop s1

  ; 结束
  mov ax,4c00h
  int 21h
codesg ends

end start