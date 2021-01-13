#include <memutils.h>

void memset8(uint8_t *src, uint8_t data, size_t count) {
    for(uint64_t i = 0; i < count; i++)
        *src++ = data;
}

void memset16(uint16_t *src, uint16_t data, size_t count) {
    for(uint64_t i = 0; i < count; i++)
        *src++ = data;
}

void memset32(uint32_t *src, uint32_t data, size_t count) {
    for (uint64_t i = 0; i < count; i++)
        *src++ = data;
}

void memcpy8(uint8_t *dest, uint8_t *src, size_t count) {
    for(uint64_t i = 0; i < count; i++) {
        dest[i] = src[i];
    }
}

void memcpy16(uint16_t *dest, uint16_t *src, size_t count) {
    for(uint64_t i = 0; i < count; i++) {
        dest[i] = src[i];
    }
}

void memcpy32(uint32_t *dest, uint32_t *src, size_t count) {
    for(uint64_t i = 0; i < count; i++) {
        dest[i] = src[i];
    }
}

char *itob(size_t num, size_t base) {
    static char hold[] = "0123456789ABCDEF";
    static char buffer[50];
    char *str;

    str = &buffer[49];
    *str = '\0';

    do {
        *--str = hold[num%base];
        num /= base;
    } while(num != 0);

    return str;
}

size_t strlen(const char *str) {
    size_t len = 0;
    while(str[len])
        len++;
    return len;
}

int strcmp(const char *str0, const char *str1) {
    while(*str0 && *str0 == *str1) {
        str0++;
        str1++;
    }
    return (int)(*str0) - (int)(*str1);
}

int strncmp(const char *str0, const char *str1, size_t n) {
    for(uint64_t i = 0; i < n; i++) {
        if(str0[i] != str1[i]) 
            return 1;
    }
    return 0;
}

char *strcpy(char *dest, const char *src) {
    uint64_t i;

    for(i = 0; src[i]; i++)
        dest[i] = src[i];

    dest[i] = 0;

    return dest;
}

char *strncpy(char *dest, const char *src, size_t n) {
    uint64_t i;

    for(i = 0; i < n && src[i]; i++)
        dest[i] = src[i];
    for(; i < n; i++)
        dest[i] = 0;

    return dest;
}

int atoi(char *str) {
    int ret = 0;
    for (uint64_t i = 0; i < strlen(str); i++)
        ret = ret * 10 + str[i] - '0';
    return ret;
}
