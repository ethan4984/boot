CC = gcc -m32
CFLAGS = -ffreestanding -Wall -Wextra -fno-pie
CSRC = $(shell find . -type f -name '*.c')

build:
	mkdir -p bin
	$(CC) $(CFLAGS) $(CSRC) -c
	mv *.o bin
	$(CC) -T linker.ld bin/*.o -o bin/level0.bin -nodefaultlibs -nostartfiles -no-pie -lgcc
