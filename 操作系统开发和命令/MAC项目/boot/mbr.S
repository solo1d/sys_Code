;主引导程序 
;------------------------------------------------------------
%include "boot.inc"
SECTION MBR vstart=0x7c00         
   mov ax,cs      
   mov ds,ax
   mov es,ax
   mov ss,ax
   mov fs,ax
   mov sp,0x7c00
   mov ax,0xb800
   mov gs,ax


; 清屏 利用0x06号功能，上卷全部行，则可清屏。
; -----------------------------------------------------------
;INT 0x10   功能号:0x06	   功能描述:上卷窗口
;------------------------------------------------------
;输入：
;AH 功能号= 0x06
;AL = 上卷的行数(如果为0,表示全部)
;BH = 上卷行属性
;(CL,CH) = 窗口左上角的(X,Y)位置
;(DL,DH) = 窗口右下角的(X,Y)位置
;无返回值：
   mov     ax, 0x600
   mov     bx, 0x700
   mov     cx, 0           ; 左上角: (0, 0)
   mov     dx, 0x184f	   ; 右下角: (80,25),
			   ; VGA文本模式中,一行只能容纳80个字符,共25行。
			   ; 下标从0开始,所以0x18=24,0x4f=79
   int     0x10            ; int 0x10

; 打印 MBR 字符串
   mov byte [gs:0x00], '1'
   mov byte [gs:0x01], 0xA4

   mov byte [gs:0x02], ' '
   mov byte [gs:0x03], 0xA4

   mov byte [gs:0x04], 'M'
   mov byte [gs:0x05], 0xA4

   mov byte [gs:0x06], 'B'
   mov byte [gs:0x07], 0xA4

   mov byte [gs:0x08], 'R'
   mov byte [gs:0x09], 0xA4

   mov eax, LOADER_START_SECTOR     ; 起始扇区 lba 地址, 0x2
   mov bx, LOADER_BASE_ADDR         ; 写入的内存地址 0x900
   mov cx, 1                        ; 待读入的扇区数 
   call rd_disk_m_16                ; 以下读取程序的起始部分(一个扇区)

   jmp $
   jmp LOADER_BASE_ADDR



; 读取硬盘 n 个扇区
rd_disk_m_16:
   ; eax= LAB扇区号
   ; bx= 将数据写入的内存地址
   ; cx= 读入的扇区数
   mov esi, eax     ;; 备份eax
   mov di, cx       ;; 备份cx
; 读写硬盘
; 第1步, 设置要读取的扇区数
   mov dx, 0x1f2   ;; IDE0通道 
   mov al, cl      ;; cl 在上面被设置为1  ,xc
   out dx, al

   mov eax, esi    ;; 恢复原本 eax的值

; 第2步, 将LBA地址存入 0x1f3 ~ 0x1f6 端口

   ; LBA 地址 7 ~ 0 位 写入端口 0x1f3
   mov dx, 0x1f3
   out dx, al

   ; LBA 地址 15 ~ 8 位 写入端口 0x1f4
   mov cl, 8
   shr eax, cl    ;; 逻辑右移 eax 移动 cl 位置
   mov dx, 0x1f4
   out dx, al
   
   ; LBA 地址 23 ~ 16 位 写入端口 0x1f5
   shr eax, cl    ;; 逻辑右移 eax 移动 cl 位置
   mov dx, 0x1f5
   out dx, al
   

   shr eax, cl     ;; 逻辑右移
   and al, 0x0f    ;LBA地址 第24~27位 写入 0x1f6
   or  al, 0xe0    ;设置 7~4 位为 1110 ，表示 lba模式
   mov dx, 0x1f6

;第3步，向 0x1f7 端口写入命令 ,0x20  
   mov dx, 0x1f7
   mov al, 0x20
   out dx, al 

;第4步，检测硬盘状态
.not_ready:
   ; 同一端口，写时表示写入命令字，读时表示读入硬盘状态
   nop
   in  al, dx      ; 0x1f7 端口
   and al, 0x88    ; 第3为为1表示硬盘控制器已准备好数据传输,第7位为1表示硬盘忙
   cmp al, 0x08     ; al -0x08 
   jnz .not_ready     ; 若未准备好，继续等 。 jnz 结果不等于0 时 ，跳转

;第5步, 从0x1f0 端口读数据
   mov ax, di        ; di = cx  = 1
   mov dx, 256
   mul dx     ; 乘法， dx * ax  结果的高位固定放到 dx ,低位固定放到 ax
   mov cx, ax ; cx = 1
; di 为要读取的扇区数, 一个扇区有512字节,每次读入一个字(2byte).共需要di * 512/2 次, 所以 di * 256
   
   mov dx, 0x1f0    ;; 0x1f0 是数据端口

.go_on_read:
   in ax, dx
   mov [bx], ax    ;; 将 ax的值，写入 [bx] 内存地址中
   add bx, 2       ;; 小心地址溢出
   loop .go_on_read   ; 递减 ecx
   ret

   jmp $		; 使程序悬停在此 , 0x7c31

   times 510-($-$$) db 0
   db 0x55,0xaa

