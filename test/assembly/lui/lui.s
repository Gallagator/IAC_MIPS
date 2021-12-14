	.text
	.align	2
	.globl	main
	.ent	main
main:
	.set	noreorder
    lui     $2, 0xFFFF
    jr      $0
.end	main
