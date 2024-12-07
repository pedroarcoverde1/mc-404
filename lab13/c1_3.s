.text
.global operation

operation:
# Salvar o ra
addi sp, sp, -16
sw ra, 0(sp)

# Definir as variáveis nos registradores temporários
li a0, 1              # a = 1 (int)
li a1, -2             # b = -2 (int)
li a2, 3              # c = 3 (short)
li a3, -4             # d = -4 (short)
li a4, 5              # e = 5 (char)
li a5, -6             # f = -6 (char)
li a6, 7              # g = 7 (int)
li a7, -8             # h = -8 (int)

addi sp, sp, -32        # 6 variáveis ocupando 4 bytes cada

li t0, 0b00000000000000000000000000001001       # i = 9 (char)
sw t0, 0(sp)            # i

li t0, 0b11111111111111111111111111110110       # j = -10 (char)
sw t0, 4(sp)            # j

li t0, 0b00000000000000000000000000001011       # k = 11 (short)
sw t0, 8(sp)            # k

li t0, 0b11111111111111111111111111110100       # l = -12 (short)
sw t0, 12(sp)           # l

li t0, 0b00000000000000000000000000001101       # m = 13 (int)
sw t0, 16(sp)           # m

li t0, 0b11111111111111111111111111110010        # n = -14 (int)
sw t0, 20(sp)           # n

# Chamar a função mystery_function
jal mystery_function

# Liberar a pilha e retornar
addi sp, sp, 32          # Limpa a pilha

lw ra, 0(sp)
addi sp, sp, 16
ret

