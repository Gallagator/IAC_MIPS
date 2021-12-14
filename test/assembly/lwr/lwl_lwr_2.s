    .text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    lui   $4, 0x0001
    addiu $4, $4, 0x0203 
    sw    $4, 0($0)
    lw    $3, 0($0)
    lui   $4, 0x0405
    addiu $4, $4, 0x0607
    sw    $4, 4($0)
    lw    $3, 4($0)
    lwl   $2, 4($0)
    lwr   $2, 7($0)
    jr $0
.end	main
