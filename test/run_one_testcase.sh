#!/bin/bash

TESTCASE="$1"
EXPECTED=$(cat expected/${TESTCASE}.txt)
>&2 echo "Testing with ${TESTCASE}"

iverilog -Wall -g2012 \
    ../rtl/*.v ../rtl/mips_cpu/*.v testbench/*.v \
    -s mips_cpu_bus_generic_tb \
    -Pmips_cpu_bus_generic_tb.RAM_INIT_FILE=\"machine_code/${TESTCASE}.hex.txt\" \
    -Pmips_cpu_bus_generic_tb.EXPECTED_REG_V0=${EXPECTED} \
    -o  simulator/mips_cpu_bus_tb_${TESTCASE}.sim

>&2 echo "Running test-bench"

# Run and put stdout in a file
set +e
./simulator/mips_cpu_bus_tb_${TESTCASE}.sim > \
    output/mips_cpu_bus_tb_${TESTCASE}.stdout
RESULT=$?
set -e

if [[ ${RESULT} -ne 0 ]] ; then
   echo "    ${TESTCASE}, FAIL"
   exit
fi

echo "    ${TESTCASE} PASS"
