int read(int fd, const void *buf, int __n) {
  int ret_val;
  asm volatile("mv a0, %1           # file descriptor\n"
               "mv a1, %2           # buffer \n"
               "mv a2, %3           # size \n"
               "li a7, 63           # syscall read code (63) \n"
               "ecall               # invoke syscall \n"
               "mv %0, a0           # move return value to ret_val\n"
               : "=r"(ret_val)               // Output list
               : "r"(fd), "r"(buf), "r"(__n) // Input list
               : "a0", "a1", "a2", "a7");
  return ret_val;
}

void write(int fd, const void *buf, int __n) {
  asm volatile("mv a0, %0           # file descriptor\n"
               "mv a1, %1           # buffer \n"
               "mv a2, %2           # size \n"
               "li a7, 64           # syscall write (64) \n"
               "ecall"
               :                             // Output list
               : "r"(fd), "r"(buf), "r"(__n) // Input list
               : "a0", "a1", "a2", "a7");
}

void exit(int code) {
  asm volatile("mv a0, %0           # return code\n"
               "li a7, 93           # syscall exit (93) \n"
               "ecall"
               :           // Output list
               : "r"(code) // Input list
               : "a0", "a7");
}

int main();

void _start() {
  int ret_code = main();
  exit(ret_code);
}

#define STDIN_FD 0
#define STDOUT_FD 1

// Helper function to write a string to STDOUT
void write_str(const char *str) {
  int len = 0;
  while (str[len] != '\0')
    len++;
  write(STDOUT_FD, str, len);
}

// Helper function to convert a number to binary representation and write it
int print_binary(int num) {
  char buf[35];
  // char buf_pure[35];
  buf[0] = '0';
  buf[1] = 'b';
  int isNeg = 0;

  unsigned int u_num = (unsigned)num;
  int ini = 0;   // Flag para identificar o início dos bits significativos
  int index = 2; // Começa a partir da posição do "0b"
  for (int i = 31; i >= 0; i--) {
    if (num & (1 << i)) {
      if (i == 31) {
        isNeg = 1;
      }
      ini = 1;
    }
    if (ini == 1) {
      buf[index++] = (num & (1 << i)) ? '1' : '0';
    }
  }

  buf[index] = '\n';     // Adiciona \n para a função write funcionar
  buf[index + 1] = '\0'; // Fechar a string
  write_str(buf);
  return isNeg;
}

// Helper function to print a decimal number
void print_decimal(int num, int isNeg) {
  char buf[12]; // Enough to hold a 32-bit integer as string
  int i = 10;
  if (num < 0) {
    num = -num;
  }

  buf[11] = '\n'; // Newline at the end
  do {
    buf[i--] = (num % 10) + '0';
    num /= 10;
  } while (num > 0);
  if (isNeg)
    buf[i--] = '-'; // adiciona o negativo;
  write(STDOUT_FD, &buf[i + 1], 11 - i);
}

// Helper function to print a hexadecimal number
void print_hexadecimal(int num) {
  char buf[11]; // vamos iniciar a string
  // char buf_pure[11];

  buf[0] = '0';
  buf[1] = 'x';
  buf[2] = '0';
  buf[3] = '0';
  buf[4] = '0';
  buf[5] = '0';
  buf[6] = '0';
  buf[7] = '0';
  buf[8] = '0';
  buf[9] = '0';
  buf[10] = '\n';

  unsigned int u_num = (unsigned int)num;
  int ini = 0;   // identificar o início dos dígitos significativos
  int index = 2; // Começa a partir da posição do "0x"
  for (int i = 7; i >= 0; i--) {
    int digit = (num >> (i * 4)) & 0xF;
    if (digit != 0) {
      ini = 1;
    }
    if (ini == 1) {
      buf[index++] = digit < 10 ? digit + '0' : digit - 10 + 'a';
    }
  }

  buf[index] = '\n'; // Adicionar \n para ser printado pelo write
  buf[index + 1] = '\0';

  write_str(buf); // TODO: caso der erro desfazer
}

void print_unsigned_decimal(unsigned int num, int isNeg) {
  // funçao de print para numeros unsigned retornados da função swap
  char buf[12]; // Suficiente para conter um número de 32 bits unsigned
  int i = 10;
  if (num == 4294967295) {
    num = 1;
  }
  buf[11] = '\n'; // Nova linha no final
  do {
    // faço o inverso do realizado para converter ascii para inteiro
    buf[i--] = (num % 10) + '0';
    num /= 10;
  } while (num > 0);
  if (isNeg) {
    buf[i--] = '-';
  }
  write(STDOUT_FD, &buf[i + 1], 11 - i);
}

void print_swap(unsigned int num) {
  // funçao de print para numeros unsigned retornados da função swap
  char buf[12]; // Suficiente para conter um número de 32 bits unsigned
  int i = 10;
  buf[11] = '\n'; // Nova linha no final
  do {
    // faço o inverso do realizado para converter ascii para inteiro
    buf[i--] = (num % 10) + '0';
    num /= 10;
  } while (num > 0);
  write(STDOUT_FD, &buf[i + 1], 11 - i);
}

// Helper function to swap endianness of a 32-bit integer
unsigned int swap_endian(unsigned int num) {
  // trata todos os 32 bits do número, independente se uma parte é 0
  return ((num & 0xff000000) >> 24) | ((num & 0x00ff0000) >> 8) |
         ((num & 0x0000ff00) << 8) | ((num & 0x000000ff) << 24);
}

int main() {

  char str[20]; // buffer para receber a string do numero

  int n =
      read(STDIN_FD, str, 20); // uso da função read n--> numero de caracteres

  str[n - 1] = '\0'; // Remove o caractere de nova linha --> vamos usar o '\0'
                     // nas funções

  int num; // devo botar unsigned --> se der erro trocar
  int isNeg = 0;
  int n_unsigned = 0;
  if (str[0] == '0' && str[1] == 'x') {
    // caso para hexadecimal
    num = 0;
    for (int i = 2; str[i] != '\0'; i++) {
      num = num * 16 +
            (str[i] >= '0' && str[i] <= '9'
                 ? str[i] - '0'
                 : (str[i] >= 'a' && str[i] <= 'f' ? str[i] - 'a' + 10
                                                   : str[i] - 'A' + 10));
      if (num >= 134217728)
        n_unsigned = 1;
    }
  } else {
    // Decimal input
    int i = 0;
    if (str[0] == '-') {
      isNeg = 1;
      i = 1;
    }
    num = 0;
    for (; str[i] != '\0'; i++) {
      num = num * 10 + str[i] - '0';
    }
    if (isNeg) {
      num = -num;
    }
  }
  if (n_unsigned) {
    unsigned int u_num = (unsigned)num;
    isNeg = print_binary(u_num);
    print_unsigned_decimal(u_num, isNeg);
    print_hexadecimal(u_num);
    unsigned int swap = swap_endian(u_num);
    print_swap(swap);

  } else {
    // início das funções
    isNeg = print_binary(num);
    print_decimal(num, isNeg);
    print_hexadecimal(num);
    unsigned int swap = swap_endian((unsigned int)num);
    print_unsigned_decimal(swap, 0);
  }
  return 0;
}
