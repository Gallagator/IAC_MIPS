#!/bin/bash

TESTNAME="$1"

# Assemble to an object file using mips1 assembly. Ensure it is in little endian
# format.
mips-linux-gnu-gcc -march=mips1 -mfp32 -O0 -c -EL assembly/${TESTNAME}.s -o ${TESTNAME}.o
# Turn object file into a raw binary. Only include the .text section (the code)
mips-linux-gnu-objcopy -O binary -j .text ${TESTNAME}.o ${TESTNAME}.bin
# Open in a hex editor and format for 4 bytes per line. Store this in a .hex.txt
xxd -ps -c 4 ${TESTNAME}.bin > machine_code/${TESTNAME}.hex.txt

# Remove intermediate files
rm ${TESTNAME}.o ${TESTNAME}.bin
