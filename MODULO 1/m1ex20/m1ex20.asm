.text
main:
        mov.w   #(WDTPW|WDTHOLD), &WDTCTL ; Desliga o Watchdog Timer

        ; TESTE 1: Cenário de Sucesso
        mov.w   #vetor_ok, R12            ; R12 recebe o endereço do vetor válido ('8', '9', 'A', 'B')
        call    #ASC_W16                  ; Chama a sub-rotina de conversão
        jc      teste2                    ; Se retornou Carry = 1 (Sucesso), pula para o próximo teste
        jmp     $                         ; Se falhou aqui, trava o código (loop infinito)

teste2:
        ; TESTE 2: Cenário de Falha
        mov.w   #vetor_erro, R12          ; R12 recebe o endereço do vetor com erro ('8', ':', 'A', 'B')
        call    #ASC_W16                  ; Chama a sub-rotina
        jnc     fim_testes                ; Se retornou Carry = 0 (Falha), está correto! Pula para o fim
        jmp     $                         ; Se deu sucesso indevido, trava o código

fim_testes:
        nop                               ; Breakpoint! Código passou em tudo
        jmp     $                         ; Fim do programa


ASC_W16:
        push    R13                       ; Salva R13 na pilha (usaremos como contador)
        push    R14                       ; Salva R14 na pilha (usaremos para ler os caracteres)
        push    R15                       ; Salva R15 na pilha (usaremos para acumular a palavra final)
        
        mov.w   #4, R13                   ; R13 recebe 4, pois vamos ler 4 caracteres (4 nibbles)
        mov.w   #0, R15                   ; R15 inicia zerado. Ele vai "montar" a palavra de 16 bits

laco_leitura:
        mov.b   @R12+, R14                ; Lê 1 byte (caractere ASCII) da memória para R14 e avança R12
        call    #ASC_NIB                  ; Chama a sub-rotina auxiliar para validar e converter esse byte
        
        jnc     erro_conversao            ; Se a ASC_NIB retornou Carry = 0 (inválido), aborta e pula pro erro

        ; Se chegou aqui, o caractere é válido e R14 tem o valor (0 a 15)
        rla.w   R15                       ; Desloca o acumulador (R15) 1 bit para a esquerda
        rla.w   R15                       ; Desloca +1 bit
        rla.w   R15                       ; Desloca +1 bit
        rla.w   R15                       ; Desloca +1 bit (total de 4 bits). Abre espaço para o novo nibble
        
        add.w   R14, R15                  ; Soma o nibble convertido (R14) na parte mais baixa de R15

        dec.w   R13                       ; Diminui 1 do contador de caracteres
        jnz     laco_leitura              ; Se ainda não leu os 4, volta pro laço

        ; Se leu os 4 caracteres com sucesso:
        mov.w   R15, R12                  ; O enunciado pede a palavra montada em R12, então copiamos R15 para lá
        setc                              ; Seta (ativa) a Flag de Carry = 1 indicando sucesso
        jmp     fim_conversao             ; Pula a rotina de erro

erro_conversao:
        clrc                              ; Limpa (zera) a Flag de Carry = 0 indicando falha

fim_conversao:
        pop     R15                       ; Restaura R15 original da pilha
        pop     R14                       ; Restaura R14 original
        pop     R13                       ; Restaura R13 original
        ret                               ; Retorna para o programa principal


ASC_NIB:
        ; Validação de Números ('0' a '9' -> 0x30 a 0x39)
        cmp.b   #0x30, R14                ; Compara o caractere com 0x30 ('0')
        jl      caractere_invalido        ; Se for menor que 0x30, não é um número/letra válido
        cmp.b   #0x3A, R14                ; Compara o caractere com 0x3A (um acima do '9')
        jl      eh_numero                 ; Se for menor que 0x3A, temos certeza que é de '0' a '9'

        ; Validação de Letras ('A' a 'F' -> 0x41 a 0x46)
        cmp.b   #0x41, R14                ; Compara o caractere com 0x41 ('A')
        jl      caractere_invalido        ; Se caiu aqui (entre 0x3A e 0x40), são símbolos como ':' ou '<'. Inválido.
        cmp.b   #0x47, R14                ; Compara o caractere com 0x47 (um acima do 'F')
        jl      eh_letra                  ; Se for menor que 0x47, temos certeza que é de 'A' a 'F'

caractere_invalido:
        clrc                              ; Caractere fora dos padrões permitidos. Zera o Carry.
        ret                               ; Retorna acusando erro

eh_numero:
        sub.w   #0x30, R14                ; Subtrai 0x30 para converter ASCII ('8') no valor real (8)
        setc                              ; Ativa o Carry (Sucesso)
        ret                               ; Retorna

eh_letra:
        sub.w   #0x37, R14                ; Subtrai 0x37 para converter ASCII ('A') no valor real (10 / 0x0A)
        setc                              ; Ativa o Carry (Sucesso)
        ret                               ; Retorna


        .data
vetor_ok:
        .byte   0x38, 0x39, 0x41, 0x42    ; Vetor válido do enunciado: '8', '9', 'A', 'B'

vetor_erro:
        .byte   0x38, 0x3B, 0x41, 0x42    ; Vetor inválido do enunciado. O 0x3B é o símbolo ';'