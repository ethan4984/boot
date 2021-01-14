#include <vesa.h>

uint32_t *framebuffer, fb_height, fb_width, fb_pitch, fb_bpp, fb_size;

void vesa_init(vbe_mode_info_t *vbe_mode_info) {
    framebuffer = (uint32_t*)vbe_mode_info->framebuffer;
    fb_height = vbe_mode_info->height;
    fb_width = vbe_mode_info->width;
    fb_bpp = vbe_mode_info->bpp;
    fb_pitch = vbe_mode_info->pitch;
    fb_size = fb_height * fb_pitch;
}

inline void set_pixel(uint32_t x, uint32_t y, uint32_t colour) {
    *(volatile uint32_t*)((uint32_t)framebuffer + ((y * fb_pitch) + (x * fb_bpp / 8))) = colour;
}

inline uint32_t get_pixel(uint32_t x, uint32_t y) {
    return *(volatile uint32_t*)((uint32_t)framebuffer + ((y * fb_pitch) + (x * fb_bpp / 8)));
}

void draw_shape(shape_t *shape) {
    for(uint16_t y = 0; y < shape->height; y++) { 
        for(uint16_t x = 0; x < shape->width; x++) {
            if(shape->colour_buffer[y * shape->width + x] == UNUSED_PIXEL)
                continue;
            shape->backbuffer[y * shape->width + x] = get_pixel(shape->x + x, shape->y + y);
            set_pixel(shape->x + x, shape->y + y, shape->colour_buffer[y * shape->width + x]);
        }
    }
}

void redraw_shape(shape_t *shape, uint16_t new_x, uint16_t new_y) {
    for(uint16_t x = 0; x < shape->width; x++) { 
        for(uint16_t y = 0; y < shape->height; y++) {
            if(shape->colour_buffer[y * shape->width + x] == UNUSED_PIXEL)
                continue;
            set_pixel(shape->x + x, shape->y + y, shape->backbuffer[y * shape->width + x]);
        }
    }

    shape->x = new_x;
    shape->y = new_y;

    draw_shape(shape);
}
