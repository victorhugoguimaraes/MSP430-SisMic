#include <msp430.h>

void main() {
    WDTCTL = WDTPW | WDTHOLD; // Para o cão de guarda

    // Configuração do LED Vermelho (P1.0)
    P1DIR |= BIT0;  // Configura como SAÍDA
    P1OUT &= ~BIT0; // Garante que inicie APAGADO

    while(1) {
        
        P1OUT ^= BIT0; // Inverte o estado atual do LED (Acende/Apaga)

        // Cria um laço de repetição interno para atrasar a CPU por 0,5 segundo (500ms)
        volatile long i;
        for (i = 0; i < 30000; i++); 
    }
}