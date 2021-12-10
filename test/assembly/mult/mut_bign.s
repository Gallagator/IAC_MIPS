	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    lui $3, 0x8000
    mult $3, $3
    mfhi $2
    mflo $4
    jr $0
.end	main
