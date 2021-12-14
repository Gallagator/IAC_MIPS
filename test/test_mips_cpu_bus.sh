#!/bin/bash

RTL_DIR="$1"
TESTCASES="test/machine_code/*.hex.txt"

mkdir -p output
mkdir -p simulator

# Loop over every file matching the TESTCASES pattern
for i in ${TESTCASES} ; do
    TESTNAME=$(basename ${i} .hex.txt)

    ./test/run_one_testcase.sh ${TESTNAME} ${RTL_DIR}
done
