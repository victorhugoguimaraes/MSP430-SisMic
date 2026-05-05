#include <msp430.h>

void main(void)
{
    WDTCTL = WDTPW | WDTHOLD; // desliga o cao de guarda

    P1DIR |= BIT2; // coloca o pino P1.2 como saída
    P1SEL |= BIT2; // coloca o controle do pino P1.2 para o timer

    // pino P1.1, pino responsavel por aumentar a % do cicle duty
    P1DIR &= ~BIT1; // coloca o pino P1.1 como entrada
    P1REN |= BIT1;  // ativa o resistor
    P1OUT |= BIT1;  // seleciona como pull-up (botao solto = 1, botao apertado = 0)
    P1IES |= BIT1;  // seleciona para avisar quando afundar pro valor 0 (borda de descida)
    P1IFG &= ~BIT1; // limpa sujeiras antigas
    P1IE  |= BIT1;  // liga a interrupcao (ouvido) do botao S2

    // pino P2.1, pino responsavel pela diminuicao da % do cicle duty
    P2DIR &= ~BIT1; // coloca o pino P2.1 como entrada
    P2REN |= BIT1;  // ativa o resistor
    P2OUT |= BIT1;  // seleciona como pull-up (botao solto = 1, botao apertado = 0)
    P2IES |= BIT1;  // seleciona para avisar quando afundar pro valor 0 (borda de descida)
    P2IFG &= ~BIT1; // limpa sujeiras antigas
    P2IE  |= BIT1;  // liga a interrupcao (ouvido) do botao S1

    // configuracao do timer A0, (gerador de PWM)
    TA0CCR0 = 255;       // O teto do ciclo (dita a velocidade de 128Hz)
    TA0CCR1 = 127;       // O ciclo de carga inicial (começa em 50%)
    TA0CCTL1 = OUTMOD_7; // avisa o canal 1 para operar no Modo 7 (Reset/Set)
    TA0CTL = TASSEL_1 | MC_1 | TACLR; // relógio ACLK, modo count, zera tudo

    // configuracao do timer A1 (o cronometro para tratar o debounce)
    TA1CCR0 = 655;   // teto pro ciclo dar 20ms usando relogio lento
    TA1CCTL0 = CCIE; // ativa o alarme do timer A1
    TA1CTL = TASSEL_1 | MC_0; // relógio ACLK, mas comeca parado (Modo 0)

    __enable_interrupt(); // libera a passagem geral pras interrupcoes funcionarem

    while(1) {
        // pra economizar bateria, ele so acorda com o clique do botao
        __low_power_mode_3(); 
    }
}

// botao s2 foi pressionado? rotina da porta 1
#pragma vector = PORT1_VECTOR
__interrupt void ISR_PORTA_1(void) {
    if (P1IFG & BIT1) { // verifica se foi o pino P1.1

        // desliga o ouvido dos botoes pra ignorar a mola tremendo (debounce)
        P1IE &= ~BIT1;  
        P2IE &= ~BIT1;  

        // se true, faz outra verificacao se tem como aumentar 32 que é o 12,5% pedido e nao ultrapassar o ciclo total (255)
        if (TA0CCR1 <= (255 - 32)) {
            TA0CCR1 += 32;  
        } else {
            TA0CCR1 = 255; // se tiver mais que 255-32, ele faz com que trave em 100%
        }

        P1IFG &= ~BIT1; // limpa o lixo do botao 
        
        // da a partida no cronometro do debounce 
        TA1CTL |= MC_1 | TACLR; 
    }
}

// botao s1 foi pressionado? rotina da porta 2
#pragma vector = PORT2_VECTOR
__interrupt void ISR_PORTA_2(void) {
    if (P2IFG & BIT1) { // verifica se foi o pino P2.1
        
        // desliga o ouvido dos botoes pra ignorar a mola tremendo (debounce)
        P1IE &= ~BIT1;  
        P2IE &= ~BIT1;  

        // se true, faz outra verificacao se tem como diminuir 32 que é o 12,5% pedido e nao ultrapassar o valor minimo que é 32
        if (TA0CCR1 >= 32) {  
            TA0CCR1 -= 32;  
        } else {
            TA0CCR1 = 0;   // se tiver menos que 32, faz com que trave em 0%
        }

        P2IFG &= ~BIT1; // limpa o lixo do botao 
        
        // da a partida no cronometro do debounce 
        TA1CTL |= MC_1 | TACLR; 
    }
}

// tratamento de debounce de 20ms pra quando soltar os botoes 
#pragma vector = TIMER1_A0_VECTOR
__interrupt void ISR_TIMER_A1_DEBOUNCE(void) {
    
    TA1CTL &= ~MC_1; // para o cronometro de 20ms

    P1IFG &= ~BIT1;  // limpa sujeira de tremidinha
    P2IFG &= ~BIT1;

    P1IE |= BIT1;    // religa o ouvido do pino P1.1 (pronto pra proximo aperto)
    P2IE |= BIT1;    // religa o ouvido do pino P2.1 (pronto pra proximo aperto)
} // 0% (0) -> 12,5% (32) -> 25% (64) -> 37,5% (96) -> 50% (128) -> 62,5% (160) -> 75% (192) -> 87,5% (224) -> 100% (256) (8x apertando)