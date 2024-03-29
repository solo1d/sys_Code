GUN gcc 对 ISO标准 C89 描述的C 语言进行了扩展, 其中有一部分已经包括进 ISO C99 标准中



- [嵌入汇编](#嵌入汇编)
- [汇编指令](#汇编指令)
- [**PSW/FLAG 标志位寄存器的示意图**](#**PSW/FLAG 标志位寄存器的示意图**)
- [汇编和C代码相互调用](#汇编和C代码相互调用)
- 



## 嵌入汇编

```c
asm volatile ("汇编语句"     // volatile 不允许gcc 进行优化
     : 输出寄存器    // 汇编语句执行完毕后, 保存结果的寄存器
     : 输入寄存器    // 
     : 会被修改的寄存器 );

volatile  void  fun(void);   // 代表该函数不会返回, 可以避免gcc产生假警告信息,和一定量的优化
```

````c
/* 寄存器变量  */
register  char __res;   // 寄存器变量, 该变量被保存在寄存器中
register  char __resS sam("ax");   // 寄存器变量, 该变量被保存在 rx 寄存器中


// 汇编范例 , %%ax 表示正常的 %ax
// 作用:  取 seg段 + addr 偏移值的 位置的 1字节内存数据 并返回
#define get_seg_byte(seg,addr)  \
({ 															\
  register char __res;					 \  /* 寄存器变量 __res */
  __asm__( "push %%fs;					 \  /* 保存 fs 寄存器原本的值 (段寄存器) */
            mov %%ax,%%fs;       \  /* 用  第一个参数 seg 设置 fs 寄存器 */
					  movb %%fs:%2,%%al;   \  /* 取一字节放入 al寄存器, %2 代表 (*(addr)) 这个内存偏移量 */
            pop %%fs" 					 \  /* 恢复 fs 寄存器原本的值 */
	          : "=a" (__res)       \    /* 输出寄存器 列表, 将rex寄存器的值放入 __res 变量中, 
                                       * 作为本函数的输出值, a表示加载代码, = 表示这是输出寄存器,
  																		 * 并且其中的值将被输出值替代 */
            : "0" (seg), "m" (*(addr)) ); \  /* 表示这段代码开始运行时将 seg放到 eax寄存器中,
                       											  * 0 表示使用与上面相同位置的 输出相同的寄存器. 
                       											  * (*(addr)) 表示一个内存偏移地址值 */
 __res; })
/*
输出和输入寄存器统一按序编号，顺序是从输出寄存器序列从左到右从上到下以“%0"开始，分别记为%0、%1 ... %9。
   因此，输出寄存器的编号是%0（这里只有一个输出寄存器），
   输入寄存器前一部分 ("0" (seg)) 的编号是%1, 而后部分的编号是%2 
*/ 
   
   
   
//第二种范例
int count =1;
int fill_value =3;
int dest =4;
asm("cld\n\t"
    "rep\n\t"
    "stol"
    : /* 没有输出寄存器 */
    : "c"(count-1), "a"(fill_value), "D"(dest)
    :"%ecx", "%edi");

// 第三种
asm volatile ("leal (%1 , %1, 4), %0"    // %0 输出寄存器, %1 输入寄存器
   :"=r"(y)
   :"0"(x) );  // 0表示 使用与输出寄存器一样的寄存器
// 含义为  leal (eax, eax, 4) , eax 
//  eax是 x的值(%1)  ,
// 快速的让 x * 5
````



| 代码 | 说明                                                    |     代码     | 说明                                                         |
| :--: | :------------------------------------------------------ | :----------: | :----------------------------------------------------------- |
|  a   | 使用寄存器 eax                                          |      m       | 使用内存地址                                                 |
|  b   | 使用寄存器 ebx                                          |      o       | 使用内存地址并可以加偏移值                                   |
|  c   | 使用寄存器 ecx                                          | I  (大写的i) | 使用常数 0-31                                                |
|  d   | 使用寄存器 edx                                          |      J       | 使用常数 0-63                                                |
|  S   | 使用 esi                                                |      K       | 使用常数 0-255                                               |
|  D   | 使用 edi                                                |      L       | 使用常数 0-65535                                             |
|  q   | 使用动态分配字节可寻址寄存器（eax、ebx、ecx 或 edx）    |      M       | 使用常数 0-3                                                 |
|  r   | 使用任意动态分配的寄存器                                |      N       | 使用 1 字节常数（0-255)                                      |
|  g   | 使用通用有效的地址即可（eax、ebx、ecx、edx 或内存变量） |      O       | 使用常数 0-3                                                 |
|  A   | 使用 eax 与 edx 联合（64 位）                           |      =       | 输出操作数。输出值将替换前值                                 |
|  +   | 表示操作数可读可写                                      |      &       | 早期会变的（earlyclobber）操作数。表示在使用完操作数之前，内容会被修改 |



## 汇编指令

```assembly
CLD  /* 将标志寄存器Flag的方向标志位DF清零。 在字串操作中使变址寄存器SI或DI的地址指针自动增加，字串处理由前往后 */

lodsb   /* 取 串2的字符地址 ds:[esi] --> al 寄存器 ,并且 esi++  , 栈数据 */ 
scasb  /* 比较 al 与串1 的字符 es:[edi] , 并且 edi++ */ 

tdecl 寄存器  /*原子操作 递减指令*/

text 寄存器1, 寄存器2  /*测试与运算, 只会更改标志位寄存器的值 . 第一个寄存器 减去 第二个寄存器的值, 判断结果的第一位是否为1 ,如果是  则 ZF=1 */

leave    /* 恢复原 ebp, esp值 ( 即 movl %ebp, %esp ; popl %ebp) */

leal  寄存器1, 寄存器2  /*计数有效地址, 取寄存器1的值 进行计算 然后写入寄存器2,  一般都是计算地址 */

```



## **PSW/FLAG 标志位寄存器的示意图**

| 31~19 | 18 | 17 | 16 | 15   | 14   | 13   | 12   | 11   | 10     | 9    | 8    | 7    | 6    | 5    | 4    | 3    | 2    | 1    | 0    |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ------ | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| 0 | 0 | VM | RF | 0    | NT   | IOPL | IOPL | OF   | **DF** | IF   | TF   | SF   | ZF   | 0    | AF   | 0    | PF   | 1    | CF   |

- **CF : 记录相关运算指令执行后,  无符号数运算   最高有效位向更高的假想位 进位或借位 时 该值为1.当AL=98H , `add AL,AL`,执行后CF=1,   进位标志**
- **PF :记录相关运算指令执行后, 其结果中 1 的个数是否为偶数, 1的个数为偶数或0 时 PF=1, 当1的个数为奇数时 PF=0,  恢复标志**
- **AF : 辅助进位**
- **ZF  :记录相关运算指令执行后, 其结果为0时 那么 ZF标志位=1 , 否则 ZF=0**
- **SF : 记录相关运算指令执行后, 其结果是否为负数, 如果结果为负数那么 SF=1, 非负数 SF=0**
- **TF : 跟踪标志, 单步执行指令,处理器会在每条指令执行后产生一个调用异常, 可使用 `POPF, POPFD 或 IRET` 设置该标志**
- **IF : 中断允许标志 中断允许标志位，由`CLI`，`STI`两条指令来控制；设置IF位使CPU可识别外部(可屏蔽)中断请求，复位IF位则禁止中断；IF位对不可屏蔽外部中断和故障中断的识别没有任何作用**
- **DF  :控制 `movsb 和 movsw` 指令中操作的 SI和DI寄存器的增减, 由`CLD`，`STD`两条指令控制；复位DF标志位，字符串操作指令中`SI`，`DI`值自增；设置DF位字符串操作指令中`SI`，`DI`值自减**
- **OF :记录相关运算指令执行后,  有符号数运算 是否发生溢出, 溢出OF=1, 没有溢出 OF=0,  溢出**
- **IOPL(I/O Privilege Level)**：I/O特权级字段，宽度2位, 只用于控制IO访问, 可屏蔽硬件中断,调试,任务切换,以及虚拟8086模式, 只有当 CPL小于等于这个IOLP才能访问I/O地址空间, 而且CPL为特权级0时, 程序才可以使用 `POPF 或 IRET` 指令修改这个字段.   该标志还控制对 IF标志的修改机制之一
- **NT: 控制中断返回指令`IRET`, 控制着被中断任务和调用任务之间的链接关系.递归调用**
- **RF: 恢复标志, 控制处理器对断点指令的响应  `IRETD` 来设置, 为1时会禁止断点调试**
- **VM: 虚拟8086模式, 设置时, 开启虚拟8086模式, 当为0时 ,则回到保护模式**
- 19~31:  保留, 设置为0



- **`CS:IP  指令地址`**
- **`DS:偏移量  数据地址`**
- **`SS:SP  栈地址`**

|      寄存器编号 | 作用                             | 具体描述                                                     |
| --------------: | -------------------------------- | :----------------------------------------------------------- |
|  **AX**, AH, AL | **通用寄存器, AH高8位, AL低8位** | **整数商寄存器, div BX ;整数商会放在AX , 余数在DX**          |
|  **BX**, BH, BL | 通用寄存器                       | **基址寄存器**                                               |
| **CX** , CH, CL | 通用寄存器                       | **控制  loop循环次数,  程序执行后存放代码长度**              |
|  **DX**, DH, DL | 通用寄存器                       | **余数商寄存器, div BX ;整数商会放在AX , 余数在DX**          |
|   ------------- | -------------                    |                                                              |
|          **SI** | **源变址寄存器**                 | **常用用于地址偏移量表示,  DS:SI**                           |
|          **DI** | **目标变址寄存器**               | **常用用于地址偏移量表示, ES:DI**                            |
|   ------------- | -------------                    |                                                              |
|          **SP** | **指针寄存器**                   | **栈顶偏移地址,  SS:SP**                                     |
|              BP | 堆栈基址指针寄存器               | **在栈内寻址使用,获取栈内任意位置数据,  SS:BP**              |
|   ------------- | -------------                    |                                                              |
|          **IP** | **指令指针寄存器**               | **指向下一条要执行的指令的地址, CS:IP 才是地址位置**         |
|   ------------- | -------------                    |                                                              |
|          **CS** | **代码段寄存器**                 | **代码段寄存器, CS:IP 表示下条指令地址, 会被抽象为PC寄存器** |
|          **SS** | 栈段寄存器   **stack栈**         | **栈段地址寄存器,  SS:SP  表示栈顶位置**                     |
|          **DS** | 数据段寄存器                     | **数据段寄存器,  DS:偏移量   即可得到数据段的地址**          |
|          **ES** | 附加段寄存器                     | **都是内存操作, 与串操作代码有关, ES:DI**                    |
|              FS | 附加段寄存器                     |                                                              |
|              GS | 附加段寄存器                     |                                                              |
|   ------------- | -------------段基址寄存器        | **4个内存管理寄存器**                                        |
|            GDTR | **全局描述符表寄存器**           | 指向GDT表 ,加载GDTR寄存器指令 LGDT ,保存 SGDT                |
|            IDTR | 中断描述符表寄存器               | 指向IDT表 ,加载 IDTR寄存器指令 LIDT ,保存 SIDT               |
|            LDTR | 局部描述符表寄存器               | 指向LDT表 ,加载 LDTR寄存器指令 LLDT ,保存 SLDT               |
|              TR | 任务状态寄存器                   | 存放当前任务TSS段的选择符,基地址,段长度和描述符属性,  LTR 和STR 指令 |
|   ------------- | -------------                    |                                                              |
|  **PSW / FALG** | **标志寄存器**                   | **程序状态字寄存器, DF标志位**                               |
|   ------------- | -------------                    |                                                              |
|         **ESP** | **栈帧寄存器**                   |                                                              |
|   ------------- | -------------控制寄存器          | 控制和确定处理器的操作模式以及当前执行任务的特性             |
|             CR0 | 控制寄存器0                      | 控制处理器操作模式和状态的系统控制标志                       |
|             CR1 | 控制寄存器1                      | 保留                                                         |
|             CR2 | 控制寄存器2                      | 含有导致页错误的线性地址                                     |
|             CR3 | 控制寄存器3                      | 含有页目录表物理内存基地址,  也称页目录基地址寄存器 PDBR     |



## 段寄存器使用约定

| 访问存储区类型     | 缺省段寄存器 | 可指定段寄存器 | 段内偏移地址来源       |
| ------------------ | ------------ | -------------- | ---------------------- |
| 取指令码           | CS           | 无             | IP                     |
| 堆栈操作           | SS           | 无             | SP                     |
| BP用作基地址寄存器 | SS           | CS DS ES       | 依寻址方式寻找有效地址 |
| 串操作源地址       | DS           | CS DS ES       | SI                     |
| 串操作目的地址     | ES           | 无             | DI                     |
| 一般数据存取       | DS           | CS DS ES       | 依寻址方式寻找有效地址 |



###### GDTR

```register
     47                                               16 15                        0
     +--------------------------------------------------+---------------------------+
GDTR |           32位线性基地址                          |        16位表长度          |
     +--------------------------------------------------+---------------------------+
```

加载GDTR寄存器指令

```assembly
!	           gdt_48
! 47              16 15         0
!+------------------+-----------+
!|   32位线性基地址  | gdt表长度  | gdt_48
!+------------------+-----------+
ldtr gdt_48
```

`gdtr`用于加载全局描述符表寄存器GDTR。它的操作数(gdt_48)有6个字节。前2字节(字节0-1)是描述表的字节长度值；后4字节(字节2-5)是描述符表的32位线性基地址。

###### IDRT

IDRT同GDTR





# 汇编和C代码相互调用

```c
两个文件, 一个c  一个s , 编译命令和文件内容如下
  $gcc-3.4  -c -m32 -o callee.o  callee.s  // 汇编文件到目标文件
  $gcc-3.4 -m32 -o caller caller.c  callee.o  // c文件 和目标文件 可执行文件
  $./caller   
  #运行结果如下 
     Calculationg...
     the result is 15
  
  

//  c代码  ,   caller.c
int main()
{
	char buf[1024];
	int a, b, res;
	char* mystr = "Calculationg...\n";
	char* emsg = "Error in adding\n";

	a = 5; b =10;
	mywrite(1, mystr, strlen(mystr));
	if(myadd(a, b, &res)){
		sprintf(buf, "the result is %d\n", res);
		mywrite(1, buf, strlen(buf));
	}else {
		mywrite(1, emsg, strlen(emsg));
	}
	return 0;
}


//GUN 汇编代码,   callee.s

SYSWRITE = 4
.global mywrite, myadd
.text
mywrite:
	pushl %ebp 
	movl  %esp, %ebp
	pushl %ebx
	movl  8(%ebp), %ebx
	movl  12(%ebp), %ecx
	movl  16(%ebp), %edx
	movl  $SYSWRITE, %eax
	int   $0x80
	popl  %ebx 
	movl  %ebp, %esp
	popl  %ebp 
	ret
myadd:
	pushl %ebp 
	movl  %esp, %ebp
	movl  8(%ebp), %eax
	movl  12(%ebp), %edx
	xorl  %ecx, %ecx
	addl  %eax, %edx
	jo    1f
	movl  16(%ebp), %eax
	movl  %edx, (%eax)
	incl  %ecx
1:	movl  %ecx, %eax
	movl  %ebp, %esp
	popl  %ebp
	ret
```





