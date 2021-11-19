section .bss
    result resb 4
    matrix resb 9

section .data
    three db 1
    pos db 0
    prompt db "Enter matrix element (3x3):", 0x0A
    p_len equ $-prompt
    
section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, p_len
    int 0x80

    mov eax, 3
    mov ebx, 2
    mov ecx, matrix
    mov edx, 9
    int 0x80    

    call main_diag

    mov result[3], BYTE 0x0A

    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 4
    int 0x80

    mov eax, 1
    int 0x80



main_diag:
    
    mov [three], BYTE 3
    mov ecx, 0          ;i
    mov edx, 0          ;j

col_cycle:
    mov al, cl
    mul BYTE [three]
    add al, dl
    mov bl, matrix[eax]
    cmp edx, ecx
    jg copy
    jle continue

copy:
    mov al, [pos]
    mov result[eax],bl
    inc al
    mov [pos], al
    jmp continue    
    
continue:    
    inc edx
    cmp edx, 3
    je row_cycle
    jne col_cycle
    
row_cycle:
    mov edx, 0
    inc ecx
    cmp ecx, 3
    je return
    jne col_cycle

return:
    ret
