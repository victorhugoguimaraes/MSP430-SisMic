  .cdecls "msp430.h"
  .global main
  
  .text

main:
  mov.w #vetor, R12
  mov.w #10, R13
  call #reduceSum8
fim:
  jmp $
reduceSum8:
  push R4
  push R5
  
  mov.w #0, R4

loop:
  mov.b @R12, R5
  add.w #0x00FF, R5
  add.w R5, R4

  inc.w R12
  dec.w R13
  jnz loop

  mov.w R4, R12

  pop R5
  pop R4

  ret

.data
vetor: .byte 1,2,3,4,5,6,7,8,9,10