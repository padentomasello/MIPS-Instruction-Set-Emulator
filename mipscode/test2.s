.data
failsz:		.asciiz "Test FAILED: "
expect1_str:	.asciiz "Expected: "
expect2_str:	.asciiz ", Got: "

passsz:		.asciiz "All tests passed!\n"

result1_str:	.asciiz "Passed "
result3_str:	.asciiz " tests!\n"

testnum: 	.byte 0
passcount:	.byte 0
numtests:	.byte 0


.align 2
tests:
		.asciiz "addiu1 "
		.word addiutest1
		.asciiz "addiu2 "
		.word addiutest2
		.asciiz "lbtest1"
		.word lbtest1
		.asciiz "lbtest2"
		.word lbtest2
		.asciiz "lbu2   "
		.word lbutest2
		.asciiz "lb3    "
		.word lbtest3
		.asciiz "lbu3   "
		.word lbutest3
		.asciiz "lb4    "
		.word   lbtest4
		.asciiz "lbu4   "
		.word lbutest4
		.asciiz "lb5    "
		.word lbtest5
		.asciiz "lbu5   "
		.word lbutest5
		.byte 0
#
.text

.global _start
.ent    _start
_start:

exectest:
	# load base address for test structure into $s0
	addiu $t1, $zero, 12
	mult $t0, $t1
	mflo $t0
	la $t1, tests
	addu $s0, $t0, $t1

	# check to see if the test name is null
	lb $t0, 0($s0)
	beq $t0, $zero, done
	
	# increment max test count
	lb $t0, numtests
	addiu $t0, $t0, 1
	sb $t0, numtests
	
	# load address to test and jump
	addu $t0, $s0, 8
	lw $t0, 0($t0)
	jalr $t0
	
	# if $v0 is 0, we passed, if not, we failed
	bnez $v0, testfail
	
	# print a dot, increment the pass count, and loop
	addiu $v0, $zero, 11
	addiu $a0, $zero, '.'
	syscall
	
	lb $t0, passcount
	addiu $t0, $t0, 1
	sb $t0, passcount
	
	j mainloop
testfail:
	# clear line from testing dots
	addiu $v0, $zero, 11
	addiu $a0, $zero, '\n'
	syscall
	
	# print test failed text and the name of the current test
	addiu $v0, $zero, 4
	la $a0, failsz
	syscall
	move $a0, $s0
	syscall
	addiu $v0, $zero, 11
	addiu $a0, $zero, '\n'
	syscall
	
	# return to expectation function to print differences.
	jr $ra

mainloop:
	# increment test number and go back to top
	lb $t0, testnum
	addiu $t0, $t0, 1
	sb $t0, testnum
	j exectest

done:
	lb $t0, passcount
	lb $t1, numtests
	
	# print newline
	addiu $v0, $zero, 11
	addiu $a0, $zero, '\n'
	syscall
	
	# if we didn't pass all of them don't say we did.
	bne $t0, $t1, results
	
	# print passed message
	addiu $v0, $zero, 4
	la $a0, passsz
	syscall
	
results:
	# print results 
	addiu $v0, $zero, 4
	la $a0, result1_str
	syscall
	
	addiu $v0, $zero, 1
	lb $a0, passcount
	syscall
	
	addiu $v0, $zero, 11
	addiu $a0, $zero, '/'
	syscall
	
	addiu $v0, $zero, 1
	lb $a0, numtests
	syscall
	
	addiu $v0, $zero, 4
	la $a0, result3_str
	syscall
	
	# exit
	addiu $v0, $zero, 10
	syscall

# expectation functions go here
pass_if_equal:
	# $a0 -> value
	# $a1 -> expected
	# checks to see if $a0 and $a1 are equal, result goes into $v0 and control is returned to the main loop
	sne $v0, $a0, $a1
	move $t0, $ra
	
	move $s6, $a0
	move $s7, $a1
	
	jalr $t0

	# print expectation vs reality
	addiu $v0, $zero, 4
	la $a0, expect1_str
	syscall
	addiu $v0, $zero, 34
	move $a0, $s7
	syscall
	addiu $v0, $zero, 4
	la $a0, expect2_str
	syscall
	addiu $v0, $zero, 34
	move $a0, $s6
	syscall
	addiu $v0, $zero, 11
	addiu $a0, $zero, '\n'
	syscall
	
	# go to next test
	j mainloop

# tests start here


addiutest1:
	move $a0, $0
	li $t0, 0xffff
	addiu $a0, $t0, -1
	li $a1, 0xfffe
	j pass_if_equal

addiutest2:
	move $a0, $0
	li $t0, 0xffff
	addiu $a0, $t0, -1
	li $a1, 0xfffe
	j pass_if_equal

lbtest1:
	lui $sp, 0x10
	addiu $sp, $sp, -4
	addu $t0, $zero, 0xff
	sb $t0, 0($sp)
	lb $a0, 0($sp)
	li $a1, 0xffffffff
	addiu $sp, $sp, 4
	j pass_if_equal


lbtest2:
	addiu $sp, $sp, -4
	lui $t0, 0xabcd
	ori $t0, 0xef10
	sw $t0, 0($sp)
	lb $a0, 0($sp)
	li $a1, 0x10
	addiu $sp, $sp, -4
	j pass_if_equal

lbutest2:
	addiu $sp, $sp, -4
	lui $t0, 0xabcd
	ori $t0, 0xef10
	sw $t0, 0($sp)
	lbu $a0, 0($sp)
	li $a1, 0x10
	addiu $sp, $sp, -4
	j pass_if_equal

lbtest3:
	addiu $sp, $sp, -4
	lui $t0, 0xabcd
	ori $t0, 0xef10
	sw $t0, 0($sp)
	lb $a0, 1($sp)
	li $a1, 0xffffffef
	addiu $sp, $sp, -4
	j pass_if_equal

lbutest3:
	addiu $sp, $sp, -4
	lui $t0, 0xabcd
	ori $t0, 0xef10
	sw $t0, 0($sp)
	lbu $a0, 1($sp)
	li $a1, 0x000000ef
	addiu $sp, $sp, -4
	j pass_if_equal

lbtest4:
	addiu $sp, $sp, -4
	lui $t0, 0xabcd
	ori $t0, 0xef10
	sw $t0, 0($sp)
	lb $a0, 2($sp)
	li $a1, 0xffffffcd
	addiu $sp, $sp, -4
	j pass_if_equal

lbutest4:
	addiu $sp, $sp, -4
	lui $t0, 0xabcd
	ori $t0, 0xef10
	sw $t0, 0($sp)
	lbu $a0, 2($sp)
	li $a1, 0x000000cd
	addiu $sp, $sp, -4
	j pass_if_equal

lbtest5:
	addiu $sp, $sp, -4
	lui $t0, 0xabcd
	ori $t0, 0xef10
	sw $t0, 0($sp)
	lb $a0, 3($sp)
	li $a1, 0xffffffab
	addiu $sp, $sp, -4
	j pass_if_equal

lbutest5:
	addiu $sp, $sp, -4
	lui $t0, 0xabcd
	ori $t0, 0xef10
	sw $t0, 0($sp)
	lbu $a0, 3($sp)
	li $a1, 0x000000ab
	addiu $sp, $sp, -4
	j pass_if_equal


lbutest1:
	lui $sp, 0x10
	addiu $sp, $sp, -4
	addu $t0, $zero, 0xff
	sb $t0, 0($sp)
	lbu $a0, 0($sp)
	li $a1, 0xff
	addiu $sp, $sp, 4
	j pass_if_equal



.end _start

