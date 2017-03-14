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
#	$a1 intains s 
#	$a2 contains e
#	$a3 is the direction (either 0 or 1)
#	$v0 returns the maximum subarray
#   Write your code here
addi $sp, $sp, 32		#increment the stack pointer
sw   $ra, 0($sp)		#store old return address
sw   $fp, 4($sp)		#store old frame pointer
sw   $a1, 8($sp) 		#store the value of s
sw   $a2, 12($sp) 		#store the value of e
sw   $a3, 16($sp)		#store the direction value
sw   $v0, 20($sp)		#store the return value
sw   $s1, 24($sp)
addi $fp, $fp, 32		#increment the frame pointer
main:
beq  $a1, $a2, base		#check for base case, when s = e
beq  $a3, $0, traverseb		#if $a3 = 0, then traverse backwards
traversef:
jal findMax2
addi $a1, $a1, 1		#increment s by 1
j MaxSumBoundary		#call MaxSumBoundary
traverseb:
jal findMax2
addi $a1, $a1, -1
j MaxSumBoundary

base:
sll  $t0, $a1, 2		#multiply s by four
add  $t0, $t0, $a0		#add the address of s to the address of the first element of arr[]
lw   $t0, 0($t0)		#load arr[s]
add  $v0, $0, $t0		#place arr[s] into the output register
lw   $ra, 0($sp) 		#load the return address
lw   $fp, 4($sp) 		#load the frame pointer
addi $fp, $0, -32		#decrement the frame pointer
jr i  $ra


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
beq  $a1, $a2, base
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
base: 
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
 T I C E !!! *** END OF WINTER QUARTER *** ACCOUNTS DELETION ***
====================================================================
   Tuesday March 28, 2017 is the last day class accounts & disk
   space will be accessible, they will be deleted the following day.
   Please back up all your files you wish to keep BEFORE that date.

   For reasons accounts may be closed/suspended see:
      https://acms.ucsd.edu/students/account-status.shtml
      https://acms.ucsd.edu/students/account-closure-todo.shtml
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



Account information for user: jhhu
        Remaining allocation for jhhu was 55.00 units
        as of Fri Mar 10 05:15:06 2017
jhhu is connected to recharge printer (real-money) account: la069119
        la069119 balance: $13.60
        la069119 status is: active
        la069119 access groups: nocover
=============================================================
For details about your account resources, please use the
Account Lookup Tool on our website at http://acms.ucsd.edu
=============================================================


/*-----------------------------------------------------------
Server running slow due to too many users?
        There are 10 compute servers available:
        ieng6-240,ieng6-241,ieng6-242,ieng6-243,ieng6-244,ieng6-245,ieng6-246
        ieng6-247,ieng6-248,ieng6-249,ieng6-250,ieng6-251,ieng6-252,ieng6-253
        ieng6-254

ECE students, please check with your TA or instructor on which hosts
you can run your projects.

Please do not login to ieng6-640 or ieng6-641, your processes will be
killed unless you're authorized to use these hosts.
-----------------------------------------------------------*/


To see all available software packages, type "prep -l" at the command prompt,
or "prep -h" for more options.
[jhhu@ieng6-201]:~:501$ cd Desktop/ECE30/ECE-30/Project/
[jhhu@ieng6-201]:Project:502$ vim project.s
[jhhu@ieng6-201]:Project:503$ rm .project.s.swp
[jhhu@ieng6-201]:Project:504$ vim project.s
[jhhu@ieng6-201]:Project:505$ git add
Nothing specified, nothing added.
Maybe you wanted to say 'git add .'?
[jhhu@ieng6-201]:Project:506$ git add project.s
[jhhu@ieng6-201]:Project:507$ git commit -m "Commiting"
[master b9098dc] Commiting
 1 file changed, 7 insertions(+), 17 deletions(-)
[jhhu@ieng6-201]:Project:508$ git push origin master
Counting objects: 4, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (4/4), 409 bytes | 0 bytes/s, done.
Total 4 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To https://www.github.com/hu-simon/ECE-30
   0bc44f5..b9098dc  master -> master
[jhhu@ieng6-201]:Project:509$ vim project.s
[jhhu@ieng6-201]:Project:510$ vim project.s
[jhhu@ieng6-201]:Project:510$ vim project.s
jr $ra

##########################################################
FindMax2:
#       $a1 holds the first number.
#       $a2 holds the second number.
#       $v0 contains the maximum between the 2 input numbers.
#       Write your code here
#       Code last checked on 2/7/2017. Confirmed to be working.

slt $t0, $a1, $a2       #see if $a1 is less than $a2
beq $t0, $0, done       #if $a1 > $a2, then jump to done procedure
add $v0, $0, $a2        #if $a1 < $a2, then set $v0 to $a2
jr $ra                  #return to caller
done:
add $v0, $0, $a1        #if $a1 > $a2, then set $v0 to $a1
jr $ra

