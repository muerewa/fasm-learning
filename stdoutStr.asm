format ELF64 executable
entry _start

	msg  db 'hello world!',0xA,0
_start:

	mov eax, msg
	call pring_str
	call exit

; | input: 
; rax = string
pring_str: 
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

; | input: 
; rax = string
; | output: 
; rax = length
len_str:
	push rdx ; Добавление в стек
	xor rdx,rdx ; Обнуление
	.next_iter:
		cmp[rax+rdx], byte 0
		je .close
		inc rdx
		jmp .next_iter
	.close:
		mov rax, rdx
		pop rdx ; Извлечение из стека
		ret

exit: 
	mov eax,1
	xor ebx, ebx
	int 0x80