	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $3, 378
    jr $0
    srl   $2, $3, 3
.end	main
