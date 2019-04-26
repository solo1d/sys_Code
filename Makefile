all: Image

bootsect.o:
	as --32 bootsect.S -o bootsect.o
