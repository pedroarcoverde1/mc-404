.text
.globl _start

_start:
call main                   # chama a função main

read_4bits:
li a0, 0                    # Descriptor para stdin 
la a1, input_4bits
li a2, 5
li a7, 63                   # Chamada de sistema para read (63)
ecall
ret

read_7bits:
li a0, 0                    # Descriptor para stdin 
la a1, input_7bits
li a2, 8
li a7, 63                   # Chamada de sistema para read (63)
ecall
ret


write_4bits:
li a0, 1
la a1, output_4bits
li a2, 5
li a7, 64
ecall
ret

write_7bits:
li a0, 1
la a1, output_7bits
li a2, 8
li a7, 64
ecall
ret
write_error:
li a0, 1
la a1, output_error
li a2, 2
li a7, 64
ecall
ret

############################ # função de conversão de ascii para int

ascii_to_bin_4bits:
li t2, 4                    # joga o limite do loop em t2                
li t1, 0

loop_convert_4bits:                       
beq t2, zero, done_convert_4bits  # compara o t2 com 0
lbu t3, 0(a0)               # adiciona o valor do caractere ascii na var temp t3
addi t3, t3, -48            # adiciona o valor do inteiro correspondente em t3
li t4, 2                    # adiciona o valor 2 (bin) em um registrador t4
mul t1, t1, t4              # multiplica num_int por 10 e salva em t1
add t1, t1, t3              # adiciona o inteiro correspondente em t1
addi a0, a0, 1              # avança o a0 == input em 1 byte --> vai para o próximo caractere
addi t2, t2, -1             # adiciona 1 em t1 para evitar loop infinito
j loop_convert_4bits              # pula pro inicio do loop

done_convert_4bits:
la t4, num_bin
sw t1, 0(t4)                # salva o valor de t1 no endereço de num_int
ret

############################# função de conversão para 7 bits
ascii_to_bin_7bits:
li t2, 7                    # joga o limite do loop em t2                
li t1, 0

loop_convert_7bits:                       
beq t2, zero, done_convert_7bits  # compara o t2 com 0
lbu t3, 0(a0)               # adiciona o valor do caractere ascii na var temp t3
addi t3, t3, -48            # adiciona o valor do inteiro correspondente em t3
li t4, 2                    # adiciona o valor 2 (bin) em um registrador t4
mul t1, t1, t4              # multiplica num_int por 10 e salva em t1
add t1, t1, t3              # adiciona o inteiro correspondente em t1
addi a0, a0, 1              # avança o a0 == input em 1 byte --> vai para o próximo caractere
addi t2, t2, -1             # adiciona 1 em t1 para evitar loop infinito
j loop_convert_7bits              # pula pro inicio do loop

done_convert_7bits:
la t4, num_bin
sw t1, 0(t4)                # salva o valor de t1 no endereço de num_int
ret



########################### # função de hamming encode

hamming_encode:
                            # Input: número binário de 4 bits em a0
                            # Output: código Hamming de 7 bits em hamming_code_buffer

                            # Extrai os bits de dados d1, d2, d3, d4
                            # suponho que o valor do numero ja fois associado à variável a0
lw t0, 0(a0)
andi t1, t0, 1              # faço um AND com o primeiro termo para conseguir d4
srli t2, t0, 1              # faço um shift para a direita para pegar o proximo bit
andi t2, t2, 1              # d3
srli t3, t0, 2
andi t3, t3, 1              # d2
srli t4, t0, 3
andi t4, t4, 1              # d1

                            # Calcula os bits de paridade
xor  t5, t4, t3             # p1 = d1 XOR d2 XOR d4
xor  t5, t5, t1
xor  t6, t4, t2             # p2 = d1 XOR d3 XOR d4
xor  t6, t6, t1
xor  s1, t3, t2             # p3 = d2 XOR d3 XOR d4
xor  s1, s1, t1

                            # Armazena no buffer os bits na ordem: p1 p2 d1 p3 d2 d3 d4
