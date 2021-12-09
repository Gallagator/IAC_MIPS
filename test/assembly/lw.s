	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $4, $0, 1234 
    addiu $5, $0, 0x8
    sw    $4, 0xFFFE($5)    /* mem addr is 6 = 8 - 2 */
    lw    $2, 0xFFFE($5)    /* mem addr is 6 = 8 - 2 */
    jr $0
.end	main

