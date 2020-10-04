; 用户程序, 从 0x10000 处开始
SECTION header vstart=0
	program_len      dd program_end  ;; 这四个字节 代表整个用户程序字节长度; 代码地址0x00

	code_entry       dw start   ; 0x04
					 dd section.code1.start  ; 0x06

	;;重定位表的项数,  0x0A
	readlloc_items	 dw (header_end - code1Segment)/ 4  ; 每项4Bytes大小

	;;重定位表
	code1Segment    dd  section.code1.start  ;从代码段到整个用户程序的开始 这段偏移量, SECTION code1那里,  0x0C
	data1Segment    dd  section.data1.start  ;从数据段到整个用户程序的开始 这段偏移量, SECTION data1那里,  0x10
	stackSegment    dd  section.stack.start  ; 栈段偏移量   ,  0x14

	snakeSegment    dd  section.snake.start  ;贪吃蛇代码段偏移 ,  0x18
	snakeDataSegment dd section.snakeData.start  ; 贪吃蛇数据段偏移;  0x1C
header_end:

;---------------------------------------------------------
; 贪吃蛇代码段
;---------------------------------------------------------
SECTION snake aling=16 vstart=0


snakeEnd:
;---------------------------------------------------------
; 贪吃蛇数据段
;---------------------------------------------------------
SECTION snakeData align=16 vstart=0



snakeDataEnd:

;---------------------------------------------------------
SECTION code1 align=16  vstart=0 ; 代码段, 16字节对齐偏移从 当前代码段开始计算
; 显示字符串代码段
start:
	mov  ax, [stackSegment]
	mov  ss, ax     ; 栈顶指针 段寄存器   ,栈从高地址向低地址增长
	mov  ax, stack_pointer
	mov  sp, ax

	xor  ah, ah
	mov  al, 3
	int  0x10   ; 调用中断, 清空屏幕
	mov  ah, 0x13 ; AH 对应的是 0x13 功能号  , 设置 640*480的屏幕
	mov  al, 1
	xor  bh, bh
	mov  bl, 0x04
	mov  cx, data1_end - msg1  ; 字符串长度
	
	mov  dh, 12     ; 字符串放在12行
	mov  dl, 25     ; 在 25列 位置
	
	mov  bp, msg1   ; 字符串 在内存位置的 偏移
	push ax
	mov  ax, [data1Segment]  ; 字符串段地址
	mov  es,ax 
	pop  ax
	int  0x10

	hlt


;---------------------------------------------------------
SECTION data1 align=16 vstart=0  ;; 数据段 从这里开始计算
	msg1 db 'The game is going to start...', 0
data1_end:


;---------------------------------------------------------
SECTION stack  align  vstart=0  ;; 栈   SS:
	resb 256  ;预留 256字节空间 清空成0, 伪指令, inter手册查不到
stack_pointer:  ; 指向栈顶指针的位置, 栈从高地址向低地址增长. 栈放在地址的最高处

;---------------------------------------------------------
SECTION  tail align=16  vstart=0   ;;结尾段, 仅仅是为了上面的 program_len标号
program_end:

