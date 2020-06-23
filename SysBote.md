# bootsect.s   Makefile   .gitignore     linker Script


# 第一天:

**首先根据教程编写了 bootsect.S文件, 然后执行了下面的汇编指令** 


**汇编指令,  没有出现错误, 生成了 a.out文件,   然后我就删除了它,  随后根据教程继续下去 编写Makefile**
    _$ sa --32 bootsect.S_
        **但是注意, --32 是32位,  但是我汇编文件内指定了是16位的,所以他会变成16位进行编译,而忽略 --32参数**

**编写了Makefile 文件, 但是出现了一个问题, all: Image 这里出错 , 然后 仔细看了一遍调用 原来是下面的指令. **
    _$ make bootsect.o_
            **在写make的时候, 发现在命令前添加@ 就可以不用在终端输出make执行的命令,  @as --32 bootsect.S -o bootsect.o**


**然后使用了 $objdump -S bootsect.o  进行查看汇编代码,但是汇编出来的代码不正常, 这是因为参数不对.**
  **然后使用了 $objdump -m i8086  -S bootsect.o    这个正确的参数来进行查看,随后显示的才是正常的.**

### 这个时候继续修改 Makefile 文件 ,变成下面这样

```{
all: Image

.PHONY=clean run-qemu

bootsect.o:
    @as --32 bootsect.S -o bootsect.o    # @表示不在命令行出现

run-qemu:
    @qemu-system-i386 -boot a -fda bootsect.o    
            #指定eqmu架构,通过a盘(软盘)启动，将bootsect.o 装载到软盘里，软盘里面启动 .o  进行引导

clean:
    @rm -f *.o  
}
```

**但是如果使用 $make run-qemu 命令的话,模拟器会提示找不到引导文件, 这是因为 bootsect.o 文件内部出现了不该有的内容,删除他**
**可以使用 $hexdump -C bootsect.o  这个命令来查看这个文件的十六进制内容**
    **bootsect.o 文件的开头会多出 ELF的开头, 这个是Linux用来识别它是不是可运行的程序,然后来调用加载器,但是我们不需要它**
        **使用命令 $objcopy -O binary bootsect.o   来把 ELF的内容从 bootsect.o 中删除出去** 
            **删除后,就变成可以被bios认识,而且可以启动的扇区**
                **而且使用 $file bootsect.o  这个命令来查看,会提示是 DOS/MBR boot sector文件,这个就是我需要的启动引导**








