format ELF64
public _start

section '.data' writeable
    _buffer.size equ 20

section '.bss' writeable
    _buffer rb _buffer.size
    bss_char rb 1

section '.text' executable
_start:
    mov rax, 222
    mov rbx, _buffer
    mov rcx, _buffer.size
    call num_to_str

    mov rax, _buffer
    call print_string
    call print_line
    call exit

section '.num_to_str' executable
; input
; rax = number
; rbx = buffer
; rcx = buffer size
num_to_str: 
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    mov rsi, rcx
    xor rcx, rcx
    
    .next_iter:
        push rbx
        mov rbx, 10
        xor rdx, rdx
        div rbx
        pop rbx
        add rdx, '0'
        push rdx
        inc rcx
        cmp rax, 0
        je .next_step
        jmp .next_iter

    .next_step:
        mov rdx, rcx
        xor rcx, rcx

    .to_str:
        cmp rcx, rsi
        je .pop_iter
        cmp rcx, rdx
        je .close
        pop rax
       mov [rbx+rcx], rax
        inc rcx
        jmp .to_str

    .pop_iter:
        cmp rcx, rdx
        je .close
        pop rax
        inc rcx
        jmp .pop_iter
       .close:
        pop rsi
        pop rdx
        pop rcx
        pop rbx
        pop rax
        ret

section '.print_string' executable
; | input: 
; rax = string
print_string: 
	push rax
	push rbx
	push rcx
	push rdx
	mov rcx,rax
	call len_str
	mov rdx, rax
	mov rax, 4
	mov rbx, 1
	int 0x80
	pop rdx
	pop rcx
	pop rbx
	pop rax
	ret

section '.len_str' executable
; | input: 
; rax = string
; | output: 
; rax = length
len_str:
	push rdx
	xor rdx,rdx
	.next_iter:
		cmp[rax+rdx], byte 0
		je .close
		inc rdx
		jmp .next_iter
	.close:
		mov rax, rdx
		pop rdx
		ret

section '.print_char' executable
;  input:
; rax  = char
print_char:

    push rax
    push rbx
    push rcx
    push rdx

    mov [bss_char], al
    mov rax, 4
    mov rbx, 1
    mov rcx, bss_char
    mov rdx, 1
    int 0x80

    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

section '.print_line' executable
print_line: 
    push rax
    mov rax, 0xA
    call print_char 
    pop rax
    ret

section '.exit' executable
exit: 
    mov rax, 1
    xor rbx, rcx
    int 0x80
