#include <msp430.h>

void main(void)
{
    WDTCTL = WDTPW | WDTHOLD;

    P1DIR |= BIT0;
    P1OUT &= ~BIT0;    

    P2DIR |= BIT0;
    P2REN |= BIT1;
    P2OUT |= BIT1;

    P2IE |= BIT1;
    P2IES |= BIT1;
    P2IFG &= ~BIT1;

    __bis_SR_register(LPM4_bits| GIE);
}


#pragma vector = PORT2_VECTOR

__interrupt void Port_2_ISR (void){
    
    switch(__even_in_range(P2IV, 16)){
        case 0x00: break;
        case 0x02: break;
        
        case 0x04: 
            P1OUT ^= BIT0;
            break;

            case 0x06: break;

            default: break;
    }
}