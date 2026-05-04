        .cdecls "msp430.h"
        .global main

        .text

main:
        mov.w   #(WDTPW|WDTHOLD), &WDTCTL 

        mov.w   #vetor_teste, R12         ; R12 recebe o endereco do vetor 
        mov.w   #10, R13                  ; R13 recebe o tamanho 
        
        call    #ORDENA                   
        
        jmp     $                         

ORDENA:
        push    R4                        ; contador do laco 1 
        push    R5                        ; ponteiro de varredura
        push    R6                        ; contador do laco 2 
        push    R14                       ; backup do elemento atual
        push    R15                       ; backup do elemento da frente

        mov.w   R13, R4                   ; copia o tamanho pra R4
        dec.w   R4                        ; o laco 1 roda tamanho-1 vezes
        jz      fim_ordena                ; se so tem 1 elemento, ja ta ordenado, pula pro fim

laco1:
        mov.w   R12, R5                   ; R5 volta pro inicio do vetor a cada varrida
        mov.w   R4, R6                    ; R6 recebe o limite de trocas (diminui a cada volta ja q decrescenta)

laco2:
        mov.b   @R5, R14                  ; R14 le o byte atual
        mov.b   1(R5), R15                ; R15 le o byte da frente (index + 1)
        
        cmp.b   R14, R15                  ; faz: Frente (R15) - Atual (R14)
        jhs     nao_troca                 ; se Frente >= Atual, pula a troca.

        ; se chegou aq e pq o atual > frente. Entao troca eles de lugar
        mov.b   R15, 0(R5)                ; joga o menor pra tras
        mov.b   R14, 1(R5)                ; joga o maior pra frente

nao_troca:
        inc.w   R5                        ; avanca o ponteiro pro proximo byte
        dec.w   R6                        ; diminui o contador do laco 2
        jnz     laco2                     ; se ainda tem par pra comparar, repete o laco 2

        dec.w   R4                        ; diminui o laco 1
        jnz     laco1                     ; se ainda faltar, volta pro laco 1

fim_ordena:
        pop     R15                       
        pop     R14
        pop     R6
        pop     R5
        pop     R4
        ret                              


        .data
vetor_teste:
        .byte   255, 12, 190, 45, 2, 128, 77, 210, 33, 0