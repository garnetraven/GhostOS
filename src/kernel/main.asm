org 0x7C00 ; assembler tell BIOS where to load operating system in memory
bits 16 ; start in 16 bit mode because of backwards compatibility with original 8086 processor

%define ENDL 0x0D, 0x0A

_start:
    jmp main

;
; prints a string to the screen
; Params:
;   - ds:si points to string
;
puts:
    ; save registers we will modify
    push si
    push ax

.loop:
    lodsb                       ; loads next character in al
    or al, al                   ; verify if next character is null?
    jz .done

    mov ah, 0x0e                ; call bios interrupt
    mov bh, 0
    int 0x10

    jmp .loop

.done:
    pop ax
    pop si
    ret

main:

    ; setup data segments
    mov ax, 0                   ; can't write to ds/es directly
    mov ds, ax
    mov es, ax

    ; setup stack
    mov ss, ax
    mov sp, 0x7C00              ; stack grows downwards from where we are loaded in memory

    mov si, msg_hello
    call puts

    hlt

.halt:
    jmp .halt

msg_hello: db 'Hello, World!', ENDL, 0


times 510-($-$$) db 0
dw 0AA55H
