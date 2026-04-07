  .cdecls "msp430.h"
  .global main
  
  .text

main:
  mov.w #vetor, R12
  mov.w #10, R13
  call #reduceSum16
fim:
  jmp $
reduceSum16:
  push R4
  push R5
  push R6
  
  mov.w R12, R4
  mov.w R13, R6
  
  mov.w #0, R12
  mov.w #0, R13

loop:
  mov.W @R4, R5
  
  add.w R5, R12
  add.w #0, R13

  add.w #2 , R4
  dec.w R6
  jnz loop

  pop R6
  pop R5
  pop R4

  ret

.data
vetor: .word   1000,2000,3000,4000,5000,6000,7000,8000,9000,10000