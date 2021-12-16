.text
    .align  2
    .globl  main
    .ent    main
main:
    .set    noreorder
    beq     $0, $0, .L1
    addiu   $2, $0, 0x9
    addiu   $2, $0, 0x5
    addiu   $2, $0, 0x6
.L1:
    addiu   $2, $2, 0
    jr      $0
    addiu   $2, $2, 0
.end    main
