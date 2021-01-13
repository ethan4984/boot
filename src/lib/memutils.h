#ifndef MEMUTILS_H_
#define MEMUTILS_H_

#include <stdint.h>
#include <stddef.h>

#define ROUNDUP(a, b) (((a) + ((b) - 1)) / (b))

#define BM_SET(bitmap, location) (bitmap)[(location) / 8] = (bitmap)[(location) / 8] | (1 << ((location) % 8))
#define BM_CLEAR(bitmap, location) (bitmap)[(location) / 8] = (bitmap)[(location) / 8] & (~(1 << ((location) % 8)));
#define BM_TEST(bitmap, location) ((bitmap[(location) / 8] >> ((location) % 8)) & 0x1)

#define ALIGN_UP(x, a) ({ \
    typeof(x) value = x; \
    typeof(a) align = a; \
    value = ROUNDUP(value, align) * align; \
    value; \
})

typedef void *symbol[];

void memset8(uint8_t *src, uint8_t data, size_t count);

void memset16(uint16_t *src, uint16_t data, size_t count);

void memset32(size_t *src, size_t data, size_t count);

void memcpy8(uint8_t *dest, uint8_t *src, size_t count);

void memcpy16(uint16_t *dest, uint16_t *src, size_t count);

void memcpy32(size_t *dest, size_t *src, size_t count);

size_t strlen(const char *str);

int strcmp(const char *str0, const char *str1);

int strncmp(const char *str0, const char *str1, size_t n);

char *strcpy(char *dest, const char *src);

char *strncpy(char *dest, const char *src, size_t n);

int atoi(char *str);

char *itob(size_t num, size_t base);

#endif
