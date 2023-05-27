## bochsDebug指令

```bash
# 需要在bochs 已经启动的情况下开始测试

执行
<bochs:x> c     #开始运行,直到断点处停止
<bochs:x> s  5  #单步执行 5 条 汇编 指令。 数字可忽略， 默认执行一条
<bochs:x> n  4  #单步执行 5 条 C语言级 指令。 数字可忽略， 默认执行一条

断点
<bochs:x> blist          # 显示所有断点信息，  与 info b  功能相同
<bochs:x> b 0x7c00       # 实模式下， 打断点 (物理地址) , pb与b作用相同
<bochs:x> vb 0x0:0x7c00  #保护模式下， 打断点 (虚拟地址)  addr为段基址：偏移地址， cs段
<bochs:x> lb 0x7c00      # 在线性地址处设置断点  addr为线性物理地址，不加基址
<bochs:x> sb 5           # 从当前位置开始再执行 5 条汇编之类后程序就中断（相对）
<bochs:x> sba 5          # CPU开始运行时，执行第 5 条汇编之类后程序就中断 （上电一刻就开始计算）（绝对）
<bochs:x> d 1            # 删除 1号断点，通过 blist来查询断点号。
<bochs:x> bpd 1          # 禁用 1号断点，通过 blist来查询断点号。
<bochs:x> bpe 1          # 启用 1号断点，通过 blist来查询断点号。

<bochs:x> watch   			 	 # 显示所有 IO读写断点
<bochs:x> watch r 物理地址	# 设置 物理地址 有读 操作就停止运行  (一般是IO操作)
<bochs:x> watch w 物理地址	# 设置 物理地址 有写 操作就停止运行  (一般是IO操作)
<bochs:x> unwatch   			 # 清除所有 IO读写断点
<bochs:x> unwatch 物理地址	# 清除 物理地址处的 IO读写断点

反汇编
<bochs:x> u  0x1    #反汇编 指定内存位置的指令
<bochs:x> u /5      #反汇编 当前位置开始的后5条指令

寄存器查询
<bochs:x> r       #查看通用寄存器
<bochs:x> sreg    #查看段寄存器（es,cs,gs,ss,fs,ds以及idt,gdt,ldt,tr）
<bochs:x> creg    #查看控制寄存器（cr0，cr1，cr2，cr3）
<bochs:x> dreg    #查看调试寄存器（dr0-dr7）
<bochs:x> info tab    #显示页表中线性地址到物理地址的映射
<bochs:x> page 线性地址   #显示线性地址到物理地址的映射
# 这里再插一句，标志寄存器的查看方法：
<bochs:x> eflags 0x00000002: id vip vif ac vm rf nt IOPL=0 of df if tf sf zf af pf cf    （均为置位）
<bochs:x> eflags 0x00000046: id vip vif ac vm rf nt IOPL=0 of df if tf sf ZF af PF cf （ZF,PF置位）
#0x00000002是标志寄存器的实际数值，后面的zf，sf等为标志位，小写时标志位未置位，大写为已置位。（刚刚用bochs时为这个问题费解了好久。。。）

堆栈
<bochs:x> print-stack		16	# 查看堆栈, 栈顶开始的16个条数。 默认值为16


内存
<bochs:x> x /1b addr   # 显示线性地址（addr）的内容, 显示1条，每条以1个字节为单位 (注意大小端)
<bochs:x> x /2h addr   # 显示线性地址（addr）的内容, 显示2条，每条以2个字节为单位 (注意大小端)
<bochs:x> x /2hs addr  # 显示线性地址（addr）的内容, 显示2条，每条以2个字节为单位,并以ASCIIz显示
								     # s表示asciiz, x表示16进制, d表示十进制, t表示二进制, c按字符显示, i按instr显示
<bochs:x> xp /3w addr   # 显示物理地址（addr）的内容, 显示3条， 每条以4个字节为单位  (注意大小端)
<bochs:x> xp /4g addr   # 显示物理地址（addr）的内容, 显示4条， 每条以8个字节为单位 (注意大小端)


设置内存和寄存器的值
<bochs:x> setpmem  addr 4 0  # 设置物理地址 addr 处开始的 4个字节为 0  （最大值为4）


info指令组
<bochs:x> info b		 #展示当前的断点状态信息
<bochs:x> info dirty   	#展示自从上次显示以来物理内存中的脏页（被写的页）
<bochs:x> info program 	#展示程序的执行状态  （无法使用！）
<bochs:x> info r|reg|rigisters 		#展示寄存器内容
<bochs:x> info cpu 		#展示CPU寄存器内容
<bochs:x> info fpu 		#展示FPU寄存器的状态
<bochs:x> info idt 		#展示中断描述表
<bochs:x> info ivt 		#展示中断向量表(保护模式下无效)
<bochs:x> info gdt 		#展示全局描述表
<bochs:x> info tss 		#展示当前的任务状态段
<bochs:x> info cr     #展示CR0-CR4寄存器状态 （无法使用）
<bochs:x> info flags  #展示标志寄存器   （无法使用）
<bochs:x> info tab    #显示页表中线性地址到物理地址的映射
<bochs:x> page 线性地址   #显示线性地址到物理地址的映射

开启 在中断发生时输出提示,用以排查报错
<bochs:x> show int  #开启 在中断发生时输出提示。exception 外部中断, softint软件中断
<bochs:x> show extint  # 开启， 打印中断信息
<bochs:x> show sofint  #
<bochs:x> show iret    #


查看寄存器信息：info cpu/r/fp/sreg/creg
查看堆栈:print-stack
查看内存物理地址内容：xp /nuf addr |eg：xp /40bx 0x9013e
查看线性地址内容：x /nuf addr |eg：x /40bx 0x13e
反汇编一段内存：u start end  |eg：u 0x30400 0x3020D
```



