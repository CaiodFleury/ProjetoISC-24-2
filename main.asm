.data
selectframeads:	.word 0xFF200604

char_pos:		.half 0, 0
old_char_pos:		.half 0, 0

.include "fundolaranja.data"
.include "personagem.data"
.include "fundopersonagem.data"

#Codigo vai come?ar na main.
#Fun??es no final
#Padr?o for/while/if : Loop_num
#Padr?o fun??es FazerAlgo

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
	
	call GAME_LOOP		

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

GAME_LOOP:
	call KeyDown
	xori s0, s0,1
	
	la t0, char_pos
	
	la a0, personagem
	lh a1, 0(t0)
	lh a2, 2(t0)
	mv a3, s0
	call LoadScreen
	
	lw t0, selectframeads
	sw s0,0(t0)
	
	la t0, old_char_pos
	
	la a0, fundopersonagem
	lh a1, 0(t0)
	lh a2, 2(t0)
	mv a3, s0
	xori a3, a3,1
	call LoadScreen
	
	j GAME_LOOP


KeyDown:
	li t1,0xFF200000		# carrega o endere?o de controle do KDMMIO
	lw t0,0(t1)			# Le bit de Controle Teclado
	andi t0,t0,0x0001		# mascara o bit menos significativo
   	beq t0,zero,FIM   	   	# Se n?o h? tecla pressionada ent?o vai para FIM
  	lw t2,4(t1)  			# le o valor da tecla tecla

	li t0, 'd'
	beq t2, t0, MoveRight
	
	li t0, 'a'
	beq t2, t0, MoveLeft
	
	li t0, 'w'
	beq t2, t0, MoveUp
	
	li t0, 's'
	beq t2, t0, MoveDown

	FIM:	ret				# retorna
	
	
	# t1 = x, t2 = y
	MoveRight:
		la t0, char_pos
		la t1, old_char_pos
		lw t2, 0(t0)
		sw t2, 0(t1)
		lh t1, 0(t0)
		addi t1, t1, 16 # 16 bits pra direita
		sh t1, 0(t0)
		ret
		
	MoveLeft:
		la t0, char_pos
		la t1, old_char_pos
		lw t2, 0(t0)
		sw t2, 0(t1)
		lh t1, 0(t0)
		addi t1, t1, -16 # 16 bits pra esquerda
		sh t1, 0(t0)
		ret
		
	MoveUp:
		la t0, char_pos
		la t1, old_char_pos
		lw t2, 0(t0)
		sw t2, 0(t1)
		lh t1, 2(t0)
		addi t1, t1, -16 # 16 bits pra esquerda
		sh t1, 2(t0)
		ret
		
	MoveDown:
		la t0, char_pos
		la t1, old_char_pos
		lw t2, 0(t0)
		sw t2, 0(t1)
		lh t1, 2(t0)
		addi t1, t1, 16 # 16 bits pra esquerda
		sh t1, 2(t0)
		ret
	
#void func;
FimPrograma:
	li a7,10
	ecall
	
	
	
	
	
	
	
	
	
	
	
	
	
	