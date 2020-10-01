; MBR ASMFORGE

	jmp start 

;  设置显示的字符,  'A‘是显示的字 , 0x07 黑底白字 字的属性, szText是地址,而不是指令, szText就是指向 'A' 的地址
szText db 'A', 0x07, 'S', 0x07, 'M' , 0x07, 'F', 0x07, 'O' , 0x07 ,'R', 0x07, 'G', 0x07, 'E', 0x07

start:
	;赋值段寄存器ds 数据段
	mov  ds, szText
	mov  cx, (start - szText) / 2
	
	movsw
