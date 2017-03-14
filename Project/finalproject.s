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
addi $sp, $sp, 32	# increment the stack pointer by 32 words
sw   $ra, 0($sp)	# store old return address
sw   $fp, 4($sp)	# store old frame pointer
sw   $a1, 8($sp)	# store the value of s
sw   $a2, 12($sp) 	# store the value of e
sw   $a3, 16($sp)	# store the direction value
sw   $v0, 20($sp) 	# store the return value
jal calculate
sw   $t0, 24($sp) 	# store the value in the array at the current array position
addi $fp, $fp, 32	# increment the frame pointer
execute:
beq $a1, $a2, base_case	# check for base case, s == e
beq $a3, $0, backwards  # if $a3 == 0 then traverse backwards, otherwise, traverse forwards
forwards:
addi $a1, $a1, 1	# increment s by 1
jal MaxSumBoundary	# call MaxSumBoundary on s + 1
jal base_case
jr $ra
backwards:
addi $a2, $a2, -1 	# decrement e by 1
jal MaxSumBoundary	# call MaxSumBoundary on e - 1
jal base_case
jr $ra

base_case:		# we are now at the base case
jal calculate 		# calculate the current array value (base case value)
add $s1, $0, $t0	# store this in $s1
lw $ra, 0($sp)		# load previous stack return address
lw $fp, 4($sp)		# load previous stack frame pointer
add $s2, $s1, $t0	# add the two elements
add $a1, $0, $s1	# load the first number into the argument
add $a2, $0, $s2	# load the second number into the argument
jal FindMax2 		# call the FindMax2 procedure
sw $v0, 28($sp)		# store the result of FindMax2
jr $ra

calculate:
sll $t0, $a1, 2		# multiply s by four
add $t0, $t0, $a0	# add the address of s to the address of the first element of array
lw $t0, 0($t0)		# load arr[s]
add $t0	$0, $t0		# place arr[s] into register $t1
jr $ra
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
