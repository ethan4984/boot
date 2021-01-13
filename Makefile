build:
	cd src && make

qemu: 
		touch serial.log
		qemu-system-x86_64 -enable-kvm game -serial file:serial.log &
		tail -n0 -f serial.log

info: build
	qemu-system-x86_64 game -no-reboot -monitor stdio -d int -D qemu.log -no-shutdown -vga vmware
	rm boot
debug: build
	qemu-system-x86_64 game -no-reboot -monitor stdio -d int -no-shutdown
	rm boot
