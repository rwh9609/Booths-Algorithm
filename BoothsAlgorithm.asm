# Randy Hartzell
# November 2018, Computer Architecture and Assembler
# Dr. Hale

.data
	message: .asciiz "Input a number: "
	message2: .asciiz "Input a second number: "
	boothMessageMcand: .asciiz "The binary value of the multiplicand is: "
	boothMessageMplier: .asciiz "The binary value of product/multiplier is: "
	input: .space 20
.text
	main:
		# asks user for input
		li $v0, 4 # load code 4 into $v0 to display message
		la $a0, message
		syscall
		
		# gets input
		li $v0, 8 # code 8 into $v0 for syscall to get user input
		la $a0, input # $a0 points to memory address at 'input'
		li $a1, 20 # allocates 20 bytes
		syscall
		
		# loads memory address of string at $a0 to $t0, starting with the first byte
		add $t0, $a0, $zero
		lb $t1, 0($t0)
		
		# initializing variables
		mul $v0, $v0, $zero
		li $t2, 10 # this will be used to multiply digits to obtain an accurate base 10 integer

		# determine if negative, if so, store the negative sign and load the next byte before branching to loop.
		beq $t1, 45, Negative
		
	# loops through the string inputted by the user
	# branches if encounters any non-digits
	# iteration takes a digit at a time from the string
	# and multiplies by the correct power of 10
	# to be added into register $v0 properly
	Loop:
		# checks if loop reached null terminator, checking to see if this was a negative int now
		beq $t1, 10, CheckNegative 
		
		# branch if one of the chars isn't a digit, return -1
		blt $t1, 48, Error
		bgt $t1, 73, Error
		
		# substract ascii by 48 to obtain an integer representation
		sub $t1, $t1, 48 
		
		# multiply the digit by the correct base 10 if not the first digit
		mul $v0, $v0, $t2
		add $v0, $v0, $t1
		
		# on to the next byte
		addiu $t0, $t0, 1
		lb $t1, 0($t0) #loading the byte 

		j Loop
	
	# string has an invalid character in it, return -1
	Error:
		mul $v0, $v0, $zero #setting $v1 to zero to add -1 to it
		add $v0, $v0, -1
		j ErrorExit
		
	# if the first digit of the number is negative, load the next byte and store a -1 into $t4
	Negative:
		addi $t4, $t4, -1
		addiu $t0, $t0, 1
		lb $t1, 0($t0)
		j Loop
	
	# after getting the number, this is the final check to see if the number should be negative
	CheckNegative:
		beq $t4, -1, ComputeNegative
		add $s0, $v0, $s0
		j SecondInt
		
	#multiplies the number by -1 to make it negative
	ComputeNegative:
		sub $s0, $zero, $v0
		mul $v0, $v0, $t4
		j SecondInt

	SecondInt:
	
		# resets the check negative register
		add $t4, $zero, $zero
		
		# asks user for input
		li $v0, 4 # load code 4 into $v0 to display message
		la $a0, message
		syscall
		
		# gets input
		li $v0, 8 # code 8 into $v0 for syscall to get user input
		la $a0, input # $a0 points to memory address at 'input'
		li $a1, 20 # allocates 20 bytes
		syscall
		
		# loads memory address of string at $a0 to $t0, starting with the first byte
		add $t0, $a0, $zero
		lb $t1, 0($t0)
		
		# initializing variables
		mul $v0, $v0, $zero
		li $t2, 10 # this will be used to multiply digits to obtain an accurate base 10 integer

		# determine if negative, if so, store the negative sign and load the next byte before branching to loop.
		beq $t1, 45, SecondNegative
		
	# loops through the string inputted by the user
	# branches if encounters any non-digits
	# iteration takes a digit at a time from the string
	# and multiplies by the correct power of 10
	# to be added into register $v0 properly
	SecondLoop:
		# checks if loop reached null terminator, checking to see if this was a negative int now
		beq $t1, 10, SecondCheckNegative 
		
		# branch if one of the chars isn't a digit, return -1
		blt $t1, 48, SecondError
		bgt $t1, 73, SecondError
		
		# substract ascii by 48 to obtain an integer representation
		sub $t1, $t1, 48 
		
		# multiply the digit by the correct base 10 if not the first digit
		mul $v0, $v0, $t2
		add $v0, $v0, $t1
		
		# on to the next byte
		addiu $t0, $t0, 1
		lb $t1, 0($t0) #loading the byte 

		j SecondLoop
	
	# string has an invalid character in it, return -1
	SecondError:
		mul $v0, $v0, $zero #setting $v1 to zero to add -1 to it
		add $v0, $v0, -1
		j ErrorExit
		
	# if the first digit of the number is negative, load the next byte and store a -1 into $t4
	SecondNegative:
		add $t4, $zero, $zero
		addi $t4, $t4, -1
		addiu $t0, $t0, 1
		lb $t1, 0($t0)
		j SecondLoop
	
	# after getting the number, this is the final check to see if the number should be negative
	SecondCheckNegative:
		beq $t4, -1, SecondComputeNegative
		add $s1, $v0, $s1
		j ComputeBooth
		
	#multiplies the number by -1 to make it negative
	SecondComputeNegative:
		sub $s1, $zero, $v0
		mul $v0, $v0, $t4
		j ComputeBooth




	# AT THIS POINT
	# WE HAVE TWO INPUTTED NUMBERS
	# STORED IN REGISTERS $S0 and $S1
	# TIME TO IMPLEMENT BOOTH'S ALGORITHM
	
	

	#S0 is the multiplicand
	#S3 is the multiplier
	#Need to expand the multiplier/product to be two registers. probably $S2 and $S3
	#Need to initially load $S2 to be a string of 0S
	#Need to initially load $S3 to be $S1
	ComputeBooth:
	
		add $s0, $s0, $zero   #Multiplicand
		add $s2, $s2, $zero   #product/multiplier
		add $s3, $s3, $s1     #product/multiplier cont'd
	
		# prints a new line
		li $v0, 11
		addi $a0, $zero, 10
		syscall
		
		# prints the booth message
		li $v0, 4
		la $a0, boothMessageMcand
		syscall
		
		# prints a new line
		li $v0, 11
		addi $a0, $zero, 10
		syscall

		# PRINTS THE MULTIPLICAND
		li $v0, 35 # load code 35 into $v0 to the binary value of the product/multiplier
		add $a0, $s0, $zero
		syscall

		
		# prints a new line
		li $v0, 11
		addi $a0, $zero, 10
		syscall


		# prints the booth message
		li $v0, 4
		la $a0, boothMessageMplier
		syscall
		
		# prints a new line
		li $v0, 11
		addi $a0, $zero, 10
		syscall

		# PRINTS THE MULTIPLIER/PRODUCT RESULT 
		li $v0, 35 # load code 35 into $v0 to the binary value of the product/multiplier
		add $a0, $s2, $zero
		syscall
		li $v0, 35
		add $a0, $s3, $zero
		syscall
	
		# prints a new line
		li $v0, 11
		addi $a0, $zero, 10
		syscall
		
		# store the implicit 0 
		add $s5, $s5, $zero


		# prints a new line
		li $v0, 11
		addi $a0, $zero, 10
		syscall
		# prints a new line
		li $v0, 11
		addi $a0, $zero, 10
		syscall

		# prints a space
		li $v0, 11
		addi $a0, $zero, 0x20
		syscall
		# prints a space
		li $v0, 11
		addi $a0, $zero, 0x20
		syscall
		# prints a string of zeros in front of multiplicand
		li $v0, 35
		add $a0, $s2, $zero
		syscall

		# PRINTS THE MULTIPLICAND
		li $v0, 35 # load code 35 into $v0 to the binary value of the product/multiplier
		add $a0, $s0, $zero
		syscall

		
		# prints a new line
		li $v0, 11
		addi $a0, $zero, 10
		syscall

		
		# prints the 'x' symbol
		li $v0, 11
		add $a0, $zero, $zero
		addi $a0, $zero, 0x58
		syscall
		# prints a space
		li $v0, 11
		addi $a0, $zero, 0x20
		syscall
		
		# PRINTS THE MULTIPLIER/PRODUCT RESULT 
		li $v0, 35 # load code 35 into $v0 to the binary value of the product/multiplier
		add $a0, $zero, $zero
		add $a0, $s2, $zero
		syscall
		li $v0, 35
		add $a0, $s3, $zero
		syscall

		# prints a new line
		li $v0, 11
		add $a0, $zero, $zero
		addi $a0, $zero, 10
		syscall
		
		# prints a underscores
		add $t0, $zero, $zero
	UnderscoreLoop:
		li $v0, 11
		addi $a0, $zero, 0x5F
		syscall
		addi $t0, $t0, 1
		bne $t0, 66, UnderscoreLoop
		
		# prints a new line
		li $v0, 11
		add $a0, $zero, $zero
		addi $a0, $zero, 10
		syscall
		
		
		#initialize a register to be a mask to determine whether to subtract or add 
		# the mcand to the mplier, or do nothing, initally setting it to zero
		add $t4, $zero, $zero
		
		#the counter register
		add $t6, $zero, $zero
		add $t7, $zero, $zero
		#intialize a variable to capture the rightmost bit of the mcand so that
		#when it's shifted, that bit isn't lost
		add $t5, $zero, $zero
		
		# prints a new line
		li $v0, 11
		add $a0, $zero, $zero
		addi $a0, $zero, 10
		syscall
		
		# PRINTS THE MULTIPLIER/PRODUCT RESULT 
		li $v0, 35 # load code 35 into $v0 to the binary value of the product/multiplier
		add $a0, $zero, $zero
		add $a0, $s2, $zero
		syscall
		li $v0, 35
		add $a0, $s3, $zero
		syscall


	BoothAlgorithm:
		# check the last digit of the mplier
		andi $t2, $s3, 0x00000001
		# logic to determine which operation to do
		# this will be a 1 if an add or sub is needed
		xor $t7, $t2, $s7
		
		# resets $t5 to zero
		add $t5, $zero, $zero
		beq $t7, 1, BoothAddOrSub
		j BoothShift
	BoothCounter:

		# print current state 
		# prints a new line
		li $v0, 11
		add $a0, $zero, $zero
		addi $a0, $zero, 10
		syscall
		# PRINTS THE MULTIPLIER/PRODUCT RESULT 
		li $v0, 35 # load code 35 into $v0 to the binary value of the product/multiplier
		add $a0, $zero, $zero
		add $a0, $s2, $zero
		syscall
		li $v0, 35
		add $a0, $s3, $zero
		syscall
		
		# keep chugging through until 32 passes
		addi $t6, $t6, 1
		bne $t6, 32, BoothAlgorithm
		j Exit
	BoothAddOrSub:
		andi $t2, $s3, 0x00000001
		beq $t2, 1, BoothSub
		add $s2, $s0, $s2
		j BoothShift
	BoothSub:
		addi $t3, $zero, 5
		sub $s2, $s2, $s0
		j BoothShift
	BoothShift:
		# captures the last bit of left part of mplier
		andi $t1, $s2, 0x00000001
		# captures last bit of the rightmost part of the mplier
		andi $s7, $s3, 0x00000001
		
		
		sra $s2, $s2, 1
		sra $s3, $s3, 1
		
		beq $t1, 1, BoothShiftSetMostSignificantBitToOne

		# else set it to zero
		andi $s3, $s3, 0x7FFFFFFF
		
	BoothShiftEnd:
		j BoothCounter
		
	BoothShiftSetMostSignificantBitToOne:
		ori $s3, $s3, 0x80000000
		j BoothShiftEnd
		
	Exit:
		# prints a new line
		li $v0, 11
		add $a0, $zero, $zero
		addi $a0, $zero, 10
		syscall
		
		# prints a underscores
		add $t0, $zero, $zero
	SecondUnderscoreLoop:
		li $v0, 11
		addi $a0, $zero, 0x5F
		syscall
		addi $t0, $t0, 1
		bne $t0, 64, SecondUnderscoreLoop

		# prints a new line
		li $v0, 11
		add $a0, $zero, $zero
		addi $a0, $zero, 10
		syscall

		# PRINTS THE MULTIPLIER/PRODUCT RESULT 
		li $v0, 35 # load code 35 into $v0 to the binary value of the product/multiplier
		add $a0, $zero, $zero
		add $a0, $s2, $zero
		syscall
		li $v0, 35
		add $a0, $s3, $zero
		syscall

	ErrorExit:
	