### 中断调试过程

```bash
bash$  nm kernel.bin  | grep thread_start
		# 获得  c00031a0 T thread_start   

#开始执行 bochs
bochs:

<bochs:1>  lb 0xc00031a0		# 进入函数断点
<bochs:2> c
	(0) Breakpoint 1, 0x00000000c00031a0 in ?? ()
	Next at t=8503101
	(0) [0x0000000031a0] 0008:00000000c00031a0 (unk. ctxt): push ebp                  ; 55

<bochs:3> info b			# 查看断点
	Num Type           Disp Enb Address
  1 lbreakpoint    keep y   0x00000000c00031a0 

<bochs:4> d 1					#删除断点

<bochs:5> show extint		#显示中断信息
		show external interrupts: ON
		show mask is: extint

<bochs:6> c					#开始执行， 不滚动信息之后 就用快捷键中断(control + c)
00009460872: exception (not softint) 0008:c0001ad9 (0xc0001ad9)
00009460958: exception (not softint) 0008:c00018cb (0xc00018cb)	# 取该行的 00009460958 值
^CNext at t=103039110
(0) [0x000000001d71] 0008:00000000c0001d71 (unk. ctxt): jmp .-2  (0xc0001d71)     ; ebfe

<bochs:7> q				#信息获得完全， 退出即可


#开始执行 bochs
bochs:
			# 从上面最后一行获得 9460958 值， 在该基础上 -1 ，就会得到进入中断前的最后一个指令
<bochs:1>  sba 9460957					# 在 9460957 条汇编上打个断点
	Time breakpoint inserted. Delta = 9460957

<bochs:2> c			#开始执行
	(0) Caught time breakpoint
	Next at t=9460957
	(0) [0x000000001650] 0008:00000000c0001650 (unk. ctxt): mov byte ptr gs:[bx], cl  ; 6567880f	# 该最后一条指令用了 gs 和 bx 寄存器的值，需要看看是否正确

<bochs:3> r					# 查看通用寄存器。 主要关注 bx 寄存器的值
rax: 00000000_c000cfcf
rbx: 00000000_c0009f9e			# gdt 越界了
rcx: 00000000_0000004d
rdx: 00000000_c01003d5
rsp: 00000000_c009efac
rbp: 00000000_c009eff8
rsi: 00000000_00070000
rdi: 00000000_00000000
r8 : 00000000_00000000
r9 : 00000000_00000000
r10: 00000000_00000000
r11: 00000000_00000000
r12: 00000000_00000000
r13: 00000000_00000000
r14: 00000000_00000000
r15: 00000000_00000000
rip: 00000000_c0001650
eflags 0x00000283: id vip vif ac vm rf nt IOPL=0 of df IF tf SF zf af pf CF


<bochs:4> sreg				# 查看段寄存器，主要关注 GS 寄存器的值
es:0x0010, dh=0x00cf9300, dl=0x0000ffff, valid=1
	Data segment, base=0x00000000, limit=0xffffffff, Read/Write, Accessed
cs:0x0008, dh=0x00cf9900, dl=0x0000ffff, valid=1
	Code segment, base=0x00000000, limit=0xffffffff, Execute-Only, Non-Conforming, Accessed, 32-bit
ss:0x0010, dh=0x00cf9300, dl=0x0000ffff, valid=31
	Data segment, base=0x00000000, limit=0xffffffff, Read/Write, Accessed
ds:0x0010, dh=0x00cf9300, dl=0x0000ffff, valid=1
	Data segment, base=0x00000000, limit=0xffffffff, Read/Write, Accessed
fs:0x0000, dh=0x00001000, dl=0x00000000, valid=0
gs:0x0018, dh=0xc0c0930b, dl=0x80000007, valid=1		# 指向  GDT[0x0018] 
	Data segment, base=0xc00b8000, limit=0x00007fff, Read/Write, Accessed
ldtr:0x0000, dh=0x00008200, dl=0x0000ffff, valid=1
tr:0x0000, dh=0x00008b00, dl=0x0000ffff, valid=1
gdtr:base=0x00000000c0000900, limit=0x1f
idtr:base=0x00000000c00071e0, limit=0x107

<bochs:5> info gdt			#展示全局描述表 gdt. 看 limit 限制值
Global Descriptor Table (base=0x00000000c0000900, limit=31):
GDT[0x0000]=??? descriptor hi=0x00000000, lo=0x00000000
GDT[0x0008]=Code segment, base=0x00000000, limit=0xffffffff, Execute-Only, Non-Conforming, Accessed, 32-bit
GDT[0x0010]=Data segment, base=0x00000000, limit=0xffffffff, Read/Write, Accessed
GDT[0x0018]=Data segment, base=0xc00b8000, limit=0x00007fff, Read/Write, Accessed # 这里
You can list individual entries with 'info gdt [NUM]' or groups with 'info gdt [NUM] [NUM]'

<bochs:6> x gs:bx				# 查看内存位置的值, 下面有个警告 超出描述符限制了。 bug 找到了
WARNING: Offset 00009F9E is out of selector 0018 limit (00000000...00007fff)!
[bochs]:
0x00000000c00c1f9e <bogus+       0>:	0x007cc6c6

# 下一条指令就执行进入了中断， 因为引发了越界异常
<bochs:8> s
(0) Caught time breakpoint
Next at t=9460958
(0) [0x0000000018cb] 0008:00000000c00018cb (unk. ctxt): nop                       ; 90

```

