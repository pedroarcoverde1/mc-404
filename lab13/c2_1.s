.text

.globl swap_int
.globl swap_short
.globl swap_char

swap_int:
lw t0, 0(a0) # carrega o primeiro endereço em a0

lw t1, 0(a1) # carrega o segundo endereço em a1
sw t1, 0(a0) # salva o segundo endereço no lugar do primeiro
sw t0, 0(a1) # salva o priemeiro endereço no lugar do segundo
# Retorna 0 no registrador a0
li a0, 0
ret

swap_short:
lh t0, 0(a0) # carrega o primeiro endereço em a0

lh t1, 0(a1) # carrega o segundo endereço em a1
sh t1, 0(a0) # salva o segundo endereço no lugar do primeiro
sh t0, 0(a1) # salva o priemeiro endereço no lugar do segundo
# Retorna 0 no registrador a0
li a0, 0
ret

swap_char:
lb t0, 0(a0) # carrega o primeiro endereço em a0
lb t1, 0(a1) # carrega o segundo endereço em a1
sb t1, 0(a0) # salva o segundo endereço no lugar do primeiro
sb t0, 0(a1) # salva o priemeiro endereço no lugar do segundo
# Retorna 0 no registrador a0
li a0, 0
ret
