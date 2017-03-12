# ECE 30 Winter 2017
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
addi $a3, $0, 1
la $a0, array1
jal MaxSumBoundary # MaxSubArraySum(arr,0, size-1);
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
addi $sp, $sp, -32		#increment the stack pointer
sw   $ra, 0($sp)		#store old return address
sw   $fp, 4($sp)		#store old frame pointer
sw   $a1, 8($sp) 		#store the value of s
sw   $a2, 12($sp) 		#store the value of e
sw   $a3, 16($sp)		#store the direction value
sw   $v0, 20($sp)		#store the return value
sw   $s1, 24($sp)
addi $fp, $fp, -32		#increment the frame pointer
main_procedure:
beq  $a1, $a2, base		#check for base case, when s = e
beq  $a3, $0, traverseb		#if $a3 = 0, then traverse backwards
traversef:
lw   $t1, 0($a0) 
addi $a1, $a1, 4		#increment s by 1
lw   $t2, 4($a0)
add  $t3, $t1, $t2
addi $a0, $t3, 0
addi $a1, $t2, 0
jal FindMax2  
jal MaxSumBoundary		#call MaxSumBoundary

traverseb:
jal FindMax2
addi $a1, $a1, -1
jal MaxSumBoundary

base:
sll  $t0, $a1, 2		#multiply s by four
add  $t0, $t0, $a0		#add the address of s to the address of the first element of arr[]
lw   $t0, 0($t0)		#load arr[s]
add  $v0, $0, $t0		#place arr[s] into the output register
lw   $ra, 0($sp) 		#load the return address
lw   $fp, 4($sp) 		#load the frame pointer
addi $fp, $0, -32		#decrement the frame pointer
jr   $ra


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
beq  $a1, $a2, base_case
add  $t1, $a1, $a2 		#calculate s + e. store this in $t1, which will represent m
srl  $t1, $t1, 1		#divide by 2
callLeft: 			#this procedure will call MaximumSubArraySum on the left subarray
add  $t2, $0, $a2 		#$t2 will store e
add  $a2, $0, $t1		#store m into the argument register
jal  MaximumSubArraySum		#call MaximumSubArraySum
add  $s0, $0, $v0		#store the result in register $s0
callRight:  			#this procedure will call MaximumSubArraySum on the right subarray
add  $t3, $0, $a1		#$t3 will store s
addi $a1, $a2, 1		#set the first argument to m + 1
add  $a2, $0, $t2		#set the second argument to e
jal  MaximumSubArraySum		#call MaximumSubArray
add  $s1, $0, $v0		#store the result in register $s1
callMaxCrossing: 		#this procedure calls the MaxCrossingSum procedure
add  $a1, $0, $t3 		#set first argument register to s
add  $a2, $0, $t1		#set second argument register to m
add  $a3, $0, $t2		#set third argument register to e
jal MaxCrossingSum		#call MaxCrossingSum
add  $s2, $0, $v0		#store the result in $s2
findMax:			#this procedure finds the maximum value of the values found in the previous procedures
add  $a0, $0, $s0		#set the first argument register to the result of the first MaximumSubArraySum call
add  $a1, $0, $s1		#set the second argument register to the result of the second MaximumSubArraySum call 
add  $a2, $0, $s2		#set the final argument register to the result of the MaxCrossingSum call
jal FindMax3			#call the FindMax3 procedure
add  $s4, $0, $v0		#store the result of the FindMax3 call in $s4
done: 
jr $ra
base_case: 
sll  $t0, $a2, 2 		#multiply s by four
add  $t0, $t0, $a0		#add the address of s to the address of the first element of the array
lw   $t0, 0($t0) 		#load arr[s]
add  $v0, $0, $t0		#store value of arr[s] into output register
jr $ra

##########################################################
FindMax2:
#	$a1 holds the first number.
#	$a2 holds the second number.
#	$v0 contains the maximum between the 2 input numbers.
#   	Write your code here
#	Code last checked on 2/7/2017. Confirmed to be working.

slt $t0, $a1, $a2 	#see if $a1 is less than $a2
beq $t0, $0, finish	#if $a1 > $a2, then jump to done procedure
add $v0, $0, $a2	#if $a1 < $a2, then set $v0 to $a2
jr $ra			#return to caller
finish: 
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
