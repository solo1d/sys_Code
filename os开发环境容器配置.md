环境 `Mac M1 Mro(arm架构)` 笔记本



## 1、下载X86容器

```bash
$ docker pull amd64/ubuntu    # 最新版的 X86模式的 ubuntu 即可
```

## 2、配置X86运行环境

使用 buildx，需要开启docker的实验功能后，才可以使用，开启方式：

- 打开 Docker.app 的设置界面 --> Docker Engine 里面的json配置窗口
  - 添加如下内容：

```json
{
    "experimental": true
}
```

- 编辑 ～/.docker/config.json 添加如下内容：

```json
"experimental" : "enabled"
```

重启Docker即可（需要Docker版本为4.17以上）



## 3、启动容器并映射开发目录

```bash
# 将本地的   /home/ns/os 目录挂载到容器的 /root/os 目录（读写）。
#  并启动 ubuntu 最新的容器 到后台
$ docker run --name ubuntu_os -itd --mount type=bind,source=/home/ns/os,target=/root/os   amd64/ubuntu

# 输出内容：
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
5250ba5d6c871c0625e352817849463693e5cceef7db2080d15a6ad973663d99
                                                                   
```

## 4、进入ubuntu容器

```bash
$ docker exec  -it 5250ba5d6c  /bin/bash     # 通过 docker ps 来获取容器id
```

## 5、设置显示中文

```bash
#先查看是否有支持的编码
$locale -a

#输出如下：
locale: Cannot set LC_CTYPE to default locale: No such file or directory
locale: Cannot set LC_MESSAGES to default locale: No such file or directory
locale: Cannot set LC_COLLATE to default locale: No such file or directory
C
C.utf8
POSIX
#输出结束

# 设置为  C.utf8 这个所支持的编码即可
echo "export LANG=C.utf8"  >> ~/.bashrc

#重新载入环境变量
source ~/.bashrc
```

## 6、配置apt为国内源

将 `/etc/apt/sources.list` 这个文件的内容全部注释，并添加下面的内容。

```ini
#先备份
$ cp -a /etc/apt/sources.list /etc/apt/sources.list.bak

# 更换为 阿里云(x86) 源
$ sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list

# 再执行清空和更新
$ apt clean
$ apt update
```

```bash
# apt 换成国内源

# 将如下内容写入文件 sources.list ,并放入 /Users/ns/iChannel 目录内，然后将容器内的 /etc/apt/sources.list 文件进行替换即可。

# 默认注释了源码仓库，如有需要可自行取消注释
deb http://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted universe multiverse
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted universe multiverse

deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted universe multiverse

deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse

deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
# deb-src http://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
```



## 7、配置开发环境

```bash
$ apt install -y vim  gcc make nasm   


# 下面内容暂不需要
# 取消系统最小化配置
# $ unminimize

# $ apt install man   #安装man
```



```bash
在使用ARM 版本的ubuntu情况下，需要交叉编译工具。但是我还没有调试好，暂时屏蔽
# gcc-arm-linux-gnueabihf 
$ arm-linux-gnueabihf-gcc -mbe32   #编译32位程序
$ arm-linux-gnueabihf-ld --verbose   #查看支持的仿真类型
elf32-bigarm
```

