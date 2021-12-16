	.text
	.align	2
	.globl	main
	.ent	main
main:
    .set	noreorder
    lui $3, 0xBFC0
    addiu $3, $3, 28
    jalr $8, $3
    addiu $2, $2, 1
    jr $0
    addiu $2, $2, 2
    
    addiu $2, $2, 4
    addiu $2, $2, 52
    jr $0
    addiu $2, $2, 32

    addiu $2, $2, 64
    jr $14
    addiu $2, $2, 128
    jr $0
    addiu $2, $2, 256

.end	main
