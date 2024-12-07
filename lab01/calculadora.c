void exit(int code) {
  __asm__ __volatile__("mv a0, %0           # return code\n"
                       "li a7, 93           # syscall exit (64) \n"
                       "ecall"
                       :           // Output list
                       : "r"(code) // Input list
                       : "a0", "a7");
}

void _start() {
  int ret_code = main();
  exit(ret_code);
}

/* read
 * Parameters:
 *  __fd:  file descriptor of the file to be read.
 *  __buf: buffer to store the data read.
 *  __n:   maximum amount of bytes to be read.
 * Return:
 *  Number of bytes read.
 */
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

/* write
 * Parameters:
 *  __fd:  files descriptor where that will be written.
 *  __buf: buffer with data to be written.
 *  __n:   amount of bytes to be written.
 * Return:
 *  Number of bytes effectively written.
 */
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

/* Buffer to store the data read */
char input_buffer[10];
char output[2]; // 1 espaço para o resultado, e um para p \n

int main() {
  int n = read(0, (void *)input_buffer, 10);

  char s1 = input_buffer[0]; // primeiro numero
  char op = input_buffer[2]; // operação
  char s2 = input_buffer[4]; // segundo número

  // lógica para converter em inteiro
  // usar ascii num = ascii(num) - ascii('0')
  int primeiro = s1 - '0';
  int segundo = s2 - '0';
  int resultado;

  switch (op) {
  case '+':
    resultado = primeiro + segundo;
    break;
  case '-':
    resultado = primeiro - segundo;
    break;
  case '*':
    resultado = primeiro * segundo;
    break;
  }

  // para retornar o resultado vamos usar a lógica de ascii inversa
  output[0] = resultado + '0';
  output[1] = '\n';
  write(1, output, 2);
  return 0;
}
