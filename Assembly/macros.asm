#reg_nomes

.eqv cache_atrib $s0
.eqv compMisses $s1
.eqv capaMisses $s2
.eqv confMisses $s3
.eqv nHit $s4
.eqv nAce $s5
.eqv i $t1

#argumentos

.eqv cache_name 0
.eqv sets  4      
.eqv bSize 8    
.eqv assoc 12    
.eqv subst 16     
.eqv output_flag 20
.eqv benchmark 24

#enum

.eqv RANDOM 0
.eqv FIFO 1
.eqv LRU 2


#macros
.macro printf(%str)
.data
string: .asciiz %str
.text
li $v0, 4
la $a0, string
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

