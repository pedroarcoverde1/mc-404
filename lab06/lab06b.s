.section .text
.global _start

_start:
call main                   # chama a função main

read_pos:
li a0, 0                    # Descriptor para stdin
la a1, input_pos            # Endereço do buffer de input
li a2, 11                   # Tamanho do buffer (20 bytes)
li a7, 63                   # Chamada de sistema para read (63)
ecall
ret

read_tempos:
li a0, 0                    # Descriptor para stdin
la a1, input_tempos         # Endereço do buffer de input
li a2, 12                  # Tamanho do buffer (20 bytes)
li a7, 63                   # Chamada de sistema para read (63)
ecall
ret

write:
li a0, 1                    # file descriptor = 1 (stdout)
la a1, output               # buffer
li a2, 12                   # size 20 bytes
li a7, 64                   # syscall write (64)
ecall
ret

########################### # função normal de conversão de ascii para int
ascii_to_int_pos:
li t2, 5                    # quantidade de bits a serem lidos       
li t1, 0                    # inicialização por segurança
li s0, 1                    # booleano de sinal --> 1 por default
                            # checagem de sinal
lbu t0, 0(a0)               # carrega o primeiro caracetere do buffer
li t4, 45
li t5, 43
beq t0, t4, negative_num    # verificação de negativo
# num positivo
addi a0, a0, 1              # avança o buffer
addi t2, t2, -1             # reduz o parser
j 1f              # pula para o loop de conversão
negative_num:
addi s0, s0, -2             # verificador de neg = -1
addi a0, a0, 1              # avança no buffer
addi t2, t2, -1             # reduz o parser do loop

1:               # loop de conversão normal        
beq t2, zero, done_convert_pos  # compara o t2 com 0
lbu t3, 0(a0)               # adiciona o valor do caractere ascii na var temp t3
addi t3, t3, -48            # adiciona o valor do inteiro correspondente em t3
li t4, 10                   # adiciona o valor 10 em um registrador t4
mul t1, t1, t4              # multiplica num_int por 10 e salva em t1
add t1, t1, t3              # adiciona o inteiro correspondente em t1
addi a0, a0, 1              # avança o a0 == input em 1 byte --> vai para o próximo caractere
addi t2, t2, -1             # adiciona 1 em t1 para evitar loop infinito
j 1b                        # pula pro inicio do loop

done_convert_pos:
mul t1, t1, s0              # aplica o sinal  
ret
############################################################
ascii_to_int:
li t2, 4                    # joga o limite do loop em t2                
li t1, 0

loop_convert:                       
beq t2, zero, done_convert  # compara o t2 com 0
lbu t3, 0(a0)               # adiciona o valor do caractere ascii na var temp t3
addi t3, t3, -48            # adiciona o valor do inteiro correspondente em t3
li t4, 10                   # adiciona o valor 10 em um registrador t4
mul t1, t1, t4              # multiplica num_int por 10 e salva em t1
add t1, t1, t3              # adiciona o inteiro correspondente em t1
addi a0, a0, 1              # avança o a0 == input em 1 byte --> vai para o próximo caractere
addi t2, t2, -1             # adiciona 1 em t1 para evitar loop infinito
j loop_convert              # pula pro inicio do loop

done_convert:
ret

########################### # função de calcular raiz quadrada
calculate_sqrt:
la t4, num_int              # salva o endereço de num_int em t4
lw t0, 0(t4)                # salva o valor de num_int na var temp t0
addi t1, zero, 0            # o t1 vai ser o nosso resultado --> começa com 0
srai t1, t0, 1              # (k = y/2)
addi t2, zero, 21           # cria a var temp t2 que leva o total de interações  

loop_sqrt:
beq t2, zero, done_sqrt     # verifica se o t2 == 0 (condição de término)
div t3, t0, t1              # divide o num_int pela raiz e salva em t3
add t1, t1, t3              # adiciona o novo t3 ao sqrt
srai t1, t1, 1              # divide o sqrt por 2
addi t2, t2, -1             # adiciona -1 ao t2 para evitar loop infinito
j loop_sqrt                 # jump para o início do loop

done_sqrt:
mv a2, t1
j 2f

########################### # função de conversão int para ascii

int_to_ascii:
mv t1, a2
addi t3, zero, 1000

int_to_ascii_loop:
beq t3, zero, done_int_to_ascii # verifica se o parser chegou a 0
div t2, t1, t3              # divide o argumento por 1000->100->10->1
addi t2, t2, 48             # converte de volta para caractere ascii
sb t2, 0(a1)                # adicinoar o caractere do buffer de output
rem t1, t1, t3              # aplica o resto para a proxima iteração
addi a1, a1, 1              # avança os 4 bytes do numero
li t4, 10                   # carrega o valor 10 no registrador t4
div t3, t3, t4              # reduz o parser 
j int_to_ascii_loop

done_int_to_ascii:
ret

############################# seção para calcular as distâncias
calcula_distancia:

li t5, 3                    # Valor de 0.3 para multiplicação
li t6, 10                   # valor de 10 em t5

sub s7, s6, s3              # dA = (TR - TA)
sub s8, s6, s4              # dB = (TR - TB)
sub s9, s6, s5              # dC = (TR - TC)

mul s7, s7, t5              # multiplica dA por 3
div s7, s7, t6              # divide dA por 10
mul s8, s8, t5              # multiplica dB por 3
div s8, s8, t6              # divide dB por 10
mul s9, s9, t5              # multiplica dB por 3
div s9, s9, t6              # divide dB por 10
ret

############################# função calcula y

