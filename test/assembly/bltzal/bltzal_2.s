    .text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu   $3, $0, 0x0
    bltzal    $3, .L1
    addiu   $2, $0, 0x1
    addiu   $2, $2, 0x1
    addiu   $2, $2, 0x1
    addiu   $2, $2, 0x1
    addiu   $2, $2, 0x1
    addiu   $2, $2, 0x1
    addiu   $2, $2, 0x1
    addiu   $2, $2, 0x1
    jr      $0
    addiu   $2, $2, 0x1
.L1:
    addiu   $2, $2, 1
    jr      $31
	addiu   $2, $2, 1
.end	main
