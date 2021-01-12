real_int: ; intended to be called from 32 bit pmode
    pushf
    push eax
    cli

    sgdt [.save_gdtr]
    sidt [.save_idtr]

    lidt [ivt]

    jmp 0x8:.pmode16
    bits 16
.pmode16:
    mov eax, cr0
    and al, 0xfe
    mov cr0, eax

    jmp 0:.zero_cs
.zero_cs:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    pop eax

    db 0xcd ; opcode for int
.int_number:
    db 0

    lgdt [.save_gdtr]
    lidt [.save_idtr]
    push eax
    
    mov eax, cr0
    or al, 1
    mov cr0, eax
    
    jmp 0x18:.pmode32
    bits 32
.pmode32:
    mov ax, 0x20
    mov ds, ax
    mov ss, ax
    mov es, ax

    pop eax
    popf
    ret
.save_gdtr:
    dq 0
.save_idtr:
    dq 0
ivt:
    dw 0x3ff
    dd 0
