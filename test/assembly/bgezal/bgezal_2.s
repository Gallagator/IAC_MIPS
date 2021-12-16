    .text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    addiu   $3, $0, 0xFFFF
    bgezal  $3, .L1
    jr      $0
    addiu   $2, $0, 0x9
    addiu   $2, $2, 0
    jr      $0
	addiu   $2, $2, 0
.L1:
    addiu   $2, $0, 0xF
    jr      $31

.end	main
