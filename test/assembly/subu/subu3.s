.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 0x7FFF
    addiu  $4, 0xFFFF
    jr $0
    subu  $2, $4, $3
.end	main
