# trabalhando com periféricos usando serila port

.bss
buffer: .skip 50
.align 10
r_buffer: .skip 50
.align 10
aux_buffer: .skip 10 

.text 
# endereço base 
.set BASE, 0xFFFF0100       # endereço base do periférico
.globl _start
_start:
call main

write:
li a1, BASE

write_loop:
lbu t0, 0(a0)               # carrega o caractere do buffer em um resgistrador 
beqz t0, final_string       # compara com 0             
sb t0, 0x01(a1)             # salva esse caractere em base +0x01
li t1, 1                    # joga 1 na flag de write
sb t1, 0x00(a1)

1:
lb t2, 0x00(a1)           # carrega o byte na flag
beqz t2, 1f
j 1b    

1:
addi a0, a0, 1
j write_loop

final_string:
li t2, 10                   # joga \n no ultimo caractere
sb t2, 0x01(a1)           # salva o byte no espaço a ser printado
sb t1, 0x00(a1)           # printa
1:
lb t2, 0x00(a1)           # carrega o byte na flag
beqz t2, 1f
j 1b 
1:
ret


# função de gets -> lê o input e bota no buffer de input
read:
# devo setar a flag de read em base + 0x02 para ler 1 byte em base +0x03
li t0, 10
li t1, 0
la a0, buffer
li a2, 0xFFFF0100

read_loop:
li t2, 1                    # carregar 1 em um registrador
sb t2, 0x02(a2)             # salvar 1 no base + 0x02

1:
lb t2, 0x02(a2)           # carrega o byte na flag
beqz t2, 1f
j 1b    

1:
lbu a1, 0x03(a2)          # carregar o valor de base + 0x03 
sb a1, 0(a0)                # jogar ela no meu buffer de input
beq a1, t0, end             # comparar com \n
addi a0, a0, 1              # avança o buffer
addi t1, t1, 1              # avança o contador de tamanho
j read_loop

end:
sb zero, 0(a0)              # joga \0 no final em vez de \n
sub a0, a0, t1              # joga o a0 de volta para o incio do buffer
ret

# int atoi (const char *str);
# int atoi (const char *str);
atoi:                       # função atoi -> converte de ascii para int
addi sp, sp, -4
sw ra, 0(sp)

li t0, 0
mv t1, a0
li t6, 1
1:
lb t2, 0(t1)
beqz t2, 1f
addi t0, t0, 1
addi t1, t1, 1
j 1b
1:
# loop de conversão
mv a1, t0
convert_loop:
lbu t0, 0(a0)                # carrego o caractere
li t1, 0
li t2, 58
li t3, 'A'
li t5, 45
beq t0, t5, neg_sinal
blt t0, t2, convert_dec     # se for menor q 10 vamos para conversão decimal
bge t0, t3, convert_hex     # se for maior que 'A' vamos para a conversão hexadecimal

neg_sinal:
li t6, -1
addi a0, a0, 1
addi a1, a1, -1
j convert_loop

convert_hex:
beqz a1, end_convert
lb t0, 0(a0)
li t4, 16
mul t1, t1, t4              # multiplica o resgistrador de resultado pela base 16
addi t0, t0, -65            # tira 'A' do caractere
addi t0,t0, 10              # A = 10
add t1, t1, t0              # soma o registrador de resposta com o caractere
addi a0, a0, 1              # avança buffer 
addi a1, a1, -1             # reduz o parser
j convert_hex

convert_dec:
beqz a1, end_convert
lb t0, 0(a0)
li t4, 10                   # carrega a base 10
mul t1, t1, t4              # multiplica a resposta por 10
addi t0, t0, -48            # tira 48 do caractere
add t1, t1, t0              # adiciona o caractere atual 
addi a0, a0, 1              # avança o buffer
addi a1, a1, -1             # reduz o parser
j convert_dec

end_convert:
mul t1, t1, t6
mv a0, t1                   # move o valor de t1 para a0

lw ra, 0(sp)
addi sp, sp, 4
ret                         # retorna


# char *itoa ( int value, char *str, int base );
itoa:                      
# numero a ser convertido está em a0
# ponteiro para a string está em a1
# base está em a2

li t0, 0                    # inciar um indice
li t1, 0                    # fazer uma flag para negativo

