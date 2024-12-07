.bss
    arg:
        .skip 4             # reserva 4 bytes para o inteiro de argumento no cálculo da raiz quadrada
    sqrt:
        .skip 4             # reserva 4 bytes para o inteiro referente à raiz quadrada
    num_int:
        .skip 4             # reserva 4 bytes para o inteiro referente ao num inteiro
    input:
        .skip 20            # reserva 20 bytes para o buffer de input
    output:
        .skip 20            # reserva 20 bytes para o buffer de output


.section .text
.global _start

_start:
call main                   # chama a função main

read:
li a0, 0                    # file descriptor = 0 (stdin)
li a7, 63                   # syscall read (63)
ecall
ret

write:
li a0, 1                    # file descriptor = 1 (stdout)
li a7, 64                   # syscall write (64)
ecall
ret

ascii_to_int:
#addi t0, zero, 0           # define o inicio do loop com 0
lw t2, 0(a1)                    # joga o limite do loop em t2                
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
la t4, num_int
sw t1, 0(t4)                # salva o valor de t1 no endereço de num_int
ret

int_to_ascii:
la t4, sqrt                 # salva o endereço de sqrt em t4
lw t1, 0(t4)                # carrega o valor da raiz quadrada em t1
#la t0, output               # conecta o t0 ao endereço do output
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
li t4, 32                   # adiciona o espaço quando acaba 
sb t4, 0(a1)                # salva o espaço no a1
addi a1, a1, 1              # avança o a1
ret


main:

la a1, input                # joga o endereço do buffer de input no a1
li a2, 2                   # joga o tamanho do buffer em a2 
jal read                    # chama a função read

la a0, input                # joga o valor de input em a0
li a1, 2                   # joga o valor do tamanho do buffer
jal ascii_to_int            # chama a função de conversão

la a1, output
la t0, num_int
la t1, sqrt
sw t1, 0(t0)
jal int_to_ascii

la a1, output
li a2, 2
jal write

li a7, 93                   # call de exit
ecall