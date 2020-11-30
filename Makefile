X86-GCC			:= i386-elf-gcc
X86-LD			:= i386-elf-gcc

X86_64-GCC		:= x86_64-elf-gcc
X86_64-LD		:= x86_64-elf-gcc

TARGET			:= X86_64
HEADERS			:= sysroot/usr/include

X86-CFLAGS		:= 
X86_64-CFLAGS	:= -m64 -ffreestanding -z max-page-size=0x1000 -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -std=gnu99 -O2 -Wall -Wextra -I $(HEADERS)

X86-LDFLAGS		:= 
X86_64-LDFLAGS	:= -ffreestanding -nostdlib -lgcc -O2

SUBDIRS := kernel/boot/arch/x86_64/ \
			#kernel/boot/arch/i386 \

$(SUBDIRS):
	$(MAKE) -C $@

loader: $(SUBDIRS)

.PHONY: all