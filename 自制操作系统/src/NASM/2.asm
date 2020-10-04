; 用户程序
;---------------------------------------
SECTION header vstart=0 
	program_len		dd program_end ; 0x00

	code_entry		dw start ; 0x04
				dd section.code1.start ; 0x06
 
	realloc_items		dw (header_end-code1Segment)/4 ; 0x0a
	; 重定位表
	code1Segment		dd section.code1.start ; 0x0c
	data1Segment		dd section.data1.start ; 0x10
	stackSegment		dd section.stack.start ; 0x14
	snakeSegment		dd section.snake.start ; 0x18
	snakeDataSegment	dd section.snakeData.start ; 0x1c
header_end:


;---------------------------------------
; 贪吃蛇代码段
SECTION snake align=16 vstart=0


;---------------------------------------
; 贪吃蛇数据段
SECTION snakeData align=16 vstart=0


snakeDataEnd:

;---------------------------------------
SECTION code1 align=16 vstart=0
; 显示字符串代码段
start:
	mov ax, [stackSegment]
	mov ss, ax
	mov ax, stack_pointer
	mov sp, ax

	xor ah, ah
	mov al, 3
	int 0x10
	mov ah, 0x13
	mov al, 1
	xor bh, bh
	mov bl, 0x04
	mov cx, data1_end - msg1
	mov dh, 12
	mov dl, 25
	mov bp, msg1
	push ax
	mov ax, [data1Segment]
	mov es, ax
	pop ax
	int 0x10

	hlt
	
;---------------------------------------
SECTION data1 align=16 vstart=0
; 
	msg1 db 'The game is going to start...', 0
data1_end:
;---------------------------------------
SECTION stack align=16 vstart=0
	resb 256
stack_pointer:
;---------------------------------------
SECTION tail align=16
program_end:
;---------------------------------------