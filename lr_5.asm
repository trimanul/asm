section .bss
    init_str resb 10
    sub_str resb 4
    result resb 11
    
    
section .text
    prompt1 db "Enter initial string (10 characters):", 0x0A
    p1_len equ $-prompt1
    prompt2 db "Enter substring (4 characters):", 0x0A
    p2_len equ $-prompt2

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, p1_len
    int 0x80

    mov eax, 3
    mov ebx, 2
    mov ecx, init_str
    mov edx, 11
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, p2_len
    int 0x80

    mov eax, 3
    mov ebx, 2
    mov ecx, sub_str
    mov edx, 5
    int 0x80


    mov ecx, 0                   ;position in init_str --> %ecx
    mov edx, 0                   ;position in sub_str --> %edx
    
   
cycle:
    mov al, init_str[ecx]        ;current init_str element --> %al
    mov bl, sub_str[edx]         ;current sub_str element --> %bl
    cmp al, bl
    je elem_found
    inc ecx
    cmp ecx, 10
    je not_found
    jne cycle

not_found:
    mov ecx, 0
    mov edx, 0
    mov ebx, 10
    jmp copy_result

elem_found:
    inc edx
    cmp edx, 4
    je substr_found
    mov al, init_str[ecx + edx]
    cmp al, sub_str[edx]
    je elem_found
    jne cycle

substr_found:
    mov edx, 0
    jmp rm_substr

rm_substr:
    mov init_str[ecx + edx], BYTE 0
    inc edx
    cmp edx, 4
    jne rm_substr

    mov ecx, 0
    mov ebx, 10
    mov edx, 0
    jmp copy_result


copy_result:

    mov al, init_str[ecx]
    cmp al, 0
    je skip
    mov result[ecx + edx], al
    inc ecx
    cmp ecx, ebx
    jl copy_result
    jge end

skip:
    inc ecx
    dec edx
    cmp ecx, ebx
    jge end
    jmp copy_result

end:
    add ecx, edx
    inc ecx
    mov result[ecx], BYTE 0x0A
    mov edx, ecx

    mov eax, 4
    mov ebx, 1
    mov ecx, result
    int 0x80
    
    mov eax, 1
    int 0x80
    
    
    
    


