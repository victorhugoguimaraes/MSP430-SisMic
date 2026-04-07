  .cdecls "msp430.h"
  .global main
  
  .text

main:
mov.w #saida, R12
mov.w #vetorA, R13
mov.w #vetorB, R14
mov.w #10, R15

call #mapSub8

fim:
  jmp $
  
mapSub8:
  push R4
  push R5
  

loop:
  mov.b @R13, R4
  mov.b @R14, R5
  
  sub.b R5, R4
  mov.b R4, @R12

  inc.w R12
  inc.w R13
  inc.w R14
  
  dec.w R15
  jnz loop

  pop R5
  pop R4
  ret

.data
saida:  .byte   0,0,0,0,0,0,0,0,0,0
vetorA: .byte   10,20,30,40,50,60,70,80,90,100
vetorB: .byte   1,2,3,4,5,6,7,8,9,10