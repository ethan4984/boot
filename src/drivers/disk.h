#ifndef DISK_H_
#define DISK_H_

#include <stdint.h>

#define BLOCK_SIZE 0x200

typedef struct {
    uint8_t size;
    uint8_t zero;
    uint16_t sector_cnt;
    uint16_t segment;
    uint16_t offset; 
    uint32_t lba_low;
    uint32_t lba_high;
} __attribute__((packed)) dap_t;

int read_block(int drive, void *buffer, uint32_t sector);

int disk_read(int drive, void *buffer, uint64_t loc, uint64_t cnt);

#endif
