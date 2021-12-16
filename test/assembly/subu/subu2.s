.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 132
    addiu  $4, 79
    jr $0
    subu  $2, $4, $3
.end	main
