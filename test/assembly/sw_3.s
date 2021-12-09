	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $4, $0, 1234
    addiu $5, $0, 0x30
    sw    $4, 8($5)
    lw    $3, 8($5)
    addu  $4, $3, $5
    sw    $4, 8($3)
    lw    $2, 8($3)
    jr $0
.end	main
