unreal_int: ; intended to be called from 32 bit unreal mode
    pushf
    cli

    mov eax, cr0
    or al, 1
    mov cr0, eax

    jmp 0x8:.pmode16
    bits 16
.pmode16:
    push eax
    mov eax, cr0
    and al, 0xfe
    mov cr0, eax
    pop eax

    jmp 0:.zero_cs0
.zero_cs0:
    db 0xcd ; int opcode
.int_number:
    db 0

    push 0 
    pop ss

    push eax

    mov eax, cr0 
    or al, 1
    mov cr0, eax

    jmp 0x18:.pmode32
    bits 32
.pmode32:
    mov ax, 0x20
    mov ds, ax
    mov es, ax
    mov ss, ax 

    mov eax, cr0 
    and al, 0xfe
    mov cr0, eax

    jmp 0:.zero_cs1
.zero_cs1:
    pop eax
    popf
    ret
