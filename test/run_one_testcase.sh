#!/bin/bash

TESTCASE="$1"
EXPECTED=$(cat expected/${TESTCASE}.txt)

# Compile cpu along with testbench. Load the ram file and the expected result 
# into the testbench.
iverilog -Wall -g2012 \
    ../rtl/*.v ../rtl/mips_cpu/*.v testbench/*.v \
    -I../rtl/mips_cpu \
    -s mips_cpu_bus_generic_tb \
    -Pmips_cpu_bus_generic_tb.RAM_INIT_FILE=\"machine_code/${TESTCASE}.hex.txt\" \
    -Pmips_cpu_bus_generic_tb.EXPECTED_REG_V0=${EXPECTED} \
    -o  simulator/mips_cpu_bus_tb_${TESTCASE}.sim


# Run and put stdout in a file
set +e
./simulator/mips_cpu_bus_tb_${TESTCASE}.sim > \
    output/mips_cpu_bus_tb_${TESTCASE}.stdout
RESULT=$?
set -e

if [[ ${RESULT} -ne 0 ]] ; then
   echo "${TESTCASE}, FAIL"
   exit
fi

echo "${TESTCASE} PASS"
