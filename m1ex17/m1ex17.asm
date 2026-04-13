    .cdecls "msp430.h"
    .global main

    .text
    
main:
    mov.w #(WDTPW|WDTHOLD), &WDTCTL
    
    mov.b #5, R12
    mov.b #10, R13

    clr.b R14
main_loop:
    call #mult8
    dec.b R13

    jnz main_loop

    jmp $
    nop
mult8:
    add.b R12, R14
    
    ;mov.w R14, R12

    ret