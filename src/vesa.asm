find_vesa_mode:
    mov ax, 0x4f00
    mov di, VBE_INFO
    int 0x10
    jc .error

    cmp ax, 0x4f ; check if we support vbe at all
    jne .error

    cmp dword [VBE_INFO.signature], 'VESA' 
    jne .error
    
    mov ax, word [VBE_INFO.video_mode_seg]
    mov es, ax
    mov di, word [VBE_INFO.video_mode_offset]
.loop:
    cmp word [es:di], 0xffff
    je .error

    push es ; some bioses destroy es
    push di

    mov ax, 0x4f01
    mov cx, word [es:di]
    mov di, VBE_MODE_INFO
    int 0x10

    pop di
    pop es

    mov ah, 0xe
    mov al, 'g'
    int 0x10

    cmp word [VBE_MODE_INFO.width], 1024
    jne .back

    cmp word [VBE_MODE_INFO.height], 768
    jne .back

    cmp byte [VBE_MODE_INFO.bpp], 32
    jne .back

    mov ax, 0x4f02
    mov bx, word [es:di]
    int 0x10
    
    ret
.back:
    add di, 2
    jmp .loop
.error:
    mov si, vesa_error
    call tm_print

    cli
    hlt

VBE_MODE_INFO:
    times 16 db 0
    .pitch: dw 0
    .width: dw 0
    .height: dw 0
    times 3 db 0
    .bpp: db 0
    times 14 db 0
    .framebuffer: dd 0
    times 212 db 0

VBE_INFO:
    .signature: dd 0
    .version_minor: db 0
    .version_magor: db 0
    .oem_offset: dw 0
    .oem_seg: dw 0
    .capabilities: dd 0
    .video_mode_offset: dw 0
    .video_mode_seg: dw 0
    .video_mem_blocks: dw 0
    .software_rev: dw 0
    .vendor_off: dw 0
    .vendor_seg: dw 0
    .product_name_off: dw 0
    .product_name_seg: dw 0
    .project_rev_off: dw 0
    .project_rev_seg: dw 0
    times 222 db 0
    .oem_data times 256 db 0

vesa_error: db 'Unable to enter a suitable video mode... halting', 0
