# funções traduzidas na norma ABI

# puts(buffer)
# void puts ( const char *str );
.text 
.globl gets
.globl puts
.globl atoi
.globl itoa
.globl exit
.globl recursive_tree_search

puts:
addi sp, sp, -4
sw ra, 0(sp)
# o endereço da string está no a0
# pega o tamanho da string
mv a1, a0
li a2, 0
1:
lbu t1, 0(a0)               # carrega o caractere atual
addi a2, a2, 1              # avança o tamanho da string também
beqz t1, 1f                 # verifica se é igual a 0 (\0)
addi a0, a0, 1              # se não for avança no buffer
j 1b                        # pula para o inicio do loop

1:
li t0, 10                   # carrega o valor de \n 
sb t0, 0(a0)                # salva o \n de volta no final do buffer
li a0, 1
# a1 ja foi definido
# a2 ja foi definido                    
li a7, 64
ecall
ret



# função de gets -> lê o input e bota no buffer de input
gets:
li t0, 0
li t2, 10
la a1, buffer
addi sp, sp, -4
sw ra, 0(sp)

read_loop:
li a0, 0
#li a1, buffer
li a2, 1
li a7, 63
ecall

lb t1, 0(a1)
beq t1, t2, end
addi t0, t0, 1
addi a1, a1, 1
j read_loop

end:
sb zero, 0(a1)
sub a0, a1, t0

lw ra, 0(sp)
addi sp, sp, 4


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
addi sp, sp, -4
sw ra, 0(sp)          
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
lw ra, 0(sp)
addi sp, sp, 4
ret                         # retorna o a0 apontando para o buffer revertido


# função exit -> função de saída do código
exit:
li a7, 93
ecall

# função linked_list_search  -> realiza a busca na lista ligada
# int linked_list_search(Node *head_node, int val);
# a0 é para estar setado como o endereço de head_node
# a1 é para estar setado como o valor a ser encontrado

recursive_tree_search:
# vamos realizar uma busca numa arvore binária
# a árvore não está organizada

# a0 --> endereço do head_node
# a1 --> valor a ser procurado

li t0, 1            # profundidade
li t5, 1            # indicador de esquerda
li t6, 2            # indicador de direita
addi sp, sp, -8     # reserva espaço na pilha para o endereço do nó anterior e um flag
sw zero, 0(sp)      # joga zero na pilha (endereço do nó anterior)
sw zero, 4(sp)      # flag para indicar se é filho esquerdo ou direito

search_loop:        # loop de procura
lw t1, 0(a0)        # carrego o valor a ser comparado
lw t2, 4(a0)        # carrego o endereço do node da esquerda
lw t3, 8(a0)        # carrego o endereço do node da direita

beq t1, a1, found   # faço a verificação do valor do node

# se o valor for diferente eu tenho que ir pro node da esquerda
bgt t2, zero, left  # só pula se o valor do endereço for diferente de null
bgt t3, zero, right # só pula se o valor do endereço for diferente de null

# caso em que a direita e a esqueda são null
# tenho que voltar para o node anterior e setar o atual como null
lw a0, 0(sp)        # carrega o endereço do node anterior da pilha
lw t4, 4(sp)        # verificador de flag
addi sp, sp, 8      # encurta a pilha
addi t0, t0, -1     # recua a profundidade
beqz a0, not_found  # se o valor não existir o valor que o head_node vira é zero

# Verifica se o nó atual é o filho esquerdo ou direito
beq t4, t5, set_left_null # se o flag for 1, setar filho esquerdo como null
beq t4, t6,set_right_null #se o flag for 2, setar filho direito como null

j search_loop       # pula pro loop de procura

set_left_null:
sw zero, 4(a0)      # seta o filho esquerdo do nó anterior como null
j search_loop       # volta para o loop de procura

set_right_null:
sw zero, 8(a0)      # seta o filho direito do nó anterior como null
j search_loop       # volta para o loop de procura


left:
addi sp, sp, -8     # gravo o endereço do nó atual e o flag antes de pular
sw a0, 0(sp)        # salva o endereço do nó atual
li t4, 1            # marca que viemos do filho esquerdo
sw t4, 4(sp)        # salva o flag
lw a0, 4(a0)        # pulo para o nó da esquerda
addi t0, t0, 1      # aumenta a profundidade
j search_loop       # volta para o loop de procura

right:
addi sp, sp, -8     # gravo o endereço do nó atual e o flag antes de pular
sw a0, 0(sp)        # salva o endereço do nó atual
li t4, 2            # marca que viemos do filho direito
sw t4, 4(sp)        # salva o flag
lw a0, 8(a0)        # pulo para o nó da direita
addi t0, t0, 1      # aumenta a profundidade
j search_loop       # volta para o loop de procura


not_found:
li t0, 0
found:
mv a0, t0           # jogo o valor da profundidade em a0 
ret                 # retorno

