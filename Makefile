
ASM_SRC := $(shell pwd)/asm/x64
BUILD_DIR := $(shell pwd)/.build

LINK_FILE := $(shell pwd)/scripts/linker.ld
LINK_FLAGS := -nostdlib -m64 -Wl,-T,$(LINK_FILE),--build-id=none,-L,$(BUILD_DIR),--nmagic,--gc-section

GRUB_CFG := $(shell pwd)/iso/boot/grub/grub.cfg
GRUB_MKRESCUE := grub2-mkrescue

QEMU := qemu-system-x86_64
QEMU_FLAGS := -no-reboot -no-shutdown -m 4096

default: run

boot.o: $(ASM_SRC)/boot.asm $(ASM_SRC)/multiboot_header.asm
	@mkdir -p $(BUILD_DIR)
	nasm -I $(ASM_SRC)/ -f elf64 $< -o $(BUILD_DIR)/$@

kernel.elf: boot.o $(LINK_FILE)
	ld -n -o $(BUILD_DIR)/$@ -T $(LINK_FILE) $(BUILD_DIR)/$<
#	crystal build src/main.cr --target=x86_64 --prelude=empty --link-flags "$(LINK_FLAGS)" -o $(BUILD_DIR)/$@

os.iso: kernel.elf $(GRUB_CFG)
	mkdir -p $(BUILD_DIR)/isofiles/boot
	cp -R iso/* $(BUILD_DIR)/isofiles/
	cp $(BUILD_DIR)/$< $(BUILD_DIR)/isofiles/boot/
	$(GRUB_MKRESCUE) -o $(BUILD_DIR)/$@ $(BUILD_DIR)/isofiles

run: os.iso
	$(QEMU) $(QEMU_FLAGS) -cdrom $(BUILD_DIR)/$<

clean:
	@rm -fr $(BUILD_DIR)