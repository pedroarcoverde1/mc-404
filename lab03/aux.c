#include <stdio.h>

void tira_zero(char *str_cheia, char *str_pura) {

  // TODO: verificação
  printf("Entrando na função de tiar zeros à esquerda\n");

  int i = 2, j = 2;
  while (str_cheia[i] == '0') {
    i++;
  }

  printf("total de casas = %d\n", i);

  while (str_cheia[i] != '\n' && str_cheia[i] != '\0') {
    printf("Passo: %d --> caractere %c\n", j - 2, str_cheia[i]);
    str_pura[j++] = str_cheia[i++];
  }

  printf("%s\n", str_pura);
}

void adiciona_zeros(char *str, int num_zeros) {
  int len = 0;

  // Conta o comprimento da string ignorando o "0x"
  while (str[len] != '\0') {
    len++;
  }

  // Desloca os caracteres existentes para a direita, começando do final
  for (int i = len; i >= 2; i--) {
    str[i + num_zeros] = str[i];
  }

  // Preenche com zeros os espaços vazios à esquerda
  for (int i = 0; i < num_zeros; i++) {
    str[2 + i] = '0';
  }

  // Atualiza o final da string
  str[len + num_zeros] = '\0';
}

// funçao de converter uma string para o seu equivalente inteiro
unsigned int converte_int(char str[11], int base) {
  // TODO: remover isso depois
  printf("começando a converção para int...\n");
  str[10] = '\0';
  printf("O numero escolhido foi %s\n", str);
  printf("a base escolhida foi %d\n", base);

  unsigned int num = 0;
  unsigned int valor;
  int neg = 0;
  int i = 0;

  // verificação de negativo
  if (str[0] == '-' && base == 10) {
    // TODO: verificação
    printf("O número é negativo\n");
    i++;
    neg = 1;
  }

  if (base == 16 && str[0] == '0' && str[1] == 'x') {
    i += 2; // Ignora o prefixo "0x"
  }

  // TODO: tirar isso daqui depois
  printf("verificação de negativo feita\n");

  while (str[i] != '\0') {
    if (str[i] >= '0' && str[i] <= '9') {
      valor = str[i] - '0';
    } else if (str[i] >= 'a' && str[i] <= 'f') {
      valor = str[i] - 'a' + 10;
    }
    num = num * base + valor;

    printf("Passo %d\n", i);
    printf("%c\n", str[i]);
    printf("%d\n", valor);
    printf("num = %u\n", num);

    i++;
  }

  if (neg == 1) {
    return -num;
  }

  // TODO: print de verificação
  printf("o numero convertido eh %u\n", num);

  return num;
}

// função que retorna um numero inteiro para a sua forma string
void int_to_str(unsigned int num, char *str, int isNeg) {
  int i = 0;
  unsigned int temp_num = num;
  char temp_str[10]; // Buffer temporário para armazenar os dígitos

  // Processa os dígitos de trás para frente
  while (temp_num != 0) {
    temp_str[i++] =
        (temp_num % 10) + '0'; // Converte o último dígito para caractere
    temp_num /= 10;            // Remove o último dígito
  }

  // Reverte a string, pois os dígitos foram obtidos de trás para frente
  int j = 0;
  if (isNeg == 1) {
    printf("O número é negativo, botando - no inicio\n");
    str[j++] = '-';
  }
  for (int k = 0; k < i; k++) {
    str[j++] = temp_str[i - k - 1];
  }
  str[j] = '\0'; // Adiciona o terminador nulo
}

void print_int(unsigned int num, int isNeg) {
  // TODO: retirar isso daqui depois
  printf("Entrou na função de printar inteiro\n");

  char buffer[12]; // Buffer para armazenar a string do número, incluindo espaço
                   // para números negativos
  int_to_str(num, buffer, isNeg); // Converte o número para string
  printf("%s\n", buffer); // TODO:Usa a função write para imprimir o número
}

