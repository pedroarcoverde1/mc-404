.data
.globl my_var           # torna a var global
my_var: .word 10        # aloba 4 byter (32 bits)

.text
.global increment_my_var

increment_my_var:
la t0, my_var
lw t1, 0(t0)
addi t1, t1, 1
sw t1, 0(t0)
mv a0, t1
ret


