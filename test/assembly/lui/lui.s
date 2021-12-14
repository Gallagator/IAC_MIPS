	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    jr      $0
    lui     $2, 0xFFFF
.end	main
