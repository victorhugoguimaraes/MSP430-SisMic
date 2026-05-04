#include <msp430.h>

void main(){

  //PxDIR = Direção (Entrada ou Saída) Entrada = 0, Saída = 1
  //PxOUT = Ligado ou Desligado caso seja saída, caso seja entrada, e o REN tiver ligado, 0 = Pull-down, 1 = Pull-UP
  //PxIN = Leitura do pino. 0 ou 1
  //PxREN = Liga ou Desliga o resistor interno de pull-up e pull-down, Se for 1, vc altera no out quall pull voce quer
  
  WDTCTL = WDTPW | WDTHOLD;
  P4DIR |= BIT7; // INICIALIZA COM O VALOR 1 O BIT 7, ASSIM O P4.7 FICA COMO SAIDA (VALOR 1)
  P4OUT &= ~BIT7; // FAZ COM QUE P4.7 LEVE A SAÍDA PARA NIVEL BAIXO

  P1DIR &= ~BIT1; // INICIALIZA COM VALOR 0, LOGO O P1.1 VAI SER ENTRADA (VALOR 0)
  P1REN |= BIT1; // Resistor ativado, logo o out vai ser ou pull down, ou pull up
  P1OUT |= BIT1; // Saída determinada como 1, logo vai ser Pull-UP

  while(1){
    if(!(P1IN & BIT1)) // VERIFICA SE P1.1 ESTÁ COM VALOR DIFERENTE DE 0
    {
      P4OUT |= BIT7;  // SE FOR TRUE, ESTA ATIVADO, LOGO ELE VAI ACENDER O P4.7, DEIXANDO ELE 1
    }else 
    {
      P4OUT &= ~BIT7;  // SE FOR FALSE, ESTA DESATIVADO, LOGO VAI APAGAR O P4.7, DEIXANDO ELE 0
    }
  }

  
}