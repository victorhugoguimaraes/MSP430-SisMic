  .cdecls "msp430.h"
  .global main
        
  .text

main:
  mov.w   #(WDTPW|WDTHOLD), &WDTCTL 

  mov.w   #0x2400, R12       ; declara a memoria 0x2400 como inicial      
  mov.w   #20, R13          ; 20 numeros da sequencia       

  call    #FIB                      
        
  jmp     $

FIB:                            
  push    R4                        ;registrador do valor anterior
  push    R5                        ;registrador do valor atual
  push    R6                        ;registrador que vai servir de backup do valor atual

  ; preparacao dos casos bases
  mov.w   #0, R4             ; adiciona 0 ao registrador q vamos usar como valor anterior      
  mov.w   #1, R5             ; adiciona 1 ao registrador q vamos usar como valor atual       

        
  mov.w   R4, 0(R12)         ; adiciona o valor anterior na memoria       
  add.w   #2, R12            ; soma 2 ao valor endereco, 0x2400 + 2 = 0x2402      
  dec.w   R13                       

  mov.w   R5, 0(R12)         ; adiciona o valor atual na memoria 0x2402       
  add.w   #2, R12            ; soma 2 ao valor endereco, 0x2402 + 2 = 0x2404      
  dec.w   R13                      

loop:                         ; label jump aq pra n precisar fazer as movimentacoes dos casos bases
  mov.w   R5, R6             ; antes de somar anterior com atual, o R6 fica com o valor atual, como backup para nao perder o valor atual       
  add.w   R4, R5             ; valor anterior + valor atual     
  mov.w   R6, R4             ; move o valor do backup para ser o valor anterior       

  mov.w   R5, 0(R12)         ; joga o valor atual para a memoria      
  add.w   #2, R12            ; soma +2 ao endereco de memoria que esta no registrador       
  dec.w   R13                       
  jnz     loop               ; repete o codigo do ponto de onde esta o loop      

  pop     R6                  ; retira da pilha os registradores
  pop     R5
  pop     R4
  ret                            