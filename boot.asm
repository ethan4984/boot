pml4 equ 0x1000
pml3 equ 0x2000
pml2 equ 0x3000
hh_pml2 equ 0x4000
hh_pml3 equ 0x5000

bits 16
org 0x7c00

cld
jmp 0:initCS

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
mov edi, 0x6000

e820:
    mov eax, 0xe820
    mov ecx, 24
    mov edx, 0x534d4150
    int 0x15
    
    add edi, 24

    jc .exit
  
    test ebx, ebx 
    jnz e820

.exit:

cli

mov word [pml4 + 256 * 8], pml3 | 0x3 
mov word [pml4], pml3 | 0x3
mov word [pml3], pml2 | 0x3

mov word [pml4 + 511 * 8], hh_pml3 | 0x3 
mov word [hh_pml3 + 510 * 8], hh_pml2 | 0x3

xor eax, eax
xor edi, edi

buildPageTables:
    or eax, (1 << 7) | 0x3
    mov dword [pml2 + edi], eax 
    mov dword [hh_pml2 + edi], eax

    add eax, 0x200000
    add edi, 8

    cmp eax, 0x40000000
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

    jmp 0x7e00

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
    dw 0xffff
    dw 0
    db 0
    db 0b10011010
    db 0
    db 0
.DATA16:
    dw 0xffff
    dw 0
    db 0
    db 0b10011010
    db 0
    db 0
.CODE32:
    dw 0xffff
    dw 0
    db 0
    db 0b10011010
    db 0b11001111
    db 0
.DATA32:
    dw 0xffff
    dw 0
    db 0
    db 0b10010010
    db 0b11001111
    db 0
.CODE64:
    dw 0
    dw 0
    db 0
    db 0b10011010
    db 0b00100000
    db 0
.DATA64:
    dw 0
    dw 0
    db 0
    db 0b10010010
    db 0
    db 0

.end:

times 510-($-$$) db 0
dw 0xaa55 ; boot signature

incbin 'kernel.bin'
