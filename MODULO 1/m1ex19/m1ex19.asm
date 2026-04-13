.text
main:
        mov.w   #(WDTPW|WDTHOLD), &WDTCTL
        
        mov.w   #0x89AB, R12              ; Carrega o valor de teste pedido no R12
        mov.w   #vetor_saida, R13         ; R13 aponta para o endereço onde vamos guardar a resposta
        call    #W16_ASC                  ; Chama a sub-rotina principal
        
        nop                              
        jmp     $                        


W16_ASC:
        push    R14                       ; Salva R14 na pilha, rascunho do nibble
        push    R5                        ; Salva R5 na pilha para não sujar o registrador original
        
        mov.w   R13, R5                   ; O enunciado pede para usar R5 como ponteiro de escrita

        ;  1º NIBBLE (Mais significativo, no exemplo: '8') 
        mov.w   R12, R14                  ; Copia o número original (0x89AB) para o rascunho
        swpb    R14                       ; Inverte os bytes: 0x89AB vira 0xAB89
        rra.w   R14                       ; Desloca 1 bit para a direita
        rra.w   R14                       ; Desloca +1 bit
        rra.w   R14                       ; Desloca +1 bit
        rra.w   R14                       ; Desloca +1 bit (total de 4 posições. 0xAB89 vira 0xFAB8)
        and.w   #0x000F, R14              ; Aplica a máscara para zerar o lixo e sobrar só o '8' (0x0008)
        call    #NIB_ASC                  

        ;  2º NIBBLE (No exemplo: '9') 
        mov.w   R12, R14                  ; Copia o número original de novo
        swpb    R14                       ; Inverte os bytes: 0x89AB vira 0xAB89
        and.w   #0x000F, R14              ; O '9' já está na posição correta (bits 3 a 0), basta aplicar a máscara
        call    #NIB_ASC                  ; Converte e salva

        ;  3º NIBBLE (No exemplo: 'A') 
        mov.w   R12, R14                  ; Copia o número original
        rra.w   R14                       ; Desloca 4 vezes para a direita (0x89AB vira 0xF89A)
        rra.w   R14                       
        rra.w   R14                       
        rra.w   R14                       
        and.w   #0x000F, R14              ; Aplica a máscara para sobrar só o 'A' (0x000A)
        call    #NIB_ASC                  

        ; 4º NIBBLE (Menos significativo, no exemplo: 'B')
        mov.w   R12, R14                  ; Copia o número original
        and.w   #0x000F, R14              ; O 'B' já está no fundo, só aplicar a máscara (sobra 0x000B)
        call    #NIB_ASC                  ; Converte e salva

        pop     R5                        ; Restaura R5 da pilha (ordem inversa)
        pop     R14                       ; Restaura R14 da pilha
        ret                               ; Retorna para o main


NIB_ASC:
        cmp.w   #10, R14                  ; Compara o valor isolado com 10
        jge     letra_A_F                 ; Se for 10 ou mais (A até F), pula para a lógica das letras
        
        add.w   #0x0030, R14              ; Se for menor que 10 (0 a 9), soma 0x30 (código ASCII do '0')
        jmp     salva_ascii               ; Pula a lógica das letras e vai direto salvar

letra_A_F:
        add.w   #0x0037, R14              ; Se for letra, soma 0x37. Ex: 10 + 0x37 = 0x41 (código ASCII do 'A')

salva_ascii:
        mov.b   R14, 0(R5)                ; Escreve APENAS UM BYTE (.b) do código ASCII na memória
        inc.w   R5                        ; Avança o ponteiro R5 em 1 byte para o próximo caractere
        ret                               ; Retorna para dentro da W16_ASC


        .data
vetor_saida:
        .space  4                         ; Reserva 4 bytes vazios na memória para receber a resposta