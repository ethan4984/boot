build:
	nasm -fbin boot.asm

info:
	qemu-system-x86_64 boot -no-reboot -monitor stdio -d int -D qemu.log -no-shutdown
	rm boot
debug:
	qemu-system-x86_64 boot -no-reboot -monitor stdio -d int -no-shutdown
	rm boot
