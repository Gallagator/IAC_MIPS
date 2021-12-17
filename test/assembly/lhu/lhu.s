	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $4, $0, 0xACFF
    sw    $4, 0($0)    /* mem addr is 4 = 8 - 4 */
    jr $0
    lhu   $2, 0($0)    /* Address calculation must be a multiple of 2 */ 
.end	main
