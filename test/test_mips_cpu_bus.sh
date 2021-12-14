#!/bin/bash

RTL_DIR="$1"
INSTR_TO_TEST="$2"

if [ -z "$INSTR_TO_TEST" ] ; then
    INSTRS="test/machine_code/*"
else
    INSTRS="test/machine_code/${INSTR_TO_TEST}"
fi

mkdir -p test/output
mkdir -p test/simulator

# Loop over every file matching the TESTCASES pattern
for INSTR in ${INSTRS} ; do
    TESTCASES="${INSTR}/*.hex.txt"
    DIR=$(basename ${INSTR})
    mkdir -p test/output/${DIR}
    mkdir -p test/simulator/${DIR}
    
    for i in ${TESTCASES} ; do
        TESTNAME=$(basename ${i} .hex.txt)

        ./test/run_one_testcase.sh ${TESTNAME} ${RTL_DIR} ${DIR}
    done
done

