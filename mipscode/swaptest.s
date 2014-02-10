	.text

	.global _start
.ent    _start
_start:

main:
	lui $sp, 0x10
	la	$a0,n1
	la	$a1,n2
	jal	proc
	jal	swapa	# swapa works correctly, swapb throws error
	li	$v0,1	# print n1 and n2; should be 27 and 14
	lw	$a0,n1
	syscall
	li	$v0,11
	li	$a0,' '
	syscall
	li	$v0,1
	lw	$a0,n2
	syscall
	li	$v0,11
	li	$a0,'\n'
	syscall
	li	$v0,10	# exit
	syscall

swapa:	
        addiu $29, $29, -4
        lw $8, 0($4) #Loads value of px to $t0
        sw $8, 0($29) #Stores value of $t0 on stack
        
        lw $8, 0($5) #loads value of py to $t0
        sw $8, 0($4) #store value of $t0 to py
        
        lw $8, 0($29) #loads value of temp to $t0
        sw $8, 0($5) #stores value of temp $t0 to py
        addiu $29, $29, 4
        jr $ra
        

swapb:	
    addiu $29, $29, -4
    lw $8, 0($4) #sets $t0 to value of px (*px)
    lw $9, 0($29) # $t1 to value of temp stored on stack
    sw $8, 0($9) # attempts to store  $t0 (value px) to address of $t1
    lw $8, 0($5) # puts value of py into $t0
    sw $8, 0($4) # stores value of py into px
    lw $8, 0($9) # attemps to load from temp
    sw $8, 0($5) # saves value of $t0 to py
    addiu $29, $29, 4 #adjusts stack
    jr $ra
    
# if the value of the 0($sp) happens to be an adress on the stack, then the program will run fine. 
# temp will get an address and program will not crash. 
# custom procedure to crash buggy swap
proc:	
    addiu $29, $29, -4
    sw $0, 0($29)
    addiu $29, $29, 4
    jr $ra

.end _start

	.data
n1:	.word	14
n2:	.word	27


