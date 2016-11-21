;;------------------------------------------------------------------------------------------------
;;`src/asm/x64/mb_header.asm`
;;
;;Declares multiboot header and tags
;;------------------------------------------------------------------------------------------------

; How many bytes from the start of the file we search for the header.
%define MULTIBOOT_SEARCH			32768
%define MULTIBOOT_HEADER_ALIGN			8

; The magic field should contain this.
%define MULTIBOOT2_HEADER_MAGIC			0xe85250d6

; This should be in %eax.
%define MULTIBOOT2_BOOTLOADER_MAGIC		0x36d76289

; Alignment of multiboot modules.
%define MULTIBOOT_MOD_ALIGN			0x00001000

; Alignment of the multiboot info structure.
%define MULTIBOOT_INFO_ALIGN			0x00000008

; Flags set in the 'flags' member of the multiboot header.

%define MULTIBOOT_TAG_ALIGN                  8
%define MULTIBOOT_TAG_TYPE_END               0
%define MULTIBOOT_TAG_TYPE_CMDLINE           1
%define MULTIBOOT_TAG_TYPE_BOOT_LOADER_NAME  2
%define MULTIBOOT_TAG_TYPE_MODULE            3
%define MULTIBOOT_TAG_TYPE_BASIC_MEMINFO     4
%define MULTIBOOT_TAG_TYPE_BOOTDEV           5
%define MULTIBOOT_TAG_TYPE_MMAP              6
%define MULTIBOOT_TAG_TYPE_VBE               7
%define MULTIBOOT_TAG_TYPE_FRAMEBUFFER       8
%define MULTIBOOT_TAG_TYPE_ELF_SECTIONS      9
%define MULTIBOOT_TAG_TYPE_APM               10
%define MULTIBOOT_TAG_TYPE_EFI32             11
%define MULTIBOOT_TAG_TYPE_EFI64             12
%define MULTIBOOT_TAG_TYPE_SMBIOS            13
%define MULTIBOOT_TAG_TYPE_ACPI_OLD          14
%define MULTIBOOT_TAG_TYPE_ACPI_NEW          15
%define MULTIBOOT_TAG_TYPE_NETWORK           16
%define MULTIBOOT_TAG_TYPE_EFI_MMAP          17
%define MULTIBOOT_TAG_TYPE_EFI_BS            18

%define MULTIBOOT_HEADER_TAG_END  0
%define MULTIBOOT_HEADER_TAG_INFORMATION_REQUEST  1
%define MULTIBOOT_HEADER_TAG_ADDRESS  2
%define MULTIBOOT_HEADER_TAG_ENTRY_ADDRESS  3
%define MULTIBOOT_HEADER_TAG_CONSOLE_FLAGS  4
%define MULTIBOOT_HEADER_TAG_FRAMEBUFFER  5
%define MULTIBOOT_HEADER_TAG_MODULE_ALIGN  6
%define MULTIBOOT_HEADER_TAG_EFI_BS        7

%define MULTIBOOT_ARCHITECTURE_I386  0
%define MULTIBOOT_ARCHITECTURE_MIPS32  4
%define MULTIBOOT_HEADER_TAG_OPTIONAL 1

%define MULTIBOOT_CONSOLE_FLAGS_CONSOLE_REQUIRED 1
%define MULTIBOOT_CONSOLE_FLAGS_EGA_TEXT_SUPPORTED 2

%define KERNEL_START 0x100000000

section .multiboot_header
header_start:
	; Magic
    dd MULTIBOOT2_HEADER_MAGIC
    ; ISA: i386
	dd MULTIBOOT_ARCHITECTURE_I386
	; Header length.
    dd header_end - header_start
    ; checksum
    dd  KERNEL_START - (MULTIBOOT2_HEADER_MAGIC + MULTIBOOT_ARCHITECTURE_I386 + (header_end - header_start))

;framebuffer_tag_start:	
;	dw MULTIBOOT_HEADER_TAG_FRAMEBUFFER
;	dw MULTIBOOT_HEADER_TAG_OPTIONAL
;	dd framebuffer_tag_end - framebuffer_tag_start
;	dd 1024
;	dd 768
;	dd 32
;framebuffer_tag_end:
	dw MULTIBOOT_HEADER_TAG_END
	dw 0
	dd 8
header_end: