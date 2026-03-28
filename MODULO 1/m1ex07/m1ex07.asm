  .cdecls "msp430.h"
  .global main
  
  .text

main:
  call #FIB
fim:
  jmp $

FIB: 
  push R4
  push R5
  push R6
  push R7

  mov.w #0x2400, R4
  mov.w #0, R5 ;caso base
  mov.w #1, R6 ;caso base
  mov.w #20, R7 ;20 numeros

  mov.w R5, 0(R4)
  add.w #2, R4
  dec.w R7

  mov.w R6, 0(R4)
  add.w #2, R4
  dec.w R7

loop:
  mov.w R6, R12
  add.w R5, R6
  mov.w R12, R5

  mov.w R6, 0(R4)
  add.w #2, R4
  dec.w R7
  jnz loop

  pop R7
  pop R6
  pop R5
  pop R4
  ret

  