    .text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    beq     $0, $0, .L1
    jr      $0      /* The jr never gets executed. */
    addiu   $2, $0, 0x1
    jr      $0
    addiu   $2, $0, 0x5
.L1:
    addiu   $2, $2, 1
    jr      $0
	addiu   $2, $2, 1
.end	main
