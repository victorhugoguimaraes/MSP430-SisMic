  .cdecls "msp430.h"
  .global main
  
  .text

main:
  mov.w #(WDTPW|WDTHOLD), &WDTCTL
  call #FIB16
fim:
  jmp $
  
FIB16:
  push R4
  push R5
  push R6
  
  mov.w #0, R4
  mov.w #1, R5
  
loop:
  mov.w R4, R6
  add.w R5, R6
  jc fim_FIB16
  mov.w R5, R4
  mov.w R6, R5

  jmp loop

fim_FIB16:
  mov.w R5, R12
  pop R6
  pop R5
  pop R4
  ret