    .cdecls "msp430.h"
    .global main

    .text

main:
    mov   #vetor, R12      ; endereco do vetor
    mov   #10, R13         ; tamanho do vetor

    call  #menor

fim:
    jmp   $

; -------------------------------------------------
; menor
; Entrada:
;   R12 = endereco inicial do vetor de bytes
;   R13 = tamanho do vetor
;
; Saida:
;   R12 = menor elemento do vetor
;   R13 = frequencia do menor
; -------------------------------------------------
menor:
    push  R4
    push  R5
    push  R6
    push  R7
    push  R8

    mov   R12, R4          ; R4 = ponteiro para o vetor
    mov   R13, R5          ; R5 = quantidade de elementos

    cmp   #0, R5
    jeq   menor_fim_zero   ; se tamanho = 0, sai com zero

    mov.b @R4+, R6         ; R6 = menor atual (primeiro elemento)
    mov   #1, R7           ; R7 = frequencia do menor
    dec   R5               ; ja consumimos o primeiro elemento

loop:
    cmp   #0, R5
    jeq   fim_menor

    mov.b @R4+, R8         ; R8 = elemento atual

    cmp.b R6, R8
    jeq   igual_menor

    jc    atualiza_menor   ; se R8 < R6, atualiza o menor

    jmp   proximo

igual_menor:
    inc   R7
    jmp   proximo

atualiza_menor:
    mov.b R8, R6
    mov   #1, R7

proximo:
    dec   R5
    jmp   loop

fim_menor:
    mov   R6, R12
    mov   R7, R13

    pop   R8
    pop   R7
    pop   R6
    pop   R5
    pop   R4
    ret

menor_fim_zero:
    clr   R12
    clr   R13

    pop   R8
    pop   R7
    pop   R6
    pop   R5
    pop   R4
    ret

    .data
vetor:
    .byte 7, 3, 9, 3, 5, 1, 8, 1, 4, 1