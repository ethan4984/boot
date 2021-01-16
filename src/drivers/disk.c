#include <drivers/disk.h>
#include <output.h>
#include <unreal_int.h>
#include <stddef.h>

static dap_t dap = { .size = 0x10, .sector_cnt = 1 };

int read_block(int drive, void *buffer, uint32_t sector) {
    regs_t rm = { .eax = 0x4200, .ds = rm_seg(&dap), .esi = rm_off(&dap), .edx = drive };

    dap.segment = rm_seg(buffer);
    dap.offset = rm_off(buffer);
    dap.lba_low = sector;

    /*kprintf("[KDEBUG]", "%x %x %x", (size_t)&dap, rm.ds, rm.esi);
    kprintf("[KDEBUG]", "%x %x %x", (size_t)buffer, dap.segment, dap.offset);*/

    unreal_int(0x13, &rm , &rm);

    if(rm.eflags & (1 << 0)) {
        kprintf("[KDEBUG]", "Error: disk %x | sector %x | error %x", drive, sector, (uint8_t)(rm.eax >> 8));
        return -1;
    }
    return 0;
}

/*int disk_read(int drive, void *buffer, uint64_t start, uint64_t cnt) {

} */
