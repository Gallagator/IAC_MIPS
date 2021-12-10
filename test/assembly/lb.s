	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $4, $0, 0xACFF
    addiu $5, $0, 0x8
    sw    $4, -4($5)    /* mem addr is 4 = 8 - 4 */
    lw    $2, -4($5)    /* mem addr is 4 = 8 - 4 */
    lb    $2, -3($5)    
    jr $0
.end	main
