    .text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    lui   $3, 0x7FFF
    addiu $3, $3, 1
    sw    $3, 0($0)
    lw    $2, 0($0)
    jr $0
.end	main
