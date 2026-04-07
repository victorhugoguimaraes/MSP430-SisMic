    .cdecls "msp430.h"
    .global main

    .text

main:
    mov   #vetor, R12      ; endereço inicial do vetor
    mov   #8, R13          ; tamanho do vetor

    call  #m2m4

fim:

m2m4:
    push  R4
    push  R5
    push  R6
    push  R7

    mov   R12, R4          ; R4 = ponteiro para o vetor
    mov   R13, R5          ; R5 = contador de elementos restantes

    clr   R12              ; contador de múltiplos de 2
    clr   R13              ; contador de múltiplos de 4

loop:
    cmp   #0, R5
    jeq   fim_m2m4         ; se acabou o vetor, termina

    mov.b @R4+, R6         ; pega 1 byte do vetor e avança ponteiro

    ; testa múltiplo de 2
    bit.b #1, R6           ; testa bit 0
    jnz   testa_fim        ; se bit 0 = 1, nao é múltiplo de 2

    inc   R12              ; conta como múltiplo de 2

    ; testa múltiplo de 4
    bit.b #3, R6           ; testa bits 0 e 1
    jnz   testa_fim        ; se algum deles for 1, nao é múltiplo de 4

    inc   R13              ; conta como múltiplo de 4

testa_fim:
    dec   R5
    jmp   loop

fim_m2m4:
    pop   R7
    pop   R6
    pop   R5
    pop   R4
    ret

    .data
vetor:
    .byte 2, 3, 4, 5, 8, 10, 12, 15