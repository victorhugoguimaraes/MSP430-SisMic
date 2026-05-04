#include <msp430.h>

// Variável global para guardar o valor do nosso contador (0 a 3)
volatile unsigned char cont = 0;

// Função auxiliar para atualizar as luzes com base no número atual
void atualiza_LEDs() {
    // Verifica o LSB (Bit 0). Se for 1, acende o Verde. Se não, apaga.
    if (cont & 0x01) { P4OUT |= BIT7; } 
    else             { P4OUT &= ~BIT7; }
    
    // Verifica o MSB (Bit 1). Se for 1, acende o Vermelho. Se não, apaga.
    if (cont & 0x02) { P1OUT |= BIT0; } 
    else             { P1OUT &= ~BIT0; }
}

void main(void) {
    WDTCTL = WDTPW | WDTHOLD;   // Desliga o Watchdog Timer

    // Configuração dos LEDs (Saídas, iniciam apagados)
    P1DIR |= BIT0;  P1OUT &= ~BIT0; // LED Vermelho
    P4DIR |= BIT7;  P4OUT &= ~BIT7; // LED Verde

    // Configuração do Botão S2 (P1.1)
    P1DIR &= ~BIT1;             // Entrada
    P1REN |= BIT1;              // Habilita resistor
    P1OUT |= BIT1;              // Pull-up (mantém em 3,3V)
    P1IE  |= BIT1;              // Habilita interrupção
    P1IES |= BIT1;              // Borda de descida (quando aperta)
    P1IFG &= ~BIT1;             // Limpa a flag por segurança

    // Configuração do Botão S1 (P2.1)
    P2DIR &= ~BIT1;             // Entrada
    P2REN |= BIT1;              // Habilita resistor
    P2OUT |= BIT1;              // Pull-up (mantém em 3,3V)
    P2IE  |= BIT1;              // Habilita interrupção
    P2IES |= BIT1;              // Borda de descida (quando aperta)
    P2IFG &= ~BIT1;             // Limpa a flag por segurança

    // Coloca o microcontrolador para dormir e aguardar os apertos
    __bis_SR_register(LPM4_bits | GIE); 
}

// -----------------------------------------------------------------------
// ISR (Rotina de Interrupção) para a PORTA 1 -> Onde está o botão S2
// -----------------------------------------------------------------------
#pragma vector = PORT1_VECTOR
__interrupt void Port_1_ISR(void) {
    switch(__even_in_range(P1IV, 16)) {
        case 0x04: // P1.1 (Botão S2) gerou a interrupção
            
            // ELIMINAÇÃO DE REBOTE (Debounce) via Software
            // Uma pausa rápida de ~20ms. Impede que o "quique" metálico 
            // seja lido como múltiplos apertos.
            __delay_cycles(20000); 

            // Decrementa o contador e aplica a máscara 0x03
            // (Ex: 0 - 1 resulta num número negativo que, cortado pela máscara, vira 3)
            cont = (cont - 1) & 0x03; 
            
            atualiza_LEDs();
            break;
    }
}

// -----------------------------------------------------------------------
// ISR (Rotina de Interrupção) para a PORTA 2 -> Onde está o botão S1
// -----------------------------------------------------------------------
#pragma vector = PORT2_VECTOR
__interrupt void Port_2_ISR(void) {
    switch(__even_in_range(P2IV, 16)) {
        case 0x04: // P2.1 (Botão S1) gerou a interrupção
            
            // ELIMINAÇÃO DE REBOTE (Debounce) via Software
            __delay_cycles(20000); 
            
            // Incrementa o contador e aplica a máscara para não passar de 3
            cont = (cont + 1) & 0x03; 
            
            atualiza_LEDs();
            break;
    }
}