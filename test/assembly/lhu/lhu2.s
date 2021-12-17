	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    lui $3, 0xF185
    addiu $3, 0x7739
    addiu $25, 0x3CFC
    sw $3, -128($25)

    jr $0
    lhu $2, -126($25)
.end	main
