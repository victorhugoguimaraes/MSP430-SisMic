#include <msp430.h>

void main() {
  
  WDTCTL = WDTPW | WDTHOLD; // Para o cão de guarda

  // CONFIGURAÇÕES
  P1DIR |= BIT0;  // P1.0 (LED Vermelho) como SAÍDA
  P1OUT &= ~BIT0; // Inicia com o LED apagado

  P1DIR &= ~BIT1; // P1.1 (Botão S2) como ENTRADA
  P1REN |= BIT1;  // Liga o resistor interno
  P1OUT |= BIT1;  // Diz que o resistor é Pull-UP (mola puxando pro teto, lê '1')

  // PASSO 1: Ficar vigiando a gangorra para sempre
  while(1) {
    
    // PASSO 2: A gangorra encostou no chão? (Alguém apertou e mandou '0'?)
    if(!(P1IN & BIT1)) {
        
      // Ação: INVERTE o estado atual do LED Vermelho usando o XOR
      P1OUT ^= BIT0;  

      // Debounce do aperto: perde um tempo contando até 10000 para 
      // ignorar a "quicada" metálica de quando o botão desce
      volatile int i;
      for(i = 0; i < 10000; i++);

      // PASSO 3: Armadilha da soltura! 
      // Fica travado nessa linha ENQUANTO o dedo estiver esmagando o botão
      while(!(P1IN & BIT1)); 

      // Debounce da soltura: perde mais um tempinho para ignorar a 
      // "quicada" da mola puxando o botão para cima quando você solta
      for(i = 0; i < 10000; i++);
      
    }
  }
}
