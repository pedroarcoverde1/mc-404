int read(int __fd, const void *__buf, int __n) {
  int ret_val;
  __asm__ __volatile__("mv a0, %1           # file descriptor\n"
                       "mv a1, %2           # buffer \n"
                       "mv a2, %3           # size \n"
                       "li a7, 63           # syscall read code (63) \n"
                       "ecall               # invoke syscall \n"
                       "mv %0, a0           # move return value to ret_val\n"
                       : "=r"(ret_val)                   // Output list
                       : "r"(__fd), "r"(__buf), "r"(__n) // Input list
                       : "a0", "a1", "a2", "a7");
  return ret_val;
}

void write(int __fd, const void *__buf, int __n) {
  __asm__ __volatile__("mv a0, %0           # file descriptor\n"
                       "mv a1, %1           # buffer \n"
                       "mv a2, %2           # size \n"
                       "li a7, 64           # syscall write (64) \n"
                       "ecall"
                       :                                 // Output list
                       : "r"(__fd), "r"(__buf), "r"(__n) // Input list
                       : "a0", "a1", "a2", "a7");
}

void exit(int code) {
  __asm__ __volatile__("mv a0, %0           # return code\n"
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

// TODO: começar o programa aqui

// pegar numero na base decimal --> operações binarias --> output em hexadecimal

void pack(int input, int start_bit, int end_bit, int *valor) {
  // INPUT --> NUMERO decimal
  int mask = (1 << (end_bit - start_bit + 1)) -
             1; // 0000 0000 0000 0000 0000 0000 0000 0111 -> 1°caso

  int bits = (input & mask) << start_bit;

  *valor |= bits;
}

// func hexadecimal
void hex_code(int val) {
  char hex[11];
  unsigned int uval = (unsigned int)val, aux;

  hex[0] = '0';
  hex[1] = 'x';
  hex[10] = '\n';

  for (int i = 9; i > 1; i--) {
    aux = uval % 16;
    if (aux >= 10)
      hex[i] = aux - 10 + 'A';
    else
      hex[i] = aux + '0';
    uval = uval / 16;
  }
  write(1, hex, 11);
}

int converte_int(char *str, int start) {
  int sign = 1;
  if (str[start] == '-') {
    sign = -1;
    start++;
  } else if (str[start] == '+') {
    start++;
  }

  int num = 0;
  for (int i = 0; i < 4; i++) { // 5 caracteres
    num = num * 10 + (str[start + i] - '0');
  }

  return num * sign;
}
// func int main(int argc, char *argv[])
int main() {

  // COMEÇAR PEGANDO UM INPUT DE 30 BITS
  char str[30];
  int nums[5];
  // ler o input até o espaço --> isso vai ser um número
  read(STDIN_FD, str, 30);

  int i;
  int valor = 0;
  /*

    1st number: 3 LSB => Bits 0 - 2
    2nd number: 8 LSB => Bits 3 - 10
    3rd number: 5 LSB => Bits 11 - 15
    4th number: 5 LSB => Bits 16 - 20
    5th number: 11 LSB => Bits 21 - 31

  */
  nums[0] = converte_int(str, 0);
  nums[1] = converte_int(str, 6);
  nums[2] = converte_int(str, 12);
  nums[3] = converte_int(str, 18);
  nums[4] = converte_int(str, 24);

  pack(nums[0], 0, 2, &valor);
  pack(nums[1], 3, 10, &valor);
  pack(nums[2], 11, 15, &valor);
  pack(nums[3], 16, 20, &valor);
  pack(nums[4], 21, 31, &valor);

  hex_code(valor);

  return 0;
}
