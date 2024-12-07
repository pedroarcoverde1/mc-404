	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_m2p0_a2p0_f2p0_d2p0"
	.file	"calculadora.c"
	.globl	read
	.p2align	2
	.type	read,@function
read:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	li	a7, 63	# syscall read code (63) 
	ecall		# invoke syscall 
	mv	a3, a0	# move return value to ret_val

	#NO_APP
	sw	a3, -28(s0)
	lw	a0, -28(s0)
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end0:
	.size	read, .Lfunc_end0-read

	.globl	write
	.p2align	2
	.type	write,@function
write:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	lw	a3, -12(s0)
	lw	a4, -16(s0)
	lw	a5, -20(s0)
	#APP
	mv	a0, a3	# file descriptor
	mv	a1, a4	# buffer 
	mv	a2, a5	# size 
	li	a7, 64	# syscall write (64) 
	ecall	
	#NO_APP
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end1:
	.size	write, .Lfunc_end1-write

	.globl	main
	.p2align	2
	.type	main,@function
main:
	addi	sp, sp, -48
	sw	ra, 44(sp)
	sw	s0, 40(sp)
	addi	s0, sp, 48
	li	a0, 0
	sw	a0, -12(s0)
	lui	a1, %hi(input_buffer)
	sw	a1, -44(s0)
	addi	a1, a1, %lo(input_buffer)
	sw	a1, -40(s0)
	li	a2, 10
	call	read
	lw	a1, -44(s0)
	mv	a2, a0
	lw	a0, -40(s0)
	sw	a2, -16(s0)
	lb	a1, %lo(input_buffer)(a1)
	sb	a1, -17(s0)
	lb	a1, 2(a0)
	sb	a1, -18(s0)
	lb	a0, 4(a0)
	sb	a0, -19(s0)
	lbu	a0, -17(s0)
	addi	a0, a0, -48
	sw	a0, -24(s0)
	lbu	a0, -19(s0)
	addi	a0, a0, -48
	sw	a0, -28(s0)
	lbu	a0, -18(s0)
	sw	a0, -36(s0)
	li	a1, 42
	beq	a0, a1, .LBB2_5
	j	.LBB2_1
.LBB2_1:
	lw	a0, -36(s0)
	li	a1, 43
	beq	a0, a1, .LBB2_3
	j	.LBB2_2
.LBB2_2:
	lw	a0, -36(s0)
	li	a1, 45
	beq	a0, a1, .LBB2_4
	j	.LBB2_6
.LBB2_3:
	lw	a0, -24(s0)
	lw	a1, -28(s0)
	add	a0, a0, a1
	sw	a0, -32(s0)
	j	.LBB2_6
.LBB2_4:
	lw	a0, -24(s0)
	lw	a1, -28(s0)
	sub	a0, a0, a1
	sw	a0, -32(s0)
	j	.LBB2_6
.LBB2_5:
	lw	a0, -24(s0)
	lw	a1, -28(s0)
	mul	a0, a0, a1
	sw	a0, -32(s0)
	j	.LBB2_6
.LBB2_6:
	lw	a0, -32(s0)
	addi	a1, a0, 48
	lui	a0, %hi(output)
	sb	a1, %lo(output)(a0)
	addi	a1, a0, %lo(output)
	li	a0, 10
	sb	a0, 1(a1)
	li	a0, 1
	li	a2, 2
	call	write
	li	a0, 0
	lw	ra, 44(sp)
	lw	s0, 40(sp)
	addi	sp, sp, 48
	ret
.Lfunc_end2:
	.size	main, .Lfunc_end2-main

	.type	input_buffer,@object
	.bss
	.globl	input_buffer
input_buffer:
	.zero	10
	.size	input_buffer, 10

	.type	output,@object
	.section	.sbss,"aw",@nobits
	.globl	output
output:
	.zero	2
	.size	output, 2

	.ident	"Debian clang version 14.0.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym read
	.addrsig_sym write
	.addrsig_sym input_buffer
	.addrsig_sym output
