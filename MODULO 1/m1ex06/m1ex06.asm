  .cdecls "msp430.h"
  .global main
  
  .text

main:
  mov.w #10, R12
  mov.w #3, R13
  call #mult8 ; 10 X 3 com sub-rotina

  mov.w #0, R12
  mov.w #15, R13 ;0 x 15 com sub-rotina
  call #mult8

  mov.w #255, R12
  mov.w #255, R13
  call #mult8  ;255 x 255 com sub-rotina

fim: 
  jmp $


mult8:
  push R4
  push R13
  clr.w R4

  tst.w R13
  jz fim_mult8

loop:
  add.w R12, R4
  dec.w R13

  jnz loop

fim_mult8:
  mov.w R4, R12
  pop R4
  pop R13
  ret