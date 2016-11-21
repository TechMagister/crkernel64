;;------------------------------------------------------------------------------------------------
;;`src/asm/x64/boot.asm`
;;
;;Kernel entry file, performs basic system checks and enables paging and long mode.
;;------------------------------------------------------------------------------------------------

global _start

section .boot
%include "multiboot_header.asm"

section .text
bits 32
_start:
    ; print `OK` to screen
    mov dword [0xb8000], 0x2f4b2f4f
    hlt
