	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 378
    srl   $2, $3, 3
    jr $0
.end	main
