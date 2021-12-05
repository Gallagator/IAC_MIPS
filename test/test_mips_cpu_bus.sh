#!/bin/bash

TESTCASES="machine_code/*.hex.txt"

mkdir -p output
mkdir -p simulator

# Loop over every file matching the TESTCASES pattern
for i in ${TESTCASES} ; do
    TESTNAME=$(basename ${i} .hex.txt)

    ./run_one_testcase.sh ${TESTNAME}
done
