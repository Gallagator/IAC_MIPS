#!/bin/bash

TESTCASE="$1"

>&2 echo "Testing with ${TESTCASE}"

iverilog -Wall -g2012 \
    ../rtl/mips_cpu/*.v ../rtl/*.v testbench/*.v \
    -s mips_cpu_bus_generic_tb \
    -Pmips_cpu_bus_generic_tb.RAM_INIT_FILE=\"machine_code/${TESTCASE}.hex.txt\" \
    -o  simulator/mips_cpu_bus_tb_${TESTCASE}.sim

>&2 echo "Running test-bench"

# Run and put stdout in a file
set +e
./simulator/mips_cpu_bus_tb_${TESTCASE}.sim > \
    output/mips_cpu_bus_tb_${TESTCASE}.stdout
set -e
