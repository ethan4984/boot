#include <vesa.h>

__attribute__((section(".init")))
void main(vbe_mode_info_t *vbe_mode_info) {
    vesa_init(vbe_mode_info); 
    set_pixel(50, 50, 0xff);
    for(;;)
        asm volatile ("cli\nhlt");
}
