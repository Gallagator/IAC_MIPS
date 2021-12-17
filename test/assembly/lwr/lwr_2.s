   .text
	.align	2
	.globl	main
	.ent	main
main:  
	.set	noreorder
    lui   $3, 0x1234
    addiu $3, 0x5678
    sw    $3, 0($0)
    jr $0
    lwr   $2, 1($0) 
.end	main
