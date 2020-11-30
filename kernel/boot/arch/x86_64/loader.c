#include <multiboot.h>
#include <stddef.h>
//#include <elf64.h>

//extern void setup_longmode();
//extern void load_kernel(void* entry, uint32_t multiboot_info);

/*
char* kernel_elf_space[sizeof(elf_file_data_t)];
elf_file_data_t* kernel_elf = (elf_file_data_t*) kernel_elf_space;

void* load_elf_module(multiboot_uint32_t mod_start, multiboot_uint32_t mod_end)
{
	unsigned long err = parse_elf_executable((void*)mod_start, sizeof(elf_file_data_t), kernel_elf);
	if (err == 0) {
		for (int i = 0; i < kernel_elf->numSegments; i++) {
			elf_file_segment_t seg = kernel_elf->segments[i];

			const void* src = (const void*) (mod_start + seg.foffset);
			memcpy((void*)seg.address, src, seg.flength);
		}
		return (void*) kernel_elf->entryAddr;
	}
	return NULL;
}
*/

void lmain(const void* multiboot_struct)
{
	/* set up gdt */
	const multiboot_info_t* mb_info = multiboot_struct;
	multiboot_uint32_t mb_flags = mb_info->flags;

	void *kentry = NULL;

	/* check modules */
	if (mb_flags & MULTIBOOT_INFO_MODS) {
		multiboot_uint32_t mods_count = mb_info->mods_count;
		multiboot_uint32_t mods_addr = mb_info->mods_addr;

		for (uint32_t mod = 0; mod < mods_count; mod++) {
			multiboot_module_t* module = (multiboot_module_t*)(mods_addr + (mod * sizeof(multiboot_module_t)));
		}
		const char* module_string = (const char*)module->cmdline;
	
		if(strcmp(module_string, kernel_bin_string)){
			kentry = load_elf_module(module->mod_start, module->mod_end);
		}
	}

	

	//setup_longmode();
	//load_kernel(kentry, (uint32_t)mb_info);
}