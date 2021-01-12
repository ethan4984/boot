org 0x7c00
bits 16

E820_MMAP_LOC equ 0x1000

jmp 0:init_cs
init_cs:
    xor ax, ax 
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00

    cld

    mov byte [boot_drive], dl
    mov ah, 0x42
    mov si, DAP
    int 0x13

    mov di, E820_MMAP_LOC
    call e820

    in al, 0x92
    or al, 2
    out 0x92, al ; if this does not work then cope

    call find_vesa_mode

    lgdt [GDT]

    cli
    mov eax, cr0
    or al, 1
    mov cr0, eax

    jmp GDT.CODE16 - GDT.start:pmode_cs_init

e820: ; esi contains the number of entries, es:di entry buffer
    xor esi, esi
    xor ebx, ebx
.loop:
    mov eax, 0xe820
    mov ecx, 24 ; size of struct 
    mov edx, 0x534d4150 ; 'SMAP'
    int 0x15
    
    jc .exit ; error on carry

    test ebx, ebx ; ebx == 0 means we are done
    jz .exit

    cmp dword [es:di + 8], 0 ; skip over entries with length=0
    jz .loop

    inc esi

    add edi, 24 ; iterate the buffer
    jmp .loop
.exit:
    ret

tm_print: ; ds:si = buffer
    mov ah, 0xe
.loop: 
    lodsb
    test al, al
    jz .end
    int 0x10
    jmp .loop
.end:
    ret

pmode_cs_init:
    mov ax, GDT.DATA32 - GDT.start
    mov ss, ax
    mov ds, ax
    mov es, ax

    mov eax, cr0 
    and al, 0xfe
    mov cr0, eax

    jmp 0:.zero_cs
.zero_cs:
    xor ah, ah
    mov byte [unreal_int.int_number], 0x16
    call unreal_int

;    mov ah, 0xe
;    mov byte [unreal_int.int_number], 0x10
;    call unreal_int

    mov esi, [VBE_MODE_INFO.framebuffer]
    mov dword [esi], 0xfffffff

    jmp $

.save_gdtr:
    dq 0

times 218-($-$$) db 0
times 6 db 0

GDT:
    dw .end - .start - 1 
    dd .start
.start:
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
    db 0b10010010 ; access
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
    db 0b10010110 ; access
    db 0 ; granularity
    db 0 ; base high
.end:

DAP:
    db 0x10 ; size of DAP
    db 0 ; unused
    dw 63 ; number of sectors to be read
    dd 0x7e00
    dq 1 ; first sector

boot_drive:
    db 0

times 510-($-$$) db 0
dw 0xaa55 ; boot signatura

%include 'src/vesa.asm'

%include 'src/unreal_int.asm'

times 2048-($-$$) db 0

times 0x8000-($-$$) db 0
