# boot
This is a simple bootloader designed for easy integration into hobbyist operating systems and for learning purposes. 
To avoid the annoyance of entering higherhalf 64 bit long mode, this does it for you :)

We map the first gigabyte of memory with these following mappings
```
0000000000000000-0000000040000000 0000000040000000 -rw
ffff800000000000-ffff800040000000 0000000040000000 -rw
ffffffff80000000-ffffffffc0000000 0000000040000000 -rw
```
We use 2MB pages. Also side note, be sure not to edit anything between 0x1000 -> 0x7000 becuase that is where 
the page tables are stored along with the e820 mmap.

Hm that reminds me, this thing also grabs for you the e820 mmap, it puts it at address 0x6000.
To make good use of this just do something like this within your kernel
```c
typedef struct {
  uint64_t base;
  uint64_t length;
  uitn32_t type;
  uint32_t unused;
} E820Entry_t;

__attribute__(section(".init")))
void kernelMain() {
  E820Entry_t *E820Entries = (E820Entry_t*)0x6000;
}
```
to load your kernel, at the end of boot.asm, just edit this line too 
```asm
incbin '<insert path to kernel binary>'
```
Keep in mind, one of the limitations of this bootloader, is that it cant read from elf binarys, only flat binarys.
So in your linker, just change the output format.

Also since we are linking flat, to insure that kernelMain is actually at 0x7e00, just put kernelMain in section .init and put
it at the very beginning of your linker script; like this 
```ld
OUTPUT_FORMAT(binary)
entry(kernelMain)

SECTIONS {
  . 0x7e00;
  .init : { 
    *(.init*)
  } 
  ...
}
```
