    .cdecls "msp430.h"
    .global main
  
    .text

main:
    mov   #vetor1, R5
    mov   #vetor2, R6
    mov   #vetorSoma, R7

    call  #mapSum16

fim:
    jmp   $
  
mapSum16:
    push  R8
    push  R9
    push  R10

    mov   #8, R8

loop:
    mov   @R5+, R9
    mov   @R6+, R10

    add   R10, R9

    mov   R9, 0(R7)
    add   #2, R7

    dec   R8
    jnz   loop

    pop   R10
    pop   R9
    pop   R8

    ret

    .data
vetor1:   .word 7, 65000, 50054, 26472, 53000, 60606, 814, 41121

vetor2:   .word 7, 226, 3400, 26472, 470, 1020, 44444, 12345

vetorSoma:    .space 16