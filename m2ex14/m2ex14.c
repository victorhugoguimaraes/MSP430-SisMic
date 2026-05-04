#include <msp430.h>

void main(void) {
    // 1. Para o cão de guarda
    WDTCTL = WDTPW | WDTHOLD;

    // 2. Configura o pino P1.0 (LED Vermelho)
    P1DIR |= BIT0;     // Configura como saída
    P1OUT &= ~BIT0;    // Garante que inicie apagado

    // 3. Configura o Limiar do Timer (CCR0)
    // O timer vai contar de 0 até 16383 (o que leva exatos 0,5s no ACLK)
    TA0CCR0 = 16383; 

    // 4. Habilita a interrupção local do comparador CCR0
    // CCIE = Capture/Compare Interrupt Enable
    TA0CCTL0 = CCIE; 

    // 5. Configura e liga o Timer0
    // TASSEL_1: Escolhe o ACLK (32.768 kHz)
    // MC_1: Escolhe o Modo UP (Conta até CCR0 e zera)
    // TACLR: Zera o contador antes de iniciar
    TA0CTL = TASSEL_1 | MC_1 | TACLR; 

    // 6. Coloca o microcontrolador para dormir (LPM3) e liga as interrupções (GIE)
    // O LPM3 desliga o cérebro (CPU) e relógios rápidos, mas mantém o ACLK vivo!
    __bis_SR_register(LPM3_bits | GIE); 
    
    // Nenhuma instrução while(1) é necessária aqui.
}

// -----------------------------------------------------------------------
// ROTINA DE SERVIÇO DE INTERRUPÇÃO (ISR) - VETOR DEDICADO DO CCR0
// Esta função é chamada a cada 0,5 segundos (sempre que Timer == CCR0)
// -----------------------------------------------------------------------
#pragma vector = TIMER0_A0_VECTOR   // <--- Note que o vetor é o A0 (exclusivo do CCR0)
__interrupt void Timer0_A0_ISR(void) {
    
    // Inverte o estado do LED Vermelho.
    // Se estava 0, vira 1. Se estava 1, vira 0.
    P1OUT ^= BIT0; 

    // ATENÇÃO: Repare que NÃO precisamos fazer switch(TA0IV), nem limpar 
    // a bandeira manualmente. O simples ato de entrar nesta função dedicada
    // já sinaliza para o hardware baixar a bandeira de interrupção do CCR0!
}