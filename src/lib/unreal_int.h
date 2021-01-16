#ifndef UNREAL_INT_H_
#define UNREAL_INT_H_

#include <stdint.h>

#define rm_seg(x) ((uint16_t)(((int)x & 0xffff0) >> 4))
#define rm_off(x) ((uint16_t)(((int)x & 0x0000f) >> 0))

#define rm_desegment(seg, off) (((uint32_t)(seg) << 4) + (uint32_t)(off))

typedef struct {
    uint16_t gs;
    uint16_t fs;
    uint16_t es;
    uint16_t ds;
    uint32_t eflags;
    uint32_t ebp;
    uint32_t edi;
    uint32_t esi;
    uint32_t edx;
    uint32_t ecx;
    uint32_t ebx;
    uint32_t eax;
} regs_t;

void unreal_int(uint8_t num, regs_t *input, regs_t *output);

#endif
