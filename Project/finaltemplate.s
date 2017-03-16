# Project ECE 30 Winter 2017
# Maximum Subarray Sum
# Student 1 : PID A99040472
# Zheng, Nianqi
# Student 2 : PID A12916778
# Hu, Jun Hao

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
addi $sp, $sp, -20	# move the stack pointer up
sw $ra, 4($sp)		# store return address
sw $fp, 8($sp) 		# store frame pointer
sw $s0, 12($sp)		# store the save values onto the stack
sw $s1, 16($sp)		
sw $s2, 20($sp)	
addi $fp, $sp, 20	# move the frame pointer up

bne $a1, $a2, notEqual  # if s == e, then go to notEq. otherwise, base case

baseCase:
sll $t0, $a1, 2		# multiply s by four
add $t1, $a0, $t0	# set $t1 = arr + (s*4)
lw $v0, 0($t1) 		# return value of arr[s]. i.e. store it in output register
j MaxSumBoundaryEnd	# jump to the end

notEqual:		# check for the direction 
bne $a3, $0, forwards	# if $a3 != 0, traverse forwards
j backwards

forwards:
addi $sp, $sp, -20 	# allocate space for the stack. move $sp up
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
addi $sp, $sp, 20	# move the stack pointer down, prepare to pop stack out
addi $s0, $v0, 0	# store the output in register $s0

addi $sp, $sp, -20	# move stack pointer up, prepare another stack
sw $a0, 4($sp)		# store the argument registers onto the stack
sw $a1, 8($sp) 	
sw $a2, 12($sp)
sw $a3, 16($sp)

sll $t0, $a1, 2		# multiply s by 4
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
addi $sp, $sp, 20	# move the stack pointer down, push the stack out
addi $v0, $v0, 0	# store the output in $v0 register
j MaxSumBoundaryEnd	# jump to the end, we are finished

backwards:
addi $sp, $sp, -20 	# move the stack pointer up
sw $a0, 4($sp) 		# store all arguments onto the stack
sw $a1, 8($sp)		
sw $a2, 12($sp)
sw $a3, 16($sp)

addi $a2, $a2, -1 	# decrement e by 1
addi $a0, $a0, 0	# set argument parameters, prepare to do recursion
addi $a1, $a1, 0	
addi $a2, $a2, 0	
addi $a3, $0, 0		# direction is still 0
jal MaxSumBoundary	# do recursion
			# now we are done with the recusion and we are back to this address
lw $a0, 4($sp)		# restore the arguments
lw $a1, 8($sp)
lw $a2, 12($sp)
lw $a3, 16($sp)
addi $sp, $sp, 20	# move the stack pointer down, prepare to push the stack out
addi $s0, $v0, 0	# store the output in the register $s0

addi $sp, $sp, -20	# move the stack pointer up, prepare another stack frame
sw $a0, 4($sp)		# store arguments in the stack
sw $a1, 8($sp)
sw $a2, 12($sp)
sw $a3, 16($sp)

sll $t0, $a2, 2		# multiply e by 4
add $t1, $a0, $t0	# $t1 = arr + (e*4), to get array element
lw $t2, 0($t1)		# $t2 = arr[e]
add $t3, $t2, $s0	# $t3 = arr[e] + (arr + (e*4))

addi $a1, $t2, 0	# prepare parameters for FindMax2 call
addi $a2, $t3, 0	
jal FindMax2		# call the FindMax2 procedure
			# we are done with FindMax2 procedure and have returned
lw $a0, 4($sp)		# restore the arguments
lw $a1, 8($sp)
lw $a2, 12($sp)
lw $a3, 16($sp)
addi $sp, $sp, 20	# move the stack pointer down, prepare to pop stack out
addi $v0, $v0, 0	# store the output in $v0

MaxSumBoundaryEnd:
lw $ra, 4($sp)		# load the return address
lw $fp, 8($sp)		# load the frame pointer
lw $s0, 12($sp)		# load the save values on the stack
lw $s1, 16($sp)	
lw $s2, 20($sp)
addi $sp, $sp, 20	# move the stack pointer down
jr $ra			# jump to the return address	

##########################################################

MaximumCrossingSum:
#	$a0 contains arr[]
#	$a1 contains s
#	$a2 contains m
#	$a3 contains e
#	$v0 returns the maximum sum of arrays that cross the midpoint
#   Write your code here
addi $sp, $sp, -20	# move the stack pointer up 
sw $ra, 4($sp)		# save the return address
sw $fp, 8($sp)		# store the frame pointer
sw $s1, 12($sp)		# store the save values onto the stack
sw $s2, 16($sp)		
addi $fp, $fp, 16	# move the frame pointer up

