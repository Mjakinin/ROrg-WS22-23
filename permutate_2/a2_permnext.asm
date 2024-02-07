	#+ BITTE NICHT MODIFIZIEREN: Vorgabeabschnitt
	#+ ------------------------------------------

.data
str_Par: .asciiz "("
str_ColonTab: .asciiz "):\t"
str_Start: .asciiz "Das Programm ruft die Funktion permnext auf und zeigt Iterationsnummer und die neu gebildete Permutation an.\n"
str_Abbruch: .asciiz "Ausfuehrung abgebrochen (maximale Iterationsnummer erreicht).\n"
str_Spaces: .asciiz "  "
str_Break: .asciiz "\n"

.text

.eqv SYS_PUTSTR 4 		#const define syscall ($v0)
.eqv SYS_RD_INT 5
.eqv SYS_PUTCHAR 11
.eqv SYS_PUTINT 1
.eqv SYS_EXIT 10

.globl main
main:
	# Beginn der Ausführung anzeigen:
	li $v0, SYS_PUTSTR
	la $a0, str_Start
	syscall

	move $s0, $zero		#int i=0
_print_main:
	li $v0, SYS_PUTSTR
	la $a0, str_Par
	syscall
	
	li $v0, SYS_PUTINT
	move $a0, $s0
	syscall

	li $v0, SYS_PUTSTR
	la $a0, str_ColonTab
	syscall

	addi $s0, $s0, 1
	la $a0, test_perm
	lw $a1, test_perm_length
	jal perm_print

	la $a0, test_perm
	lw $a1, test_perm_length
	jal permnext
	beq $zero, $v0, _end_main
	li $t0, 1000
	blt $s0, $t0, _print_main
	
	li $v0, SYS_PUTSTR
	la $a0, str_Abbruch
	syscall
	
	# Programmende
	li $v0, SYS_EXIT
	syscall

_end_main:
	li $v0, SYS_EXIT
	syscall

# void perm_print(unsigned char *perm, int length)
perm_print:
	move $t0, $zero
	move $t1, $a0
_for:
	add $t2, $t1, $t0
	lbu $t3, 0($t2)

	li $v0, SYS_PUTINT
	move $a0, $t3
	syscall

	li $v0, SYS_PUTSTR
	la $a0, str_Spaces
	syscall

	addi $t0, $t0, 1
	bne $t0, $a1, _for
#_ret:
	li $v0, SYS_PUTSTR
	la $a0, str_Break
	syscall
	jr $ra

# void swap(unsigned char *test_perm, int a, int b)
swap:
	add $t1, $a0, $a1
	add $t2, $a0, $a2
	lbu $t0, 0($t1)
	lbu $t3, 0($t2)
	sb $t3, 0($t1)
	sb $t0, 0($t2)
#_ret:
	jr $ra

	#+ BITTE VERVOLLSTAENDIGEN: Persoenliche Angaben zur Hausaufgabe 
	#+ -------------------------------------------------------------

	# Vorname:
	# Nachname:
	# Matrikelnummer:
	
	#+ Loesungsabschnitt
	#+ -----------------

.data

test_perm_length: .word 4
test_perm: .byte 0, 1, 2, 3

.text

permnext:
	
	jr $ra
