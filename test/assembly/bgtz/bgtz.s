    .text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu   $3, $0, 0x1
    bgtz    $3, .L1
    addiu   $2, $0, 0x7
    addiu   $2, $2, 0
    jr      $0
	addiu   $2, $2, 0
.L1:
    addiu   $2, $2, 0x1
    jr      $0
    addiu   $2, $2, 0x1

.end	main
