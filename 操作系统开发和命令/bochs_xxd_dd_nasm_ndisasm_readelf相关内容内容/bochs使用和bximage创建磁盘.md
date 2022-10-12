## bximage创建磁盘

```bash
#mac 使用， -hd 后面是文件大小(以MB为单位)
$ bximage -func=create -hd=60 -imgmode=flat -q 文件名.img

#linux 使用, size 是文件大小(以MB为单位)
$ bximage -hd -mode="flat" -size=60 -q 文件名.img
```



## bochs配置

```bash
#尽量查看 bochs 安装目录下的 bochsrc-sample.txt
```

