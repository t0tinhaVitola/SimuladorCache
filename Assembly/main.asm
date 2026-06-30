.include "macros.asm"
.globl main, buffer, file_info
.data
.align 2
file_info: .space FILE_SIZE
buffer: .space BUFFER_SIZE

.text
#run with:
#java -jar Mars4_5.jar sm p main.asm pa cache_simulator 1 4 32 L 1 vortex.in.sem.persons.bin
main:

fill_args($a0, $a1, $zero, $zero)
jal cache_initialization

load_arg(benchmark, cache_atrib)
fill_args($v1, $zero, $zero, $zero)
jal parser_initialization

setRandomSeedToTime()

main_loop:
lw $a0, file_info+offset 
lw $a1, file_info+read_bytes
jal read_4_bytes
beq $v1, 1, buffer_read
move $a0, $v0
jal insert_cache
j main_loop

buffer_read:

jal readFromFile
bnez $v0, main_loop
jal closeTheFile
jal print_cache

end



