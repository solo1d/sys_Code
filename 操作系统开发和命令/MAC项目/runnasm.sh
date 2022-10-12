#!/bin/bash
#  $1 put file name
#  $2 source file name
nasm -I ./boot/include -o  $1  ./boot/$2  || echo "nasm Error" 

echo " === nasm OK === "

echo "rundd.sh $1"
./rundd.sh $1
