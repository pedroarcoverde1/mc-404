.text
.globl node_creation

node_creation:
addi sp, sp, -8        # desce a pilha

li t0, 0b00000000000000000000000000011110               # t0 = 30
sw t0, 0(sp)            # node.a = 30

li t0, 0b00000000000000000000000000011001       # t0 = 25
sb t0, 4(sp)            # node.b = 25

li t0, 0b00000000000000000000000001000000       # t0 = 64
sb t0, 5(sp)            # node.c = 64

li t0, 0b11111111111111111111111111110100       # t0 = -12
sh t0, 6(sp)           # node.d = -12

sw ra, 8(sp)           # salva o ra

mv a0, sp               # joga o endereço da pilha em a0
jal mystery_function    # chama a função

lw ra, 8(sp)           # carrega o ra
addi sp, sp, 8         # Libera o espaço alocado

ret
