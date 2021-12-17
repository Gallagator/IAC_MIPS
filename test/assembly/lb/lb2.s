	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    lui $3, 0xF185
    addiu $3, 0x7739
    addiu $25, 0x3FFC
    sw $3, -128($25)

    lb $4, -128($25)
    addu $2, $2, $4
    lb $4, -127($25)
    addu $2, $2, $4
    lb $4, -126($25)
    addu $2, $4
    lb $4, -125($25)
    addu $2, $4

    jr $0
    nop 
.end	main
