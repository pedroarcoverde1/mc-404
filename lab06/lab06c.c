// Função para sair do programa com código de saída
void exit(int code) {
  __asm__ __volatile__("mv a0, %0\n"
                       "li a7, 93\n" // syscall exit
                       "ecall"
                       : 
                       : "r"(code) 
                       : "a0", "a7");
}

// Função de leitura
int read(int __fd, const void *__buf, int __n) {
  int ret_val;
  __asm__ __volatile__("mv a0, %1\n"
                       "mv a1, %2\n"
                       "mv a2, %3\n"
                       "li a7, 63\n" // syscall read
                       "ecall\n"
                       "mv %0, a0\n"
                       : "=r"(ret_val)
                       : "r"(__fd), "r"(__buf), "r"(__n)
                       : "a0", "a1", "a2", "a7");
  return ret_val;
}

// Função de escrita
void write(int __fd, const void *__buf, int __n) {
  __asm__ __volatile__("mv a0, %0\n"
                       "mv a1, %1\n"
                       "mv a2, %2\n"
                       "li a7, 64\n" // syscall write
                       "ecall"
                       : 
                       : "r"(__fd), "r"(__buf), "r"(__n)
                       : "a0", "a1", "a2", "a7");
}


// Função para calcular a raiz quadrada aproximada (Método de Newton)
int sqrt_approx(int num) {
  int x = num;
  int y = (x + 1) / 2;

  while (y < x) {
    x = y;
    y = (x + num / x) / 2;
  }

  return x;
}

// Função absoluta
int absolute(int num) {
  return (num < 0) ? -num : num;
}

// Função para converter de ASCII para inteiro
int ascii_to_int(char *buf, int size) {
  int result = 0;
  int sign = 1;
  int i = 0;

  // Verifica o sinal
  if (buf[0] == '-') {
    sign = -1;
    i++;
  } else if (buf[0] == '+') {
    i++;
  }

  // Converte os dígitos para inteiro
  for (; i < size; i++) {
    if (buf[i] >= '0' && buf[i] <= '9') {
      result = result * 10 + (buf[i] - '0');
    }
  }

  return result * sign;
}

// Função para converter de inteiro para ASCII
void int_to_ascii(int num, char *buf, int size) {
  int is_negative = 0;
  if (num < 0) {
    is_negative = 1;
    num = -num;
  }

  buf[size] = '\0';
  for (int i = size - 1; i >= 0; i--) {
    buf[i] = (num % 10) + '0';
    num /= 10;
  }

  if (is_negative) {
    buf[0] = '-';
  } else {
    buf[0] = '+';
  }
}

// Função principal de cálculo das coordenadas
void calculate_coordinates(int YB, int XC, int TA, int TB, int TC, int TR, char *output) {
  // Velocidade da luz em metros por nanosegundo
  const int c = 300;

  // Cálculo das distâncias
  int dA = (TR - TA) * c;
  int dB = (TR - TB) * c;
  int dC = (TR - TC) * c;

  // Cálculo de y
  int y = (dA * dA + YB * YB - dB * dB) / (2 * YB);

  // Cálculo de x
  int temp = dA * dA - y * y;
  int x1 = sqrt_approx(temp);
  int x2 = -x1;

  // Verificação de qual x é mais próximo
  int dist_x1 = absolute((x1 - XC) * (x1 - XC) + y * y - dC * dC);
  int dist_x2 = absolute((x2 - XC) * (x2 - XC) + y * y - dC * dC);

  int x = (dist_x1 < dist_x2) ? x1 : x2;

  // Converte as coordenadas para ASCII
  int_to_ascii(x, &output[0], 5);
  int_to_ascii(y, &output[6], 5);
}


// Início do programa
void _start() {
  char input_coordenadas[12];
  char input_tempos[20];
  char output[12];  // Para armazenar os resultados x e y

  // Leitura dos buffers
  read(0, input_coordenadas, 12);
  read(0, input_tempos, 20);

  // Converte ASCII para inteiros
  int YB = ascii_to_int(&input_coordenadas[0], 5);
  int XC = ascii_to_int(&input_coordenadas[6], 5);
  int TA = ascii_to_int(&input_tempos[0], 4);
  int TB = ascii_to_int(&input_tempos[5], 4);
  int TC = ascii_to_int(&input_tempos[10], 4);
  int TR = ascii_to_int(&input_tempos[15], 4);

  // Calcula as coordenadas
  calculate_coordinates(YB, XC, TA, TB, TC, TR, output);

  // Escreve o resultado no buffer de saída
  write(1, output, 12);

  // Finaliza o programa
  exit(0);
}
