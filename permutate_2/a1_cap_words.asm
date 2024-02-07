	#+ BITTE NICHT MODIFIZIEREN: Vorgabeabschnitt
	#+ ------------------------------------------
.data
str_info1: .asciiz "test_string: \""
str_info2: .asciiz "\"\nRueckgabewert cap_words(test_string): "

.text

.eqv SYS_PUTSTR 4
.eqv SYS_PUTCHAR 11
.eqv SYS_PUTINT 1
.eqv SYS_EXIT 10

main:
	li $v0, SYS_PUTSTR
	la $a0, str_info1
	syscall

	li $v0, SYS_PUTSTR
	la $a0, test_string
	syscall

	li $v0, SYS_PUTSTR
	la $a0, str_info2
	syscall

	move $v0, $zero
	la $a0, test_string
	jal cap_words

	move $a0, $v0
	li $v0, SYS_PUTINT 
	syscall

	li $v0, SYS_EXIT
	syscall


	#+ BITTE VERVOLLSTAENDIGEN: Persoenliche Angaben zur Hausaufgabe 
	#+ -------------------------------------------------------------

	# Vorname:
	# Nachname:
	# Matrikelnummer:
	
	#+ Loesungsabschnitt
	#+ -----------------
	
.data

test_string: .asciiz "Nur aNfangsbuchstaben ZAEhlen als gROss geschrieben"

.text

cap_words:

	jr $ra
	