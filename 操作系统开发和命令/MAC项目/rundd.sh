#!/bin/bash
#  $1 source file name
dd if=$1 of=hd60M.img bs=512 count=1 conv=notrunc  seek=0
 