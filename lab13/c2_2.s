.text
.globl middle_value_int
.globl middle_value_short
.globl middle_value_char
.globl value_matrix


middle_value_int:
srai a1, a1, 1       # divide o valor de n por 2
slli t0, a1, 2       # Multiplica a1 por 4, int -> 4 bytes
add t0, a0, t0       # soma com o inicio do array
lw a0, 0(t0)         # carrega o valor em a0 para retorno
ret

middle_value_short:
srai a1, a1, 1       # divide o valor de n por 2
slli t0, a1, 1       # Multiplica a1 por 2, half -> 2 bytes
add t0, a0, t0       # soma com o inicio do array
lh a0, 0(t0)         # carrega o valor em a0 para retorno
ret

middle_value_char:
srai a1, a1, 1       # divide o valor de n por 2
add t0, a0, a1       # soma com o inicio do array
lb a0, 0(t0)         # carrega o valor em a0 para retorno
ret

#int value_matrix(int matrix[12][42], int r, int c){
#    return matrix[r][c];
#};

value_matrix:
# a0 -> valor de memória da matriz (12 linhas, 42 colunas) -> int
# a1 -> valor da linha
# valor da coluna
li t0, 42             # num de colunas
mul t0, a1, t0        # t0 = r * 42
add t0, t0, a2        # t0 = r * 42 + c
slli t0, t0, 2        # t0 = (r * 42 + c) * 4 ( int são 4 bytes)

add t0, a0, t0        # soma no enderço de inicio da matriz
lw a0, 0(t0)          # Carrega matrix[r][c] em a0 (retorno)
ret