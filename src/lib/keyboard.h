#ifndef KEYBOARD_H_
#define KEYBOARD_H_

#include <stdint.h>

#define CURSOR_RIGHT 0x500
#define CURSOR_LEFT 0x1000
#define CURSOR_UP 0x1500
#define CURSOR_DOWN 0x2000

int read_char(void);

#endif
