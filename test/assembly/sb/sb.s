    .text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu   $3, $0, 0xABCD # Sign extended
    sw      $3, 4($0)
    addiu   $4, $0, 0x1234
    sb      $4, 7($0)
    jr      $0
    lw      $2, 4($0)
.end	main

