TARGET		:= X86_64
HEADERS		:= sysroot/usr/include

X64OBJS :=	kernel/kernel.o

ifeq ($TARGET, "X86_64")
 GCC := x86_64-elf-gcc
 LD  := x86_64-elf-gcc
 CFLAGS := -m64 -ffreestanding -z max-page-size=0x1000 -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -std=gnu99 -O2 -Wall -Wextra -I $(HEADERS)
 LDFLAGS := -ffreestanding -nostdlib -lgcc -O2
 LDFILE := x86_64-linker.ld
 ARCH_OBJS := kernel/boot/arch/x86_64/boot.o \
 		kernel/boot/arch/x86_64/loader.o
else # FIXME: this is utterly retarded
 GCC := i686-elf-gcc
 LD  := i686-elf-gcc
 CFLAGS := -ffreestanding -std=gnu99 -O2 -g -Wall -Wextra -I $(HEADERS)
 LDFLAGS := 
 LDFILE := i386-linker.ld
 ARCH_OBJS := kernel/boot/arch/i386/boot.o \
 		kernel/boot/arch/i386/loader.o
endif

%.o: %.asm
	$(AS) -c $< -o $@

%.o: %.c
	$(GCC) $(CFLAGS) -c $< -o $@

kernel: $(OBJS) $(ARCH_OBJS)
	$(LD) $(LDFLAGS) -T $(LDFILE) -o kernel.bin

.PHONY: $(OBJS) $(ARCH_OBJS) kernel
