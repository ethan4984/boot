CC = gcc -m32
CFLAGS = -ffreestanding -Wall -Wextra -fno-pie -I. -Ilib
CSRC = $(shell find . -type f -name '*.c')

build:
	mkdir -p bin
	$(CC) $(CFLAGS) $(CSRC) -c
	mv *.o bin
	nasm -felf32 lib/unreal_int.asm -o bin/unreal_int.o
	$(CC) -T linker.ld bin/*.o -o bin/game.bin -nodefaultlibs -nostartfiles -no-pie -lgcc
	nasm -fbin boot/boot.asm -o ../game
