; MBR 主引导扇区, 读取物理第101块扇区的内容, 放到内存地址 0x10000 处位置
; 地址是组合 而不是相加,   0x0001 : 0x1234  ->  0x0010 1234


	lba_start_num equ 100   ; 用户程序所在虚拟硬盘中的虚拟扇区号 位置
						    ; 从逻辑扇区100号 开始写,逻辑扇区的100, 对应的是 物理扇区 101 ,逻辑扇区从1开始

SECTION mbr vstart=0x7C00 aling=16  ; 段地址从0x7c00 开始, 16字节对齐,  因为BIOS会将MBR放到内存地址 0x7c00处
									; 并且 CS:IP 会设置为这个值,  CS=0x07c0 , IP =0x0000

	mov ax, 0     ;设置栈顶位置 这里设置的地址并不是0, 而是 0x7c00 ,  
	mov ss, ax   
	mov sp, ax    ; SS:SP = 0x7c00,  栈顶位置
 
	mov ax, [cs:phy_base]
	mov dx, [cs:phy_base + 0x02]   ;; 组合两个16位寄存器 变成32位
	mov bx, 0x10
	div bx  ;  结果 0x1000 放在 AX寄存器, 余数放在 DX寄存器, 段地址计算, 0x10000 / 16 = 0x1000

	mov ds, ax  ; 将计算结果 放入 ds , 拿到了段地址,偏移地址从0开始

	xor bx,bx   ; 将寄存器清0
	mov si, lba_start_num   ; 读100号 扇区的内容, 逻辑编号
	xor di,di   ; 清0
	call read_disk  ; 将硬盘的 物理第 101号扇区 内容读取到 内存0x10000处位置, 一共 512字节

	mov ax, [0]   ; ax= 0x10000 内存位置的值, 同等于  mov ax,[0x10000]
	mov dx, [2]
	mov bx, 0x200
	div bx     ; ax= 程序所占的扇区总数 也就是整数商, dx=余数 
	cmp dx,0   ;验证是否有余数, 没有余数就代表是 有一部分数据不足一个扇区
	jnz CantDiv   ; dx不为0 代表有余数 就跳转
	dec ax        ; 扇区数自减

CandDiv:
	cmp  ax,0   ;判断 用户程序的所有内容是否满足一整个扇区.
	jz   realloc   ; ax为0 时执行这里, 跳转到重定位的位置
	mov cx, ax     ; ax 不等于0 会执行这里, 
				     ; cx是控制loop 循环的, ax非0 就表示有多少个扇区需要读
	push ds   ;保存栈地址
ReadContinue:  ; 还有扇区需要读
	inc si
	mov ax, ds
	add ax ,0x20
	mov ds, ax 
	xor bx,bx  ; 清空 偏移地址
	call read_disk
	loop ReadContinue
	pop ds 


realloc: ; 重定位操作, 所有的数据全部都已经读到内存了
	mov ax,[0x06]  ;段地址加偏移   用户程序的两个重定位表 具体位置 0x10006
	mov da,[0x08]  ;段地址加偏移
	call reallocAddr
	mov [0x06], ax


	mov cx, [0x0a]  ;; 循环次数, 重定位表的表项
	mov bx, 0x0c

reallocLoop:   ; 将重定位表  进行重定位
	mov ax,[bx]   ; 将寄存器 bx 里面存储的地址 指向的内存位置的值 取出来给ax
	mov ax,[bx +2] 
	call reallocAddr  ; 计算内存中的位置, 结果写入了 ax 寄存器,
	mov [bx], ax
	add bx , 4

	loop reallocLoop

	jmp far  [0x04] ; 处理器的控制权交给了用户程序

;---------------------------------------------------------------
; 输入: dx:ax == 32的偏移地址
; 输出:  16位段地址 写入 ax
reallocAddr:    ;计算物理内存位置的重定位程序
	push dx

	add ax, [cs:phy_base]  ; ax是调用者传入的 相对偏移量
	add dx, [cs:phy_base+0x02]

	shr ax,4  ;逻辑右移四位,  最后一位删除, 前面补0
	ror dx,4  ;循环右移四位 , 最低位 会放到最高位
	and dx, 0xf000  ; 与操作, 清空 低7bit位
	or  ax, dx   

	pop dx
	ret



;---------------------------------------------------------------
;输入: ds:bx = 从硬盘读取数据至该物理内存地址 , di:si= 逻辑扇区号
read_disk:
	push ax  ;保护现场
	push bx
	push cx
	push dx


	mov dx,0x1f2  ;0x1f2 是一个端口 BIOS提供的,	向这个端口写数据,控制的是 每次读多少个扇区, 端口映射的是 磁盘控制器
	              ; 0x1f2 控制的是 扇区写入的数目
				  ; 0x1f3 ~ 0x1f6  每个端口都是8位的 ,共32位, LBA28 地址寻找占用 0到27位
				  ; 0x1f7  是状态端口, 写入0x20就是读操作


	mov  al, 1    ; al 是8位寄存器
	out dx, al   ; 将 al内容写入到 0x1f2位置,  1是设置 每次只读一个扇区, 每个扇区512字节, 

	inc dx      ;自增 +1, 变成 0x1f3
	mov ax, si
	out dx, al  ; out就是写入命令

	inc dx     ; 0x1f4
	mov al, ah
	out dx, al

	inc dx   ;0x1f5
	mov ax, di
	out dx, al

	inc dx  ; 0x1f6
	mov al, 0xe0     ;设置7 -> 0 位, 7: 1LBA,0CHS  , 6:默认1, 5:0从硬盘,1主硬盘, 4:默认0 ,   1110 0000
	or al, ah
	out dx, al

	inc  dx;   0x1f7
	mov  al, 0x20  ; 0x20 代表是一个读命令, 写入之后就表示要读取硬盘扇区数据了
	out dx, al

waits:     ;检测硬盘是否繁忙
	in al, dx   ;通过 0x1f7端口 读取硬盘的状态到  al
	            ; 一共8位,  7:繁忙位 为1时无法访问,  3: 准备位 为1时才可以进行磁盘读写操作, 
	and al, 0x88
	cmp al, 0x08
	jnz waits     ;硬盘忙, 跳回去, 继续等待

	mov dx, 0x1f0  ; 0x1f0 硬盘控制器的数据端口 16位的, 并不上面8位的, 每次读取2字节, 一个扇区 需要读取 256次
	mov cx, 0x100  ;  0x100 = 256, 读取一个扇区的数据所需要的循环次数, 控制 loop循环

readsw:  ;能运行到这里, 就代表硬盘准备好了, 可以进行读写操作
	in    ax, dx     ; 读取 0x1f0 地址的数据, 放到 ax寄存器里面
	mov   [bx], ax   ; 将读取到的数据 写入到 栈区. bx指向的是栈区偏移值位置
	add   bx, 2      ; 每次读取两个2字节, 需要将 栈指针进行 增2
	loop readsw      ; 循环256次, 正好读取一个扇区的宽度 512Bytes

	pop dx  ;恢复现场
	pop cx
	pop bx
	pop ax
	ret ;  返回

	phy_base          dd 0x10000
	times  510-($-$$) db 0 ; $指的是当前地址, $$指的是段的起始地址 0x7c00, ($-$$) 会得到段起始地址到目前地址的距离
					   ; 510 减去前面的内容长度 会得到剩下的内容长度, 使用 db 将结果长度赋值成0
					   ; 填充中间的空闲区域
				      dw 0xaa55
    			  	  ;db 0x55, 0xaa    ; MBR启动扇区的最后两个字节的必需品,也是确认当前是启动扇区的主要标识符

