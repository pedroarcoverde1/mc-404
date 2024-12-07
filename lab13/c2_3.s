.text
.globl fill_array_int
.globl fill_array_short
.globl fill_array_char

fill_array_int:
addi sp, sp, -16        
sw ra, 0(sp)

addi sp, sp, -400       # desce a pilha (100 espaços de 4 bytes)
mv t0, sp               # copia o incio da pilha em t0
li t1, 0                # parser
li t2, 100

1:
sw t1, 0(t0)            # salva int no espaço t0
addi t1, t1, 1          # incrementa o num em 1
addi t0, t0, 4          # incrementa a memória em 4
beq t1, t2, 1f          # acaba quando o num for 100
j 1b                    # se n acabar volta para o topo do loop
1:
mv a0, sp               # copia o inicio da pilha para a0
jal mystery_function_int

addi sp, sp, 400
lw ra, 0(sp)
addi sp, sp, 16
ret

fill_array_short:
addi sp, sp, -16
sw ra, 0(sp)            # salva ra

addi sp, sp, -200       # desce a pilha (100 espaços de 2 bytes)
mv t0, sp               # copia o incio da pilha em t0
li t1, 0                # parser
li t2, 100

1:
sh t1, 0(t0)            # salva int no espaço t0
addi t1, t1, 1          # incrementa o num em 1
addi t0, t0, 2          # incrementa a memória em 2
beq t1, t2, 1f          # acaba quando o num for 100
j 1b                    # se n acabar volta para o topo do loop
1:
mv a0, sp               # copia o inicio da pilha para a0
jal mystery_function_short

addi sp, sp, 200        # sobe a pilha
lw ra, 0(sp)          # carrega o ra
addi sp, sp, 16
ret

fill_array_char:
addi sp, sp, -16
sw ra, 0(sp)
addi sp, sp, -100       # desce a pilha (100 espaços de 4 bytes)
mv t0, sp               # copia o incio da pilha em t0
li t1, 0                # parser
li t2, 100

1:
sb t1, 0(t0)            # salva int no espaço t0
addi t1, t1, 1          # incrementa o num em 1
addi t0, t0, 1          # incrementa a memória em 4
beq t1, t2, 1f          # acaba quando o num for 100
j 1b                    # se n acabar volta para o topo do loop
1:
mv a0, sp               # copia o inicio da pilha para a0
jal mystery_function_char
addi sp, sp, 100
lw ra, 0(sp)
addi sp, sp, 16
ret
