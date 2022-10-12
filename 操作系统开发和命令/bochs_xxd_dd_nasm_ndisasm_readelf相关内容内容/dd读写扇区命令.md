## dd命令

```bash
$dd if=指定读取的文件  of=输入的文件 
		bs=指定块字节大小 
		count=块的数量  
		seek=跳过的读取文件中的长度 
		conv=指定如何转换文件,一般为 notrunc 不打断文件 覆盖所写入的位置，其他的不动


$nasm -o mbr.bin mbr.S && dd if=./mbr.bin of=./hd60M.img bs=512 count=1  conv=notrunc
```

