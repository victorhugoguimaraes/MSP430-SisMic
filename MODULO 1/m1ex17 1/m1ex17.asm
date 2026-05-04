    .cdecls "msp430.h"
    .global main

    .text

main:
    mov.w   #(WDTPW|WDTHOLD), &WDTCTL

    mov.w   #vetor, R12        ; adiciona o endereco do vetor no registrador de entrada
    mov.w   #10, R13            ; 5 numeros 

    call    #maior16           

    jmp     $                 

maior16:
    push    R4                
    push    R5
    push    R6
    push    R7
    push    R8

    mov.w   R12, R4            ; R4 fica sendo o ponteiro do vetor
    mov.w   R13, R5            ; R5 fica sendo o contador de elementos

    cmp.w   #0, R5             ; testa se o vetor ta vazio
    jeq     fim_zero           ; se tiver vazio pula pro fim_zero

    ; preparacao do caso base (o primeiro elemento é o maior por enquanto)
    mov.w   @R4+, R6           ; R6 = maior atual. le 2 bytes juntos e soma +2 no endereco
    mov.w   #1, R7             ; R7 = frequencia do maior
    dec.w   R5                 ; ja leu o primeiro, entao diminui 1 do contador

loop:                         
    cmp.w   #0, R5             ; testa se o contador zerou
    jeq     fim_maior          ; se zerou, ja leu tudo, pula pro fim

    mov.w   @R4+, R8           ; carrega o proximo elemento pro R8

    cmp.w   R6, R8             ; compara o novo elemento com o maior que ja temos
    jeq     igual              ; se o valor for igual, pula pra label igual

    jc      atualiza           ; se tiver carry (o novo for maior q o antigo sem sinal), pula pra atualizar

    jmp     proximo            ; se for menor, ignora e pula pro proximo

igual:
    inc.w   R7                 ; soma 1 na frequencia ja que achou outro numero igual
    jmp     proximo            ; pula pro proximo

atualiza:
    mov.w   R8, R6             ; move o valor do novo maior para o R6
    mov.w   #1, R7             ; reseta a frequencia pra 1, pq eh um numero novo

proximo:
    dec.w   R5                 ; diminui 1 do contador de elementos que faltam
    jmp     loop               ; repete o codigo do ponto de onde esta o loop

fim_maior:
    mov.w   R6, R12            ; joga o valor do maior elemento pra saida R12
    mov.w   R7, R13            ; joga o valor da frequencia pra saida R13

    pop     R8                 ; retira da pilha os registradores
    pop     R7
    pop     R6
    pop     R5
    pop     R4
    ret                        ; retorna pro main

fim_zero:
    clr.w   R12                ; zera a saida se o vetor for vazio
    clr.w   R13

    pop     R8                 ; retira da pilha os registradores
    pop     R7
    pop     R6
    pop     R5
    pop     R4
    ret                        ; retorna pro main

    .data
; vetor de 10 bytes usando valores de 0 a 255
vetor:
    .word 12, 250, 250, 100, 0, 150, 250, 200, 155, 10