calcula_y:

li t4, 0                    # carrega o valor de 0 em t4

sub t0, s7, s8              # dA - dB
add t1, s7, s8              # dA + dB
mul t1, t1, t0              # dA² - dB² -> (dA + dB)*(dA - dB)

li t5, 2                    # valor para divisão e multiplicação

mul t2, s2, t5              # 2 * YB
div t1, t1, t2              # (dA^2 - dB^2) / 2YB
             
div t3, s2, t5              # yB² / 2Yb = Yb/2

add t1, t1, t3              # y = (dA^2 - dB^2) / 2YB + Yb/2
mv s11, t1
ret
############################# função calcula x
calcula_x:

add t0, s7, s11
sub t1, s7, s11              # dA^2 - y^2 --> (dA+y) * (dA-y) --> t2
mul t1, t1, t0

la t3, num_int              # salva o endereço de num_int em t3
sw t1, 0(t3)                # salva o valor de t2 em num_int

j calculate_sqrt          # Chama função para calcular sqrt(dA^2 - y^2)

2:

neg t0, a2                  # x2 = -sqrt
mv t1, a2                   # x1 = sqr
                            # Escolher qual x satisfaz a equação
add t2, s9, s11             # (dC+Y)
sub t3, s9, s11             # (dc-Y)

mul t4, t3, t2              # dC²-Y²-->(dC+Y)*(dc- Y)
# t2 e t3 livres
sub t5, t1, s1              # x1 - XC
mul t5, t5, t5              # (x1 - XC)^2

sub t2, t5, t4              # distancia do x1 do resultado

sub t3, t0, s1              # x2 - XC
mul t3, t3, t3              # (x2 - XC)^2

sub t6, t3, t4              # distancia de x2 do resultado

bgt t2, t6, choose_x2       # Se x1 for mais próximo, escolhe x1
j done_x

choose_x2:
mv t1, t0                   # Escolhe x2

done_x:
mv s10, t1
ret

########################### # função main
main:

jal read_pos                # função de leitura do buffer
la a0, input_pos            # carrego o endereço de input no a0

jal ascii_to_int_pos        # o buffer de input_coord ja está em a0
mv s2, t1                   # salva o nuemro de t1 em yb

addi a0, a0, 1              # AVANÇA NO BUFFER DE INPUT_POS 

jal ascii_to_int_pos        # chama a função de conversão denovo
mv s1, t1                   # salva o valor de num_int em xc

addi a0, a0, 1              # AVANÇA NO BUFFER

jal read_tempos             # chama a função read
la a0, input_tempos         # carrega o valor de input_tempos em a0

jal ascii_to_int            # chama a função de conversão --> primeiro termo
mv s3, t1                   # salva o valor de num_int em time_a

addi a0, a0, 1              # avança no buffer --> estou pulando espaço ' '

jal ascii_to_int            # chama novamente a função de conversão --> segundo termo
mv s4, t1                   # salva o valor de num_int em time_b

addi a0, a0, 1              # avança outro espaço ' '

jal ascii_to_int            # outra chamada da função de conversão--> terceiro termo
mv s5, t1                   # salva num_int em time_c

addi a0, a0, 1              # avança outro espaço ' '

jal ascii_to_int            # chama a função de conversão para o  ultimo termo do buffer
mv s6, t1                # salva num_int em time_r

addi a0, a0, 1              # alcança o '\n'

jal calcula_distancia       # chama a função para calcular distâncias (da, db, dc)

############################# seção para calcular o valor da coordenada y
jal calcula_y
########################### # seção para calcular o valor da coordenada x
jal calcula_x
########################### # Output x, y

                            # Printar x com sinal          
 # salva o valor de coord_x em t1
mv t1, s10

la a1, output

blt t1, zero, neg_x         # verfica se é negativo
li t0, 43                   # carrega o valor de '+' em t0


sb t0, 0(a1)                # salva o '+' na primeira posição do output
addi a1, a1, 1
j print_x                   # jump para a o print de x

neg_x:                      # caso do numero ser negativo
li t0, 45                   # carrega o valor de '-' 
sb t0, 0(a1)                # salva na primeira posição do output
addi a1, a1, 1
neg t1, t1                  # Transforma em positivo para printar

print_x:
mv a2, t1
jal int_to_ascii            # chama a função de voltar para ascii
li t4, 32                   # adiciona o espaço quando acaba 
sb t4, 0(a1)                # salva o espaço no a1
addi a1, a1, 1              # avança o a1

# Printar y com sinal      
mv t1, s11

blt t1, zero, neg_y         # verifica se é negativo
li t0, 43                   # carrega o '+' em t0
sb t0, 0(a1)                # salva na primeira posição do buffer
addi a1, a1, 1
j print_y                   # jump para o print

neg_y:
li t0, 45
sb t0, 0(a1)
addi a1, a1, 1
neg t1, t1                  # Transforma em positivo para printar

print_y:
mv a2, t1
jal int_to_ascii            # chama a função de conversão 

li t2, 10                   # numero do caractere \n 
sb t2, 0(a1)               # adiciona no final do buffer de output e salva

jal write                   # printa o buffer de output

li a0, 0
li a7, 93                   # call de exit
ecall

.bss
sqrt:               .skip 4        # valor de calculo de raiz quadrada
.align 4
input_pos:          .skip 12      # Buffer de input (para leitura de coordenadas e tempos)
.align 4
input_tempos:       .skip 20
.align 4
output:             .skip 12       # Buffer de output (para escrita das coordenadas)
.align 4
num_int:            .skip 4 
.align 4