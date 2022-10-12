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
<bochs:x> sb 5           # 执行 5 条汇编之类后程序就中断
<bochs:x> sba 5          # CPU开始运行时，执行第 5 条汇编之类后程序就中断 （上电一刻就开始计算）
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


开启 在中断发生时输出提示,用以排查报错
<bochs:x> show int  #开启 在中断发生时输出提示
<bochs:x> show extint  #
<bochs:x> show sofint  #
<bochs:x> show iret    #


查看寄存器信息：info cpu/r/fp/sreg/creg
查看堆栈:print-stack
查看内存物理地址内容：xp /nuf addr |eg：xp /40bx 0x9013e
查看线性地址内容：x /nuf addr |eg：x /40bx 0x13e
反汇编一段内存：u start end  |eg：u 0x30400 0x3020D
```

