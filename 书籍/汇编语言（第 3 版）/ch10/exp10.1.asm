; 【实验 10.1】

assume cs:code,ds:data,ss:stacksg

data segment
  db "            _____ _                             _                               "
  db "            / ____| |                           | |                             "
  db "           | (___ | |__   __ _ _ __ ___  _ __   | |     ___  ___                "
  db "            \___ \| '_ \ / _` | '__/ _ \| '_ \  | |    / _ \/ _ \               "
  db "            ____) | | | | (_| | | | (_) | | | | | |___|  __/  __/               "
  db "           |_____/|_| |_|\__,_|_|  \___/|_| |_| |______\___|\___|               "
  db "                                                                               ",0

data ends

stacksg segment stack
  dw 32 dup(0)
stacksg ends

code segment
start:
  mov ax,data
  mov ds,ax

  mov ax,stacksg
  mov ss,ax
  mov sp,64

  mov si,0
  mov dh,10
  mov dl,0
  mov cl,00000001b
  call show_str

  mov ax,4c00h
  int 21h

; 子程序：show_str
; 功能：在指定的位置，用指定的颜色，显示一个用 0 结束的字符串
; 参数：dh    行号，取值范围 0 ~ 24
;       dl     列号，取值范围 0 ~ 79
;       cl     颜色，（闪烁）BL   （背景）R G B   （高亮）I    （前景）R G B 
;       ds:si  字符串首地址
; 返回：无
show_str:
  ; push 用到的寄存器
  push ax
  push bx
  push cx
  push dx
  push es
  push ds
  push si
  push di

  ; 0,0 位置
  mov ax,0b800h
  mov es,ax

  ; dh 行 x 80 x 2
  push cx
  mov bl,dh
  mov bh,0
  mov cl,dl
  mov ch,0
  mov ax,160
  mul bx
  ; 加上 dl 列
  add ax,cx
  add ax,cx
  mov bx,ax ; 第 dh 行，第 dl 列
  pop cx

  ; 颜色
  mov al,cl

; 字符串循环
mov ch,0
mov di,0
str_for:
  mov cl,[si]
  jcxz str_end
  mov es:[bx+di],cl
  mov es:[bx+di].1,al
  inc si
  add di,2
  jmp str_for
str_end:
  pop di
  pop si
  pop ds
  pop es
  pop dx
  pop cx
  pop bx
  pop ax
  ret
code ends

end start