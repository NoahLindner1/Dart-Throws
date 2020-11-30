			.text
			.align		2
			.global		main

		//Dictionary
		//x20			as argv (iterations)
		//x21			as i to compare against iterations
		//x22			x
		//x23			y
		//d20			pi approximation float	//should this be a different d register so it doesnt overlap with x20?, do i need a x register to hold pi too and then I conver it to a float?
		//d22			holds float x value
		//d24			holds randmax value
		//x25			hits amount
		//d25		    holds float y value		//should this be d23???

main:
			stp			x29, x30, [sp, -16]!
			stp			x20, x21, [sp, -16]!
			stp			x22, x23, [sp, -16]!
			stp			x24, x25, [sp, -16]!
			stp			d20, d21, [sp, -16]!

			mov			x25, xzr				//sets hits amount to zero register
			mov			x21, xzr				//sets i value to zero register

			mov			x20, x1					//moves argv into x20
			ldr			x20, [x20, 8]			//dereferenes it to the number of executions
			cbz			x20, emptyList			//checks to see if there is an argument otherwise breaks to empty argument scenario
			mov			x0, x20					//moves that value into x0 for atoi
			bl			atoi					//converts the argument to an int
			mov			x20, x0					//move int into x20
			mov			x0, xzr

			bl			time
			bl			srand

			mov			x1, x20					//moves argv value back into x0 for print
			ldr			x0, =iterations
			bl			printf
	
			b			genNums					//break to genNums now that we have the amount of executions

loop:		
			cmp			x21, x20				//compares the number of executions to the number we have done so far
			bge			solve					//if i >= to executions go to solve
			b			genNums					//otherwise keep generating numbers

emptyList:
			ldr			x0, =100000				//loads 1000000 into x0 as the default value when no arguments
			mov			x20, x0					//moves it into x20
			mov			x1, x20
			ldr			x0, =iterations
			bl			printf
			b			genNums					//goes into gen nums to generate 100000 executions


genNums:
			stp			d25, d26, [sp, -16]!
			stp			d22, d24, [sp, -16]! 	

			str			x0, [sp, -16]			//store x0 on the stack
			bl			rand
			ldr			x1, [sp], 16			//restores x1
			mov			x22, x0					//moves random number into x22
			ldr			x0, =2147483647			//loads RAND_MAX value into x0
			scvtf		d24, x0					//converts x0 into float
			scvtf		d22, x22				//converts random x value into a float
			fdiv		d22, d22, d24			//divides x value by randmax
		
			str			x0, [sp, -16]			//repeats the same process, but now to generate a y value (d25)
			bl			rand
			ldr			x1, [sp], 16
			mov			x23, x0
			ldr			x0, =2147483647
			scvtf		d24, x0
			scvtf		d25, x23
			fdiv		d25, d25, d24

			/* 
			mov			x0, x23
			ldr			x0, =fptest
			bl			printf
			*/
			add			x21, x21, 1				//increments i because we have done a execution
			b			squareroot				//branches to squareroot to test
			ldp			d22, d24, [sp], 16		
			ldp			d25, d26, [sp], 16
			//am I deleting what these registers are holding?
			
squareroot:
			fmov		d0, 1.0				//sets d0 to 1 so it can be used to compare
			fmul		d22, d22, d22			//squares x
			fmul		d25, d25, d25			//squares y
			fadd		d20, d22, d25			//adds (x and y)
			fsqrt		d20, d20				//square root that value
			fcmp		d20, d0					//compares result to 1
			bge			loop					//if the result is 1 or greater go do it for the next set
			b			increment				//otherwise go increment it

increment:
			add			x25, x25, 1				//adds to the number of hits
			b			loop					//branches back to loop to go through process again

solve:
			scvtf		d0, x20					//turnes iterations into a float
			scvtf		d1, x25					//turns hits into a float
			fmov		d2, 4.0					//moves 4 into d2
			fdiv		d3, d1, d0				//sets d3 equal to hits / iterations
			fmul		d4, d3, d2				//multiply that by four to get your pi approximation
			fmov		d20, d4					//move that into d20

			b			print
			
print:
			mov			x1, x25					//moves the number of hits into x1 to be printed
			fmov		d0,	d20					//moves the approximation into d2 to be printed
			ldr			x0, =statement			//loads print statement
			bl			printf					//prints it
			b			bottom					//breaks to bottom and closes the program


bottom:
			ldp			d20, d21, [sp], 16
			ldp			x24, x25, [sp], 16
			ldp			x22, x23, [sp], 16
			ldp			x20, x21, [sp], 16
			ldp			x29, x30, [sp], 16		
			ret

			.data

statement:	.asciz		"Hits: %d\nApproximation: %f\n"
iterations:	.asciz		"Executing: %d iterations\n"
fptest:		.asciz		"%f\n"
approxtest:	.asciz		"approx test %f\n"
			.end
