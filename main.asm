.data
selectframeads:	.word 0xFF200604
frame0:	     	.word 0xFF100000
frame1: 	.word 0xFF000000
.include "funcoes.asm"
.include "fundolaranja.data"
#Codigo vai começar na main.
#Funções no final
#Padrão for/while/if : loop_num
#Padrão funções F.print
#
#
#
.text
main:	
	li  a0,4
	li a7,1
	ecall
	li a0, 1 
	call TrocarTela

	
	li s0 0xFF100000
	
	la t0 fundolaranja
	lw t1 0(t0)
	lw t2, 4(t0)
	li t3, 0
	mul t4, t1, t2
	addi t0,t0,8
	add  a0,t4,zero
	li a7,1
	ecall
LOOP:	beq t3, t4, FORA
	lw t5, 0(t0)
	sw t5, 0(s0)
	addi t0,t0,4
	addi t3,t3,4
	addi s0,s0,4
	li  a0,2
	li a7,1
	ecall
	j LOOP
FORA:
	li s1, 1
	lw s0, selectframeads
	sw s1, 0(s0)
	li a7,10
	ecall	 
#FUNÇÕES--->	
#recebe a0; a = 0/1 define a tela a = 3 troca 
TrocarTela:
	lw s0, selectframeads
 	If_TT1: 
 		li t0,3
 		bge a0,t0, Else_TT1
		sw a0, 0(s0)
		ret
	Else_TT1:
		lb t1,0(s0)
		li t0, 1
		If_TT2:
			bne t1,t0, Else_TT2
			li t1, 0
			sw t1, 0(s0)
			ret
		Else_TT2:
			li t1, 1
			sw t1, 0(s0)
			ret
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
