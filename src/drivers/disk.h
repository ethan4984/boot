#ifndef DISK_H_
#define DISK_H_

#include <stdint.h>

#define BLOCK_SIZE 0x200

typedef struct {
    uint16_t size_zero; 
    uint16_t sector_cnt;
    uint16_t offset;
    uint16_t segment;
    uint64_t lba;
} __attribute__((packed)) dap_t;

#endif
