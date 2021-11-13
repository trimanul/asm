section .data
    array: db 3, 2, 9, 6, 0, 8
    arr_len equ 6
    msg: db ?, 0x0A


section .text

global _start

_start:

    mov cl, 1                       ;initialize counter
    mov bl, array[0]                ;%bl stores smallest array elem
    mov dl, 0                       ;%dl stores smallest array elem's index




cycle:
  
    mov al, array[ecx]          ;current array elem --> %al 
    cmp al, bl
    jl switch
    

    inc cl
    cmp cl, arr_len
    jl cycle
    je end
    
switch:
    mov bl, al
    mov dl, cl
    inc cl
    cmp cl, arr_len
    jl cycle
    je end



end:
    add dl, 48
    mov msg[0], dl

    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, 2
    int 0x80

    mov eax, 1
    int 0x80
