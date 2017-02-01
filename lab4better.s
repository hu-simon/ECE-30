.globl main
.globl classmarks
.globl compare

.text

main:   addi  $sp, $sp, -12     #establish new frame. decrement the stack pointer
	sw    $ra, 8($sp)       #save return address
	sw    $fp, 4($sp)       #save old frame pointer
        addi  $fp, $sp, 12      #set frame pointer
	li    $a0, 3		#set M = 3
	li    $a1, 0x10010000	#set MARKS1
	addiu $a2, $a1, 16	#set MARKS2
	addiu $a3, $a2, 16	#set FINAL_MARKS
	li    $t0, 44
	sw    $t0, 0($a1)
	li    $t0, 45
	sw    $t0, 4($a1)
	li    $t0, 43
	sw    $t0, 8($a1)
	li    $t0, 43
	sw    $t0, 0($a2)
	li    $t0, 47
	sw    $t0, 4($a2)
	li    $t0, 42 
	sw    $t0, 8($a2)
	jal   classmarks
	lw    $ra, 8($sp)
	lw    $fp, 4($sp)
	addi  $sp, $sp, 12
	jr    $ra

classmarks:  addi $sp, $sp, -36  #set aside space for the stack frame. 
				 #for save registers, frame pointers, return
	     sw   $fp, 4($sp)	 #save old frame pointer
	     sw   $ra, 8($sp)    #save return address
	     
	     sw   $s1, 12($sp)   #save save registers
	     sw   $s2, 16($sp)
	     sw   $s3, 20($sp)
	     sw   $s4, 24($sp)
             sw   $s5, 28($sp)
             sw   $s6, 32($sp)
             sw   $s7, 36($sp)
	 
	     addi $fp, $sp, 36 #set frame pointer

             addi $s0, $s0, 0 	 #initialize i
	     addi $s1, $a0, 0 	 #put m = 3 into a saved register
	     sw   $s2, 0($a1)    #store first element of MARKS1
	     sw   $s3, 0($a2)    #same as above but with MARKS2
             sw   $s4, 0($a3)    #same as above but with FINAL_MARKS
loop:        slt  $t1, $s0, $s1 
	     beq  $t1, $0, finish
	     lw   $t2, 0($s2)    #MARKS1[i]
             lw   $t3, 0($s3)    #MARKS2[i]
	     jal  compare
	     slt  $t1, $s5, $0   #returns 1 if $s5 < 0
             beq  $t1, $0, else  #if $s5 > 0
             sw   $s3, 0($s4) 	 #store MARKS2 into FINAL_MARKS
             j    increment
else:        sw   $s2, 0($s4)    #store MARKS1 into FINAL_MARKS
increment:   addi $s0, $s0, 1    #increment the pointers in each of the respective arrays
	     addi $a1, $a1, 4
	     addi $a2, $a2, 4
             addi $a3, $a3, 4
	     j    loop           #jump back to loop
finish:      lw   $fp, 4($sp)    #restore the frame pointer
	     lw   $ra, 8($sp)    #restore the return address 
	     lw   $s1, 12($sp)   #restore the saved save registers
	     lw   $s2, 16($sp)   
 	     lw   $s3, 20($sp) 
	     lw   $s4, 24($sp)
             lw   $s5, 28($sp)
             lw   $s6, 32($sp)
             lw   $s7, 36($sp)
             addi $sp, $sp, 36   #restore the stack pointer
             jr   $ra            #return to the old $ra

compare:     sub  $s5, $t2, $t3  #compare the two numbers
    	     jr   $ra

	     
             
	     
	     
	     
	     

