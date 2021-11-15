section .bss
    expr resb 8

section .data
    prompt db "Enter expression: "
    prompt_len equ $-prompt
    tmp db 1
    result db 0, 0, 0 ,0 


section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80
    
    mov eax, 3
    mov ebx, 2
    mov ecx, expr
    mov edx, 8
    int 0x80

    mov eax, 0
    mov ecx, 0    

    mov al, expr[ecx]
    sub al, 48
    mov dl, 10
    mul dl

    inc cl
    mov bl, expr[ecx]
    sub bl, 48
    add al, bl

    mov [tmp], al
    
cycle_check:
    inc cl

    mov dl, expr[ecx]
    cmp dl, 45                  ; ASCII code for '-'
    je minus

    cmp dl, 43                  ; ASCII code for '+'
    je plus

    
    mov dl, 100
    mov ecx, 0     
    mov al, [tmp]               
    jmp result_proc 

plus:
    inc cl 
    mov al, expr[ecx]
    sub al, 48
    mov dl, 10
    mul dl

    inc cl
    mov bl, expr[ecx]
    sub bl, 48
    add al, bl

    add [tmp], al
    jmp cycle_check

minus:
    inc cl
    mov al, expr[ecx]
    sub al, 48
    mov dl, 10
    mul dl

    inc cl
    mov bl, expr[ecx]
    sub bl, 48
    add al, bl
    
    sub [tmp], al
    jmp cycle_check


result_proc:
   
    idiv dl
    
    cmp al, 0
    je digit_nxt

    mov result[ecx], al
    add result[ecx], BYTE 48
    mov al, ah
    mov ah, 0
    inc ecx
    mov dl, 10
    jmp result_proc

digit_nxt:
    cmp ecx, 1
    je digit2_zero
    cmp ah, 10
    jl end
    mov dl, 10
    mov al, ah
    mov ah, 0
    inc ecx
    jmp result_proc    

digit2_zero:
    add result[ecx], BYTE 48
    inc ecx
    jmp end

end:
    mov result[ecx], ah
    add result[ecx], BYTE 48         ;????
    inc ecx
    mov result[ecx], BYTE 0x0A
    inc ecx
    
    mov edx, ecx
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    int 0x80

    mov eax, 1
    int 0x80  





    

    