addi $sp, $sp, -20	# move the stack pointer up, prepare another stack
sw $a0, 4($sp) 	# store the arguments on the stack
sw $a1, 8($sp)
sw $a2, 12($sp)
sw $a3, 16($sp)

addi $a3, $0, 0		# set the direction, prepare to call MaxSumBoundary on the left array
jal MaxSumBoundary	# call MaxSumBoundary on the left array
			# now we are done and we restore the arguments
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $a2, 12($sp)
lw $a3,	16($sp)
addi $sp, $sp, 20 	# move the stack pointer down, pop the stack
addi $s1, $v0, 0	# store the output into $s1

addi $sp, $sp, -20 	# move the stack pointer up, prepare another stack
sw $a0, 4($sp)		# save the arguments in the stack
sw $a1, 8($sp)
sw $a2, 12($sp)
sw $a3, 16($sp)

addi $t2, $a2, 1 	# calculate m + 1
addi $a1, $t2, 0	# store this in the first argument
addi $a2, $a3, 0	# store e in the second argument
addi $a3, $0, 1		# set the direction we're going in
jal MaxSumBoundary
			# now we are done and we will restore the arguments
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $a2, 12($sp)
lw $a3, 16($sp)
addi $sp, $sp, 20	# move the stack pointer down, prepare to pop stack
addi $s2, $v0, 0	# store the output of the call to MaxSumBoundary to $s2
add $v0, $s1, $s2	# store leftSum + rightSum
			# now we prepare to return address
lw $ra, 4($sp)		# load return address
lw $fp, 8($sp)		# load frame pointer address
lw $s1, 16($sp)		# restore the saved values from our stack and store them in $s1, $s2
lw $s2, 20($sp) 	
addi $sp, $sp, 20	# move the stack pointer down
jr $ra

##########################################################
MaximumSubArraySum:
#	$a0 contains arr[].
#	$a1 contains s
#	$a2 contains e
#   Write your code here
addi $sp, $sp, -24 	# move the stack pointer up, prepare another stack
sw $ra, 4($sp)		# store the return address
sw $fp, 8($sp)		# store the address of the frame pointer
sw $s0, 12($sp)		# store the save values on the stack
sw $s1, 16($sp)
sw $s2, 20($sp)
sw $s3, 24($sp)		
addi $fp, $sp, 24	# move the frame pointer up

bne $a1, $a2, ArgsNotEqual	# check to see if s == e. if yes, return arr[s], else, go to ArgNotEqual procedure
sll $t0, $a1, 2			# calculate s*4
add $t1, $a0, $t0		# calculate arr + (s*4)
lw  $v0, 0($t1) 			# store arr[s] 
j MaxSubArraySumEnd		# we're done and jump to the end

ArgsNotEqual:
add $t4, $a1, $a2 		# calculate s + e
srl $s1, $t4, 1			# calculate (s+e)/2, the middle of the array 

addi $sp, $sp, -20		# move the stack pointer up, prepare another stack
sw $a0, 4($sp)			# store arguments on the stack
sw $a1, 8($sp)
sw $a2, 12($sp)
sw $a3, 16($sp)

addi $a0, $a0, 0		# load arguments
addi $a1, $a1, 0
addi $a2, $s1, 0		# store the address pointing to the middle of the array into the argument register, prepare to do recursive call
jal MaximumSubArraySum		# call MaximumSubArraySum 
				# now we are done, so restore the arguments
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $a2, 12($sp)
lw $a3, 16($sp)

addi $sp, $sp, 20 		# move the stack pointer down 
addi $s0, $v0, 0		# store the result of the MaximumSubArraySum call into a save register

addi $sp, $sp, -20		# move the stack pointer up, prepare another stack
sw $a0, 4($sp)			# store the arguments on the stack
sw $a1, 8($sp)
sw $a2, 12($sp)
sw $a3, 16($sp)

addi $t4, $s1, 1		# calculate m + 1 and store it in a register
addi $a0, $a0, 0		# load arguments
addi $a1, $t4, 0		# set argument parameters to prepare for another recursive call
addi $a2, $a2, 0
jal MaximumSubArraySum		# call MaximumSubArraySum
				# now we are done, so restore arguments
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $a2, 12($sp)
lw $a3, 16($sp)
addi $sp, $sp, 20		# move the stack pointer down, pop out stack
addi $s2, $v0, 0		# store the output of the recursive call into a save register

