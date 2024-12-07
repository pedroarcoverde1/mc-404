	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p0_m2p0_a2p0_f2p0_d2p0"
	.file	"lab06c.c"
	.globl	exit
	.p2align	2
	.type	exit,@function
exit:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	lw	a1, -12(s0)
	#APP
	mv	a0, a1
	li	a7, 93
	ecall	
	#NO_APP
.Lfunc_end0:
	.size	exit, .Lfunc_end0-exit

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
	mv	a0, a3
	mv	a1, a4
	mv	a2, a5
	li	a7, 63
	ecall	
	mv	a3, a0

	#NO_APP
	sw	a3, -28(s0)
	lw	a0, -28(s0)
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end1:
	.size	read, .Lfunc_end1-read

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
	mv	a0, a3
	mv	a1, a4
	mv	a2, a5
	li	a7, 64
	ecall	
	#NO_APP
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end2:
	.size	write, .Lfunc_end2-write

	.globl	sqrt_approx
	.p2align	2
	.type	sqrt_approx,@function
sqrt_approx:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	addi	a0, a0, 1
	srli	a1, a0, 31
	add	a0, a0, a1
	srai	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB3_1
.LBB3_1:
	lw	a0, -20(s0)
	lw	a1, -16(s0)
	bge	a0, a1, .LBB3_3
	j	.LBB3_2
.LBB3_2:
	lw	a0, -20(s0)
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	lw	a1, -12(s0)
	div	a1, a1, a0
	add	a0, a0, a1
	srli	a1, a0, 31
	add	a0, a0, a1
	srai	a0, a0, 1
	sw	a0, -20(s0)
	j	.LBB3_1
.LBB3_3:
	lw	a0, -16(s0)
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end3:
	.size	sqrt_approx, .Lfunc_end3-sqrt_approx

	.globl	absolute
	.p2align	2
	.type	absolute,@function
absolute:
	addi	sp, sp, -16
	sw	ra, 12(sp)
	sw	s0, 8(sp)
	addi	s0, sp, 16
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	li	a1, 0
	bge	a0, a1, .LBB4_2
	j	.LBB4_1
.LBB4_1:
	lw	a1, -12(s0)
	li	a0, 0
	sub	a0, a0, a1
	sw	a0, -16(s0)
	j	.LBB4_3
.LBB4_2:
	lw	a0, -12(s0)
	sw	a0, -16(s0)
	j	.LBB4_3
.LBB4_3:
	lw	a0, -16(s0)
	lw	ra, 12(sp)
	lw	s0, 8(sp)
	addi	sp, sp, 16
	ret
.Lfunc_end4:
	.size	absolute, .Lfunc_end4-absolute

	.globl	ascii_to_int
	.p2align	2
	.type	ascii_to_int,@function
ascii_to_int:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	li	a0, 0
	sw	a0, -20(s0)
	li	a1, 1
	sw	a1, -24(s0)
	sw	a0, -28(s0)
	lw	a0, -12(s0)
	lbu	a0, 0(a0)
	li	a1, 45
	bne	a0, a1, .LBB5_2
	j	.LBB5_1
.LBB5_1:
	li	a0, -1
	sw	a0, -24(s0)
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB5_5
.LBB5_2:
	lw	a0, -12(s0)
	lbu	a0, 0(a0)
	li	a1, 43
	bne	a0, a1, .LBB5_4
	j	.LBB5_3
.LBB5_3:
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB5_4
.LBB5_4:
	j	.LBB5_5
.LBB5_5:
	j	.LBB5_6
.LBB5_6:
	lw	a0, -28(s0)
	lw	a1, -16(s0)
	bge	a0, a1, .LBB5_12
	j	.LBB5_7
