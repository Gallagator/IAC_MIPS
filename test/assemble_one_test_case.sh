#!/bin/bash

TESTNAME="$1"

mips-linux-gnu-gcc -march=mips1 -mfp32 -O0 -c -EL assembly/${TESTNAME}.s -o ${TESTNAME}.o
mips-linux-gnu-objcopy -O binary -j .text ${TESTNAME}.o ${TESTNAME}.bin
xxd -ps -c 4 ${TESTNAME}.bin > machine_code/${TESTNAME}.hex.txt

rm ${TESTNAME}.o ${TESTNAME}.bin
