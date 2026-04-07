    .cdecls "msp430.h"
    .global main

    .text

main:
    mov   #vetor, R12      ; endereco do vetor
    mov   #5, R13          ; tamanho do vetor em words

    call  #maior16

fim:
    jmp   $

; -------------------------------------------------
; maior16
; Entrada:
;   R12 = endereco inicial do vetor de words
;   R13 = tamanho do vetor
;
; Saida:
;   R12 = maior elemento
;   R13 = frequencia do maior
; -------------------------------------------------
maior16:
    push  R4
    push  R5
    push  R6
    push  R7
    push  R8

    mov   R12, R4          ; R4 = ponteiro do vetor
    mov   R13, R5          ; R5 = quantidade de elementos

    cmp   #0, R5
    jeq   fim_zero         ; se vetor vazio, retorna 0

    mov   @R4+, R6         ; R6 = maior atual (primeiro elemento)
    mov   #1, R7           ; R7 = frequencia do maior
    dec   R5               ; ja consumimos o primeiro elemento

loop:
    cmp   #0, R5
    jeq   fim_maior

    mov   @R4+, R8         ; R8 = elemento atual

    cmp   R6, R8
    jeq   igual

    jc    atualiza         ; como jeq ja foi tratado, aqui significa R8 > R6

    jmp   proximo

igual:
    inc   R7
    jmp   proximo

atualiza:
    mov   R8, R6
    mov   #1, R7

proximo:
    dec   R5
    jmp   loop

fim_maior:
    mov   R6, R12
    mov   R7, R13

    pop   R8
    pop   R7
    pop   R6
    pop   R5
    pop   R4
    ret

fim_zero:
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
    .word 7, 65000, 50054, 26472, 53000