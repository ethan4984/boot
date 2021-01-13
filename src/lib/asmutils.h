#ifndef ASMUTILS_H_
#define ASMUTILS_H_

#include <stdint.h>

void outb(uint16_t port, uint8_t data);

void outw(uint16_t port, uint16_t data);

void outd(uint16_t port, uint32_t data);

uint8_t inb(uint16_t port);

uint16_t inw(uint16_t port);

uint32_t ind(uint16_t port);

#endif
