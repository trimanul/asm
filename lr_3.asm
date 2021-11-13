section .bss
    op1 resb 2
    op2 resb 2


section .data
    prompt1 db "Enter 1st operand: "
    prompt2 db "Enter 2nd operand: "
    len equ 19
    


    result db ?, 0x0A 



section .text

    global _start

_start:
    
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, len
    int 0x80

    mov eax, 3
    mov ebx, 2
    mov ecx, op1
    mov edx, 3
    int 0x80

    mov eax, 0          ;clear eax
    mov al, op1[0]      ;1st digit --> %al
    sub al, 48
    mov dl, 10          ;multiplier (10) --> %dl
    mul dl

    mov bl, op1[1]      ;2nd digit --> %bl
    sub bl, 48
    add al, bl

    mov op1[1], BYTE 0
    mov op1[0], al
    ;first operand processed from str to int
    
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, len
    int 0x80

    mov eax, 3
    mov ebx, 2
    mov ecx, op2
    mov edx, 3
    int 0x80

    mov eax, 0          ;clear eax
    mov al, op2[0]      ;1st digit --> %al
    sub al, 48
    mov dl, 10
    mul dl

    mov bl, op2[1]      ;2nd digit --> %bl
    sub bl, 48
    add al, bl
 
    mov op2[1], BYTE 0
    mov op2[0], al   
    


    mov al, op1[0]      ;dividend --> %al
    mov dl, op2 [0]     ;divisor --> %dl
    
    div dl
    
    add al, 48

    mov result[0], al
    
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, 2
    int 0x80

    mov eax, 1
    int 0x80





