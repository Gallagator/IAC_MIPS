#Test-suite usage

assembly files must be provided in `assembly/`. A few examples have 
been given. `.hex.txt` files will be produced after running: `assemble_test_cases.sh`.

It should be noted that the expected result should be put in `expected/`. As of
now, there is no feasible way to emulate the assembly as all test cases rely on:
`jr $0`. So the expected results must be computed by hand. Still, at least you 
don't have to encode the binary by hand.

After the testcases have been assembled and the expected results of register\_v0
($2) have been produced. The simulator can be run with: `test_mips_cpu_bus.sh`.

#Dependencies

To assemble to .s files a mips compiler along with binutils must be installed 
on your system.

with apt, you can use:

```shell
sudo apt install binutils-mips-linux-gnu gcc-mips-linux-gnu
```
