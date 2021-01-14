#include <drivers/disk.h>
#include <unreal_int.h>

static dap_t dap;

int disk_read(int drive, uint64_t loc, uint64_t cnt) {
    regs_t rm = { .eax = 0x42, .edx = drive, .esi = &dap };
    unreal_int(0x13, &rm, &rm);
}
