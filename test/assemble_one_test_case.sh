#!/bin/bash

TESTNAME="$1"
TMP_FILE=$(basename TESTNAME)


# Assemble to an object file using mips1 assembly. Ensure it is in little endian
# format.
mips-linux-gnu-gcc -march=mips1 -mfp32 -O0 -c -EL assembly/${TESTNAME}.s -o ${TMP_FILE}.o
# Turn object file into a raw binary. Only include the .text section (the code)
mips-linux-gnu-objcopy -O binary -j .text ${TMP_FILE}.o ${TMP_FILE}.bin
# Open in a hex editor and format for 4 bytes per line. Store this in a .hex.txt
BINARY=$(xxd -ps -c 4 ${TMP_FILE}.bin)

echo -e "@0\n${BINARY}" > machine_code/${TESTNAME}.hex.txt
# Remove intermediate files
rm ${TMP_FILE}.o ${TMP_FILE}.bin

