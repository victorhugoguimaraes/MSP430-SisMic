.text
main:
        mov.w   #(WDTPW|WDTHOLD), &WDTCTL 
        mov.w   #vetor_teste, R12         ; R12 recebe o endereço inicial de onde o vetor está na memória
        mov.w   #5, R13                   ; R13 recebe o tamanho do vetor (neste caso, 5 elementos)
        call    #extremos                 ; Pula para a sub-rotina que vai procurar o menor e o maior

        nop                              
        jmp     $                        


extremos:
        push    R10                       ; Salva o valor original de R10 na pilha 
        push    R14                       ; Salva o valor original de R14 na pilha
        push    R15                       ; Salva o valor original de R15 na pilha

        tst     R13                       ; Testa se o tamanho do vetor (R13) é zero
        jz      fim_extremos              ; Se o vetor for vazio (zero), pula direto para o fim

        mov.w   @R12+, R14                ; R14 (Menor) recebe o 1º elemento. O ponteiro R12 já avança +2
        mov.w   R14, R15                  ; R15 (Maior) também recebe o 1º elemento para iniciar a lógica
        
        dec.w   R13                       ; Diminui 1 do tamanho total, pois já lemos o primeiro número
        jz      prepara_retorno           ; Se o vetor só tinha 1 elemento, já acabou. Pula para o fim

laco_busca:
        mov.w   @R12+, R10                ; R10 (Atual) lê o próximo número da memória. R12 avança de novo
        
        cmp.w   R14, R10                  ; Compara o elemento Atual (R10) com o Menor salvo (R14)
        jge     testa_max                 ; Se Atual for >= Menor (usando salto COM SINAL), ignora e pula
        mov.w   R10, R14                  ; Se não pulou, é porque Atual < Menor. Então R14 vira o novo Menor

testa_max:
        cmp.w   R15, R10                  ; Compara o elemento Atual (R10) com o Maior salvo (R15)
        jl      proximo_elemento          ; Se Atual for < Maior (usando salto COM SINAL), ignora e pula
        mov.w   R10, R15                  ; Se não pulou, é porque Atual >= Maior. Então R15 vira o novo Maior

proximo_elemento:
        dec.w   R13                       ; Diminui 1 do contador de elementos que ainda faltam ler
        jnz     laco_busca                ; Se o contador ainda não zerou, volta para ler o próximo

prepara_retorno:
        mov.w   R14, R12                  ; O enunciado pede o Menor no R12, então copiamos R14 para lá
        mov.w   R15, R13                  ; O enunciado pede o Maior no R13, então copiamos R15 para lá

fim_extremos:
        pop     R15                       ; Restaura o R15 original tirando da pilha (na ordem inversa)
        pop     R14                       ; Restaura o R14 original tirando da pilha
        pop     R10                       ; Restaura o R10 original tirando da pilha
        ret                               ; Retorna para o 'main' na linha exata após o 'call'


        .data
vetor_teste:
        .word   10                        ; 1º Elemento: Positivo comum
        .word   -50                       ; 2º Elemento: Negativo comum
        .word   150                       ; 3º Elemento: Maior de todos (Vai para R13 no final)
        .word   -200                      ; 4º Elemento: Menor de todos (Vai para R12 no final)
        .word   0                         ; 5º Elemento: Zero