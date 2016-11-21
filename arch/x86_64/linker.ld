OUTPUT_FORMAT(elf64-x86-64)
ENTRY(start)

INPUT(boot.o)

SECTIONS {
    . = 1M;

    .boot :
    {
        /* ensure that the multiboot header is at the beginning */
        KEEP(*(.multiboot_header))
    }

    .text :
    {
        *(.text)
    }
}