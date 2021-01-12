build:
	cd src && make

info: build
	qemu-system-i386 game -no-reboot -monitor stdio -d int -D qemu.log -no-shutdown -vga vmware
	rm boot
debug: build
	qemu-system-x86_64 game -no-reboot -monitor stdio -d int -no-shutdown
	rm boot
