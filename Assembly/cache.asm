.include "macros.asm"
.globl cache_initialization, insert_cache, print_cache
.text


cache_initialization:
push($ra)

jal is_argc_7
jal save_args
jal calculate_index_offset

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

sw $zero, valid_count(cache_atrib)

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
addi $t2, $a2, -1
and $t2, $t2, $a2
beqz $t2, is_pair_done
not_pair:
printf("Algum dos argumentos númericos não é potencia de 2 ou é menor que 1\n")
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


calculate_index_offset:

load_arg(sets, cache_atrib)
move $a0, $v1
load_arg(bSize, cache_atrib)
move $a1, $v1

li $t2, 0
index_loop:
ble $a0, 1, index_done
srl $a0, $a0, 1
addi $t2, $t2, 1
j index_loop
index_done:

li $t3, 1
sllv $t3, $t3, $t2
addi $t3, $t3, -1
sw $t3, index_mask(cache_atrib)

li $t3, 0
offset_loop:
ble $a1, 1, offset_done
srl $a1, $a1, 1
addi $t3, $t3, 1
j offset_loop
offset_done:
sw $t3, offset_bits(cache_atrib)
add $t2, $t3, $t2
sw $t2, index_offset_bits(cache_atrib)

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



insert_cache:

push($ra)

jal get_set
move $t0, $v0
jal get_tag
move $t1, $v0
load_arg(assoc, cache_atrib)
move $t3, $v1

mul $t0 ,$t0, $t3
mul $t0, $t0, MATRIX_MULT
addu $t0, cache_matrix, $t0

li $t2, -1
li $t7, 0 #was there an empty space?

hit_loop:
addi $t2, $t2, 1
beq $t2, $t3, hit_done
sll $t4, $t2, 3
addu $t4, $t4, $t0
lw $t5, ($t4)
beqz $t5, valid_zero
lw $t5, tag($t4)
bne $t5, $t1, hit_loop
addi nHit, nHit, 1
beq $t3, 1, skip_LRU #skipping LRU, if direct
lw $v1, subst(cache_atrib)
bne $v1, LRU, skip_LRU

lw $t6, 4($t4)
beq $t4, $t0, lru_hit_done

lru_hit_loop:

lw $t5, -4($t4)
sw $t5, 4($t4)
addiu $t4, $t4, -MATRIX_MULT
bne $t4, $t0, lru_hit_loop
sw $t6, 4($t4)

lru_hit_done:

skip_LRU:

addi nAce, nAce, 1

pop($ra)
jr $ra

valid_zero:
#already remembering which slot is free
beq $t7, 1, hit_loop
li $t7, 1
move $t6, $t4 #already considers block position(times 8)
j hit_loop

hit_done:


beq $t7, 1, compulsory_miss #testing if cache had a empty space or not

beq $t3, 1, direct_cache_case
load_arg(subst, cache_atrib)
move $t8, $v1

random:
bne $t8, RANDOM, fifo

randomIntRange($t3)
mul $a0, $a0, MATRIX_MULT
addu $t4, $t0, $a0
j conflict_miss


fifo:

bne $t8, FIFO, lru
li $t2, 1
fifo_loop:

beq $t2, $t3, fifo_loop_done
sll $t4, $t2, 3
addu $t4, $t4, $t0
lw $t5, 4($t4)
sw $t5, -4($t4)
addi $t2, $t2, 1
j fifo_loop

fifo_loop_done:

j conflict_miss
 
lru:

addiu $t2, $t3, -1

lru_loop:

beqz $t2, lru_loop_done
sll $t4, $t2, 3
addu $t4, $t4, $t0
lw $t5, -4($t4)
sw $t5, 4($t4)
lw $t8, -8($t4)
sw $t8, ($t4)
addi $t2, $t2, -1
j lru_loop

lru_loop_done:

move $t4, $t0
beq $t7, 1, lru_comp
j conflict_miss

direct_cache_case:

move $t4, $t0

conflict_miss:
lw $v0, sets(cache_atrib)
mul $v0, $v0, $t3
load_arg(valid_count, cache_atrib)
beq $v1, $v0, capacity_miss
addi confMisses, confMisses, 1
j save_adress

capacity_miss:

addi capaMisses, capaMisses, 1
j save_adress

compulsory_miss:

load_arg(subst, cache_atrib)#testando se é lru
beq $v1, LRU, lru
move $t4, $t6 #saving registers
lru_comp:
li $t5, 1
add compMisses, compMisses, $t5
load_arg(valid_count, cache_atrib)
addi $v1, $v1, 1
sw $v1, valid_count(cache_atrib)
sw $t5, ($t4)

save_adress:

addiu $t4, $t4, tag
sw $t1, ($t4)
addi nAce, nAce, 1

pop($ra)
jr $ra






get_set:

load_arg(offset_bits, cache_atrib)
move $a1, $v1
load_arg(index_mask, cache_atrib)
move $a2, $v1
load_arg(sets, cache_atrib)
move $a3, $v1


srlv $t2, $a0, $a1
and $v0, $t2, $a2

#div $t2, $a3
#mfhi $v0

jr $ra


get_tag:

load_arg(index_offset_bits, cache_atrib)
move $a1, $v1

srlv $v0, $a0, $a1

jr $ra






print_cache:

push($ra)
# Total de acessos, Taxa de hit, Taxa de miss, Taxa de miss compulsório, Taxa de miss de capacidade, Taxa de miss de conflito


print_int($s6)
print_char(' ')

transformToFloat(nAce, $f1)
move $a0, nHit
jal get_rate
print_float($f0)
print_char(' ')

sub $a0, nAce, nHit
move $t0, $a0
jal get_rate
print_float($f0)
print_char(' ')

transformToFloat($t0, $f1)
move $a0, compMisses
jal get_rate
print_float($f0)
print_char(' ')

move $a0, capaMisses
jal get_rate
print_float($f0)
print_char(' ')

move $a0, confMisses
jal get_rate
print_float($f0)
print_char('\n')

pop($ra)
jr $ra

get_rate:

transformToFloat($a0, $f0)
div.s $f0, $f0, $f1

jr $ra