int print_binary(int num, char *str_bin) {
  // TODO: print de verificação
  printf("Entramos na função de printar binário\n");
  printf("%s\n", str_bin);

  for (int i = 33; i >= 2; i--) {
    // Desloca o bit desejado para a posição mais à direita e faz o AND com 1
    int bit = (num >> i) & 1;
    str_bin[33 - i] = bit ? '1' : '0';

    // TODO: verificação
    printf("Passo %d\n", 33 - i);
    printf("%d\n", bit);
  }

  // TODO: verificar se os vetores em C já vem com a ultima casa com o
  printf("%s\n", str_bin);

  printf("Agora vamos tirar os zeros à esqueda\n");

  char str_pura[33] = {'0', 'b'};

  if (str_bin[2] == '1') {
    tira_zero(str_bin, str_pura);
    printf("O numero binário associado é negativo\n");
    return 1;
  } else {
    tira_zero(str_bin, str_pura);
    return 0;
  }
}

void print_hex(int num, char *str_hex) {
  // TODO: tirar o print daqui depois
  printf("Começando a conversção para hexadecimal\n");

  printf("%s\n", str_hex);
  int n = 2;

  unsigned int unsigned_num = (unsigned int)num;

  for (int i = 7; i >= 0; i--) {
    int bit = (unsigned_num >> (i * 4)) & 0xf;
    char hex_digit = bit < 10 ? '0' + bit : 'a' + (bit - 10);
    str_hex[n++] = hex_digit;

    printf("Passo %d\n", 4 - i);
    printf("digito hex: %c\n", hex_digit);
  }

  char str_hex_pura[11] = {'0', 'x'};
  tira_zero(str_hex, str_hex_pura);

  printf("string hexadecimal pura%s\n", str_hex_pura);
  printf("string hexadecimal bruta%s\n", str_hex);
}

void print_swap(char *str) {
  // para a string "0x23456789\n"

  // TODO: remover isso depois
  printf("Iniciando o swap...\n");
  printf("O numero escolhido foi %s\n", str);
  char temp;
  int count = 0;
  while (str[count] != '\0') {
    count++;
  }

  // Quantos dígitos hexadecimais temos (desconsiderando o "0x")?
  int num_digitos = count - 2;

  printf("numero de dígitos: %d", num_digitos);

  // Se tivermos menos que 8 dígitos, adiciona zeros à esquerda
  if (num_digitos < 8) {
    int num_zeros = 8 - num_digitos;
    adiciona_zeros(str, num_zeros);
    printf("Número com zeros adicionados: %s\n", str);
  }

  temp = str[8];
  str[8] = str[2];
  str[2] = temp;

  temp = str[9];
  str[9] = str[3];
  str[3] = temp;

  temp = str[6];
  str[6] = str[4];
  str[4] = temp;

  temp = str[7];
  str[7] = str[5];
  str[5] = temp;

  printf("Número swap %s\n", str);
  // tira_zero(str, str_hex_pura);
  int num = converte_int(str, 16);
  print_int(num, 0);
}

int main() {
  int num;

  char endLine = '\n';
  // usar write(STDOUT, &endLine, 1); para tentar encerrar

  printf("Escolha um numero\n");

  char str[11];
  char str_bin[35];
  str_bin[0] = '0';
  str_bin[1] = 'b';

  for (int i = 2; i < 34; i++) {
    str_bin[i] = '0';
  }
  str_bin[34] = '\0';

  scanf("%s", str);

  printf("O numero escolhido foi %s\n", str);

  if (str[1] == 'x') {
    char str_hex[11] = "00000000\n";
    // caso de numero na base hexadecimal
    // TODO: tirar isso daqui depois
    printf("O numero escolhido foi hexadecimal\n");
    num = converte_int(str, 16); // converte inteiro
    // TODO: print de varificação
    printf("numero convertido para int: %d\n;", num);
    int isNeg = print_binary(num, str_bin); // print binário
    printf("verifica se é negativo, primeiro dígito %c\n", str_bin[2]);
    print_int(num, isNeg);
    printf("%s\n", str); // print hexadecimal
    print_swap(str);     // print swap
  } else {

    char str_hex[11];
    str_hex[0] = '0';
    str_hex[1] = 'x';

    // TODO: TIRAR ISSO DAQUI DEPOIS
    printf("O número escolhido está na base decimal\n");
    // caso de inteiro
    num = converte_int(str, 10); // converte inteiro

    // TODO: TIRAR ISSO DAQUI DEPOIS
    printf("O numero escolhido foi %d\n", num);

    print_binary(num, str_bin); // print binário
    char str_pura[33] = {'0', 'b'};

    printf("%s\n", str);     // print inteiro
    print_hex(num, str_hex); // print hexadecimal
    print_swap(str_hex);     // print swap
  }

  return 0;
}
