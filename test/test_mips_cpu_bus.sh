#!/bin/bash

RTL_DIR="$1"
INSTRS="test/machine_code/*"

mkdir -p output
mkdir -p simulator

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