.LBB5_7:
	lw	a0, -12(s0)
	lw	a1, -28(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	li	a1, 48
	blt	a0, a1, .LBB5_10
	j	.LBB5_8
.LBB5_8:
	lw	a0, -12(s0)
	lw	a1, -28(s0)
	add	a0, a0, a1
	lbu	a1, 0(a0)
	li	a0, 57
	blt	a0, a1, .LBB5_10
	j	.LBB5_9
.LBB5_9:
	lw	a0, -20(s0)
	li	a1, 10
	mul	a1, a0, a1
	lw	a0, -12(s0)
	lw	a2, -28(s0)
	add	a0, a0, a2
	lbu	a0, 0(a0)
	add	a0, a0, a1
	addi	a0, a0, -48
	sw	a0, -20(s0)
	j	.LBB5_10
.LBB5_10:
	j	.LBB5_11
.LBB5_11:
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	j	.LBB5_6
.LBB5_12:
	lw	a0, -20(s0)
	lw	a1, -24(s0)
	mul	a0, a0, a1
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end5:
	.size	ascii_to_int, .Lfunc_end5-ascii_to_int

	.globl	int_to_ascii
	.p2align	2
	.type	int_to_ascii,@function
int_to_ascii:
	addi	sp, sp, -32
	sw	ra, 28(sp)
	sw	s0, 24(sp)
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	li	a1, 0
	sw	a1, -24(s0)
	lw	a0, -12(s0)
	bge	a0, a1, .LBB6_2
	j	.LBB6_1
.LBB6_1:
	li	a0, 1
	sw	a0, -24(s0)
	lw	a1, -12(s0)
	li	a0, 0
	sub	a0, a0, a1
	sw	a0, -12(s0)
	j	.LBB6_2
.LBB6_2:
	lw	a0, -16(s0)
	lw	a1, -20(s0)
	add	a1, a0, a1
	li	a0, 0
	sb	a0, 0(a1)
	lw	a0, -20(s0)
	addi	a0, a0, -1
	sw	a0, -28(s0)
	j	.LBB6_3
.LBB6_3:
	lw	a0, -28(s0)
	li	a1, 0
	blt	a0, a1, .LBB6_6
	j	.LBB6_4
.LBB6_4:
	lw	a0, -12(s0)
	lui	a1, 419430
	addi	a1, a1, 1639
	mulh	a2, a0, a1
	srli	a3, a2, 31
	srli	a2, a2, 2
	add	a2, a2, a3
	li	a3, 10
	mul	a2, a2, a3
	sub	a0, a0, a2
	addi	a0, a0, 48
	lw	a2, -16(s0)
	lw	a3, -28(s0)
	add	a2, a2, a3
	sb	a0, 0(a2)
	lw	a0, -12(s0)
	mulh	a0, a0, a1
	srli	a1, a0, 31
	srai	a0, a0, 2
	add	a0, a0, a1
	sw	a0, -12(s0)
	j	.LBB6_5
.LBB6_5:
	lw	a0, -28(s0)
	addi	a0, a0, -1
	sw	a0, -28(s0)
	j	.LBB6_3
.LBB6_6:
	lw	a0, -24(s0)
	li	a1, 0
	beq	a0, a1, .LBB6_8
	j	.LBB6_7
.LBB6_7:
	lw	a1, -16(s0)
	li	a0, 45
	sb	a0, 0(a1)
	j	.LBB6_9
.LBB6_8:
	lw	a1, -16(s0)
	li	a0, 43
	sb	a0, 0(a1)
	j	.LBB6_9
.LBB6_9:
	lw	ra, 28(sp)
	lw	s0, 24(sp)
	addi	sp, sp, 32
	ret
.Lfunc_end6:
	.size	int_to_ascii, .Lfunc_end6-int_to_ascii

	.globl	calculate_coordinates
	.p2align	2
	.type	calculate_coordinates,@function
calculate_coordinates:
	addi	sp, sp, -96
	sw	ra, 92(sp)
	sw	s0, 88(sp)
	addi	s0, sp, 96
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	sw	a3, -24(s0)
	sw	a4, -28(s0)
	sw	a5, -32(s0)
	sw	a6, -36(s0)
	li	a1, 300
	sw	a1, -40(s0)
	lw	a0, -32(s0)
	lw	a2, -20(s0)
	sub	a0, a0, a2
	mul	a0, a0, a1
	sw	a0, -44(s0)
	lw	a0, -32(s0)
	lw	a2, -24(s0)
	sub	a0, a0, a2
	mul	a0, a0, a1
	sw	a0, -48(s0)
	lw	a0, -32(s0)
	lw	a2, -28(s0)
	sub	a0, a0, a2
	mul	a0, a0, a1
	sw	a0, -52(s0)
	lw	a0, -44(s0)
	mul	a0, a0, a0
	lw	a1, -12(s0)
	mul	a2, a1, a1
	add	a0, a0, a2
	lw	a2, -48(s0)
	mul	a2, a2, a2
	sub	a0, a0, a2
	slli	a1, a1, 1
	div	a0, a0, a1
	sw	a0, -56(s0)
	lw	a0, -44(s0)
	mul	a0, a0, a0
	lw	a1, -56(s0)
	mul	a1, a1, a1
	sub	a0, a0, a1
	sw	a0, -60(s0)
	lw	a0, -60(s0)
	call	sqrt_approx
	sw	a0, -64(s0)
	lw	a1, -64(s0)
	li	a0, 0
	sub	a0, a0, a1
	sw	a0, -68(s0)
	lw	a0, -64(s0)
	lw	a1, -16(s0)
	sub	a0, a0, a1
	mul	a0, a0, a0
	lw	a1, -56(s0)
	mul	a1, a1, a1
	add	a0, a0, a1
	lw	a1, -52(s0)
	mul	a1, a1, a1
	sub	a0, a0, a1
	call	absolute
	sw	a0, -72(s0)
	lw	a0, -68(s0)
	lw	a1, -16(s0)
	sub	a0, a0, a1
	mul	a0, a0, a0
	lw	a1, -56(s0)
	mul	a1, a1, a1
	add	a0, a0, a1
	lw	a1, -52(s0)
	mul	a1, a1, a1
	sub	a0, a0, a1
	call	absolute
	sw	a0, -76(s0)
	lw	a0, -72(s0)
	lw	a1, -76(s0)
	bge	a0, a1, .LBB7_2
	j	.LBB7_1
.LBB7_1:
	lw	a0, -64(s0)
	sw	a0, -84(s0)
	j	.LBB7_3
.LBB7_2:
	lw	a0, -68(s0)
	sw	a0, -84(s0)
	j	.LBB7_3
.LBB7_3:
	lw	a0, -84(s0)
	sw	a0, -80(s0)
	lw	a0, -80(s0)
	lw	a1, -36(s0)
	li	a2, 5
	sw	a2, -88(s0)
	call	int_to_ascii
	lw	a2, -88(s0)
	lw	a0, -56(s0)
	lw	a1, -36(s0)
	addi	a1, a1, 6
	call	int_to_ascii
	lw	ra, 92(sp)
	lw	s0, 88(sp)
	addi	sp, sp, 96
	ret
.Lfunc_end7:
	.size	calculate_coordinates, .Lfunc_end7-calculate_coordinates

	.globl	_start
	.p2align	2
	.type	_start,@function
_start:
	addi	sp, sp, -112
	sw	ra, 108(sp)
	sw	s0, 104(sp)
	addi	s0, sp, 112
	li	a0, 0
	sw	a0, -80(s0)
	addi	a1, s0, -20
	sw	a1, -104(s0)
	li	a2, 12
	sw	a2, -84(s0)
	call	read
	lw	a0, -80(s0)
	addi	a1, s0, -40
	sw	a1, -96(s0)
	li	a2, 20
	call	read
	lw	a0, -104(s0)
	li	a1, 5
	sw	a1, -100(s0)
	call	ascii_to_int
	lw	a1, -100(s0)
	sw	a0, -56(s0)
	addi	a0, s0, -14
	call	ascii_to_int
	mv	a1, a0
	lw	a0, -96(s0)
	sw	a1, -60(s0)
	li	a1, 4
	sw	a1, -92(s0)
	call	ascii_to_int
	lw	a1, -92(s0)
	sw	a0, -64(s0)
	addi	a0, s0, -35
	call	ascii_to_int
	lw	a1, -92(s0)
	sw	a0, -68(s0)
	addi	a0, s0, -30
	call	ascii_to_int
	lw	a1, -92(s0)
	sw	a0, -72(s0)
	addi	a0, s0, -25
	call	ascii_to_int
	sw	a0, -76(s0)
	lw	a0, -56(s0)
	lw	a1, -60(s0)
	lw	a2, -64(s0)
	lw	a3, -68(s0)
	lw	a4, -72(s0)
	lw	a5, -76(s0)
	addi	a6, s0, -52
	sw	a6, -88(s0)
	call	calculate_coordinates
	lw	a1, -88(s0)
	lw	a2, -84(s0)
	li	a0, 1
	call	write
	lw	a0, -80(s0)
	call	exit
.Lfunc_end8:
	.size	_start, .Lfunc_end8-_start

	.ident	"Debian clang version 14.0.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym exit
	.addrsig_sym read
	.addrsig_sym write
	.addrsig_sym sqrt_approx
	.addrsig_sym absolute
	.addrsig_sym ascii_to_int
	.addrsig_sym int_to_ascii
	.addrsig_sym calculate_coordinates