bltz a0, negative_num       # verificação se o numero é negativo

itoa_loop:                  # loop de conversão
# vou fazer divisões sucessivas pela base
rem t2, a0, a2              # 2345 % 10 = 5
li t4, 10                   # joga 10 em t4
blt t2, t4, 1f              # se o resto for maior q 10 é hexa
# conversão hexadecimal
li t3, 'A'
addi t2, t2, -10            # tira 10 do numero
add t2, t2, t3              # joga a base hexadecimal
j 2f
1:
li t3, 48                   # mascara do ascii
add t2, t2, t3              # 5 -> '5'
2:
sb t2, 0(a1)                # salva o byte no buffer de output
addi a1, a1, 1              # avança o buffer
addi t0, t0, 1              # incrementa o indice
div a0, a0, a2              # 2345 / 10 = 234 (proxima iteração)

bnez a0, itoa_loop          # repete o loop até a0 = 0
bnez t1, add_neg            # faz a veruficação da flag de negativo
j end_itoa                  # pula para a finalização

negative_num:               # número a ser convertido é negativo
li t1, 1                    # flag_negativo = 1
neg a0, a0                  # deixa o número positivo
j itoa_loop

add_neg:                    # se a flag_neg == 1 adiciona o sinal '-' no buffer
li t4, 45                   # '-' == 45
sb t4, 0(a1)
addi a1, a1, 1              # avança o buffer
addi t0, t0, 1

end_itoa:
li t5, 0                    # joga 0 em t5
sb t5, 0(a1)                # salva o valor de \0 no buffer {'5'; '4'; '3'; '2'; '-'; '0'}

mv a0, a1                   # joga o valor de a1 em a0 --> retorno da função
sub a0, a0, t0              # subtrai a0 do indice -> a0 aponta para o incio do buffer

mv t0, a0                   # joga o valor de a0 em t0
addi a1, a1, -1             # tira o a1 do \0 (não vamos mexer nele)

reverse_loop:
bge t0, a1, end_reverse     # verifica se o index de t0 é maior q o de a1
lb t2, 0(t0)                # carrega o caractere do inicio em t2
lb t3, 0(a1)                # carrega o caractere do final em t3
sb t3, 0(t0)                # salva o final no inicio
sb t2, 0(a1)                # salva o inicio no final

addi t0, t0, 1              # avança o inicio
addi a1, a1, -1             # reduz o final

j reverse_loop              # volta para o incio do loop

end_reverse:                # função de término
ret                         # retorna o a0 apontando para o buffer revertido


reverse:
la a0, buffer               # Carrega o endereço do buffer em a0
la a1, r_buffer             # carrega o endereço do buffer de reversão
mv t0, a0                   # Armazena o início do buffer em t0


# Encontrar o final da string
find_end:
1:
lb t1, 0(t0)                # carrega o caractere
beqz t1, found_end
addi t0, t0, 1              # avança o buffer
j 1b

found_end:
addi t0, t0, -1             # saio do \0
2:
lbu t1, 0(t0)               # carrega o byte do final
sb t1, 0(a1)                # salva o byte no buffer revertido  
addi a1, a1, 1              # avança o buffer de reversão
beq t0, a0, 2f              # se t0 chegar no inicio acaba
addi t0, t0, -1             # recua o buffer original
j 2b

2:
li t1, 0
sb t1, 0(a1)
mv a0, a1
ret                         # Retorna da função


op1:
# salvar o ra
addi sp, sp, -4             # desce a pilha
sw ra, 0(sp)                # salva o ra na pilha

jal read                    # chamar  a função de read denovo
la a0, buffer               # suponho que a0 eteja com o valor do inicio do buffer
jal write                   # chamar a função de write

lw ra, 0(sp)                # carrega o ra original
addi sp, sp, 4              # sobe a pilha
ret

op2:
addi sp, sp, -4             # desce a pilha
sw ra, 0(sp)                # salva o ra na pilha

jal read                    # chamar a função de leitura
jal reverse                 # chamar a função de inverter
la a0, r_buffer               # suponho que a0 eteja com o valor do inicio do buffer
jal write                   # chama a função de escrever

lw ra, 0(sp)                # carrega o ra original
addi sp, sp, 4              # sobe a pilha
ret

