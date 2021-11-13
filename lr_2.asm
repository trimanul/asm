section .bss
    array resb 5

section .data
    msg db "Enter array: "
    msg_len equ $-msg
    res db ?, 0x0A

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msg_len
    int 0x80

    mov eax, 3
    mov ebx, 2
    mov ecx, array
    mov edx, 5
    int 0x80

    
    mov ecx, 0                   ;initialize counter
    mov bl, 0                   ;%bl stores sum of indices
    
cycle:
    mov al, array[ecx]           ;%al stores cuurent array element
    test al, 1
    jnz odd
    
    inc cl
    cmp cl, 5
    jl cycle
    je end

odd:

    add bl, cl
    inc cl
    cmp cl, 5
    jl cycle
    je end
    
end:

    add bl, 48
    mov res[0], bl
    mov bl, 0
    
    mov eax, 4
    mov ebx, 1
    mov ecx, res
    mov edx, 2
    int 0x80     

    mov eax, 1
    int 0x80
