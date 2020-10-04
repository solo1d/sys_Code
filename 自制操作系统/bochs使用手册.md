- [bochs手册](#bochs手册)
- [bochs配置文件位置](#bochs配置文件位置)
- [bochs配置文件解读和设置](#bochs配置文件解读和设置)
- [bochs设置使用磁盘镜像](#bochs设置使用磁盘镜像)
- 

> **用来测试 MBR 启动扇区**



### bochs手册

> - **安装:**  
>
>   - `brew install bochs sdl sdl2`
>
> - **配置工作目录:**
>
>   - 例如目录为  `/Users/user/bochsObj`
>
>   - 在里面新建一个  bochsrc 文件, 内容如下
>
>     - ```tex
>       # 设置虚拟机内存为32MB
>       megs: 32
>       # 设置BIOS镜像
>       romimage: file=$BXSHARE/BIOS-bochs-latest 
>       # 设置VGA BIOS镜像
>       vgaromimage: file=$BXSHARE/VGABIOS-lgpl-latest
>       # 设置启动软盘 ,  trt.img 可以修改成自定义的 mian.img 文件
>       floppya: 1_44=try.img, status=inserted
>       # 设置启动方式
>       boot: floppy
>       # 设置日志文件
>       log: bochsout.txt
>       # 关闭鼠标
>       mouse: enabled=0
>       # 打开键盘
>       keyboard:keymap=/usr/local/share/bochs/keymaps/sdl2-pc-us.map
>       
>       # 设置硬盘
>       # ata0: enabled=1, ioaddr1=0x1f0, ioaddr2=0x3f0, irq=14
>       
>       # 添加gdb远程调试支持
>       #gdbstub: enabled=1, port=1234, text_base=0, data_base=0, bss_base=0
>       ```
>
> - **运行 bochs:**
>
>   - `cd /Users/user/bochsObj`  首先来到工作目录
>   - **`bochs -f bochsrc`   运行模拟器 并且设置配置文件为 bochsrc**
>   - **运行后 选择6 来准备开始模拟**
>     - **运行命令:**
>       - 随后的 是选择运行就输入 `c` , 他会运行到断点处, 如果没断点 就一直运行
>       - 如果输入 `n` , 就是单步执行, 跳过子程序和 init 中断程序
>       - **`s 步数`   如果单独出现 `s` 也是单步执行,  如果加上步数 , 就表示 执行 多少步**
>     - **断点命令:**
>       - **如果要设置断点就需要 `b 物理地址` , 虚拟地址断点  `vb 地址`**
>       - 指定线性地址设置断点 `lb 地址` , 
>       - 显示所有断点信息   `info break`,  或者  `blist`
>       - 删除断点  `d  断点号`
>     - **接下来执行的汇编代码查看:**
>       - **`u/数量`   查看多少条代码, 从当前位置开始向下计算, 从低向高**
>     - **状态和寄存器查看:**
>       - `r`  只查看通用寄存器
>       - **`sreg`  查看段寄存器 (es cs gs ss fs ds、idt gdt ldt tr )**
>       - `creg`  查看控制寄存器(cr0 ~ cr3)
>       - `dreg`  查看调试寄存器(dr0 ~ dr7)
>       - `x (nuf) [addr]`  显示线性地址内容
>         - **nuf 的解释: **(替换成下面的内容, 例如  x (2bx) 0x07c0 )
>           - n  :  显示单元数
>           - u : 每个单元的大小 , 可以是 `b` `h` `w` `g` ，依次为 8、16、32、64位
>           - f : 显示格式，可以是 `x` `d` `u` `o` `t` `c`
>       - `xp (nuf) [addr]`  显示物理地址信息
>     - **打印CPU信息:**
>       - `trace-reg on`  每执行一条指令就 打印 CPU信息
>     - **反汇编:**
>       - `u start end        # 反汇编一段内存, start 开始位置和结束位置`
>       - `trace-on                     # 每执行一条指令就反汇编一条指令`
>     - **退出:**
>       - 使用 `q` 即可退出调试
>       - `Ctrl + C` 结束执行状态，返回调试器提示符

### info 指令组

| **Info b**   | **查看断点信息** | **info cpu** | **从上次显示以来物理内存中的脏页** |
| ------------ | ---------------- | ------------ | ---------------------------------- |
| info idt     | 显示中断描述表   | info ivt     | 显示中断向量表                     |
| info gdt     | 显示全局描述表   | info tss     | 展示当前的任务状态段               |
| Info symbols | 显示symbol信息   |              |                                    |



## bochs配置文件位置

- **MacOS 使用 brew install bochs 进行安装的话,**
  -  配置文件路径是 **`/usr/local/Cellar/bochs/2.6.11/share/doc/bochs/bochsrc-sample.txt`**
- **windows 进行安装的话, 会在 bochs安装跟目录**



## bochs配置文件解读和设置

```bash
# 以下为 MacOS  bochs 的配置文件, 

# cpu: CPU的模式配置, CPU核心数量,  时钟频率,  三重故障后重启而不是重置CPU, 
#      忽略Bochs不了解的MSR参考, 定义用户CPU模型特定寄存器（MSR）规范的路径, 
# cpu: 确定是否将最大CPUID功能限制为2  解决WinNT安装和启动问题需要此模式。
cpu: model=core2_penryn_t9600, count=1, ips=50000000, reset_on_triple_fault=1, ignore_bad_msrs=1, msrs="msrs.def"
cpu: cpuid_limit_winnt=0


# memory: 内存池总共使用的内存(MB), 正常使用的内存 如果不够就会从内存池中拿取
memory: guest=512, host=256


# bochs 提供的 BIOS文件位置,
romimage: file=$BXSHARE/BIOS-bochs-latest, options=fastboot


# vga显存配置文件位置
vgaromimage: file=$BXSHARE/VGABIOS-lgpl-latest


#仿真鼠标类型的参数
mouse: enabled=0


#PCI芯片组 是否存在 和 具体型号
pci: enabled=1, chipset=i440fx


#软盘文件的位置路径, 如果这段话被注释,那么代表就不再使用软盘了
floppya: 1_44=/dev/fd0, status=inserted
 #还可以写成这样   floppya: 1_44=/Users/user/a.img, status=inserted
 

#磁盘
ata0: enabled=1, ioaddr1=0x1f0, ioaddr2=0x3f0, irq=14
#ata1: enabled=1, ioaddr1=0x170, ioaddr2=0x370, irq=15
#ata2: enabled=0, ioaddr1=0x1e8, ioaddr2=0x3e0, irq=11
#ata3: enabled=0, ioaddr1=0x168, ioaddr2=0x360, irq=9

# 主从磁盘设置 : 硬盘, 平坦模式, 路径, 柱面(磁道), 磁头(盘面), 每个柱面的扇区数量
ata0-master: type=disk, mode=flat, path="./a.img", cylinders=615, heads=6, spt=17
		# 磁盘启动的 img 需要使用 bochs自带的命令  bximage 来创建启动磁盘文件
		# 例如生成的名字就是 a.img
				# 30MB大小磁盘: (都是可以计算的)
						#6个盘面 , 盘面必须为偶数, 一张盘两个面
						#每个盘面的总字节数 5242880 Bytes
						#每个盘片扇区总数  10240
						#每个盘面的磁道  615
						#每个磁道 17 个扇区
						#每个扇区 512 Bytes 字节
			#100MB磁盘的设置为  cylinders=753, heads=16, spt=17
			

#bootloader 启动器 在磁盘还是软盘 , disk 或 floppy , 网络netowrk , 光盘cdrom
boot: disk


#日志等级
panic: action=ask
error: action=report
info: action=report
debug: action=ignore, pci=report # report BX_DEBUG from module 'pci'


#声卡
sound: driver=default, waveout=/dev/dsp. wavein=, midiout=

#话筒 扬声器
speaker: enabled=1, mode=sound



```







## bochs设置使用磁盘镜像

**需要将写好的 MBR 使用 `bximage`  命令  为Bochs 创建/转换磁盘镜像/调整大小  和提交工具**





#### bochsrc 与a.img 同目录下的配置文件

```bash
# 设置虚拟机内存为64MB 
memory: 64,32
# 设置BIOS镜像
romimage: file=$BXSHARE/BIOS-bochs-latest
# 设置VGA BIOS镜像
vgaromimage: file=$BXSHARE/VGABIOS-lgpl-latest
# 设置启动软盘
#floppya: 1_44=a.img, status=inserted

# 设置启动方式
#boot: floppy
boot: disk


# 设置日志文件
log: bochsout.txt
# 关闭鼠标
#mouse: enabled=0
# 打开键盘
#keyboard:keymap=/usr/local/share/bochs/keymaps/sdl2-pc-us.map

# 设置硬盘
ata0: enabled=1, ioaddr1=0x1f0, ioaddr2=0x3f0, irq=14

#启动磁盘的 大小为100MB,需要单独设置磁道之类的内容, 和启动磁盘的路径文件
ata0-master: type=disk, mode=flat, path="./a.img", cylinders=615, heads=16, spt=20
    # 100MB = 104857600 Bytes
    # 盘面16个
    # 每个盘面  615 个柱面(磁道)
    # 每个柱面(磁道) 20个扇区
    # 每个扇区 512Bytes 字节


# 添加gdb远程调试支持
#gdbstub: enabled=1, port=1234, text_base=0, data_base=0, bss_base=0                                                        
```











