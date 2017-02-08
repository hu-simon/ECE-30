E 30 Winter 2017
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
addi $sp, $sp, 32 		#move the stack pointer up
sw   $ra, 0($sp)		#store the return address 
sw   $..  4($sp)		#
beq  $a1, $a2, baseCase		#check if s == e. if s == e, then we are at the base case of the recursion formula
beq  $a3, $0,  backTraverse	#check if $a3 == 0. if so, then we traverse backwards. else traverse forwards
addi $a1, $0,  1		#traverse forwards. increment s by 1.	
	

backTraverse:
baseCase:
sll  $t0, $a1, 2 		#multiply s by four
add  $t0, $t0, $a0		#add the address of s to the address of the first element of the array
lw   $t0, 0($t0)		#load arr[s]
add  $v0, $0, $t0		#place the value of arr[s] into the output register
sw   $v0, 0x00000021		#store the return value in some random place in memory
jr   $ra 			#jump back to caller

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
#   	Write your code here
#	Code last checked on 2/7/2017. Confirmed to be working.

slt $t0, $a1, $a2 	#see if $a1 is less than $a2
beq $t0, $0, done	#if $a1 > $a2, then jump to done procedure
add $v0, $0, $a2	#if $a1 < $a2, then set $v0 to $a2
jr $ra			#return to caller
done: 
add $v0, $0, $a1	#if $a1 > $a2, then set $v0 to $a1
jr $ra

FindMax3:
##########################################################
#	$a1 holds the first number.
#	$a2 holds the second number.
#	$a3 holds the third number.
#	$v0 contains the maximum among the 3 numbers
#  	Write your code here
#	Code last checked on 2/7/2017. Confirmed working.
slt $t0, $a1, $a2	#check if $a1, is less than $a2
beq $t0, $0, check 	#if $a1 > $a2, then see if $a1 > $a3, otherwise $a2 > $a1, then check if $a2 > $a3
slt $t1, $a2, $a3 	#check if $a2 > $a3
beq $t1, $0, second 	#if $a2 > $a3, then the second number is the maximum
jr $ra
check: 
slt $t1, $a1, $a3 	#check if $a1 > $a3
beq $t1, $0, first	#if $a1 > $a3, then $a1 is the largest
add $v0 $0, $a3		#otherwise, $a3 is the biggest so set $v0 to $a3
jr $ra
first:
add $v0, $0, $a1	#$a1 is the maximum, so set $v0 to $a1
jr $ra
second:
add $v0, $0, $a2 	#$a2 is the maximum, so set $v0 to $a2
jr $ra
