## 虚拟化加载img镜像文件安装系统

总结了一下，有两种方式最方便，一种是转换，即把img转换为对应虚拟化平台的磁盘文件，直接启动就是成品；另一种是使用img刷入磁盘，然后在启动成品。



## 转换方法

使用`qemu-img`命令将其转换为对应虚拟化平台的磁盘文件，直接启动即可；这种方法通用性强，兼容性也好；

```
支持的格式
Supported formats: blkdebug blklogwrites blkreplay blkverify bochs cloop copy-on-read 
dmg file ftp ftps host_cdrom host_device http https iscsi iser luks nbd null-aio 
null-co nvme parallels qcow qcow2 qed quorum raw rbd replication sheepdog ssh throttle 
vdi vhdx vmdk vpc vvfat
```

其中五种常用的格式：**vmdk**、qcow2、raw、vhdx、vdi；

其中vmdk为vmware的格式，包括vsphere和Workstation，qcow2和raw格式为Xen/KVM所支持的格式，而vhdx、vhd为hyper-v支持的；高版本的hyper-v（2016+）或第二代为vhdx，而老版本

***上述格式或参数中，vpc生成的文件为vhd，而vhdx格式的参数则为vhdx***

### 安装qemu组件

```bash
#Ubuntu/Debian
sudo apt install qemu-utils -y

#RHEL/CentOS
sudo yum install qemu-img -y

#MAC
brew install qemu
```



### 使用方法

```bash
# 转换为第一代hyper-v或早期hyper-v版本（2008-2012）
# 注意是vpc参数，文件格式为vhd
qemu-img convert -f raw -O vpc 需要转换的.img 转换后可启动的磁盘.vhd

# 转换为第二代hyper-v或现代版hyper-v版本（2016+）
qemu-img convert -f raw -O vhdx 需要转换的.img  转换后可启动的磁盘.vhdx

# 转换为vmware支持的格式
qemu-img convert -f raw -O vmdk 需要转换的.img  转换后可启动的磁盘.vmdk
#范例, 生成的文件直接交由 VMware 添加现有硬盘启动即可
	#qemu-img convert -f raw -O vmdk hd60M.img hd60.vmdk 
```

之后直接创建虚拟机启动即可；