addi $sp, $sp, -20		# move the stack pointer up, prepare another stack for procedure call to MaxCrossingSum
sw $a0, 4($sp)			# store argument registers. not sure if this is needed, just paranoid
sw $a1, 8($sp)
sw $a2, 12($sp)
sw $a3, 16($sp)

addi $t2, $a2, 0		# set $t2 to e, this is just a temporary transfer variable
addi $a0, $a0, 0		# load arguments
addi $a1, $a1, 0
addi $a2, $s1, 0		# set the second argument to m, the middle of the array
addi $a3, $t2, 0		# set the third argument to e, prepare to call MaximumCrossingSum 
jal MaximumCrossingSum		# call the MaximumCrossingSum procedure
				# now we are done and we need to restore the arguments
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $a2, 12($sp)
lw $a3, 16($sp)

addi $sp, $sp, 20		# move the stack pointer down
addi $s3, $v0, 0		# store the output of this call into a save register

addi $sp, $sp, -20		# move the stack pointer up, prepare another stack for FindMax3 call
sw $a0, 4($sp)			# store the arguments onto the stack, in case we need them later
sw $a1, 8($sp)
sw $a2, 12($sp)
sw $a3, 16($sp)

addi $a1, $s0, 0		# prepare parameters for FindMax3 call
addi $a2, $s2, 0		
addi $a3, $s3, 0	
jal FindMax3			# call FindMax3 procedure
				# now we are done and we will restore the arguments
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $a2, 12($sp)
lw $a3, 16($sp)
addi $sp, $sp, 20		# move the stack pointer down
addi $v0, $v0, 0		# store the output of FindMax3 into the output register

MaxSubArraySumEnd:
lw $ra, 4($sp)			# load the return address
lw $fp, 8($sp)			# load the frame pointer address
lw $s0, 12($sp)			# store the save values on the stack
lw $s1, 16($sp)
lw $s2, 20($sp)
lw $s3, 24($sp)
addi $sp, $sp, 24		# move the stack pointer down, prepare to return address
jr $ra

##########################################################
FindMax2:
#	$a1 holds the first number.
#	$a2 holds the second number.
#	$v0 contains the maximum between the 2 input numbers.
#   Write your code here
addi $sp, $sp, -20	# move the stack pointer up, prepare another stack
sw $ra, 0($sp)		# store the return address into the stack
sw $fp, 4($sp) 		# store the frame pointer address into the stack
addi $fp, $sp, 20	# move the frame pointer up

slt $t0, $a1, $a2	# see if $a1 is less than $a2
beq $t0, $0, a1Bigger	# if $a1 > $a2, jump to done procedure
add $v0, $0, $a2	# if $a1 < $a2, set $v0 to $a2
j done	
a1Bigger:
add $v0, $0, $a1	# if $a1 > $a2, set $v0 to $a1
done: 
lw $ra, 0($sp)		# restore the return address
lw $fp, 4($sp)		# restore the frame pointer
addi $sp, $sp, 20	# move the stack pointer down, prepare to return address 
jr $ra


FindMax3:
##########################################################
#	$a1 holds the first number.
#	$a2 holds the second number.
#	$a3 holds the third number.
#	$v0 contains the maximum among the 3 numbers
#   Write your code here
addi $sp, $sp, -20 	# move stack pointer up, prepare new stack
sw $ra, 4($sp)		# store the return addres+s
sw $fp, 8($sp)		# store the address of the current frame pointer
addi $fp, $sp, 20	# move the frame pointer up

slt $t0, $a1, $a2	# check if $a1 < $a2
beq $t0, $0, check	# if $a1 > $a2, check for $a1 > $a3, otherwise $a2 > $a1 and check $a2 > $a3
slt $t1, $a2, $a3	# check if $a2 > $a3
beq $t1, $0, second 	# if $a2 > $a3, then $a2 is maximum
j FindMax3end
check:
slt $t1, $a2, $a3	# check if $a1 > $a3
beq $t1, $0, first	# if $a1 > $a3, then $a1 is the largest
add $v0, $0, $a3	# otherwise, $a3 is the largest, so set $v0 to $a3
j FindMax3End
first:
add $v0, $0, $a1	# $a1 is the maximum, so set $v0 to $a1
second:
add $v0, $0, $a2
FindMax3End:
lw $ra, 4($sp)		# load the return address
lw $fp, 8($sp) 		# load the address of the frame pointer
addi $sp, $sp, 20	# move the stack pointer down, prepare to jump return
jr $ra

