#int operation(int a, int b, short c, short d, char e, char f, int g, int h, char i, char j, short k, short l, int m, int n){
#    return b + c - f + h + k - m;
#};
.text
.globl operation

operation:

# alocar todos os argumentos
# a0 -> a
# a1 -> b
# a2 -> c
# a3 -> d
# a4 -> e
# a5 -> f
# a6 -> g
# a7 -> h

lb t0, 0(sp)        # 0(sp) -> i
lb t1, 4(sp)        # 4(sp) -> j
lh t2, 8(sp)        # 8(sp) -> k
lh t3, 12(sp)       # 12(sp) -> l
lw t4, 16(sp)       # 16(sp) -> m
lw t5, 20(sp)       # 20(sp) -> n


sum:
add t6, a1, a2
sub t6, t6, a5
add t6, t6, a7
add t6, t6, t2
sub t6, t6, t4

mv a0, t6
ret