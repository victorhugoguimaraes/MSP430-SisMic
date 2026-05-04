#include <msp430.h>

void main() {
    WDTCTL = WDTPW | WDTHOLD; // Para o cão de guarda

    // Configuração do LED Verde (P4.7)
    P4DIR |= BIT7;  // Configura P4.7 como saída
    P4OUT &= ~BIT7; // Inicia com o LED apagado

    // Configuração do Timer A0
    // TASSEL_1 escolhe o ACLK (32.768 Hz)
    // MC_1 escolhe o Modo UP (Ascendente, conta até o valor de CCR0)
    // TACLR zera o contador por segurança antes de começar
    TA0CTL = TASSEL_1 | MC_1 | TACLR; 
    
    // Configura o teto da contagem para exatamente 0,5s
    TA0CCR0 = 16383; // (32.768 / 2) - 1

    while(1) {
        
        // POLLING DA FLAG: 
        // O programa fica girando em falso nesta linha ENQUANTO a flag CCIFG for zero.
        // O Timer está contando sozinho no fundo. Quando bater 16.383, a flag vira 1!
        while((TA0CCTL0 & CCIFG) == 0); 
        
        // Se o programa passou da linha de cima, o alarme tocou (passou 0,5s)!
        
        // Abaixamos a "bandeirinha" (zeramos a flag) para detectar o próximo ciclo
        TA0CCTL0 &= ~CCIFG; 

        // Inverte o estado do LED Verde (se estava aceso, apaga; se apagado, acende)
        P4OUT ^= BIT7; 
    }
}