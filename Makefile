all: Image

.PHONY=clean run-qemu

bootsect.o:
	@as --32 bootsect.S -o bootsect.o    # @表示不在命令行出现

run-qemu:
	@qemu-system-i386 -boot a -fda bootsect.o    
			#指定eqmu架构,通过a盘(软盘)启动，将bootsect.o 装载到软盘里，软盘里面启动 .o  进行引导

clean:
	@rm -f *.o
