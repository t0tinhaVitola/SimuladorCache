.include "macros.asm"
.globl main
.data

.text

#run with:
#java -jar Mars4_5.jar sm p main.asm pa cache_simulator 1 4 32 L 1 vortex.in.sem.persons.bin
main:



fill_args($a0, $a1, $zero, $zero)
jal cache_initialization

printf("OI mae\n")

end



