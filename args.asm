; Build Command:
; nasm -felf64 -o args.o args.asm && ld args.o -o args && rm args.o && ./args foo bar baz

global _start

%include "./defines.asm"

section .text

_start:
	pop qword [arg_count]

	mov rbx, 0
.start_loop:
	cmp rbx, qword [arg_count]
	jge .end_loop

	pop rsi
	call strlen

	mov rax, SYS_write
	mov rdi, stdout
	syscall

	mov rax, SYS_write
	mov rdi, stdout
	lea rsi, [rsp - 1]
	mov byte [rsi], 10
	mov rdx, 1
	syscall

	inc rbx
	jmp .start_loop
.end_loop:

	; Exit with code 0
	mov rax, SYS_exit
	mov rdi, 0
	syscall

strlen:
	mov rdx, 0

.start_loop:
	cmp byte [rsi + rdx], 0
	je .end_loop

	inc rdx
	jmp .start_loop
.end_loop:

	ret

section .bss

arg_count: resq 1
