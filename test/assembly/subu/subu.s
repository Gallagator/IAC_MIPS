.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 79
    addiu  $4, 132
    subu  $2, $4, $3
    jr $0
.end	main
