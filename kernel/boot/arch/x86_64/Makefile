CFLAGS 	:= -std=gnu99 -ffreestanding -O2 -I ../../../include
LDFLAGS := -ffreestanding -O2 -nostdlib -lgcc

AS		:= i686-elf-as
GCC		:= i686-elf-gcc

OBJS	:= boot.o \
			loader.o \
			#loader.o \

%.o: %.asm
	$(AS) $< -o $@

%.o: %.s
	$(AS) $< -o $@

%.o: %.c
	$(GCC) $(CFLAGS) -c $< -o $@

link: $(OBJS)
	$(GCC) $(LDFLAGS) -T linker.ld -o loader.bin