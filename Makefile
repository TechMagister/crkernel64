
ASM_SRC := $(shell pwd)/asm/x64
BUILD_DIR := $(shell pwd)/.build

LINK_FILE := $(shell pwd)/scripts/linker.ld
LINK_FLAGS := -T $(LINK_FILE) -L $(BUILD_DIR)

GRUB_CFG := $(shell pwd)/scripts/grub.cfg

boot.o: $(ASM_SRC)/boot.asm
	@mkdir -p $(BUILD_DIR)
	nasm -f $(NASM_TARGET) $(ASM_SRC)/boot.asm -o $(BUILD_DIR)/boot.o

boot.a: boot.o
    ar --target=$(AR_TARGET) -r -c -s $(BUILD_DIR)/$@ $(BUILD_DIR)/boot.o

kernel.elf: boot.a $(LINK_FILE)
	crystal build src/main.cr --target=x86_64 --prelude=empty --link-flags "$(LINK_FLAGS)" -o $(BUILD_DIR)/$@

os.iso: kernel.elf $(GRUB_CFG)
    mkdir -p $(BUILD_DIR)/isofiles/boot
	cp -R iso/* $(BUILD_DIR)/isofiles/
	cp $(BUILD_DIR)/kernel.elf $(BUILD_DIR)/isofiles/boot/
	$(GRUB_MKRESCUE) -o $(BUILD_DIR)/os.iso $(BUILD_DIR)/isofiles