; 【实验 10.2】

assume cs:code,ds:data,ss:stacksg

data segment
  dw 32 dup(0)
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

  mov ax,4240h
  mov dx,0fh
  mov cx,0bh
  call divdw

  mov ax,4c00h
  int 21h

; 子程序：divdw
; 功能：进行不会产生溢出的除法运算，被除数为 dword 型，除数为 word 型，结果为 dword 型
; 参数：ax    被除数低 16 位
;       dx    被除数高 16 位
;       cx    除数
; 返回：ax    商低 16 位
;       dx    商高 16 位
;       cx    余数
; 举例：计算 1000000/11(F4240H/0BH)
;   mov ax,4240h
;   mov dx,0fh
;   mov cx,0bh
;   call divdw
;   结果：dx=1h，ax=631dh，cx=1h
; 公式：X/N = int(H/N)*65536 + (rem(H/N)*65536+L)/N
;   X       被除数，32 位
;   N       除数，16 位
;   H       X 高 16 位
;   L       x 低 16 位
;   int()   取整
;   rem()   取余
divdw:''

; 保存ax
mov ds:[0],ax

; 计算 int(H/N)
mov ax,dx
mov dx,0
div cx
mov ds:[2],ax

; 计算 (rem(H/N)*65536+L)/N
mov ax,ds:[0]
div cx

mov cx,dx
mov dx,ds:[2]

ret

code ends

end start