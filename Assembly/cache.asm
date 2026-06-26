.include "macros.asm"
.globl cache_initialization, print_cache
.text


cache_initialization:
push($ra)

jal is_argc_7
jal save_args


load_arg(sets , cache_atrib)
move $a0, $v1
load_arg(assoc, cache_atrib)
move $a1, $v1
jal create_matrix 


pop($ra)
jr $ra







is_argc_7:

beq $a0, 7, is_7

printf("A quantidade de argumentos é inválida.\nDeve ser 7.\nFormato: cache_simulator <nsets> <bsize> <assoc> <substituicao> <flag_saida> arquivo_de_entrada\n")
end

is_7:
jr $ra







save_args:

push($ra)
allocateByNum(CACHE_SIZE)
move cache_atrib, $v0

load_arg(cache_name, $a1)
sw $v1, cache_name(cache_atrib)

load_arg(sets, $a1)
move $a2, $v1
jal atoi
sw $v0, sets(cache_atrib)
move $a2, $v0
jal is_pair

load_arg(bSize, $a1)
move $a2, $v1
jal atoi
sw $v0, bSize(cache_atrib)
move $a2, $v0
jal is_pair

load_arg(assoc, $a1)
move $a2, $v1
jal atoi
sw $v0, assoc(cache_atrib)
move $a2, $v0
jal is_pair

load_arg(subst, $a1)
move $a2, $v1
jal what_policy
sw $v0, subst(cache_atrib)

load_arg(output_flag, $a1)
move $a2, $v1
jal atoi
sw $v0, output_flag(cache_atrib)
move $a2, $v0
jal is_outputFlag

load_arg(benchmark, $a1)
sw $v1, benchmark(cache_atrib)

pop($ra)
jr $ra






atoi:

li $v0, 0
atoi_loop:

lb $t3, ($a2)
beq $t3, '\0', atoi_done
blt $t3, '0' , not_number
bgt $t3, '9' , not_number
mul $v0, $v0, 10
sub $t3, $t3, '0'
add $v0, $v0, $t3
addi $a2, $a2, 1

j atoi_loop

not_number:
printf("Algum dos argumentos numéricos recebeu um carácter que não era um número\n")
end

atoi_done:
jr $ra






is_pair: 
blez $a2, not_pair
li $t2, 2
div $a2, $t2
mfhi $t2 
beqz $t2, is_pair_done
beq $a2, 1, is_pair_done
not_pair:
printf("Algum dos argumentos númericos não é par ou é menor que 1\n")
end

is_pair_done:
jr $ra







what_policy:

lb $t3, 1($a2)
beqz $t3, is_char
printf("O parâmetro método de substituição deve ser composto por apenas um carácter\n")
end
is_char:
lb $t3, ($a2)
bne $t3, 'R', not_RANDOM
li $v0, RANDOM
j what_policy_done
not_RANDOM:
bne $t3, 'F', not_FIFO
li $v0, FIFO
j what_policy_done
not_FIFO:
bne $t3, 'L', not_LRU
li $v0, LRU
j what_policy_done
not_LRU:
printf("Carácter inválido, deve ser: R, F ou L\n")
end

what_policy_done:
jr $ra







is_outputFlag:
bnez $a2, flagONE

printf("Não foi implementado código para output_flag = zero\n O código vai seguir como se fosse igual a 1\n")

flagONE:
jr $ra



create_matrix:
push($ra)
mul $t3, $a0, $a1
mul $t3, $t3, MATRIX_MULT
allocateByReg($t3)
move cache_matrix, $v0
fill_args(cache_matrix, $t3, $zero, $zero)
jal clear_mem



pop($ra)
jr $ra

clear_mem: 
clear_mem_loop:
beqz $a1, clear_mem_done
ble $a1, 3, byteByByte
sw $zero, ($a0)
addi $a1, $a1, -4
addi $a0, $a0, 4
j clear_mem_loop

byteByByte:

beqz $a1, clear_mem_done
sb $zero, ($a0)
addi $a1, $a1, -1
addi $a0, $a0, 1
j byteByByte

clear_mem_done:
jr $ra



print_cache:

print_char('\n')
print_char('\n')
print_char('\n')
print_char('\n')
print_char('\n')
print_char('\n')
print_char('\n')









jr $ra



