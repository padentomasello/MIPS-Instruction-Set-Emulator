.data
passstring:     .asciiz "all tests passed!\n"
fail1string:    .asciiz "test #"
fail2string:    .asciiz " failed!\n"

.text

# _start is the entry point into any program.
.global _start
.ent    _start 
_start:

#
#  The header ends here, and code goes below
#

        # test #1: beq
        ori   $2, $0, 1
        ori   $3, $0, 1
        beq   $2, $3, pass

        ori   $30, 1
        j     fail



pass:
        la $a0, passstring
        li $v0, 4
        syscall
        b done

fail:
        ori $a0, $0, %lo(fail1string)
        ori $v0, $0, 4
        syscall

        ori  $a0, $30, 0
        ori  $v0, $0, 1
        syscall

        ori $a0, $0, %lo(fail2string)
        ori $v0, $0, 4
        syscall

done:
        ori $v0, $zero, 10
        syscall

.end _start

.data
foo: .word 911
