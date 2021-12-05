#!/bin/bash

TESTCASES="assembly/*.s"

for i in ${TESTCASES} ; do
    TESTNAME=$(basename ${i} .s)
        
    ./assemble_one_test_case.sh ${TESTNAME}
done

