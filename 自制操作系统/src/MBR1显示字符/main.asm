; MBR ASMFORGE, 启动扇区

	jmp start   ; 起始地址 , 0x7c00

;  设置显示的字符,  'A‘是显示的字 , 0x07 黑底白字 字的属性, szText是地址,而不是指令, szText就是指向 'A' 的地址
; 该字符串的首地址就是  0x07c0:szText   段地址加偏移值
szText db 'A', 0x07, 'S', 0x07, 'M' , 0x07, 'F', 0x07, 'O' , 0x07 ,'R', 0x07, 'G', 0x07, 'E', 0x07

start:
	;赋值段寄存器ds 数据段,  段寄存器不可以直接使用 立即数 赋值
	mov  ax, 0x07C0
	mov  ds, ax      ; 段地址
	mov  si, szText  ; 偏移地址 , DS:SI 指的就是 szText字符串的首地址
		
	mov  ax, 0xB800
	mov  es, ax      ; 显存的内存映射地址
	mov  di, 0       ; 地址偏移值, es=0xB800, di=0x000  , ES:DI= 0xB800:0000 ->左移四位= 0xB8000

	mov  cx, (start - szText) / 2  ; 字符串长度, 将字和属性 算作一个

	
	rep movsw        
; movsw m16,m16   ; DS:SI 挪移到 ES:DI   2Bytes == 1Word , 将DS内容复制到ES, SI内容复制到DI, 一次性复制两个字节
	
halt:
	jmp  halt
	jmp  halt
	jmp  halt	
	jmp  halt
	
	
times  510-($-$$) db 0 ; $指的是当前地址, $$指的是段的起始地址 0x7c00, ($-$$) 会得到段起始地址到目前地址的距离
					   ; 510 减去前面的内容长度 会得到剩下的内容长度, 使用 db 将结果长度赋值成0
					   ; 填充中间的空闲区域
 
	db 0x55, 0xaa    ; MBR启动扇区的最后两个字节的必需品,也是确认当前是启动扇区的主要标识符