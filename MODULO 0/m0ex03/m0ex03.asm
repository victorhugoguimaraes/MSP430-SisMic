  .cdecls "msp430.h"
  .global main

  .text

main:

  mov.w #(WDTPW | WDTHOLD), &WDTCTL

  mov.w #7, R4
  mov.w #9, R5
  add.w R4, R5  

  jmp   $
  nop