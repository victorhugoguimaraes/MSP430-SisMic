  .cdecls "msp430.h"
  .global main
  
  .text

main:
  mov.w #(WDTPW|WDTHOLD), &WDTCTL

  mov.w #5, R4
  mov.w #-8, R5

  add.w R5, R4
  
  jz caso_zero
  
  jn caso_negativo

  inc.w R4
  jmp fim_condicoes

caso_zero:
  nop

caso_negativo:
  dec.w R4
  jmp fim_condicoes

fim_condicoes:
  jmp $ 
  nop