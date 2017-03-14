# Project ECE 30 Winter 2017
# Maximum Subarray Sum
# Student 1 : PID A50001111
# Lastname, Firstname 
# Student 2 : PID A50001112
# Lastname, Firstname. 

.data ## Data declaration section
## String to be printed:
string_newline: .asciiz "\n" # newline character
string_space: .asciiz " " # space character
string_MaxSubArraySum: .asciiz "Maximum Sub Array Sum is: "
array1: .word -2, -5, 6, -2, -3, 1, 5, -6
size: .word 7
.text ## Assembly language instructions go in text segment

main: ## Start of code section
li $a1, 0
la $a2, size 
lw $a2, 0($a2)
la $a0, array1
jal MaximumSubArraySum # MaxSubArraySum(arr,0, size-1);
move $a0,$v0 #result of MaxSubArraySum is stored in $v1 store that as argument of print sum
jal printsum
li $v0, 10 # terminate program
syscall

##########################################################
printsum: # Function to print the contents of the array
# $a0 = value to be printed
move $t0, $a0
	
# print newline character
la $a0, string_newline
li $v0, 4
syscall
    
la $a0,  string_MaxSubArraySum
li $v0, 4
syscall
	
# print the integer at the address $a0
li $v0, 1
move $a0,$t0
syscall
jr $ra  # Return back

##########################################################
MaxSumBoundary:
#	$a0 contains address to arr[].
#	$a1 contains s 
#	$a2 contains e
#	$a3 is the direction (either 0 or 1)
#	$v0 returns the maximum subarray
#   Write your code here
addi $sp, $sp, -32	# move the stack pointer up
sw $ra, 4($sp)		# store return address
sw $fp, 8($sp) 		# store frame pointer
sw $s0, 12($sp)		# store the save values onto the stack
sw $s1, 16($sp)		
sw $s2, 20($sp)	
addi $fp, $sp, 32	# move the frame pointer up

beq $a1, $a2, baseCase  # if s == e, then go to notEq. otherwise, base case

notEqual:		# check for the direction 
beq $a3, $0, backwards	# if $a3 == 0, traverse backwards
j forwards		# otherwise, $a3 != 0, traverse forwards

baseCase:
sll $t0, $a1, 2		# multiply s by four
add $t1, $a0, $t0	# set $t1 = arr + (s*4)
lw $v0, 0($t2) 		# return value of arr[s]. i.e. store it in output register
j MaxSumBoundaryEnd	# jump to the end

forwards:
addi $sp, $sp, -32 	# allocate space for the stack. move $sp up
sw $a0, 4($sp)		# save arguments on the stack
sw $a1, 8($sp) 	
sw $a2, 12($sp)
sw $a3, 16($sp)

addi $a0, $a0, 0	# set parameters, prepare for recursive call
addi $a1, $a1, 1	# increment s by 1
addi $a2, $a2, 0	# e does not change
addi $a3, $0, 1		# direction is still 1 (traversing to the right)
jal MaxSumBoundary	# recursive call
			# now we are done with the recursive call and we are back 
lw $a0, 4($sp)		# restore the arguments
lw $a1, 8($sp)	
lw $a2, 12($sp)
lw $a3, 16($sp)
addi $sp, $sp, 32	# move the stack pointer down, prepare to pop stack out
addi $s0, $v0, 0	# store the output in register $s0

addi $sp, $sp, -32	# move stack pointer up, prepare another stack
sw $a0, 4($sp)		# store the argument registers onto the stack
sw $a1, 8($sp) 	
sw $a2, 12($sp)
sw $a3, 16($sp)

sll $t0, $a2, 2		# multiply s by 4
add $t1, $a0, $t0	# calculate arr + (s * 4)
lw $t2, 0($t1)		# store arr[s] into register $t2
add $t3, $t2, $s0	# store into $t3, arr[s] + the previous value that was popped out
addi $a1, $t2, 0	# set first argument for FindMax2 procedure
addi $a2, $t3, 0	# set second argument for FindMax2 procedure, prepare to jump
jal FindMax2		# jump to the FindMax2 procedure, find maximum of two arguments
			# now we have found the maximum and it is stored in $v0. we proceed to restore arguments
lw $a0, 4($sp) 		#restore arguments
lw $a1, 8($sp)
lw $a2, 12($sp)	
lw $a3, 16($sp)
addi $sp, $sp, 32	# move the stack pointer down, push the stack out
addi $v0, $v0, 0	# store the output in $v0 register
j MaxSumBoundaryEnd	# jump to the end, we are finished

backwards:
# To implement tomorrow.  
##########################################################

MaximumCrossingSum:
#	$a0 contains arr[]
#	$a1 contains s
#	$a2 contains m
#	$a3 contains e
#	$v0 returns the maximum sum of arrays that cross the midpoint
#   Write your code here
jr $ra


##########################################################
MaximumSubArraySum:
#	$a0 contains arr[].
#	$a1 contains s
#	$a2 contains e
#   Write your code here
jr $ra

##########################################################
FindMax2:
#	$a1 holds the first number.
#	$a2 holds the second number.
#	$v0 contains the maximum between the 2 input numbers.
#   Write your code here

slt $t0, $a1, $a2	# see if $a1 is less than $a2
beq $t0, $0, done	# if $a1 > $a2, jump to done procedure
add $v0, $0, $a2	# if $a1 < $a2, set $v0 to $a2
jr $ra			# return to caller
done: 
add $v0, $0, $a1	# if $a1 > $a2, set $v0 to $a1
jr $ra

FindMax3:
##########################################################
#	$a1 holds the first number.
#	$a2 holds the second number.
#	$a3 holds the third number.
#	$v0 contains the maximum among the 3 numbers
#   Write your code here

slt $t0, $a1, $a2	# check if $a1 < $a2
beq $t0, $0, check	# if $a1 > $a2, check for $a1 > $a3, otherwise $a2 > $a1 and check $a2 > $a3
slt $t1, $a2, $a3	# check if $a2 > $a3
beq $t1, $0, second 	# if $a2 > $a3, then $a2 is maximum
jr $ra
check:
slt $t1, $a2, $a3	# check if $a1 > $a3
beq $t1, $0, first	# if $a1 > $a3, then $a1 is the largest
add $v0, $0, $a3	# otherwise, $a3 is the largest, so set $v0 to $a3
jr $ra
first:
add $v0, $0, $a1	# $a1 is the maximum, so set $v0 to $a1
jr $ra
