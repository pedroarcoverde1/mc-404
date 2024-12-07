# apenas caller-save registers

.text
.globl my_function

my_function:
addi sp, sp, -16
sw ra, 0(sp)
# a0 : valor 1
# a1 : valor 2
# a2 : valor 3

# SUM 1 -> soma os dois primeiros valores
mv t0, a0           # copia o valor de a0 em t0
mv t1, a1           # copia o valor de a1 em t1
mv t2, a2           # copia o valor de a2 em t2

sum_1:
add t3, t0, t1      # computa a soma do dois primeiros

#salva os valores na pilha
addi sp, sp, -16    # desce a pilha
sw t3, 0(sp)        # salva SUM 1 no topo
sw a2, 4(sp)        # salva o terceiro num
sw a1, 8(sp)        # salva o segundo num
sw a0, 12(sp)       # salva o terceiro num

call_1:
mv a0, t3           # salva sum 1 em a0
mv a1, t0           # salva o valor 1 em a1
jal mystery_function# chama a função

diff_1:
mv t4, a0           # joga o resultado da função em t4
lw t3, 0(sp)        # carrega SUM 1 no topo
lw a2, 4(sp)        # carrega o terceiro num
lw a1, 8(sp)        # carrega o segundo num
lw a0, 12(sp)       # carrega o terceiro num

sub t4, a1, t4      # diferença  entre o segundo valor e o retorno da função

sum_2:
add t4, a2, t4      # soma o terceiro valor com a diferença

call_2:
#salva os valores na pilha
sw t4, 0(sp)        # salva SUM 2 no topo
sw a2, 4(sp)        # salva o terceiro num
sw a1, 8(sp)        # salva o segundo num
sw a0, 12(sp)       # salva o terceiro num

mv a0, t4           # salva sum 2 em a0
mv a1, a1           # joga o segundo valor em a1

jal mystery_function

diff_2:
mv t5, a0           # joga o resultado da função em t5
lw t4, 0(sp)        # carrega SUM 2 no topo
lw a2, 4(sp)        # carrega o terceiro num
lw a1, 8(sp)        # carrega o segundo num
lw a0, 12(sp)       # carrega o terceiro num
sub t5, a2, t5

sum_3:
add t5, t5, t4
mv a0, t5
addi sp, sp, 16

lw ra, 0(sp)
addi sp, sp, 16
ret

