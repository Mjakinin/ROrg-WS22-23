	#+ BITTE NICHT MODIFIZIEREN: Vorgabeabschnitt
	#+ ------------------------------------------

.data

str_rowstart: .asciiz "\nnuminv von ( "
str_rowend: .asciiz "): "

	.align 2
.text

.eqv SYS_PUTSTR 4
.eqv SYS_PUTCHAR 11
.eqv SYS_PUTINT 1
.eqv SYS_EXIT 10

	# main durchlaeuft alle Permutationen in "inputs" (siehe unten) und ruft
	# jeweils numinv auf. Permutationen und Rueckgabewerte von numinv werden
	# ausgegeben.
main:
	la $s0, inputs

main_loop:
	lw $s1, 0($s0)
	beq $s1, $zero, main_end

	addi $a0, $s0, 4
	move $a1, $s1
	jal print_perm

	move $a1, $s1	
	addi $a0, $s0, 4
	jal numinv

	move $a0, $v0
	li $v0, SYS_PUTINT
	syscall
	
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

# int numinv(int perm[ ], int length){
#
#	int inversion_count = 0;
#
#	for(int i=0; i < length-1; i++){
#		for(int j=i+1; j < length-1; j++){
#			if(perm[i] > perm[j]){
#				inversion_count++;
#			}
#		}
#	}
#}

numinv:
li $v0,0	# Rückgabewert, int inversion_count = 0
li $t0,0	# int i = 0
	
for_i:	bge $t0,$a1,endfor_i	# if(i >= length-1) goto endfor_i
	
	addi $t1,$t0,1		# j = i+1
		
	for_j:	bge $t1,$a1,endfor_j	# if(j >= length-1) goto endfor_j
			
		sll $t3,$t0,2		# $t3 = 4*i
		add $t3,$a0,$t3		# $t3 = &perm[i]
		lw $t4,0($t3)		# $t4 = perm[i]
			
		sll $t5,$t1,2		# $t5 = 4*j
		add $t5,$a0,$t5		# $t5 = &perm[j]
		lw $t6,0($t5)		# $t6 = perm[j]
			
		ble $t4,$t6,endif		# if(perm[i] <= perm[j]) goto endif
			
		addi $v0,$v0,1		# inversion_count++
		addi $t1,$t1,1		# j++
		j for_j
				
		endif:	addi $t1,$t1,1	# j++
			j for_j		# goto for_j
				
	endfor_j:	addi $t0,$t0,1	# i++
		j for_i		# jump to for_i
				
endfor_i:	jr $ra		# end
