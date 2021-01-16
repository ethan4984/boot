global unreal_int

unreal_int:
    mov al, byte [esp + 4]
    mov byte [.int_number], al

    mov eax, dword [esp + 8]
    mov dword [.input_regs], eax

    mov eax, dword [esp + 12]
    mov dword [.output_regs], eax

    sgdt [.gdtr]

    push ebx
    push esi
    push edi 
    push ebp

    mov eax, cr0 
    or al, 1
    mov cr0, eax
    
    jmp 0x8:.pmode16
    bits 16
.pmode16:
    mov eax, cr0
    and al, 0xfe
    mov cr0, eax

    jmp 0:.zero_cs
.zero_cs:
    xor ax, ax
    mov ss, ax

    mov dword [ss:.save_esp], esp
    mov esp, dword [ss:.input_regs]
    pop gs
    pop fs
    pop es
    pop ds
    popfd
    pop ebp
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    mov esp, dword [ss:.save_esp]

    db 0xcd ; opcode for int
.int_number:
    db 0

    lgdt [ss:.gdtr]

    mov dword [ss:.save_esp], esp
    mov esp, dword [ss:.output_regs]
    lea esp, [esp + 10 * 4]
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    push ebp
    pushfd
    push ds
    push es
    push fs
    push gs
    mov esp, dword [ss:.save_esp]

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
    pop ebp
    pop edi
    pop esi
    pop ebx

    ret
.input_regs:
    dd 0
.output_regs:
    dd 0
.gdtr:
    dq 0
.save_esp:
    dd 0
