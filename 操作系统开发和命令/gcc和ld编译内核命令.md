```bash
CFLAGS:= -m32				#表示32位的程序
CFLAGS+= -fno-builtin		#不需要 gcc 内置函数, memcpy之类的
CFLAGS+= -nostdinc			#不需要 c标准头文件
CFLAGS+= -fno-pic			#不需要 位置无关的代码
CFLAGS+= -fno-pie			#不需要 位置无关的可执行程序
CFLAGS+= -nostdlib			#不需要 标准库
CFLAGS+= -fno-stack-protector			#不需要 栈保护
DEBUG:= -g
INCLUDE:= -I./include

# gcc 命令
gcc ${CFLAGS} ${DEBUG} ${INCLUDE} -c 源代码文件.c -o kernel.o 


# ld 命令 ,mac下无法使用 -Ttext 参数，只能在 Linux 下使用
ld -m elf_i386 -static   kernel.o  -o kerlen.bin -Ttext 0xc0001500 -e main
	#  包括可重定位文件 kernel.o
	#   -m elf_i386  编译成 x86_32位程序
	#   -static  静态编译 
	#   -Ttext  0xc0001500  指定程序起始虚拟地址,也就是内核载入的虚拟地址位置
	#   -e 指定程序起始地址（也可以是符号） ，main 就是起始符号
	
#mac 版本，但需要将地址变更为 0x400 的倍数， 而且地址控制也不准确。建议 Linux
ld main.o -o kernel.bin  -e __start -arch i386  -static   \
		-max_default_common_align 0x1  -image_base  0xc0001500 -segalign 0x4
```

