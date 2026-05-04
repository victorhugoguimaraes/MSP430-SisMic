#include <msp430.h>

void main() {
  
    WDTCTL = WDTPW | WDTHOLD; // Para o cão de guarda

    // --- CONFIGURAÇÃO DOS PINOS ---
    
    // Configura o LED Vermelho (P1.0) como SAÍDA
    P1DIR |= BIT0;
    P1OUT &= ~BIT0; // Inicia apagado

    // Configura a Chave S1 (P2.1) como ENTRADA com Pull-Up (Mola no teto)
    P2DIR &= ~BIT1;
    P2REN |= BIT1;
    P2OUT |= BIT1;

    // Configura a Chave S2 (P1.1) como ENTRADA com Pull-Up (Mola no teto)
    P1DIR &= ~BIT1;
    P1REN |= BIT1;
    P1OUT |= BIT1;

    // --- LAÇO PRINCIPAL ---
    while(1) {
        
        // TRAVA 1: Aguarda qualquer botão ser pressionado (Passagem Aberta -> Fechada)
        // O código fica girando aqui ENQUANTO S2 estiver no teto (1) E (&&) S1 estiver no teto (1)
        while( (P1IN & BIT1) && (P2IN & BIT1) ); 

        // Debounce do aperto (ignora a tremidinha do metal batendo no chão)
        volatile int i;
        for(i = 0; i < 10000; i++); 

        // Ação: Inverte o estado do LED Vermelho
        P1OUT ^= BIT0;

        // TRAVA 2: Aguarda todos os botões serem soltos (Passagem Fechada -> Aberta)
        // O código fica girando aqui ENQUANTO S2 estiver no chão (0) OU (||) S1 estiver no chão (0)
        // A exclamação (!) antes dos testes inverte a lógica para perguntar "está no chão?"
        while( !(P1IN & BIT1) || !(P2IN & BIT1) ); 

        // Debounce da soltura (ignora a tremidinha da mola puxando pro teto)
        for(i = 0; i < 10000; i++);
    }
}