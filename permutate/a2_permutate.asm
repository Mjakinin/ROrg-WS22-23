	#+ BITTE NICHT MODIFIZIEREN: Vorgabeabschnitt
	#+ ------------------------------------------

.data

str_rowstart: .asciiz "\nErgebnis fuer ( "
str_rowend: .asciiz "): "

	.align 2
alle_fruechte:
	.ascii "Apfel ----------"
	.ascii "Birne ----------"
	.ascii "Clementine -----"
	.ascii "Drachenfrucht --"
	.ascii "Erdbeere -------"
	.ascii "Feige ----------"
	.ascii "Granatapfel ----"
	.ascii "Himbeere -------"
	.ascii "Ingwer ---------"
	.ascii "Johannisbeere --"
	.ascii "Kirsche --------"
	.ascii "Limette --------"
	.ascii "Mango ----------"
	.ascii "Nektarine ------"
	.ascii "Orange ---------"
	.ascii "Pfirsich -------"
	
	.space 128
fruechte_aktuell:
	.space 512

.text

.eqv SYS_PUTSTR 4
.eqv SYS_PUTCHAR 11
.eqv SYS_PUTINT 1
.eqv SYS_EXIT 10

	# main durchlaeuft alle Permutationen in "inputs" (siehe unten) und ruft
	# jeweils permutate auf. Permutationen und das Array objects nach
	# Funktionsaufruf werden ausgegeben.
main:
	la $s0, inputs

main_loop:
	lw $s1, 0($s0)
	beq $s1, $zero, main_end

	addi $a0, $s0, 4
	move $a1, $s1
	jal print_perm

	la $a0, fruechte_aktuell
	la $a1, alle_fruechte
	sll $a2, $s1, 2
	jal wcpyz

	la $a0, fruechte_aktuell
	addi $a1, $s0, 4
	move $a2, $s1
	jal permutate

	la $a0, fruechte_aktuell
	jal print_fruechte

	sll $s1, $s1, 2
	add $s0, $s0, $s1
	addi $s0, $s0, 4
	j main_loop
	
main_end:
	li $v0, SYS_EXIT
	syscall

	# void print_perm(int *perm, int length):
	# Gibt Elemente einer Permutation durch Leerzeichen getrennt aus.
print_perm:
	move $t1, $a0

	li $v0, SYS_PUTSTR
	la $a0, str_rowstart
	syscall
	
	move $t0, $a1
print_perm_loop:
	beq $t0, $zero, print_perm_end
	
	li $v0, SYS_PUTINT
	lw $a0, 0($t1)
	syscall
	
	li $v0, SYS_PUTCHAR
	li $a0, ' '
	syscall
	
	addi $t0, $t0, -1
	addi $t1, $t1, 4
	j print_perm_loop
	
print_perm_end:
	li $v0, SYS_PUTSTR
	la $a0, str_rowend
	syscall
	
	jr $ra

	# void print_fruechte(char *objects):
	# Gibt das Array von Fruechten objects aus.
print_fruechte:
	move $t0, $a0
	li $t1, '-' # ignore this char

print_fruechte_loop:
	lb $a0, 0($t0)
	addi $t0, $t0, 1
	
	beq $a0, $zero, print_fruechte_end
	beq $a0, $t1, print_fruechte_loop
	
	li $v0, SYS_PUTCHAR
	syscall

	j print_fruechte_loop
print_fruechte_end:
	jr $ra
	
	# void wcpyz(int *dst, int *src, int size_words):
	# Kopiert size_words Woerter von src zu dst und fuegt Nullterminator hinzu. 
wcpyz: 
	beq $a2, $zero, wcpyz_end
	lw $t0, 0($a1)
	sw $t0, 0($a0)
	addi $a0, $a0, 4
	addi $a1, $a1, 4
	addi $a2, $a2, -1
	j wcpyz	
wcpyz_end:
	sb $zero, 0($a0) # zero termination
	jr $ra

	# void swap(char *objects, int k, int l):
	# Hilfsfunktion: Tauscht im Array objects die Elemente mit Indizes k und l.
swap: 
	sll $a1, $a1, 4	
	sll $a2, $a2, 4	
	add $a1, $a1, $a0
	add $a2, $a2, $a0
	li $t0, 4
swap_loop:
	lw $t1, 0($a1)
	lw $t2, 0($a2)
	sw $t2, 0($a1)
	sw $t1, 0($a2)
	add $a1, $a1, 4
	add $a2, $a2, 4
	addi $t0, $t0, -1
	bne $t0, $zero, swap_loop
	jr $ra

	# int cycle_head(int *perm, int idx):
	# Hilfsfunktion: Gibt zurueck, ob es sich bei dem Element idx der 
	# Permutation perm um einen Zyklenkopf handelt.
	# Rueckgabewert: 1, falls Zyklenkopf, sonst 0.
cycle_head: 
	move $t0, $a1 # $t0: cur
	move $t1, $a1 # $t1: initial
	move $v0, $zero
