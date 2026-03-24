  .cdecls "msp430.h"
  .global main
  
  .text

main:
  mov.w #(WDTPW|WDTHOLD), &WDTCTL

  mov.w #0x000A, R4
  mov.w #0x0003, R5

  clr.w R6

multiplica:
  add.w R4, R6
  dec.w R5

  jnz multiplica
 
fim:
  jmp $ 
  nop