#ifndef __LEVEL0_VESA_H_
#define __LEVEL0_VESA_H_

#include <stdint.h>

extern uint32_t *framebuffer, fb_height, fb_width, fb_pitch, fb_bpp, fb_size;

typedef struct {
    char reserved0[16];
    uint16_t pitch;
    uint16_t width;
    uint16_t height;
    char reserved1[3];
    uint8_t bpp;
    char reserved2[14];
    uint32_t framebuffer;
    char reserved3[212];
} __attribute__((packed)) vbe_mode_info_t;

void vesa_init(vbe_mode_info_t *vbe_mode_info);

void set_pixel(uint32_t x, uint32_t y, uint32_t colour);

uint32_t get_pixel(uint32_t x, uint32_t y);

#endif
