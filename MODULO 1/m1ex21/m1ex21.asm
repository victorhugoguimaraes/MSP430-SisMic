#include <msp430.h>

            .text
            .global main

main:
            mov.w   #WDTPW|WDTHOLD, &WDTCTL

            mov.w   #msg, R12       

loop_string:
            mov.b   @R12+, R13       
            cmp.b   #0, R13         
            jeq     fim             

           
            jmp     loop_string

fim:
            jmp     fim              

            .data
msg:
            .string "Hello, world!"