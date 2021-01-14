#include <output.h>
#include <keyboard.h>
#include <unreal_int.h>
#include <vesa.h>

#define PINK 0xFF69B4

__attribute__((section(".init")))
void main(int boot_drive, vbe_mode_info_t *vbe_mode_info) {
    vesa_init(vbe_mode_info);

    static uint32_t colour_buffer[] = {
                                        0, 0, 0, PINK, PINK, PINK, PINK, 0, 0, 0,
                                        0, 0, 0, PINK, PINK, PINK, PINK, 0, 0, 0,
                                        0, 0, 0, PINK, PINK, PINK, PINK, 0, 0, 0,
                                        0, 0, 0, PINK, PINK, PINK, PINK, 0, 0, 0,
                                        0, 0, 0, 0, PINK, PINK, 0, 0, 0, 0,
                                        0, 0, 0, 0, PINK, PINK, 0, 0, 0, 0,
                                        0, 0, 0, 0, PINK, PINK, 0, 0, 0, 0,
                                        0, 0, 0, 0, PINK, PINK, 0, 0, 0, 0,
                                        0, 0, 0, 0, PINK, PINK, 0, 0, 0, 0,
                                        0, 0, 0, 0, PINK, PINK, 0, 0, 0, 0,
                                        0, 0, 0, 0, PINK, PINK, 0, 0, 0, 0,
                                        0, 0, 0, 0, PINK, PINK, 0, 0, 0, 0,
                                        0, 0, 0, 0, PINK, PINK, 0, 0, 0, 0,
                                        0, 0, 0, 0, PINK, PINK, 0, 0, 0, 0,
                                        0, 0, 0, 0, PINK, PINK, 0, 0, 0, 0,
                                        0, 0, 0, 0, PINK, PINK, 0, 0, 0, 0,
                                        0, 0, PINK, PINK, 0, 0, PINK, PINK, 0, 0,
                                        0, 0, PINK, PINK, 0, 0, PINK, PINK, 0, 0,
                                        0, 0, PINK, PINK, 0, 0, PINK, PINK, 0, 0,
                                        0, 0, PINK, PINK, 0, 0, PINK, PINK, 0, 0,
                                      };

    static uint32_t back_buffer[sizeof(colour_buffer)];

    shape_t shape = { .colour_buffer = colour_buffer, .backbuffer = back_buffer, .x = 50, .y = 50, .height = 20, .width = 10 };

    draw_shape(&shape);

    redraw_shape(&shape, 100, 100);

    for(;;) {
        int c = read_char();
        switch(c) {
            case CURSOR_RIGHT:
                redraw_shape(&shape, shape.x + 2, shape.y);
                break;
            case CURSOR_LEFT:
                redraw_shape(&shape, shape.x - 2, shape.y);
                break;
            case CURSOR_UP:
                redraw_shape(&shape, shape.x, shape.y - 2);
                break;
            case CURSOR_DOWN:
                redraw_shape(&shape, shape.x, shape.y + 2);
        }
    }

    redraw_shape(&shape, 500, 500);
    for(;;);
}
