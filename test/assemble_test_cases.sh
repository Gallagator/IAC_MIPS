#!/bin/bash

TESTCASES="assembly/*"

for INSTR in ${TESTCASES} ; do
    TESTCASES="${INSTR}/*.s"
    DIR=$(basename ${INSTR})
    mkdir -p machine_code/${DIR}

    for TESTCASE in ${TESTCASES} ; do
        TESTNAME=$(basename ${TESTCASE} .s)
        ./assemble_one_test_case.sh ${DIR}/${TESTNAME}
    done
        
done

