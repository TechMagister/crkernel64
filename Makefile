arch ?= x86_64

build_dir := $(shell pwd)/build
asm_build_dir := $(build_dir)/asm/$(arch)
asm_src_dir := $(shell pwd)/src/asm/$(arch)
config_dir := $(shell pwd)/arch/$(arch)

kernel := $(build_dir)/kernel-$(arch).bin
iso := $(build_dir)/os-$(arch).iso
main := $(shell pwd)/src/main.cr
boot := 

linker_script := $(config_dir)/linker.ld
grub_cfg := $(config_dir)/grub.cfg

qemu_flags := -no-reboot -no-shutdown -m 4096
link_flags := -L "$(build_dir)/asm/$(arch)/" -T "$(linker_script)" -nodefaultlibs -nostdlib -Wl,-n,--gc-sections,--build-id=none
crystal_flags := --verbose --target=x86_64-linux-gnu --prelude=empty --link-flags "$(link_flags)"

.PHONY: all clean run iso

all: $(kernel)

clean:
	@rm -r $(build_dir)

run: $(iso)
	@qemu-system-x86_64 $(qemu_flags) -cdrom $(iso)

iso: $(iso)

kernel: $(kernel)

$(iso): $(kernel) $(grub_cfg)
	@mkdir -p $(build_dir)/isofiles/boot/grub
	@cp $(kernel) $(build_dir)/isofiles/boot/kernel.bin
	@cp $(grub_cfg) $(build_dir)/isofiles/boot/grub
	@grub2-mkrescue -o $(iso) $(build_dir)/isofiles 2> /dev/null
	@rm -r $(build_dir)/isofiles

$(kernel): boot.o $(linker_script)
	crystal build $(main) $(crystal_flags) -o $@

boot.o: $(asm_src_dir)/boot.asm $(asm_src_dir)/multiboot_header.asm $(asm_src_dir)/long_mode_start.asm
	@mkdir -p $(asm_build_dir)
	@nasm -felf64 -i $(asm_src_dir)/ $< -o $(asm_build_dir)/$@
