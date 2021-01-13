#include <output.h>
#include <unreal_int.h>
#include <vesa.h>

__attribute__((section(".init")))
void main(vbe_mode_info_t *vbe_mode_info) {
    vesa_init(vbe_mode_info);

    uint32_t colour_buffer[] = { 0xff, 0, 0xff, 0xff, 0, 0xff,
                                 0xff, 0, 0xff, 0xff, 0, 0xff,
                                 0xff, 0, 0xff, 0xff, 0, 0xff,
                                 0xff, 0, 0xff, 0xff, 0, 0xff,
                                 0xff, 0, 0xff, 0xff, 0, 0xff,
                                 0xff, 0, 0xff, 0xff, 0, 0xff,
                                 0xff, 0, 0xff, 0xff, 0, 0xff,
                                 0xff, 0, 0xff, 0xff, 0, 0xff,
                                 0xff, 0, 0xff, 0xff, 0, 0xff,
                                 0xff, 0, 0xff, 0xff, 0, 0xff,
                                 0xff, 0, 0xff, 0xff, 0, 0xff,
                                 0xff, 0, 0xff, 0xff, 0, 0xff,
                               };

    uint32_t back_buffer[sizeof(colour_buffer)];

    shape_t shape = { .colour_buffer = colour_buffer, .backbuffer = back_buffer, .x = 50, .y = 50, .height = 12, .width = 6 };

    draw_shape(&shape);

    redraw_shape(&shape, 100, 100);

    set_pixel(50, 50, 0xffffffff);

    kprintf("[KDEBUG]", "Welcome");

    regs_t input = { .eax = 0 };
    regs_t output;

    for(;;) {
        unreal_int(0x16, &input, &output);
        kprintf("[KDEBUG]", "%c", (uint8_t)output.eax);
    }

    redraw_shape(&shape, 500, 500);
    for(;;);
}
