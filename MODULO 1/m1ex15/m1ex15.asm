    .cdecls "msp430.h"
    .global main

    .text

main:
    ; exemplo:
    ; R12 = valor a rotacionar
    ; R13 = opcoes
    ;
    ; exemplo do enunciado:
    ; 0x1408 = direita, circular, 8 rotacoes

    mov   #0x1234, R12
    mov   #0x1408, R13

    call  #rot16

fim:
    jmp   $

; =========================================================
; rot16
; Entrada:
;   R12 = valor de 16 bits
;   R13 = opcoes compactadas
;
; Saida:
;   R12 = valor rotacionado
; =========================================================
rot16:
    push  R4
    push  R5
    push  R6
    push  R7
    push  R8
    push  R9
    push  R10

    ; -----------------------------------------
    ; extrair quantidade de rotacoes (bits 3..0)
    ; -----------------------------------------
    mov   R13, R4
    and   #0x000F, R4        ; R4 = quantidade

    ; se quantidade = 0, nao faz nada
    cmp   #0, R4
    jeq   fim_rot16

    ; -----------------------------------------
    ; extrair tipo (bits 11..8)
    ; -----------------------------------------
    mov   R13, R5
    and   #0x0F00, R5        ; R5 = tipo mascarado

    ; -----------------------------------------
    ; extrair direcao (bits 15..12)
    ; -----------------------------------------
    mov   R13, R6
    and   #0xF000, R6        ; R6 = direcao mascarada

    ; -----------------------------------------
    ; escolher tipo
    ; -----------------------------------------
    cmp   #0x0000, R5
    jeq   tipo_log0

    cmp   #0x0100, R5
    jeq   tipo_log1

    cmp   #0x0200, R5
    jeq   tipo_arit

    cmp   #0x0400, R5
    jeq   tipo_circ

    ; se tipo invalido, nao faz nada
    jmp   fim_rot16

; =========================================================
; TIPO 0: logica inserindo 0
; =========================================================
tipo_log0:
    cmp   #0x0000, R6
    jeq   log0_esq

    cmp   #0x1000, R6
    jeq   log0_dir

    jmp   fim_rot16

log0_esq:
    mov   R4, R7            ; contador
loop_log0_esq:
    add   R12, R12          ; shift left logico, entra 0
    dec   R7
    jnz   loop_log0_esq
    jmp   fim_rot16

log0_dir:
    mov   R4, R7
loop_log0_dir:
    clrc                    ; entra 0 pela esquerda
    rrc   R12
    dec   R7
    jnz   loop_log0_dir
    jmp   fim_rot16

; =========================================================
; TIPO 1: logica inserindo 1
; =========================================================
tipo_log1:
    cmp   #0x0000, R6
    jeq   log1_esq

    cmp   #0x1000, R6
    jeq   log1_dir

    jmp   fim_rot16

log1_esq:
    mov   R4, R7
loop_log1_esq:
    add   R12, R12          ; desloca para esquerda
    bis   #0x0001, R12      ; insere 1 no bit 0
    dec   R7
    jnz   loop_log1_esq
    jmp   fim_rot16

log1_dir:
    mov   R4, R7
loop_log1_dir:
    setc                    ; entra 1 pela esquerda
    rrc   R12
    dec   R7
    jnz   loop_log1_dir
    jmp   fim_rot16

; =========================================================
; TIPO 2: aritmetica
; =========================================================
tipo_arit:
    cmp   #0x0000, R6
    jeq   arit_esq

    cmp   #0x1000, R6
    jeq   arit_dir

    jmp   fim_rot16

arit_esq:
    mov   R4, R7
loop_arit_esq:
    add   R12, R12          ; esquerda aritmetica = igual ao shift left comum
    dec   R7
    jnz   loop_arit_esq
    jmp   fim_rot16

arit_dir:
    mov   R4, R7
loop_arit_dir:
    bit   #0x8000, R12      ; testa bit de sinal
    jz    arit_dir_bit0

    setc                    ; se sinal = 1, entra 1
    jmp   arit_dir_shift

arit_dir_bit0:
    clrc                    ; se sinal = 0, entra 0

arit_dir_shift:
    rrc   R12
    dec   R7
    jnz   loop_arit_dir
    jmp   fim_rot16

; =========================================================
; TIPO 4: circular
; =========================================================
tipo_circ:
    cmp   #0x0000, R6
    jeq   circ_esq

    cmp   #0x1000, R6
    jeq   circ_dir

    jmp   fim_rot16

circ_esq:
    mov   R4, R7
loop_circ_esq:
    bit   #0x8000, R12      ; pega bit 15
    jz    circ_esq_bit0

    add   R12, R12          ; shift left
    bis   #0x0001, R12      ; bit que saiu volta no bit 0
    jmp   circ_esq_cont

circ_esq_bit0:
    add   R12, R12          ; shift left, entra 0

circ_esq_cont:
    dec   R7
    jnz   loop_circ_esq
    jmp   fim_rot16

circ_dir:
    mov   R4, R7
loop_circ_dir:
    bit   #0x0001, R12      ; pega bit 0
    jz    circ_dir_bit0

    setc                    ; bit 0 vai voltar no bit 15
    jmp   circ_dir_shift

circ_dir_bit0:
    clrc

circ_dir_shift:
    rrc   R12
    dec   R7
    jnz   loop_circ_dir
    jmp   fim_rot16

fim_rot16:
    pop   R10
    pop   R9
    pop   R8
    pop   R7
    pop   R6
    pop   R5
    pop   R4
    ret