#include <msp430.h>


void main(void)
{
    WDTCTL = WDTPW | WDTHOLD; // desliga o cao de guarda

    P1DIR |= BIT2; // coloca o pino P1.2 como saída
    P1SEL |= BIT2; // coloca o controle do pino P1.2 para o timer

    // pino P1.1, pino responsavel por aumentar a % do duty cycle
    P1DIR &= ~BIT1; // coloca o pino P1.1 como entrada
    P1REN |= BIT1;  // ativa o resistor
    P1OUT |= BIT1;  // seleciona como pull-up (botao solto = 1, botao apertado = 0)
    P1IES |= BIT1;  // seleciona para avisar quando ir pro valor 0 (borda de descida)
    P1IFG &= ~BIT1; // limpa sujeiras antigas
    P1IE  |= BIT1;  // liga a interrupcao (ouvido) do botao S2

    // pino P2.1, pino responsavel pela diminuicao da % do duty cycle
    P2DIR &= ~BIT1; // coloca o pino P2.1 como entrada
    P2REN |= BIT1;  // ativa o resistor
    P2OUT |= BIT1;  // seleciona como pull-up (botao solto = 1, botao apertado = 0)
    P2IES |= BIT1;  // seleciona para avisar quando ir pro valor 0 (borda de descida)
    P2IFG &= ~BIT1; // limpa sujeiras antigas
    P2IE  |= BIT1;  // liga a interrupcao (ouvido) do botao S1

    // configuracao do timer A0, (gerador de PWM)
    TA0CCR0 = 255;       // o teto do ciclo (dita a frequencia do PWM)
    TA0CCR1 = 128;       // o ciclo de carga inicial (comeca em aproximadamente 50%)
    TA0CCTL1 = OUTMOD_7; // avisa o canal 1 para operar no modo 7 (Reset/Set)
    TA0CTL = TASSEL_1 | MC_1 | TACLR; // relogio ACLK, modo up, zera o contador

    // configuracao do timer A1, (cronometro do debounce)
    TA1CCR0 = 655;       // tempo de debounce de aproximadamente 20ms com ACLK = 32768Hz
    TA1CCTL0 = CCIE;     // liga a interrupcao do canal 0 do Timer A1
    TA1CTL = TASSEL_1 | MC_0 | TACLR; // relogio ACLK, timer parado, zera o contador

    __bis_SR_register(LPM0_bits | GIE); // entra em baixo consumo e liga as interrupcoes gerais
}

// botao S2 foi pressionado? rotina da porta 1
#pragma vector = PORT1_VECTOR
__interrupt void aumenta_duty_S2(void)
{
    if (P1IFG & BIT1) { // verifica se foi o pino P1.1

        // desliga o ouvido dos botoes pra ignorar a mola tremendo (debounce)
        P1IE &= ~BIT1;
        P2IE &= ~BIT1;

        // se true, faz outra verificacao se tem como aumentar 32 que é o 12,5% pedido e nao ultrapassar o ciclo total (255)
        if (TA0CCR1 <= (255 - 32)) {
          TA0CCR1 += 32;
        } else {
          TA0CCR1 = 255; // se tiver mais que 255 - 32, ele trava em 100%
        }

        P1IFG &= ~BIT1; // limpa o lixo do botao
        P2IFG &= ~BIT1; // limpa possivel lixo do outro botao tambem

        // da a partida no cronometro do debounce
        TA1CTL |= MC_1 | TACLR;
    }
}

// botao S1 foi pressionado? rotina da porta 2
#pragma vector = PORT2_VECTOR
__interrupt void diminui_duty_S1(void)
{
    if (P2IFG & BIT1) { // verifica se foi o pino P2.1

        // desliga o ouvido dos botoes pra ignorar a mola tremendo (debounce)
        P1IE &= ~BIT1;
        P2IE &= ~BIT1;

        // se true, faz outra verificacao se tem como diminuir 32 que é o 12,5% pedido e nao ultrapassar o valor minimo que é 0
        if (TA0CCR1 >= 32) {
            TA0CCR1 -= 32;
        } else {
            TA0CCR1 = 0; // se tiver menos que 32, ele trava em 0%
        }

        P1IFG &= ~BIT1; // limpa possivel lixo do outro botao tambem
        P2IFG &= ~BIT1; // limpa o lixo do botao

        // da a partida no cronometro do debounce
        TA1CTL |= MC_1 | TACLR;
    }
}

// tratamento de debounce de 20ms pra ignorar a tremedeira dos botoes
#pragma vector = TIMER1_A0_VECTOR
__interrupt void libera_botoes_depois_debounce(void)
{
    TA1CTL &= ~MC_1; // para o cronometro de 20ms

    P1IFG &= ~BIT1; // limpa sujeira de tremidinha do debounce
    P2IFG &= ~BIT1; // limpa sujeira de tremidinha do debounce

    P1IE |= BIT1;   // religa o ouvido do pino P1.1 (pronto pra proximo aperto)
    P2IE |= BIT1;   // religa o ouvido do pino P2.1 (pronto pra proximo aperto)
}