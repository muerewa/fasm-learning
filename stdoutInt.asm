format ELF64
public _start

section '.bss' writable
    bss_char rb 1

section '.text' executable
_start:
    mov rax, 122
    call print_num
    call exit

section '.print_num' executable
; | input   
; rax = num
; | output
print_num:
    push rax
    push rbx
    push rcx
    push rdx

    xor rcx, rcx
    .next_iter:
        cmp rax, 0
        je .print_iter
        mov rbx, 10
        xor rdx, rdx
        div rbx
        add rdx, '0'
        push rdx
        inc rcx
        jmp .next_iter
    .print_iter: 
        cmp rcx, 0
        je .close
        pop rax
        call print_chr 
        dec rcx
        jmp .print_iter
    .close:
        pop rdx
        pop rcx
        pop rbx
        pop rax    
        ret

section '.print_chr' executable

; | input
; rax = char
; | output 
; rax = char
print_chr:
    ; x64
    ; push rax
    ; mov rax, 1 ; write
    ; mov rdi, 1 ; stdout
    ; mov rsi, rsp ; rsp - последнее значение в стэке
    ; mov rdx, 1
    ; syscall
    ; pop rax
    
    ; x86
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

section '.exit' executable
exit:
    mov rax, 1
    xor rbx, rbx
    int 0x80