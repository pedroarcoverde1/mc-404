.text
.globl _start

_start:
call main
# primeiro a função de ler 
read:
li a0, 0
la a1, input
li a2, 6
li a7, 63
ecall
ret

# depois a função de printar
write:
li a0, 1
la a1, output
#li a2, 2                   # tamanho variável
li a7, 64
ecall
ret

# depois a função de saber tamanho
len:
li t0, 0                    # tamanho do buffer
li t1, 10                   # \n    
la a0, input

loop:
lbu t2, 0(a0)               # carrega o caractere
beq t2, t1, 1f              # se for igual a \n acaba
addi t0, t0, 1              # aumenta o tamanho
addi a0, a0, 1
j loop
1:
mv a0, t0
ret

# depois a função de converter para int
ascii_to_int:
li t0, 45
li t1, 0
li t5, 1                    # flag pos|neg
mv t2, a0                   # a0 estava com o tamanho do buffer
la a0, input                # carrega o endereço do input em a0

loop_convert:                       
beq t2, zero, done_convert  # compara o t2 com 0
lbu t3, 0(a0)               # adiciona o valor do caractere ascii na var temp t3
beq t3, t0, neg             # se for negativo aciona a flag de negativo
addi t3, t3, -48            # adiciona o valor do inteiro correspondente em t3
li t4, 10                   # adiciona o valor 10 em um registrador t4
mul t1, t1, t4              # multiplica num_int por 10 e salva em t1
add t1, t1, t3              # adiciona o inteiro correspondente em t1
addi a0, a0, 1              # avança o a0 == input em 1 byte --> vai para o próximo caractere
addi t2, t2, -1             # adiciona 1 em t1 para evitar loop infinito
j loop_convert              # pula pro inicio do loop

neg:
li t5, -1                   # flag de negativo ativada
addi t2, t2, -1
addi a0, a0, 1
j loop_convert              # volta para a conversão

done_convert:
mul t1, t1, t5              # multiplica pela flag
mv a0, t1                   # joga o numero em a0
ret

# depois a função de loop de procura
search:
# o valor de input está no s1
li t0, 0                    # faz um index da lista ligada atual (t0)--> começa no 0
la a0, head_node            # carrega o endereço do head em a0

search_loop:
lw t1, 0(a0)                # carrega o valor do primeiro inteiro
lw t2, 4(a0)                # carrega o segundo valor 
add t1, t1, t2              # soma os dois valores
beq t1, s1, found           # verifica se é igual ao input
lw a0, 8(a0)                # carrega o valor do ponteiro em a0
beqz a0, not_found          # verifica se acabou a lista ligada
addi t0, t0, 1              # incrementa o index
j search_loop               # volta para o topo do loop

found:
mv a0, t0                   # se for igual printa o valor do index (t0)
j done
not_found:
li a0, -1
done:
ret
# função main
main:
jal read                    # leio o input --> a0
la a0, input                # carrego o endereço de input em a0

jal len                     # tenho o tamanho do buffer

# se eu tenho o tamanho do buffer eu sei quantos elementos eu tenho que converter
jal ascii_to_int
mv s1, a0

jal search
# botei o index no a0
# fazer a logica de se for -1
la a1, output
li t0, 0                     # Inicializa t0 com 0 para comparação
li t1, 10                    # Carregar o valor 10 para comparação
li t2, 100                   # Carregar o valor 100 para comparação
li t3, 1000                  # Carregar o valor 1000 para comparação

blt a0, t0, negative_index   # Se o valor é menor que 0, ir para negative_index
blt a0, t1, single_digit     # Se o valor é menor que 10, ir para single_digit
blt a0, t2, double_digit     # Se o valor é menor que 100, ir para double_digit
blt a0, t3, triple_digit     # Se o valor é menor que 1000, ir para triple_digit

# quatro dígitos
li t0, 1000
li t1, 100
li t2, 10 

div t3, a0, t0              # 2345(a0) / 1000(t0) = 2 (primeiro digito) -> t3
rem t4, a0, t0              # 2345(a0) % 1000(t0) = 345(t4) (resto)
div t5, t4, t1              # 345(t4) / 100(t1) = 3(t5) (segundo dígito) -> t5
rem t0, t4, t1              # 345(t4) % 100(t1) = 45(t0) (resto)
div t1, t0, t2              # 45(t0) / 10(t2) = 4(t1) (terceiro dígito)--> t1
rem t2, t0, t2              # 45(t0) % 10(t2) = 5 (t2) ( quarto dígito)--> t2

