# boot
This is a simple bootloader designed for easy integration into hobbyist operating systems and for learning purposes. 
To avoid the annoyance of entering higherhalf 64 bit long mode, this does it for you :)

# features

We map the first gigabyte of memory with these following mappings
```
0000000000000000-0000000040000000 0000000040000000 -rw
ffff800000000000-ffff800040000000 0000000040000000 -rw
ffffffff80000000-ffffffffc0000000 0000000040000000 -rw
```
This bootloader also gets a lot of very useful information, including the rsdp, the e820 mmap, and more

# bproto

The bruh protocall looks like this

```c
typedef struct {
    uint16_t mmapAddress;
    uint8_t mmapEntries;
    uint32_t rsdp;
    uint16_t pitch;
    uint16_t width;
    uint16_t height;
    uint8_t bpp;
    uint32_t framebuffer;
} __attribute__((packed)) bproto;
```
A pointer to this structure is passed through rdi, directly to your kernels main function

To choose what vesa mode you want, just edit the videomode macro at the top of boot.asm
