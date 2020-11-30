global setup_longmode
global load_kernel

setup_longmode:
	mov ecx, 0xC0000080
	rdmsr
	or eax, 1 << 8
	wrmsr
	mov eax, cr0
	or eax, 1 << 31 | 1 << 0
	mov cr0, eax

load_kernel:
	/* enable a20 line */
	in al, 0x92
	or al, 2
	out 0x92, al

	push ebp
	mov ebp, esp

	mov esi, [ebp+8]
	mov [k_ptr], esi

	lgdt [GDT.pointer]

	mov ax, GDT.data
	mov ss, ax
	mov ds, ax
	mov es, ax
	jmp GDT.code:.jmp_k
.jmp_k:
	mov edi, [ebp + 12]
	mov eax, [k_ptr]
	dd 0
	jmp eax
section .data
k_ptr:
	dd 0
	