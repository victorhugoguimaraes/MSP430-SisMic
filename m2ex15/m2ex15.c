#include <msp430.h>

void main(void)
{
    WDTCTL = WDTPW | WDTHOLD; // desliga o cão de guarda para ele não resetar a placa

    // configuracao dos pinos dos leds
    P1DIR |= BIT0; // coloca o pino P1.0 (led vermelho) como saída
    P4DIR |= BIT7; // coloca o pino P4.7 (led verde) como saída
    
    // liga os leds no inicio do programa (o ciclo sempre comeca em 0%)
    P1OUT |= BIT0; // acende o led vermelho
    P4OUT |= BIT7; // acende o led verde

    // configuracao do timer A0 
    TA0CCR0 = 32768; // ciclo total para durar 1 segundo

    TA0CCR1 = (TA0CCR0/100)*30;  // determinando o tempo que o led vermelho vai piscar, sendo 30% de 1 seg, logo 0,3s
    TA0CCR2 = (TA0CCR0/100)*70;  //  determinando o tempo que o led verde vai piscar, sendo 70% de 1 seg, logo 0,7s

    // habilitar os "alarmes" (interrupcoes) nos comparadores
    TA0CCTL1 = CCIE; // ativa o alarme para quando a contagem chegar no 30 (CCR1)
    TA0CCTL2 = CCIE; // ativa o alarme para quando a contagem chegar no 70 (CCR2)
    
    // ligar o timer principal
    // TASSEL_1: escolhe o relogio ACLK (que é mais lento, ideal pra isso)
    // MC_1:  count (conta de 0 ate 100)
    // TACLR: zera o contador antes de comecar pra limpar sujeira
    // TAIE: ativa o alarme principal para quando atinge o teto (100) e volta pro 0
    TA0CTL = TASSEL_1 | MC_1 | TACLR | TAIE; 

    __enable_interrupt(); // libera a passagem geral para as interrupcoes funcionarem
    
    while(1) {
        // manda o processador dormir no modo 3 para economizar energia, ele so acorda quando um dos alarmes acima toca
        __low_power_mode_3(); 
    }
}

// rotina do "porteiro" das interrupcoes agrupadas do Timer A0
#pragma vector = TIMER0_A1_VECTOR
__interrupt void TIMER0_A1_ISR(void){
    
    // TA0IV olha quem tocou o alarme e ja apaga a bandeirinha sozinho para o proximo ciclo
    switch (TA0IV) {
    
        case 2: // alarme do CCR1 tocou? (chegou no 30% do tempo)
            P1OUT &= ~BIT0; // apaga o led vermelho
            break;
            
        case 4: // alarme do CCR2 tocou? (chegou no 70% do tempo)
            P4OUT &= ~BIT7; // apaga o led verde
            break;

        case 14: // alarme de overflow tocou? (bateu no 100 e deu a volta pro 0)
            P1OUT |= BIT0; // acende o led vermelho (comecou o ciclo novo)
            P4OUT |= BIT7; // acende o led verde (comecou o ciclo novo)
            break;

        default:
            break;
    }
} // leds acendem no 0 -> vermelho apaga em 30% -> verde apaga no 70% -> volta pro 0 e acende os dois de novo