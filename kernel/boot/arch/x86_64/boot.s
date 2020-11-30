/* 
 * please do not ask me why this is the only assembly
 * code written in the AT&T syntax. i'll rewrite this
 * in the intel syntax when i have the time.
 */

/* constants for the multiboot header */
.set ALIGN,		1<<0			 /* align loaded modules on page boundaries */
.set MEMINFO,	1<<1			 /* memory map */
.set FLAGS,		ALIGN | MEMINFO	 /* multiboot flag */
.set MAGIC,		0x1BADB002		 /* magic number */
.set CHECKSUM,	-(MAGIC + FLAGS) /* checksum */

/* the bootloader will search for magic number in the first 8 KiB of the kernel
 * aligned at a 32-bit boundary */
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long checksum

/* multiboot standard doesn't define the value of the esp so it is up to me to
 * provide a stack. sure leave the dirty job for me. this code allocated room for
 * a small stack by creating a symbol at the bottom of it, then it allocates
 * 16384 bytes for it and (finally) creates a symbol at the top.
 */
.section .bss
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

/* it doesn't make any sense to return from this function as the bootloader is gone */
.section .text
.global _start
.type _start, @function
_start:
	cli

	/* set up a valid stack */
	mov $stack_top, %esp
	mov $stack_top, %ebp

	push %ebx

	/* start loader */
	call lmain

	/* when the system is bored and has nothing to do, go into an infinite loop */
	/* disable interrupts, wait for the next interrupt to arrive and jump
	 * to the hlt instruction. if it ever wakes up, of course */
	cli
1:	hlt
	jmp 1b

/* this little hack makes debugging and implementing call tracing easier */
.size _start, . - _start
