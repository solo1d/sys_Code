; MBR 主引导扇区
	
	lba_start_num	equ 100 ; 用户程序在虚拟硬盘中的逻辑扇区号

SECTION mbr vstart=0x7c00 align=16
	
	mov ax, 0 ; 设置栈顶位置
	mov ss, ax
	mov sp, ax

	mov ax, [cs:phy_base]
	mov dx, [cs:phy_base+0x02]
	mov bx, 0x10 
	div bx ; 0x1000
	mov ds, ax
	xor bx, bx ; 0x10000

	mov si, lba_start_num
	xor di, di
	call read_disk

	mov ax, [0]
	mov dx, [2]
	mov bx, 0x200 ; 512B
	div bx ; ax == 程序所占的扇区总数  dx == 最后不满一个扇区的字节数
	cmp dx, 0
	jnz CantDiv
	dec ax
CantDiv:
	cmp ax, 0
	jz realloc
	mov cx, ax
	push ds
ReadContinue:
	inc si
	mov ax, ds
	add ax, 0x20
	mov ds, ax
	xor bx, bx
	call read_disk
	loop ReadContinue
	pop ds
;--------------------------------------------------------
realloc:
	mov ax, [0x06]
	mov dx, [0x08]
	call reallocAddr
	mov [0x06], ax
	;mov [0x06], ds
	mov cx, [0x0a]
	mov bx, 0x0c

reallocLoop:
	mov ax, [bx]
	mov dx, [bx+2]
	call reallocAddr
	mov [bx], ax
	add bx, 4

	loop reallocLoop
	
	jmp far [0x04] ; 处理器的控制权交给了用户程序

;----------------------------------------------
; 输入: dx:ax == 32位的偏移地址
; 输出: 16位的段地址 ax
reallocAddr:
	push dx

	add ax, [cs:phy_base]
	add dx, [cs:phy_base+0x02]

	shr ax, 4
	ror dx, 4
	and dx, 0xf000
	or ax, dx
	pop dx
	ret

;----------------------------------------------
; 输入: ds:bx == 从硬盘读取数据至该物理地址 di, si == 逻辑扇区号
read_disk:
	push ax
	push bx
	push cx
	push dx

	mov dx, 0x1f2
	mov al, 1
	out dx, al

	inc dx ; 0x1f3 7-0
	mov ax, si
	out dx, al

	inc dx ; 0x1f4 
	mov al, ah
	out dx, al


	inc dx ; 0x1f5
	mov ax, di
	out dx, al


	inc dx ; 0x1f6
	mov al, 0xe0
	or al, ah
	out dx, al

	inc dx ; 0x1f7
	mov al, 0x20 ; 读命令
	out dx, al

waits:
	in al, dx
	and al, 0x88
	cmp al, 0x08
	jnz waits

	mov dx, 0x1f0 ; 数据端口 16位端口
	mov cx, 0x100 ; 256
readsw:
	in ax, dx
	mov [bx], ax
	add bx, 2
	loop readsw
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
	
	phy_base		dd 0x10000
times  510-($-$$) db 0 
		db 0x55, 0xaa   