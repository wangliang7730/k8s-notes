; 【实验 9】编程：在屏幕中间分别显示绿色、绿底红色、白底蓝色的字符串“welcom to masm!”。
; 材料：
; 1. 内存 B8000H ~ BFFFFH 共 32 KB 为显示缓冲区，分 8 页，每页 4 KB，一般显示第一页
; 2. 每页显示 25 行，每行 80 个字符，每个字符 2 个字节，低字节 ascii 码，高字节属性，共占 4000 B
; 3. 属性为：7    6 5 4   3    2 1 0
;           BL   R G B   I    R G B
;          闪烁  背景色  高亮  前景色

assume cs:code,ds:data

data segment
  db 'welcom to masm!'
data ends

code segment
start:
  mov ax,data
  mov ds,ax
  mov ax,0b800h
  mov es,ax

  mov cx,15
  mov si,0
  mov di,1982 ; 12 行 32 列
line1:
  ; 第一行
  mov al,[si]
  mov ah,00000010b
  mov es:[di],ax
  ; 第二行
  mov ah,00100100b
  mov es:[di+160],ax
  ; 第三行
  mov ah,01110001b
  mov es:[di+320],ax

  inc si
  add di,2
  loop line1

  mov ax,4c00h
  int 21h
code ends

end start