.text
.globl operation

operation:
# Reservar espaço na pilha para armazenar os argumentos extras
# carregar os elementos que estão na pilha
lw t0, 0(sp)        # carregar i
lw t1, 4(sp)        # carregar j
lw t2, 8(sp)        # carregar k
lw t3, 12(sp)       # carregar l
lw t4, 16(sp)       # carregar m
lw t5, 20(sp)       # carregar n

# carregar o argumentos de a1 -> a6 na pilha
addi sp, sp, -4
sw a5, 0(sp)        # salvar f
sw a4, 4(sp)        # salvar e
sw a3, 8(sp)        # salvar d
sw a2, 12(sp)       # salvar c
sw a1, 16(sp)       # salvar b
sw a0, 20(sp)       # salvar a
sw ra, 24(sp)
# Carregar os valores finais nos resgistradores a0-a7
mv a0, t5           # copia n em a0
mv a1, t4           # copia m em a1
mv a2, t3           # copia l em a2
mv a3, t2           # copia k em a3
mv a4, t1           # copia j em a4
mv a5, t0           # copia i em a5

mv t6, a7           # salva o valor de a7
mv a7, a6           # copia a6(g) em a7
mv a6, t6           # copia a7(h) em a6

jal mystery_function
lw ra, 24(sp)
addi sp, sp, 4
# Liberar espaço da pilha e retornar
ret
