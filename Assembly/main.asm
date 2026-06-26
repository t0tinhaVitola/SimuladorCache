.include "macros.asm"
.globl main
.data
file_info: .space FILE_SIZE
buffer: .space BUFFER_SIZE

.text






#run with:
#java -jar Mars4_5.jar sm p main.asm pa cache_simulator 1 4 32 L 1 vortex.in.sem.persons.bin
main:



fill_args($a0, $a1, $zero, $zero)
jal cache_initialization

load_arg(cache_atrib, benchmark)
fill_args($v1, $zero, $zero, $zero)
jal parser_initialization



reset_loop:
load_arg(file, offset)
move $a0, $v1
load_arg(file, read_bytes)
move $a1, $v1
main_loop:
jal read_4_bytes
beq $v1, 1, buffer_read
jal insert_cache
j main_loop

buffer_read:
jal readFromFile
bnez $v0, reset_loop

#jal print_cache



printf("OI mae\n")
end