la   a0, output_7bits
addi t5, t5, '0'
sb   t5, 0(a0)              # p1

addi t6, t6, '0'
sb   t6, 1(a0)              # p2

addi t4, t4, '0'
sb   t4, 2(a0)              # d1

addi s1, s1, '0'
sb   s1, 3(a0)              # p3

addi t3, t3, '0'
sb   t3, 4(a0)              # d2

addi t2, t2, '0'
sb   t2, 5(a0)              # d3

addi t1, t1, '0'
sb   t1, 6(a0)              # d4

li   s5, 10                 # carrega o valor de '\n' em t1
sb   s5, 7(a0)              # adiciona no final do buffer

ret

########################### # função de hamming decode

                            # Decodifica 7 bits e verifica a presença de erros
hamming_decode:
la a0, num_bin
lw t0, 0(a0)                # Carrega os 7 bits codificados
la a1, output_4bits

                            # Extrai os bits codificados
srli t1, t0, 6              # p1
andi t1, t1, 1
srli t2, t0, 5              # p2
andi t2, t2, 1
srli t3, t0, 4              # d1
andi t3, t3, 1
srli t4, t0, 3              # p3
andi t4, t4, 1
srli t5, t0, 2              # d2
andi t5, t5, 1
srli t6, t0, 1              # d3
andi t6, t6, 1
andi s1, t0, 1              # d4

                            # Verifica os bits de paridade
xor s2, t1, t3              # Verifica p1
xor s2, s2, t5
xor s2, s2, s1              # p1 XOR d1 XOR d2 XOR d4
xor s3, t2, t3              # Verifica p2
xor s3, s3, t6
xor s3, s3, s1              # p2 XOR d1 XOR d3 XOR d4
xor s4, t4, t5             # Verifica p3
xor s4, s4, t6
xor s4, s4, s1            # p3 XOR d2 XOR d3 XOR d4

                            # Se qualquer um dos resultados for diferente de 0, há erro
or s5, s2, s3
or s5, s5, s4
addi s5, s5, '0'
la a3, output_error
sb s5, 0(a3)               # 1 se erro, 0 se não
li s7, 10
sb s7, 1(a3)

                            # TODO:perforamar conversão para ascii e armazena os bits decodificados
la a0, output_4bits
addi t3, t3, '0'
sb t3, 0(a0)

addi t5, t5, '0'
sb t5, 1(a0)

addi t6, t6, '0'
sb t6, 2(a0)

addi s1, s1, '0'
sb s1, 3(a0)


li t1, 10                   # carrega o valor de '\n' em t1
sb t1, 4(a0)               # adiciona no final do buffer
ret


########################### # função main
main:
                            # ler o input de 4bits
jal read_4bits
la a0, input_4bits

.align 2                            # transforma o input de ascii para binário
li a2, 7
jal ascii_to_bin_4bits            # tenho o numero convertido no rótulo num_bin

.align 2                            # joga ele na função de hamming encode
la a0, num_bin
jal hamming_encode          # output_7bits esta com os valores prontos

                            # printa o buffer de 7 bits
jal write_7bits

                            # ler o input de 7 bits
jal read_7bits
la a0, input_7bits

li a2, 4                    # transforma o input de ascii para binário
jal ascii_to_bin_7bits

                            # joga na função de hamming decode
jal hamming_decode          # output_4bits está agora disponível

                            # printa o buffer de output_4bits
jal write_4bits

                            # printa o buffer de erro
jal write_error

li a0, 0
li a7, 93                   # call de exit


.bss
num_bin:        .skip 4
.align 2
input_4bits:    .skip 5
.align 2
input_7bits:    .skip 8
.align 2
output_4bits:   .skip 5
.align 2
output_7bits:   .skip 8
.align 2
output_error:   .skip 2
