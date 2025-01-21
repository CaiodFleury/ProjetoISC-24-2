.data
indio_pos:	.half 160, 32, 1
old_indio_pos:	.half 160, 32

.text

Inimigo:
	
	#li a0, 200
	#li a7, 32
	#ecall

	la t0, indio_pos
	la t1, old_indio_pos
	lh a1, 0(t0)
	sh a1, 0(t1)
	li t3, 232
	li t4, 88
	li t5, -1
	lh t6, 4(t0)
	
	beq t6, t5, Esq	
	
Dir:	addi a1, a1, 36
	sh a1, 0(t0)
	beq a1, t3, Reset
	j Back
	
Esq:	addi a1, a1, -36
	sh a1, 0(t0)
	beq a1, t4, Reset
	j Back
	
Reset:
	mul t6, t6, t5
	sh t6, 4(t0)
	j Back
	
Back:
	j Inimigo


Fim:
	li a7, 10
	ecall
	
	
	
	