addi t3, t3, 48             # Converter primeiro dígito para ASCII
addi t5, t5, 48             # Converter segundo dígito para ASCII
addi t1, t1, 48             # Converter terceiro dígito para ASCII
addi t2, t2, 48             # Converter quarto dígito para ASCII

li t0, 10

sb t3, 0(a1)                # Armazenar o primeiro dígito no buffer
sb t4, 1(a1)                # Armazenar o segundo dígito no buffer
sb t1, 2(a1)                # Armazenar o terceiro dígito no buffer
sb t2, 3(a1)                # Armazenar o quarto dígito no buffer
sb t0, 4(a1)

li a2, 5                    # tamanho do buffer é 3 {"x"; "y"; "z"; "\n"}
jal write                   # chama a função de printar
j end_of_logic              # Ir para print_buffer

triple_digit:
li t0, 100
li t1, 10

div t2, a0, t0              # 234(a0) / 100(t0) = 2(t2) (primeiro dígito) --> t2
rem t3, a0, t0              # 234(a0) % 100(t0) = 34 (t3)
div t4, t3, t1              # 34(t3) / 10(t1) = 3(t4) (segundo dígito) --> t4
rem t5, t3, t1              # 34(t3) % 10(t1) = 4(t5) (terceiro dígito) --> t5

addi t2, t2, 48             # Converter primeiro dígito para ASCII
addi t4, t4, 48             # Converter segundo dígito para ASCII
addi t5, t5, 48             # Converter o terceiro dígito para ASCII

sb t2, 0(a1)                # Armazenar o primeiro dígito no buffer
sb t4, 1(a1)                # Armazenar o segundo dígito no buffer
sb t5, 2(a1)                # Armazenar o terceiro dígito no buffer
sb t1, 3(a1)                # adiciona o \n no buffer
li a2, 4                    # tamanho do buffer é 3 {"x"; "y"; "z"; "\n"}
jal write                   # chama a função de printar
j end_of_logic              # ir para o fim da logica

# Se for maior ou igual a 10, temos dois dígitos
double_digit:
li t1, 10
div t2, a0, t1              # 23(a0) / 10(t1) = 2 (t2) (primeiro dígito) --> t2
rem t3, a0, t1              # 23(a0) % 10(t1) = 3(t3) (segundo dígito) --> t3
addi t2, t2, 48             # Converter primeiro dígito para ASCII
addi t3, t3, 48             # Converter segundo dígito para ASCII

sb t2, 0(a1)                # Armazenar o primeiro dígito no buffer
sb t3, 1(a1)                # Armazenar o segundo dígito no buffer
sb t1, 2(a1)
li a2, 3                    # tamanho do buffer é 3 {"x"; "y"; "\n"}
jal write                   # chama a função de printar
j end_of_logic              # Ir para print_buffer

# se o numero for menor que 10 mas maior que -1 ele tem 1 dígito
single_digit:
addi t0, a0, 48             # 1 + 48 = 49 == '1'
sb t0, 0(a1)                # Armazenar o dígito no buffer
li t1, 10                   # \n
sb t1, 1(a1)                # Colocar \n no segundo byte
li a2, 2                    # aloca o tamanho do buffer para 2 {"x"; "\n"}
jal write                   # chama a função de printar
j end_of_logic

# se ele é menor que 0 ele é -1
negative_index:
li t0, 45                   # carrega o valor de '-'
li t1, 49                    # carrega o valor de 1
li t2, 10                   # carrega o valor de \n
sb t0, 0(a1)                # salva na primeira posição do buffer
sb t1, 1(a1)                # salva na segunda posição do buffer
sb t2, 2(a1)                # salva na terceira posição do buffer
li a2, 3                    # tamanho do buffer é 3 {"-"; "1"; "\n"}
jal write                   # chama a função de printar
j end_of_logic


end_of_logic:
li a0, 0
li a7, 93
ecall

.data
input: .skip 6
.align 2
output: .skip 5
