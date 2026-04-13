.text
main:
        mov.w   #(WDTPW|WDTHOLD), &WDTCTL  
        mov.w   #vetor_teste, R12         ; R12 recebe o endereço de início do vetor
        mov.w   #5, R13                   ; R13 recebe o tamanho do vetor (5 elementos)
        call    #ORDENA                   ; Chama a sub-rotina de ordenação
        
        nop                                
        jmp     $                          


ORDENA:
        push    R4                        ; Salva R4 (vai ser o contador do laço externo)
        push    R5                        ; Salva R5 (vai ser o ponteiro de varredura)
        push    R6                        ; Salva R6 (vai ser o contador do laço interno)
        push    R14                       ; Salva R14 (vai ler o elemento atual)
        push    R15                       ; Salva R15 (vai ler o elemento da frente)

        mov.w   R13, R4                   ; Copia o tamanho N para R4
        dec.w   R4                        ; O laço externo roda N-1 vezes
        jz      fim_ordena                ; Se N era 1, já está ordenado, pula pro fim

laco_externo:
        mov.w   R12, R5                   ; R5 volta a apontar para o início do vetor a cada nova varrida
        mov.w   R4, R6                    ; R6 recebe o limite de comparações (encolhe a cada varrida!)

laco_interno:
        mov.b   @R5, R14                  ; R14 lê o elemento atual (array[i])
        mov.b   1(R5), R15                ; R15 lê o elemento da frente (array[i+1])
        
        cmp.b   R14, R15                  ; Compara (array[i+1] - array[i])
        jhs     nao_troca                 ; Se array[i+1] >= array[i] (SEM SINAL), a ordem está certa. Pula a troca.

        ; Se não pulou, é porque array[i] > array[i+1]. Precisamos trocar!
        mov.b   R15, 0(R5)                ; O menor (R15) vai para a posição de trás
        mov.b   R14, 1(R5)                ; O maior (R14) vai para a posição da frente

nao_troca:
        inc.w   R5                        ; Avança o ponteiro para o próximo par de bytes
        dec.w   R6                        ; Diminui o contador de comparações do laço interno
        jnz     laco_interno              ; Se ainda tem pares para comparar nesta varrida, repete o laço interno

        dec.w   R4                        ; Diminui o contador do laço externo. O maior elemento já está no final!
        jnz     laco_externo              ; Se ainda faltam varridas, volta para o laço externo

fim_ordena:
        pop     R15                        
        pop     R14
        pop     R6
        pop     R5
        pop     R4
        ret                                


        .data
vetor_teste:
        .byte   4, 7, 3, 5, 1             ; Valores de 0 a 255 (sem sinal)