## nasm命令

```bash
#编译带 elf(32) 文件头的目标文件
$ nasm -f elf 1.asm  -o 1.o

#编译带 elf(64) 文件头的目标文件
$ nasm -f elf64 1.asm  -o 1.o


# 整合成可执行文件 (二进制文件)
$ld 1.o  -o a.out

# 整合成带 elf 的可执行文件
$ld -melf_x86_64 -s -o a.out 1.o 2.o

$ld -melf_i386 -s -o a.out 1.o 2.oz

#在 mac下使用
$ nasm -f macho64 1.asm -o 1.o

$ld  -arch x86_64 -e _start -L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib -lSystem  1.o -o a.out

ld需要-lSystem标志来防止它抛出此错误。它还需要-macosx_version_min来删除警告。使用ld的正确方法是：ld hello.o -o hello -macosx_version_min 10.13 -lSystem。

在macOS 11及更高版本上更新，您需要通过-L/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib，以便它正确定位-lSystem库。如果需要，您可以使用-L$(xcode-select -p)/SDKs/MacOSX.sdk/usr/lib动态评估正确的路径。
```

