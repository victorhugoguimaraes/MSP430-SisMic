#include <msp430.h>

void main(void)
{
    WDTCTL = WDTPW | WDTHOLD;

    P1DIR |= BIT0;
    P1OUT |= BIT0;    

    TA0CCR0 = 255;
    TA0CCR1 = 127;

    TA0CCTL1 = CCIE;

    TA0CTL = TASSEL1 | MC1 | TACLR | TAIE;

    __enable_interrupt();
    
    while(1) {
        __low_power_mode_3();
    }
}

#pragma vector = TIMER0_A1_VECTOR

__interrupt void TIMER0_A0_ISR(void){
    
    switch (TA0IV) {
    
        case 2:
            P1OUT &= ~BIT0;
            break;
            
        case 14: 

            P1OUT |= BIT0;
            break;

        default:

            break;
    }
}