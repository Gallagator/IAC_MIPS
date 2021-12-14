	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $4, $0, 1234 
    addiu $5, $0, 0x8
    sw    $4, -4($5)    /* mem addr is 4 = 8 - 4 */
    jr $0
    lw    $2, -4($5)    /* mem addr is 4 = 8 - 4 */
.end	main

