format PE GUI 4.0
entry start
include 'win32ax.inc' 

ID_FIRST = 101
ID_SECOND = 102

section '.text' code readable executable
start:
    invoke GetModuleHandle, 0
    invoke DialogBoxParam, eax, 37, NULL, DialogProc, 0
    or eax, eax
    jz exit
    invoke MessageBox, HWND_DESKTOP, result, message, MB_OK

exit:
    invoke ExitProcess, 0


proc DialogProc hwnddlg, msg, wparam, lparam
    push ebx esi edi
    cmp [msg],WM_INITDIALOG
    je .wminitdialog
    cmp [msg],WM_COMMAND
    je .wmcommand
    cmp [msg],WM_CLOSE
    je .wmclose
    xor eax,eax
    jmp .finish

.wminitdialog:
    jmp .processed

.wmcommand:
    cmp [wparam], BN_CLICKED shl 16 + IDCANCEL
    je .wmclose

    cmp [wparam], BN_CLICKED shl 16 + IDOK
    jne .processed 

    invoke GetDlgItemText,[hwnddlg], ID_FIRST, string, 5
    invoke GetDlgItemText,[hwnddlg], ID_SECOND, char, 2

    mov ecx, 0
    mov ebx, 0

.cycle:
    mov al, [string + ecx]
    cmp al, [char]
    je .found
    inc ecx 
    cmp ecx, 5
    je .res_proc
    jne .cycle

.found:
    inc ebx 
    inc ecx
    cmp ecx, 5
    je .res_proc
    jne .cycle

.res_proc:
    add bl, '0'
    mov [result], bl
    invoke EndDialog, [hwnddlg], 1
    jmp .processed

.wmclose:
    invoke EndDialog, [hwnddlg], 0

.processed:
    mov eax, 1

.finish:
    ret
endp


section '.bss' readable writeable

message db 'Result', 0

string rb 5
char rb 1
result rb 1

section '.idata' import data readable writeable

library kernel, 'KERNEL32.DLL', user, 'USER32.DLL'

import kernel, GetModuleHandle, 'GetModuleHandleA', ExitProcess, 'ExitProcess'
import user, DialogBoxParam, 'DialogBoxParamA',\
GetDlgItemText, 'GetDlgItemTextA', MessageBox, 'MessageBoxA', EndDialog, 'EndDialog'

section '.rsrc' resource data readable

directory RT_DIALOG, dialogs

resource dialogs, 37, LANG_ENGLISH+SUBLANG_DEFAULT, layout

dialog layout, 'LR8', 70, 70, 120, 120, WS_CAPTION+WS_POPUP+WS_SYSMENU+DS_MODALFRAME

dialogitem 'STATIC', 'Enter string:', -1, 10, 10, 80, 8, WS_VISIBLE
dialogitem 'EDIT', '', ID_FIRST, 10, 20, 100, 13, WS_VISIBLE+WS_BORDER+WS_TABSTOP
dialogitem 'STATIC', 'Enter character:', -1, 10, 40, 80, 8, WS_VISIBLE
dialogitem 'EDIT', '', ID_SECOND, 10, 50, 100, 13, WS_VISIBLE+WS_BORDER+WS_TABSTOP+ES_AUTOHSCROLL
dialogitem 'BUTTON', 'OK', IDOK, 10, 75, 45, 15, WS_VISIBLE+WS_TABSTOP+BS_DEFPUSHBUTTON
dialogitem 'BUTTON', 'Cancel', IDCANCEL, 65, 75, 45, 15, WS_VISIBLE+WS_TABSTOP+BS_PUSHBUTTON
enddialog



