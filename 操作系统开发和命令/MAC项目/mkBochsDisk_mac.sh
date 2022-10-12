#!/bin/bash
# $1  file name
# $2  file size , (MB)
bximage -func=create -hd=60 -imgmode=flat -q $1
