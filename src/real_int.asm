real_int:
    sgdt [.save_gdtr]

    push eax
    mov eax, dword [esp + 8]
    mov byte [.int_number], al
    pop eax
    
    jmp 0x8:.pmode16
    bits 16
.pmode16:
    push eax
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    pop eax

    push eax
    mov eax, cr0
    and al, 0xfe
    mov cr0, eax
    pop eax

    jmp 0:.zero_cs
.zero_cs:
    push eax
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    pop eax

    db 0xcd
.int_number:
    db 0

    lgdt [.save_gdtr]

    push eax
    mov eax, cr0
    or al, 1
    mov cr0, eax
    pop eax

    jmp 0x18:.pmode32
    bits 32
.pmode32:
    push eax
    mov ax, 0x20
    mov ds, ax
    mov es, ax
    mov ss, ax
    pop eax

    ret
.save_gdtr:
    dq 0
