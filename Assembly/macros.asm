#reg_nomes

.eqv cache_atrib $s0
.eqv cache_matrix $s1
.eqv compMisses $s2
.eqv capaMisses $s3
.eqv confMisses $s4
.eqv nHit $s5
.eqv nAce $s6

#cache_struct

.eqv cache_name 0
.eqv sets  4      
.eqv bSize 8    
.eqv assoc 12    
.eqv subst 16     
.eqv output_flag 20
.eqv benchmark 24
.eqv offset_bits 28
.eqv index_offset_bits 32
.eqv index_mask 36
.eqv valid_count 40


#define 
.eqv CACHE_SIZE 44
.eqv MATRIX_MULT 8
.eqv FILE_SIZE 12
.eqv BUFFER_SIZE 4096
#enum_policy

.eqv RANDOM 0
.eqv FIFO 1
.eqv LRU 2

#file_struct
.eqv file 0
.eqv read_bytes 4
.eqv offset 8

#matrix struct

.eqv valid 0 
.eqv tag 4


#macros
.macro printf(%str)
.data
string: .asciiz %str
.text
li $v0, 4
la $a0, string
syscall
.end_macro

.macro print_char(%char)
li $a0, %char
li $v0, 11
syscall
.end_macro

.macro print_int(%x)
li $v0, 1
move $a0, %x
syscall
.end_macro

.macro push(%x)
addi $sp, $sp, -4
sw   %x, ($sp)
.end_macro

.macro pop(%x)
lw   %x, ($sp)
addi $sp, $sp, 4
.end_macro

.macro allocateByReg(%x)
move $a0, %x
li $v0, 9
syscall 
.end_macro

.macro allocateByNum(%x)
li $a0, %x
li $v0, 9
syscall 
.end_macro

.macro fill_args(%w, %x, %y, %z)
move $a0, %w
move $a1, %x
move $a2, %y
move $a3, %z
.end_macro

.macro load_arg(%adress, %argv)
lw $v1, %adress(%argv)
.end_macro

.macro end
li $v0, 10
syscall
.end_macro

.macro openFile(%file_adress, %flag)
move $a0, %file_adress
li $a1, %flag
li $v0, 13
syscall
.end_macro

.macro readFile(%file, %buffer_adress, %read_amount)
move $a0, %file
la $a1, %buffer_adress
li $a2, %read_amount

li $v0, 14
syscall
.end_macro
.macro closeFile(%file)
move $a0, %file
li $v0, 16
syscall
.end_macro

.macro transformToFloat(%sourceRegister, %destinationFloatRegister)
mtc1 %sourceRegister, %destinationFloatRegister
cvt.s.w %destinationFloatRegister, %destinationFloatRegister
.end_macro

.macro print_float(%x)
li $v0, 2
mov.s  $f12, %x
syscall
.end_macro

.macro setRandomSeedToTime()
li $v0, 30
syscall
move $a1, $a0
li $v0, 40
li $a0, 0
syscall
.end_macro

.macro randomIntRange(%range)
li $v0, 42
li $a0, 0
move $a1, %range
syscall
.end_macro