; Build Command:
; nasm -felf64 -o print_file.o print_file.asm && ld print_file.o -o print_file && rm print_file.o && ./print_file

global _start

%include "./defines.asm"

section .text

_start:
	pop r8
	cmp r8, 2
	jne usage
	pop r8
	pop r8

	mov rax, SYS_open
	mov rdi, r8
	mov rsi, O_RDONLY
	mov rdx, 0
	syscall

	cmp rax, 0
	jl failed_to_open_file

	mov qword [file_handle], rax

.loop_start:
	mov rax, SYS_read
	mov rdi, qword [file_handle]
	mov rsi, file_buffer
	mov rdx, file_buffer_capacity
	syscall

	mov qword [bytes_read], rax

	mov rax, SYS_write
	mov rdi, stdout
	mov rsi, file_buffer
	mov rdx, qword [bytes_read]
	syscall

	cmp qword [bytes_read], 0
	jg .loop_start

	mov rax, SYS_exit
	mov rdi, 0
	syscall

usage:
	mov rax, SYS_write
	mov rdi, stdout
	mov rsi, usage_message
	mov rdx, usage_message_length
	syscall

	mov rax, SYS_exit
	mov rdi, 1
	syscall

failed_to_open_file:
	mov rax, SYS_write
	mov rdi, stdout
	mov rsi, failed_to_open_file_message
	mov rdx, failed_to_open_file_message_length
	syscall

	mov rax, SYS_exit
	mov rdi, 1
	syscall

section .rodata

usage_message: db "Usage: ./print_file <file>", 10
usage_message_length equ $-usage_message

failed_to_open_file_message: db "Failed to open file", 10
failed_to_open_file_message_length equ $-failed_to_open_file_message

section .bss

file_handle: resq 1
bytes_read: resq 1

file_buffer_capacity equ 1024
file_buffer: resb file_buffer_capacity