FindMax3:
##########################################################
#       $a1 holds the first number.
#       $a2 holds the second number.
#       $a3 holds the third number.
#       $v0 contains the maximum among the 3 numbers
#       Write your code here
#       Code last checked on 2/7/2017. Confirmed working.
slt $t0, $a1, $a2       #check if $a1, is less than $a2
beq $t0, $0, check      #if $a1 > $a2, then see if $a1 > $a3, otherwise $a2 > $a1, then check if $a2 > $a3
slt $t1, $a2, $a3       #check if $a2 > $a3
beq $t1, $0, second     #if $a2 > $a3, then the second number is the maximum
jr $ra
check:
slt $t1, $a1, $a3       #check if $a1 > $a3
beq $t1, $0, first      #if $a1 > $a3, then $a1 is the largest
add $v0 $0, $a3         #otherwise, $a3 is the biggest so set $v0 to $a3
jr $ra
first:
add $v0, $0, $a1        #$a1 is the maximum, so set $v0 to $a1
jr $ra
second:
add $v0, $0, $a2        #$a2 is the maximum, so set $v0 to $a2
jr $ra
                                           ==========================================

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 N O T I C E !!! *** END OF WINTER QUARTER *** ACCOUNTS DELETION ***
====================================================================
   Tuesday March 28, 2017 is the last day class accounts & disk
   space will be accessible, they will be deleted the following day.
   Please back up all your files you wish to keep BEFORE that date.

   For reasons accounts may be closed/suspended see:
      https://acms.ucsd.edu/students/account-status.shtml
      https://acms.ucsd.edu/students/account-closure-todo.shtml
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>



Account information for user: jhhu
        Remaining allocation for jhhu was 55.00 units
        as of Fri Mar 10 05:15:06 2017
jhhu is connected to recharge printer (real-money) account: la069119
        la069119 balance: $13.60
        la069119 status is: active
        la069119 access groups: nocover
=============================================================
For details about your account resources, please use the
Account Lookup Tool on our website at http://acms.ucsd.edu
=============================================================


/*-----------------------------------------------------------
Server running slow due to too many users?
        There are 10 compute servers available:
        ieng6-240,ieng6-241,ieng6-242,ieng6-243,ieng6-244,ieng6-245,ieng6-246
        ieng6-247,ieng6-248,ieng6-249,ieng6-250,ieng6-251,ieng6-252,ieng6-253
        ieng6-254

ECE students, please check with your TA or instructor on which hosts
you can run your projects.

Please do not login to ieng6-640 or ieng6-641, your processes will be
killed unless you're authorized to use these hosts.
-----------------------------------------------------------*/


To see all available software packages, type "prep -l" at the command prompt,
or "prep -h" for more options.
[jhhu@ieng6-201]:~:501$ ceng6-201]:Project:505$ git add
Nothing specified, nothing added.
Maybe you wanted to say 'git add .'?
[jhhu@ieng6-201]:Project:506$ git add project.s
[jhhu@ieng6-201]:Project:507$ git commit -m "Commiting"
[master b9098dc] Commiting
 1 file changed, 7 insertions(+), 17 deletions(-
[jhhu@ieng6-201]:Project:503$ rm .project.s.swp
[jhhu@ieng6-201]:Project:504$ vim project.s
[jhhu@ieng6-201]:Project:505$ git add
Nothing specified, nothing added.
Maybe you wanted to say 'git add .'?
[jhhu@ieng6-201]:Project:506$ git add project.s
[jhhu@ieng6-201]:Project:507$ git commit -m "Commiting"
[master b9098dc] Commiting
 1 file changed, 7 insertions(+), 17 deletions(-)
[jhhu@ieng6-201]:Project:508$ git push origin master
Counting objects: 4, done.
Delta compression using up to 8 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (4/4), 409 bytes | 0 bytes/s, done.
Total 4 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To https://www.github.com/hu-simon/ECE-30
   0bc44f5..b9098dc  master -> master
[jhhu@ieng6-201]:Project:509$ vim project.s
[jhhu@ieng6-201]:Project:510$ vim project.s
[jhhu@ieng6-201]:Project:510$ vim project.s
jr $ra

##########################################################
FindMax2:
#       $a1 holds the first number.
#       $a2 holds the second number.
#       $v0 contains the maximum between the 2 input numbers.
#       Write your code here
#       Code last checked on 2/7/2017. Confirmed to be working.

slt $t0, $a1, $a2       #see if $a1 is less than $a2
beq $t0, $0, done       #if $a1 > $a2, then jump to done procedure
add $v0, $0, $a2        #if $a1 < $a2, then set $v0 to $a2
jr $ra                  #return to caller
done:
add $v0, $0, $a1        #if $a1 > $a2, then set $v0 to $a1
jr $ra

FindMax3:
##########################################################
#       $a1 holds the first number.
#       $a2 holds the second number.
#       $a3 holds the third number.
#       $v0 contains the maximum among the 3 numbers
#       Write your code here
#       Code last checked on 2/7/2017. Confirmed working.
slt $t0, $a1, $a2       #check if $a1, is less than $a2
beq $t0, $0, check      #if $a1 > $a2, then see if $a1 > $a3, otherwise $a2 > $a1, then check if $a2 > $a3
slt $t1, $a2, $a3       #check if $a2 > $a3
beq $t1, $0, second     #if $a2 > $a3, then the second number is the maximum
jr $ra
check:
slt $t1, $a1, $a3       #check if $a1 > $a3
beq $t1, $0, first      #if $a1 > $a3, then $a1 is the largest
add $v0 $0, $a3         #otherwise, $a3 is the biggest so set $v0 to $a3
jr $ra
first:
add $v0, $0, $a1        #$a1 is the maximum, so set $v0 to $a1
jr $ra
second:
add $v0, $0, $a2        #$a2 is the maximum, so set $v0 to $a2
jr $ra
