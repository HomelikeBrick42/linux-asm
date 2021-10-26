; Build Command:
; nasm -felf64 -o hello.o hello.asm && ld hello.o -o hello && rm hello.o && ./hello

global _start

%include "./defines.asm"

section .text

_start:
	; Write the "Enter your name: " message
	mov rax, SYS_write
	mov rdi, stdout
	mov rsi, enter_name_message
	mov rdx, enter_name_message_length
	syscall

	; Read the name that was entered into the `name_buffer`
	mov rax, SYS_read
	mov rdi, stdin
	mov rsi, name_buffer
	mov rdx, name_buffer_capacity
	syscall

	; Save the length of the name entered
	mov qword [name_length], rax

	; Write the "Hello, " message
	mov rax, SYS_write
	mov rdi, stdout
	mov rsi, hello_message
	mov rdx, hello_message_length
	syscall

	; Write the `name_buffer` using the length saved before
	mov rax, SYS_write
	mov rdi, stdout
	mov rsi, name_buffer
	mov rdx, qword [name_length]
	syscall

	; Exit with code 0
	mov rax, SYS_exit
	mov rdi, 0
	syscall

section .rodata

enter_name_message:       db "Enter your name: "
enter_name_message_length equ $-enter_name_message

hello_message:       db "Hello, "
hello_message_length equ $-hello_message

section .bss

name_buffer_capacity equ 1024
name_buffer:         resb name_buffer_capacity

name_length: resq 1
