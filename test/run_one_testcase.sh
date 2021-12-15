#!/bin/bash

TESTCASE="$1"
RTL_DIR="$2"
INSTR="$3"

EXPECTED=$(cat test/expected/${INSTR}/${TESTCASE}.txt)

# Compile cpu along with testbench. Load the ram file and the expected result 
# into the testbench.
iverilog -Wall -g2012 \
    ${RTL_DIR}/*.v ${RTL_DIR}/mips_cpu/*.v test/testbench/*.v \
    -s mips_cpu_bus_generic_tb \
    -Pmips_cpu_bus_generic_tb.RAM_INIT_FILE=\"test/machine_code/${INSTR}/${TESTCASE}.hex.txt\" \
    -Pmips_cpu_bus_generic_tb.EXPECTED_REG_V0=${EXPECTED} \
    -o  test/simulator/${INSTR}/mips_cpu_bus_tb_${TESTCASE}.sim

# Run and put stdout in a file
set +e
./test/simulator/${INSTR}/mips_cpu_bus_tb_${TESTCASE}.sim > \
    test/output/${INSTR}/mips_cpu_bus_tb_${TESTCASE}.stdout
RESULT=$?
set -e

if [[ ${RESULT} -ne 0 ]] ; then
   echo "${TESTCASE} ${INSTR} Fail"
   exit
fi

echo "${TESTCASE} ${INSTR} Pass"

