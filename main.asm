.data
selectframeads:	.word 0xFF200604
frame0:	     	.word 0xFF100000
frame1: 	.word 0xFF000000
#.include "funcoes.asm"
.include "fundolaranja.data"

#Codigo vai começar na main.
#Funções no final
#Padrão for/while/if : Loop_num
#Padrão funções FazerAlgo

.text
main:	

	la a0 fundolaranja
	call LoadScreen
	
	li a0, 3
	call TrocarTela
	
	call FimPrograma	 
	
	
#FUNÇÕES--->	
#recebe a0; a0 = 0/1 define a tela a0 = 3 troca 
TrocarTela:
	lw t3, selectframeads
 	If_TT1: 
 		li t0,3
 		bge a0,t0, Else_TT1
		sw a0, 0(t3)
		ret
	Else_TT1:
		lb t1,0(t3)
		li t0, 1
		If_TT2:
			bne t1,t0, Else_TT2
			li t1, 0
			sw t1, 0(t3)
			ret
		Else_TT2:
			li t1, 1
			sw t1, 0(t3)
			ret
#recebe a0,a1,a2; a0= endereço imagem, a1 = x da imagem, a2 = y da imagem
LoadScreen:
	lw t3 0(a0)
	lw t4,4(a0)
	mul t3, t3, t4 #pega o total de pixels
	li t4, 0
	lw t2, selectframeads
	lb t2,0(t2)
 	If_LS1: 
 		li t0,1
 		bne t2,t0, Else_LS1
 		li t2 0xFF000000
		j Fim_If_LS1
	Else_LS1:
		li t2 0xFF100000
	Fim_If_LS1:
	addi a0,a0,8
	While_LS1:	
	beq t3, t4, EndWhile_LS1
		lw t5, 0(a0)
		sw t5, 0(t2)
		addi t4,t4,4
		addi a0,a0,4
		addi t2,t2,4
		j While_LS1
	EndWhile_LS1:
	ret
	
FimPrograma:
	li a7,10
	ecall
	
	
	
	
	
	
	
	
	
	
	
	
	
	
