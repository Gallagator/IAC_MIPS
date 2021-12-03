#!/bin/bash

TESTCASES="machine_code/*.hex.txt"

mkdir -p output
mkdir -p simulator

# Loop over every file matching the TESTCASES pattern
for i in ${TESTCASES} ; do
    # Extract just the testcase name from the filename. See `man basename` for what this command does.
    TESTNAME=$(basename ${i} .hex.txt)
    # Dispatch to the main test-case script
    ./run_one_testcase.sh ${TESTNAME}
done
