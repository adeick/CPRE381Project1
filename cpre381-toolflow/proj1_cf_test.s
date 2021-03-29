main:
	addi	$a0, $zero, 0x0
	addi	$a1, $zero, 0x1
	addi	$a2, $zero, 0x2
	addi	$a3, $zero, 0x3
	j	stackframetst
	addi	$s0, $v0, 0
	j	finish

stackframetst:
	addi	$sp, $sp, -20
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	sw	$a1, 8($sp)
	sw	$a2, 12($sp)
	sw	$a3, 16($sp)
	addi	$v0, $zero, 0
	jal	stcktstloop
	addi	$v0, $v0, 0
	lw	$t3, 16($sp)
	slti	$t4, $t3, 0xFF00
	bne	$t4, 1, tstdone
	
stcktstloop:
	lw	$t0, 4($sp)
	lw	$t1, 8($sp)
	lw	$t2, 12($sp)
	lw	$t3, 16($sp)
	add	$t3, $t3, $t2
	add	$t1, $t1, $t0
	add	$t2, $t2, $t1
	add	$t3, $t3, $t2
	addi	$t0, $t0, 1
	sw	$t0, 4($sp)
	sw	$t1, 8($sp)
	sw	$t2, 12($sp)
	sw	$t3, 16($sp)
	jr	$ra
	
tstdone:
	lw	$ra, 0($sp)
	addi	$sp, $sp, 20
	jr	$ra
	
finish:
	