	.text

	.global _start
.ent    _start
_start:

main:
	lui $sp, 0x10
	li	$a0,4
	li	$a1,0
	jal	nchoosek		# evaluate C(4,0); should be 1
	jal	printv0
	li	$a0,4
	li	$a1,1
	jal	nchoosek		# evaluate C(4,1); should be 4
	jal	printv0
	li	$a0,4
	li	$a1,2
	jal	nchoosek		# evaluate C(4,2); should be 6
	jal	printv0
	li	$a0,4
	li	$a1,3
	jal	nchoosek		# evaluate C(4,3); should be 4
	jal	printv0
	li	$a0,4
	li	$a1,4
	jal	nchoosek		# evaluate C(4,4); should be 1
	jal	printv0
	li	$a0,4
	li	$a1,5
	jal	nchoosek		# evaluate C(4,5); should be 0
	jal	printv0
	li	$v0,10
	syscall

nchoosek:	# calculate C($a0,$a1)
	addiu $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)

    
	beq	$a1,$0,return1
	beq	$a0,$a1,return1
	beq	$a0,$0,return0
	blt	$a0,$a1,return0

	addiu	$a0,$a0,-1		# C(n,k) = C(n-1,k) + C(n-1,k-1)
	move	$s0,$a0
	move	$s1,$a1
	jal	nchoosek
	move	$s2,$v0
	move	$a0,$s0
	addiu	$a1,$s1,-1
	jal	nchoosek
	addu	$v0,$v0,$s2
	j	return
return0:
	move	$v0,$0
	j	return
return1:
	addiu	$v0,$0,1

return:		# you fill in the epilogue
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        lw $s2, 12($sp)
        addiu $sp, $sp, 16
        jr $ra

printv0:
	addiu	$sp,$sp,-4
	sw	$ra,0($sp)
	move	$a0,$v0
	li	$v0,1
	syscall
	li	$a0,'\n'
	li	$v0,11
	syscall
	lw	$ra,0($sp)
	addiu	$sp,$sp,4
	jr	$ra


.end _start

	.data
n1:	.word	14
n2:	.word	27


