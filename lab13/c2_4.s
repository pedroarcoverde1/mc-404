.text
.globl node_op

node_op:
# a0-> endereço do node
lw t0, 0(a0)            # carrega o valor de a (int)
lb t1, 4(a0)            # carrega o valor de b (char)
lb t2, 5(a0)            # carrega o valor de c (char)
lh t3, 6(a0)            # carrega o valor de d (short)

add t0, t0, t1
sub t0, t0, t2
add t0, t0, t3
mv a0, t0
ret

