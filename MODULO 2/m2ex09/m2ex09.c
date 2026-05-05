#include <msp430.h>

void main(void)
{
    WDTCTL = WDTPW | WDTHOLD;

    P1DIR |= BIT2; // Configura o P1.2 como saída
    P1SEL |= BIT2; // Passa o controle do P1.2 para o Hardware do Timer
    

    // configuração do tempo e duty cicle
    TA0CCR0 = 255; //ciclo total
    TA0CCR1 = 127; // ciclo ligado          

    // 128/255 = 0,5 logo, 50% de duty cicle, metade ligado, metade desligado

    // remocao do CCIE (interrupção) e colocando OUTMOD_7 (hardware PWM automático)
    TA0CCTL1 = OUTMOD_7;

    TA0CTL = TASSEL_1 | MC_1 | TACLR; 

    while(1) {
        __low_power_mode_3(); 
    }
}