pml4 equ 0x1000
pml3 equ 0x2000
pml2 equ 0x3000
hh_pml2 equ 0x4000
hh_pml3 equ 0x5000
e820Entries equ 0x6000

bits 16
org 0x7c00

cld
jmp 0:initCS

mov byte [BootDrive], dl

initCS:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov sp, 0x7c00

in al, 0x92
or al, 2
out 0x92, al ; enables a20 line

lgdt[GDT]

mov ah, 0x42 ; extended sector read from disk
mov si, DAP
int 0x13

xor ax, ax
mov di, pml4
mov cx, 0x6000 / 2
rep stosw ; zeros out 0x1000 -> 0x6000

xor ebx, ebx
mov edi, e820Entries

e820:
    mov eax, 0xe820
    mov ecx, 24 ; size of struct 
    mov edx, 0x534d4150 ; 'SMAP'
    int 0x15
    
    add edi, 24

    jc .exit ; error on carry
  
    test ebx, ebx ; when is zero we are done
    jnz e820

.exit:

jmp 0x7e00

times 218-($-$$) db 0
times 6 db 0

BootDrive: db 0

DAP:
    db 0x10 ; size of DAP
    db 0 ; unused
    dw 63 ; number of sectors to be read
    dd 0x7e00 ; load point at
    dq 1 ; first sector
    
GDT:
    dw .end - .start - 1 
    dd .start

.start:

.NULL:
    dq 0
.CODE16:
    dw 0xffff ; limit
    dw 0 ; base low
    db 0 ; base mid
    db 0b10011010 ; access
    db 0 ; granularity
    db 0 ; base high
.DATA16:
    dw 0xffff ; limit
    dw 0 ; base low
    db 0 ; base mid
    db 0b10011010 ; access
    db 0 ; granularity
    db 0 ; base high
.CODE32:
    dw 0xffff ; limit
    dw 0 ; base low
    db 0 ; base mid
    db 0b10011010 ; access
    db 0b11001111 ; granularity
    db 0 ; base high
.DATA32:
    dw 0xffff ; limit
    dw 0 ; base low
    db 0 ; base mid
    db 0b10010010 ; access
    db 0b11001111 ; granularity
    db 0 ; base high
.CODE64:
    dw 0 ; limit
    dw 0 ; base low
    db 0 ; base mid 
    db 0b10011010 ; access
    db 0b00100000 ; granularity
    db 0 ; base high
.DATA64:
    dw 0 ; limit
    dw 0 ; base low
    db 0 ; base mid
    db 0b10010010 ; access
    db 0 ; granularity
    db 0 ; base high

.end:

times 0x1b8-($-$$) db 0 ; partition entry structures (left blanck dont touch)

times 510-($-$$) db 0
dw 0xaa55 ; boot signature

mov eax, 0x4f02
mov ebx, 280
int 0x10

mov eax, 0x4f01
mov ecx, 280
mov edi, VBEINFO 
int 0x10

mov word [bootheader.e820address], 0x6000
mov word [bootheader.pitch], VBEINFO.pitch
mov word [bootheader.x], VBEINFO.x
mov word [bootheader.y], VBEINFO.y
mov byte [bootheader.bpp], VBEINFO.bpp
mov dword [bootheader.framebuffer], VBEINFO.framebuffer

cli

mov word [pml4 + 256 * 8], pml3 | 0x3 ; offset for 0xffff8... is 256 * 8
mov word [pml4], pml3 | 0x3
mov word [pml3], pml2 | 0x3

mov word [pml4 + 511 * 8], hh_pml3 | 0x3 ; offset for 0xfffffffff8... is 511 * 8 on pml4 and on pml3 its 510 * 8
mov word [hh_pml3 + 510 * 8], hh_pml2 | 0x3

xor eax, eax
xor edi, edi

buildPageTables:
    or eax, (1 << 7) | 0x3 ; set them as present and writable and also set the size bit making us use 2mb pages
    mov dword [pml2 + edi], eax  
    mov dword [hh_pml2 + edi], eax

    add eax, 0x200000
    add edi, 8

    cmp eax, 0x40000000 ; map first gb
    jb buildPageTables

mov eax, pml4
mov cr3, eax

mov eax, cr4
or eax, (1 << 5) | (1 << 7) ; set PAE and PGE set PSE
mov cr4, eax

mov ecx, 0xc0000080
rdmsr
or eax, 1 << 8 ; set LME in ELER
wrmsr

mov eax, cr0
or eax, 1 << 31 | 1 << 0 ; enable protected mode and paging
mov cr0, eax

jmp GDT.CODE64 - GDT.start:longModeCode ; far jump to cs code64

bits 64

longModeCode:
    mov ax, GDT.DATA64 - GDT.start
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    jmp $

VBEINFO:
    dq 0
    dq 0
    .pitch: dw 0
    .x: dw 0
    .y: dw 0
    db 0
    db 0
    db 0
    .bpp: db 0
    dq 0
    dw 0
    db 0
    .framebuffer: dd 0 
    times 212 db 0

bootheader:
    .e820address: dw 0
    .pitch: dw 0
    .x: dw 0
    .y: dw 0
    .bpp: db 0
    .framebuffer: dd 0

times 32768-($-$$) db 0
