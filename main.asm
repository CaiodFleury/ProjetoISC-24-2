.data
selectframeads:	.word 0xFF200604

char_pos:		.half 0, 0

.include "levels/fundolaranja.data"
.include "sprites/personagem.data"

#Codigo vai come�ar na main.
#Fun��es no final
#Padr�o for/while/if : Loop_num
#Padr�o fun��es FazerAlgo

.text
main:	
	li a0, 0
	call TrocarTela	

	li a2 , 0
	li a1 , 0
	la a0 fundolaranja
	call LoadScreen 


	li a0, 3
	call TrocarTela	

	li a2 , 0
	li a1 , 0
	la a0 fundolaranja
	call LoadScreen 
	
	li a2 , 50
	li a1 , 48
	la a0 , personagem
	call LoadScreen 

	li a0, 3
	call TrocarTela	
	
	call FimPrograma
	
#FUNÇÕES--->	
#recebe a0;

# a0 = 0/1 define a tela
# a0 = 3 troca 
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

#recebe a0, a1, a2;
# a0= endereço imagem
# a1 = x da imagem
# a2 = y da imagem

LoadScreen:
	lw t0, selectframeads
	lb t0,0(t0)
 	If_LS: 
 		li t1,1
 		bne t0,t1, Else_LS
 		li t0 0xFF000000
		j Fim_If_LS
	Else_LS:
		li t0 0xFF100000
	Fim_If_LS:
	li t5 , 320
	mul t5 , t5, a2 
	add t0, t5 , t0
	
	lw t1, 0(a0)
	lw t2, 4(a0)
	li t3, 0
	li t4, 0
	addi a0,a0,8
	While_LS:	
		beq t2, t4, EndWhile_LS
		add t0, t0,a1
		While_LS1:
			beq t1, t3, EndWhile_LS1
			lw t5, 0(a0)
			sw t5, 0(t0)
			addi t3,t3,4
			addi a0,a0,4
			addi t0,t0,4
			j While_LS1
		EndWhile_LS1:
		li t5, 320
		sub t5, t5, a1
		sub t5, t5,t1
		add t0, t0, t5
		li t3, 0
		addi t4, t4,1
		j While_LS
	EndWhile_LS:
	ret

KeyDown:
	li t1,0xFF200000		# carrega o endereēo de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,FIM   	   	# Se nćo hį tecla pressionada entćo vai para FIM
  	lw t2,4(t1)  			# le o valor da tecla tecla

	FIM:	ret				# retorna
	
	li t0, 'd'
	beq t2, t0, MoveRight
	
	li t0, 'a'
	beq t2, t0, MoveLeft
	
	# t1 = x, t2 = y
	MoveRight:
		la t0, char_pos
		lh t1, 0(t0)
		addi t1, t1, 16 # 16 bits pra direita
		sh t1, 0(t0)
		ret
		
	MoveLeft:
		la t0, char_pos
		lh t1, 0(t0)
		addi t1, t1, -16 # 16 bits pra esquerda
		sh t1, 0(t0)
		ret
	
#void func;
FimPrograma:
	li a7,10
	ecall
	
	
	
	
	
	
	
	
	
	
	
	
	
	
