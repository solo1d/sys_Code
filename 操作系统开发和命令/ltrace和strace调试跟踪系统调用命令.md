## ltrace和strace跟踪系统调用命令

```bash
# ltrace 并不是内置的， 需要安装
$ sudo apt install ltrace

# 使用 ltrace  ， 可以跟踪SYS_write 系统调用，比 strace 更深
$ ltrace -S  可执行程序       #即可

# 使用 ltrace  ， 只能跟踪到 write 系统调用
$ strace   可执行程序       #即可
		# 如果只想查看某个系统调用，可以用下面的参数来替换 , write可以替换成想要的系统调用
			$ strace  -e trace=write  可执行程序 
```

