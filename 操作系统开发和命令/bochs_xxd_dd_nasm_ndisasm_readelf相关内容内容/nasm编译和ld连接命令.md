## nasm命令

```bash
#编译带 elf(32) 文件头的目标文件
$ nasm -f elf 1.asm  -o 1.o

#编译带 elf(64) 文件头的目标文件
$ nasm -f elf64 1.asm  -o 1.o


# 整合成可执行文件 (二进制文件)
$ld 1.o  -o a.out

# 整合成带 elf 的可执行文件
$ld -melf_x86_64 -s -o a.out 1.o 2.o

$ld -melf_i386 -s -o a.out 1.o 2.o

#在 mac下使用
$ nasm -f macho64 1.asm -o 1.o

$ld  -arch x86_64 -e _start -L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem  1.o -o a.out

ld需要-lSystem标志来防止它抛出此错误。它还需要-macosx_version_min来删除警告。使用ld的正确方法是：ld hello.o -o hello -macosx_version_min 10.13 -lSystem。

在macOS 11及更高版本上更新，您需要通过-L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib，以便它正确定位-lSystem库。如果需要，您可以使用-L$(xcode-select -p)/SDKs/MacOSX.sdk/usr/lib动态评估正确的路径。
```



### nasm汇编伪指令

```assembly
;dup是masm的指令
;开辟200字节内存空间
		db 200 dup (0)
	
;times是nasm的指令
;开辟200字节内存空间
		times 200 db 0
		
;指定编译环境 ,操作数反转前缀 Ox66 和寻址方式反转前缀 Ox67
;[bits 16]是告诉编译器，下面的代码帮我编译成 16位的机器码。
;[bits 32]是告诉编译器，下面的代码帮我编译成 32 位的机器码。
[bits 16]
mov word [bx], 0x1234				;16位实模式下编译
mov dword [eax], 0x1234
[bits 32]
mov word [bx], 0x1234				;32位保护模式下编译


; 实模式地址和保护模式地址变化
; 实模式的内存寻址方式: 基址寄存器{bx,bp} + 变址寄存器{si,di} + 16位的偏移量{立即数}
; 实模式只可以使用  基址寄存器只能是 bx、bp , 变址寄存器只能 是 si、 di
;                 bx 默认的段寄存器是ds (数据段)，
;                 bp 默认的段寄存器是SS (栈)
; 保护模式的内存寻址方式:  基址寄存器{全部通用寄存器} + 变址寄存器{除esp外的全部通用寄存器} * 比例因子{只能是以下数值 1,2,4,8} + 32位的偏移量{立即数}
;
; 实模式具体形式
mov ax, [si]
mov ax, [di]
mov ax, [bx + si]
mov ax, [bx + di + 0x1234]

; 保护模式具体形式
mov eax, [eax + edx*8 + 0x123456]
mov eax, [eax+ edx*2 + 0x8]
mov eax, [ecx*4 + 0x81]
mov eax, [esp+2]			;; esp作为基址寄存器
```

