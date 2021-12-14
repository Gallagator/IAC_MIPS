	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu $4, $0, 0x1234 
    addiu $5, $0, 0x10
    sw    $4, -4($5)    /* mem addr is 12 = 16 - 4 For this testcase it fails*/
    jr $0
    lw    $2, -4($5)    /* mem addr is 12 = 16 - 4 */
.end	main

