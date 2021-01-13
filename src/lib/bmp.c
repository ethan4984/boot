#include <bmp.h>

/*uint32_t bmp_get_pixel(background_image_t *bmp, uint32_t x, uint32_t y) {
    
}*/

int bmp_draw(uint32_t *image, background_image_t *ret) {
    bmp_hdr_t *hdr = (bmp_hdr_t*)image;

    if(*(uint16_t*)hdr != 0x424d) 
        return -1;

    *ret = (background_image_t) { .image = image, .hdr = *hdr };
    return 0;
}
