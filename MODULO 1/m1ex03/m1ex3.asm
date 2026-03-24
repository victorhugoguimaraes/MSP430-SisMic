  .cdecls "msp430.h"
  .global main
  
  .text

main:
  mov.w #0xFFFF, R4
  mov.w #0x0001, R5

  add.w R5, R4

  jnc pula_saturacao_1

  mov.w #0xFFFF, R4
pula_saturacao_1:
  
  nop 
  

main:
  mov.w #0x0005, R4
  mov.w #0x0003, R5

  add.w R5, R4

  jnc pula_saturacao_2

  mov.w #0xFFFF, R4
pula_saturacao_2:
  
  nop 