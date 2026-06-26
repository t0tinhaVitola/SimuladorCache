.include "macros.asm"

.globl parser_initialization, read_4_bytes, readFromFile
.text

parser_initialization:

push($ra)

openFile($a0, 0)
bltz $v0, file_error
sw $v0, file(file_info)
jal readFromFile
j parser_initialization_done

file_error:
printf("Erro na abertura do arquivo")
end

parser_initialization_done:

pop($ra)
jr $ra



readFromFile:

readFile($v0, buffer, BUFFER_SIZE)
sw $v0, read_bytes(file_info)
sw $zero, offset(file_info)

jr $ra




read_4_bytes:

push($ra)

move $v1, $zero
beq $a0, $a1, buffer_read 
lw $v0, $a0(buffer)
move $a2, $v0
jal byteSwap

j read_4_bytes_done

buffer_read: 
li $v1, 1

read_4_bytes_done:

pop($ra)
jr $ra


byteSwap:

sll $v0, $a2, 24

srl $t2, $a2, 24
or  $v0, $v0, $t2

andi $t2, $a2, 0x0000FF00
sll $t2, $t2, 8
or $v0, $v0, $t2

andi $t2, $a2, 0x00FF0000
srl $t2, $t2, 8
or $v0, $v0, $t2

jr $ra










jr $ra

