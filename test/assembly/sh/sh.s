    .text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu   $3, $0, 0xABCD
    sw      $3, 4($0)
    addiu   $5, $0, 0x8
    addiu   $4, $0, 0x1234
    sh      $4, -4($5)
    jr      $0
    lw      $2, 4($0)
.end	main