op3:
                            # salvar o ra
addi sp, sp, -4             # desce a pilha
sw ra, 0(sp)                # salva o ra na pilha

jal read                    # ler o buffer representando um número
jal atoi                    # chama a função de converter para inteiro
# joga o numero a ser convertido em a0 -> retorno padrão de atoi
la a1, buffer               # joga o endereço do buffer em a1
li a2, 16                   # joga a base 16 no a2
jal itoa                    # chama a função de voltar para caractere
jal write                   # chama a função de printar

lw ra, 0(sp)                # carrega o ra original
addi sp, sp, 4              # sobe a pilha
ret

op4:
# salva o ra
addi sp, sp, -4             # desce a pilha
sw ra, 0(sp)                # salva o ra na pilha

jal read                    # lê uma string representando uma operação aritmética
la a1, buffer               # move o endereço do buffer pra a1
la a2, aux_buffer           # carrega o endereço do buffer auxiliar
1:                          # lê o primeiro número até o espaço
lbu t0, 0(a1)                # carrega o primeiro byte
li t1, 32                   # joga ' ' no t1
sb t0, 0(a2)                # joga o caractere no buffer auxiliar
beq t0, t1, 2f               # verifica se o byte é um espaço (32)
addi a1, a1, 1              # avança o buffer
addi a2, a2, 1              # avança o buffer auxiliar
j 1b                        # volta para o topo do loop

2:                          # acabou o primeiro número -> a1 = ' '
sb zero, 0(a2)              # joga um \0 no ultimo espaço
addi a1, a1, 1              # avança o buffer com a operação
mv s1, a1                   # salva o ponto atual do a1 -> 'op'
la a0, aux_buffer           # joga o buffer auxiliar em a0
jal atoi                    # chama a função de converter para inteiro
mv a4, a0                   # joga o primeiro número em a4
# lê a operação
mv a1, s1                   # devolve a posição para a1
lbu t0, 0(a1)               # carrega o caractere da operação
mv s2, t0                   # joga a operação em s2
addi a1, a1, 2              # tira o a1 do ' '

la a2, aux_buffer           # recarrega o buffer auxiliar no início
3:                          # lê o segundo número até o \n
li t1, 0                    # joga \0 no t1
lbu t0, 0(a1)               # carrega o primeiro byte
sb t0, 0(a2)                # joga o caractere no buffer auxiliar
beq t0, t1, 3f              # verifica se o byte é um espaço (32)
addi a1, a1, 1              # avança o buffer
addi a2, a2, 1              # avança o buffer auxiliar
j 3b                        # volta para o topo do loop

3:
sb zero, 0(a2)             # salva '\0' no ultimo caractere
la a0, aux_buffer           # joga o endereço do buffer auxiliar em a0
jal atoi                    # converte para inteiro
mv a5, a0                   # joga o valor do segundo número em a5

li t0, 42                   # carrega a flag de *
li t1, 43                   # carrega a flag de +
li t2, 45                   # carrega a flag de -
li t3, 47                   # carrega a flag de /

# verificação de qual é a operação
beq s2, t0, mul
beq s2, t1, add
beq s2, t2, sub
beq s2, t3, div

mul:
mul a0, a4, a5
j 5f

add:
add a0, a4, a5
j 5f

sub:
sub a0, a4, a5
j 5f

div:
div a0, a4, a5
j 5f

5:
la a1, buffer               # carrega o buffer para output
li a2, 10                   # joga a base 10
jal itoa                    # transforma o número de inteiro para ascii
la a0, buffer               # buffer em a0 agora
jal write                   # printa o buffer com a resposta
ret


# função exit -> função de saída do código
exit:
li a7, 93
ecall

main:
jal read                    # ['1', '\0']
lb t0, 0(a0)                # carreago o numero da operação

li t1, 49                   # se for 49 -> op 1
li t2, 50                   # se for 50 -> op 2
li t3, 51                   # se for 51 -> op 3
li t4, 52                   # se for 52 -> op 4

beq t0, t1, operation_1
beq t0, t2, operation_2
beq t0, t3, operation_3
beq t0, t4, operation_4

operation_1:
jal op1
jal exit
operation_2:
jal op2
jal exit
operation_3:
jal op3
jal exit
operation_4:
jal op4
jal exit