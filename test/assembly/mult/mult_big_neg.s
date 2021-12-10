	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    lui $3, 0xA463
    lui $4, 0x6748
    addiu $4, $4, 0x45
    mult $3, $4
    mfhi $2
    jr $0
    mflo $4
.end	main
