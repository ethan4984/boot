build:
	nasm -fbin src/boot.asm -o boot

info: build
	qemu-system-i386 boot -no-reboot -monitor stdio -d int -D qemu.log -no-shutdown
	rm boot
debug: build
	qemu-system-x86_64 boot -no-reboot -monitor stdio -d int -no-shutdown
	rm boot
