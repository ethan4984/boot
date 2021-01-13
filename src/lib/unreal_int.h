#ifndef UNREAL_INT_H_
#define UNREAL_INT_H_

#include <stdint.h>

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
