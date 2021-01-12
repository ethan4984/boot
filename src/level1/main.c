__attribute__((section(".init")))
void main() {
    for(;;)
        asm volatile ("cli\nhlt");
}
