## bochs安装_Linux

```bash
#操作系统为 centos 6.5 , yum源配置为阿里云
#配置开发环境
root$ yum install -y nasm ltrace  gcc gcc-c++ libgnomeui-devel


# 下载源码包
$ wget https://udomain.dl.sourceforge.net/project/bochs/bochs/2.6.2/bochs-2.6.2.tar.gz

#解压
$ tar -xzvf bochs-2.6.2.tar.gz

# 进入解压后的目录
$ cd bochs-2.6.2


# 配置, 开启 bochs自带的调试工具， 屏蔽了gdb远程调试 (这两种只能同时存在一个)，--prefix 是安装路径
$ ./configure --prefix=/home/ns/bochs --enable-debugger --enable-disasm --enable-iodebug --enable-x86-debugger --with-x --with-x11

* --prefix=/PATH 指定软件安装目录
* --enable-debugger 打开bochs自己的调试器
* --enable-disasm 启用反编译支持
* --enable-iodebug 启用IO接口调试器
* --enable-x86-debugger 支持x86调试
* --with-x 启用X windows
* --with-x11 启用X11图形界面接口
生成bochs的配置文件bochsrc.disk根据bochs安装目录中自带的模板改改就行


# 编译和安装即可
$ make 
$ sudo make install 

# 配置PATH环境变量 , 上一步配置安装路径为 --prefix=/home/ns/bochs ， 那么就配置相应的路径
$ echo "PATH=\${PATH}:/home/ns/bochs/bin" >> ~/.bash_profile 



# apt 模式安装
apt-get install bochs bochsbios bochs-* -y
```



## bochs安装_Macos12.6

```bash
# 通用安装即可，  x86_64 平台（2018旧MAC) , sdl是显示的gui库, 在bochs启动的配置文件中也要做相应的修改
$ brew install bochs sdl2  sdl

# 重新打开终端来获得新的环境变量
```



## bochs启动配置文件_Linux

```bash
#尽量查看 bochs 安装目录下的 bochsrc-sample.txt
#设置运行过程中能够使用的内存
megs: 32
#
# bios 和vga bios
romimage: file=/home/ns/bochs/share/bochs/BIOS-bochs-latest
vgaromimage: file=/home/ns/bochs/share/bochs/VGABIOS-lgpl-latest

# 设置bochs 所使用的硬盘
floppya: 1_44=a.img, status=inserted

#选择启动盘符
#boot: floppy  #默认从软盘启动，将其注释
boot: disk

#日志
log: bochs.out

#关闭鼠标，打开键盘
mouse: enabled=0
keyboard_mapping: enabled=1, map=/home/ns/bochs/share/bochs/keymaps/x11-pc-us.map

#硬盘设置 ， 磁盘由 bximage 命令创建，Linux$ bximage -hd -mode="flat" -size=60 -q 文件名.img
ata0: enabled=1, ioaddr1=0x1f0, ioaddr2=0x3f0, irq=14
ata0-master: type=disk, path="hd60M.img", mode=flat, cylinders=121, heads=16, spt=63

#增加 bochs对 gdb的支持， 远程连接此机器 1234端口测试
#gdbstub: enabled=1, port=1234, text_base=0, data_base=0, bss_base=0
```



## bochs启动配置文件_Macos12.6

```bash
#尽量查看 bochs 安装目录下的 bochsrc-sample.txt
#设置运行过程中能够使用的内存
megs: 32
#
# bios 和vga bios
romimage: file=/usr/local/Cellar/bochs/2.7/share/bochs/BIOS-bochs-latest
vgaromimage: file=/usr/local/Cellar/bochs/2.7/share/bochs/VGABIOS-lgpl-latest

# 设置bochs 所使用的硬盘
floppya: 1_44=a.img, status=inserted

#选择启动盘符
#boot: floppy  #默认从软盘启动，将其注释
boot: disk

#日志
log: bochs.out

#关闭鼠标，打开键盘
mouse: enabled=0
#keyboard: keymap=/usr/local/Cellar/bochs/2.7/share/bochs/keymaps/x11-pc-us.map
keyboard: type=mf, serial_delay=200, paste_delay=100000

#硬盘设置 ， 磁盘由 bximage 命令创建 MAC$ bximage -func=create -hd=60 -imgmode=flat -q 文件名.img
ata0: enabled=1, ioaddr1=0x1f0, ioaddr2=0x3f0, irq=14
ata0-master: type=disk, path="hd60M.img", mode=flat, cylinders=121, heads=16, spt=63

#增加 bochs对 gdb的支持， 远程连接此机器 1234端口测试
#gdbstub: enabled=1, port=1234, text_base=0, data_base=0, bss_base=0

# 显示组件
display_library: sdl2
```



## bximage创建启动存储镜像

### 创建硬盘

    bximage -hd -mode="flat" -size=60 -q hd60M.img

### 创建软盘

## 运行bochs模拟器

### 模拟器配置文件

### 模拟器运行

执行bochs
bin/bochs -f bochsrc


写成脚本，一键运行

```
  #!/bin/bash
  /usr/bin/bochs -f bochsrc

```


## 