find_least_loop:
	bge $t0, $a1, not_lower
	jr $ra
not_lower:
	sll $t0, $t0, 2
	add $t0, $t0, $a0
	lw $t0, 0($t0)
	bne $t0, $t1, find_least_loop
	li $v0, 1
	jr $ra

	#+ BITTE VERVOLLSTAENDIGEN: Persoenliche Angaben zur Hausaufgabe 
	#+ -------------------------------------------------------------

	# Vorname:Maxim
	# Nachname:Mjakinin
	# Matrikelnummer:480592
	
	#+ Loesungsabschnitt
	#+ -----------------

.data

inputs:
	.word 4  # 1. Permutation (Laenge 4):
	.word 1, 2, 0, 3
	.word 4  # 2. Permutation (Laenge 4):
	.word 0, 1, 3, 2
	.word 4  # 3. Permutation (Laenge 4):
	.word 0, 1, 2, 3
	.word 10 # 4. Permutation (Laenge 10):
	.word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
	.word 10 # 5. Permutation (Laenge 10):
	.word 1, 2, 0, 4, 5, 3, 7, 8, 9, 6
	.word 10 # 6. Permutation (Laenge 10):
	.word 9, 0, 1, 2, 3, 4, 5, 6, 7, 8
	.word 12 # 7. Permutation (Laenge 12):
	.word 2, 7, 4, 6, 9, 10, 5, 1, 0, 8, 3, 11
	.word 16 # 8. Permutation (Laenge 16):
	.word 4, 3, 2, 15, 5, 14, 11, 10, 1, 8, 0, 12, 9, 13, 7, 6
	.word 0 # Ende der Permutationen

.text

# int i = 0
# for(int i, i<perm_len, i++){
#	if (cycle_head(perm*,perm[i] = 1)){
#	k=perm[i]
#	l=perm[k]
#	while(l!=perm[i]){
#		swap(object,k,l)
#		k=l
#		l=perm[k]}}}

permutate:

addi $sp,$sp,-32	# reserviere 32 bytes auf dem Stack

sw $ra,28($sp)		# save auf dem Stack
sw $s0,24($sp)		# save auf dem Stack
sw $s1,20($sp)		# save auf dem Stack
sw $s2,16($sp)		# save auf dem Stack
sw $s3,12($sp)		# save auf dem Stack
sw $s4,8($sp)		# save auf dem Stack
sw $s5,4($sp)		# save auf dem Stack
sw $s6,0($sp)		# save auf dem Stack

move $s0,$a0		# $s0 = $a0	objects
move $s1,$a1		# $s1 = $a1	perm
move $s2,$a2		# $s2 = $a2	perm_len
move $s3,$t2		# $s3 = $t2	perm[i]
move $s4,$t3		# $s4 = $t3	k
move $s5,$t6		# $s5 = $t6	l
move $s6,$t0		# $s6 = $t0	i

li $s6,0			# int i = 0

for:	bge $s6,$s2,endfor		# if(i>=perm) goto endfor

	if:	sll $t1,$s6,2	# $t2 = 4*i
		add $t1,$s1,$t1	# &perm[i]
		lw $s3,0($t1)	# perm[i]
		
		move $a0,$s1	# $a0 = perm	1. Funktionsparameter
		move $a1,$s3	# $a1 = perm[i]	2. Funktionsparameter

		jal cycle_head	# Funktionsaufruf cycle_head
		
		beq $v0,0,endif	# if(cycle_head(perm*,perm[i]=0) goto endif
		
		move $s4,$s3	# k=perm[i]

		sll $t4,$s4,2	# $t4 = 4*k
		add $t4,$s1,$t4	# &perm[k]
		lw $t5,0($t4)	# perm[k]
		
		move $s5,$t5	# l=perm[k] 
				
		while:	beq $s5,$s3,endif	# if(l==perm[i]) goto endif
			
			move $a0,$s0	# $a0 = objects	1. Funktionsparameter
			move $a1,$s4	# $a1 = k		2. Funktionsparameter
			move $a2,$s5	# $a2 = l		3. Funktionsparameter
	
			jal swap		# Funktionsaufruf swap
			
			move $s4,$s5	# k=l
			
			sll $t4,$s4,2	# $t4 = 4*k
			add $t4,$s1,$t4	# &perm[k]
			lw $t5,0($t4)	# perm[k]
			
			move $s5,$t5	# l=perm[k]
			
			j while		# jump to while
			
	endif:	addi $s6,$s6,1	# i++
		j for		# jump to for
		
endfor:	lw $ra,28($sp)		# wiederherstellen
	lw $s0,24($sp)		# wiederherstellen
	lw $s1,20($sp)		# wiederherstellen
	lw $s2,16($sp)		# wiederherstellen
	lw $s3,12($sp)		# wiederherstellen
	lw $s4,8($sp)		# wiederherstellen
	lw $s5,4($sp)		# wiederherstellen	
	lw $s6,0($sp)		# wiederherstellen
	
	addi $sp,$sp,32		# wiederherstellen
	
	jr $ra			# end
