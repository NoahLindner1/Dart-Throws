			.text
			.align		2
			.global		main

main:
			stp		x29, x30, [sp, -16]!
			stp		x20, x21, [sp, -16]!

			mov			x20, x1					//moves argv into x20
			ldr			x20, [x20, 8]			//dereferenes it to the number of executions
			cbz			x20, emptyList			//checks to see if there is an argument otherwise breaks to empty argument scenario
			mov			x0, x20					//moves that value into x0 for atoi
			bl			atoi					//converts the argument to an int
			mov			x20, x0					//move int into x20
			mov			x0, x20
			ldr			x0, =test
			bl			printf

emptyList:
			ldr			x0, =100000
			mov			x20, x0
			mov			x1, x20
			ldr			x0, =test
			bl			printf

bottom:
			ldp		x20, x21, [sp], 16
			ldp		x29, x30, [sp], 16

			.data

execution:	.asciz		"executing: %d iterations\nHits: %d\nApproximation: %f\n"
test:		.asciz		"execution: %d iterations\n"
			.end


