#include <keyboard.h>
#include <unreal_int.h>

int read_char(void) {
    regs_t input = { 0 };
    regs_t output = { 0 };
    unreal_int(0x16, &input, &output);

    switch((uint8_t)(output.eax >> 8)) {
        case 0x4b:
            return CURSOR_LEFT;
        case 0x4d:
            return CURSOR_RIGHT;
        case 0x48:
            return CURSOR_UP;
        case 0x50:
            return CURSOR_DOWN; 
    }

    return (uint8_t)output.eax;
}
