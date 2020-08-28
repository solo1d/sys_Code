> **使用的u-boot版本为 2012-10-rc2 版本**
>
> **写入 SD 卡内的 u-boot.bin  必须是 二进制的, ELF不算, 必须通过 二进制方式 提取**
>
> 
>
> **armV7是 指令集版本号(软件)**
>
> **arm7是 核心集成电路的版本号(硬件), 可实现armV4,armV7等指令集**

## 目录

- [开发环境搭建](#开发环境搭建)
- [编译命令](#编译命令)
- 





## 开发环境搭建

```bash
#mac, 需要先安装 brew 包管理工具
brew install  arm-linux- -binutils


#linux:
sudo apt-get install gcc-arm-linux
sudo apt-get install g++-arm-linux 

#安装后, 需要向 .bashrc 内写入的内容
alias  arm-linux-addr2line='arm-linux-gnueabihf-addr2line'
alias  arm-linux-gcov='arm-linux-gnueabihf-gcov'
alias  arm-linux-ar='arm-linux-gnueabihf-ar'            
alias  arm-linux-gcov-6='arm-linux-gnueabihf-gcov-6'
alias  arm-linux-as='arm-linux-gnueabihf-as'            
alias  arm-linux-gcov-dump='arm-linux-gnueabihf-gcov-dump'
alias  arm-linux-c++filt='arm-linux-gnueabihf-c++filt '       
alias  arm-linux-gcov-dump-6='arm-linux-gnueabihf-cpp-6 '
alias  arm-linux-cpp='arm-linux-gnueabihf-cpp '           
alias  arm-linux-gcov-tool='arm-linux-gnueabihf-gcov-tool'
alias  arm-linux-cpp-6='arm-linux-gnueabihf-cpp-6'         
alias  arm-linux-gcov-tool-6='arm-linux-gnueabihf-gcov-tool-6'
alias  arm-linux-dwp='arm-linux-gnueabihf-dwp'           
alias  arm-linux-gprof='arm-linux-gnueabihf-gprof'
alias  arm-linux-elfedit='arm-linux-gnueabihf-elfedit'       
alias  arm-linux-ld='arm-linux-gnueabihf-ld'
alias  arm-linux-g++='arm-linux-gnueabihf-g++'           
alias  arm-linux-ld.bfd='arm-linux-gnueabihf-ld'
alias  arm-linux-g++-6='arm-linux-gnueabihf-g++-6'         
alias  arm-linux-ld.gold='arm-linux-gnueabihf-ld.gold'
alias  arm-linux-gcc='arm-linux-gnueabihf-gcc'           
alias  arm-linux-nm='arm-linux-gnueabihf-gcc-nm'
alias  arm-linux-gcc-6='arm-linux-gnueabihf-gcc-6 '         
alias  arm-linux-objcopy='arm-linux-gnueabihf-objcopy'
alias  arm-linux-gcc-ar='arm-linux-gnueabihf-gcc-ar'        
alias  arm-linux-objdump='arm-linux-gnueabihf-objdump'
alias  arm-linux-gcc-ar-6='arm-linux-gnueabihf-gcc-ar-6'      
alias  arm-linux-ranlib='arm-linux-gnueabihf-ranlib'
alias  arm-linux-gcc-nm='arm-linux-gnueabihf-gcc-nm'        
alias  arm-linux-readelf='arm-linux-gnueabihf-ranlib'
alias  arm-linux-gcc-nm-6='arm-linux-gnueabihf-gcc-nm-6'      
alias  arm-linux-size='arm-linux-gnueabihf-size'
alias  arm-linux-gcc-ranlib='arm-linux-gnueabihf-gcc-ranlib'    
alias  arm-linux-strings='arm-linux-gnueabihf-strings'
alias  arm-linux-gcc-ranlib-6='arm-linux-gnueabihf-gcc-ranlib-6'  
alias  arm-linux-strip='arm-linux-gnueabihf-strip'


```



## 编译命令

```bash
cd  u-boot     #来到 u-boot 根目录

make s5p_goni_config    #编译 s5p_goni 开发板的 配置文件. 必须先编译

make           # 编译出来 u-boot-bin 和 u-boot-lsp 等文件, 才算得上成功


# 其他命令
arm-linux-gcc  
arm-linux-as  a.s -o a.o      #汇编命令, 生成连接文件
arm-linux-objdump  -S  a.o    #反汇编命令. 
arm-linux-size   a.o          # 获得到 text , data, bss 每个段的 字节长度

hexdump -C   a.out            # 16进制查看器, 查看的是已经完成编译的 ELF 文件

dd iflag=dsycn  oflog=dsync  seek=1 bs=512 if=u-boot.bin of=/dev/sda1  #写入命令, 磁盘同步, 从第一扇区开始写


```





