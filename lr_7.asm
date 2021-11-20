%macro set_check 4      ;params: set1(%1), set1_len(%2), set2(%3), set2_len(%4)
                        ;check if set1 contains set2
    mov ecx, 0          ;position in set1
    mov edx, 0          ;position in set2
    mov al, %1[ecx]          
    mov bl, %3[edx]
    
%%cycle:
    cmp bl, al
    je %%equal   
    inc ecx
    cmp ecx, %2
    je %%is_false
    mov al, %1[ecx]
    jmp %%cycle

%%equal:
    inc edx
    cmp edx, %4
    je %%is_true
    mov bl, %3[edx]
    mov ecx, 0
    jmp %%cycle


%%is_false:
    mov eax, 4
    mov ebx, 1
    mov ecx, false
    mov edx, 6
    int 0x80
    jmp %%end

%%is_true:
    mov eax, 4
    mov ebx, 1
    mov ecx, true
    mov edx, 5
    int 0x80
    jmp %%end

%%end:
%endmacro
    




section .data
    set1 db 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
    set2 db 1, 3, 8, 9, 11
    set3 db 0, 1, 2, 3, 4
    true db 'True', 0x0A
    false db 'False', 0x0A


section .text
    global _start

_start:
    set_check set1, 12, set2, 5
    set_check set1, 12, set3, 5 

    mov eax, 1
    int 0x80




