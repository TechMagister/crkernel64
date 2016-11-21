;;------------------------------------------------------------------------------------------------
;;`arch/x64/lm_start.asm`
;;
;;First 64 bit file to be called, calls kmain().
;;------------------------------------------------------------------------------------------------

global lm_start
extern main

section .text
bits 64

lm_start:
	call main
	hlt