  .cdecls "msp430.h"
  .global main
  
  .text

main:
  call #FIB32
fim:
  jmp $

FIB32:
  push R4
  push R5
  push R6
  push R7
  push R8
  push R9

  mov.w #0, R5
  mov.w #0, R4

loop:

  mov.w R4, R8
  mov.w R5, R9

  add.w R6, R8
  add.w R7, R9

  jc fim_FIB32
  
  mov.w R6, R4
  mov.w R7, R5
  mov.w R8, R6
  mov.w R9, R7

  jmp loop

fim_FIB32:
  mov.w R7, R13
  mov.w R6, R12
  
  pop R9
  pop R8
  pop R7
  pop R6
  pop R5
  pop R4
  ret
  