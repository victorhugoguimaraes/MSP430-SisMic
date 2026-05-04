#include <msp430.h>
#include <math.h> // Obrigatório incluir esta biblioteca para usar a função sqrt() (raiz quadrada) [3, 4]

void main() {
    WDTCTL = WDTPW | WDTHOLD; // Para o cão de guarda

    // Variável para guardar o resultado do cronômetro
    volatile unsigned int tempo_gasto; 
    
    // PASSO 1: "Zerar e Iniciar" o cronômetro [1]
    // TASSEL_2: Escolhe o SMCLK (relógio rápido de ~1 MHz)
    // MC_2: Modo Contínuo (começa a contar feito louco)
    // TACLR: Zera a contagem antes de começar
    TA0CTL = TASSEL_2 | MC_2 | TACLR; 

    // PASSO 2: Fazer a placa trabalhar (as linhas do seu exercício)
    volatile double hardVar = 128.43984610923f;
    hardVar = (sqrt(hardVar * 3.14159265359) + 30.3245) / 1020.2331556 - 0.11923;

    // PASSO 3: "Parar" o cronômetro [1]
    // Escrever 0 no registrador de controle desliga o timer imediatamente
    TA0CTL = 0; 

    // PASSO 4: Olhar a tela do cronômetro [2]
    // Copiamos o número de batidas que o timer contou (TA0R) para a nossa variável
    tempo_gasto = TA0R; //valor: 11613

    // Armadilha para prender o programa no final
    while(1); 
}
